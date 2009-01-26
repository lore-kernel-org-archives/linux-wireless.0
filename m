Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26636 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbZAZTOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 14:14:06 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 11:14:06 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>, <Jouni.Malinen@atheros.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: do not TX injected frames when not allowed
Date: Mon, 26 Jan 2009 11:13:26 -0800
Message-ID: <1232997206-25784-1-git-send-email-lrodriguez@atheros.com> (sfid-20090126_201419_427020_27CF64F5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Monitor mode is able to TX by using injected frames. We should
not allow injected frames to be sent unless allowed by regulatory
rules. Since AP mode uses a monitor interfaces to transmit
management frames we have to take care to not break AP mode as
well while resolving this. We deal with this by allowing compliant
APs solutions to inform mac80211 if their monitor interface is
intended to be used for an AP by setting a cfg80211 flag for the
monitor interface. hostapd, for example, currently does its own
checks to ensure AP mode is not used on channels which require radar
detection. Once such solutions are available it can can enable this
flag.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This currently hits the WARN_ON() when using hostapd and
a client tries to associate and I'm not sure why, hence RFC.
Something is fishy...

 include/linux/nl80211.h |    3 +++
 include/net/cfg80211.h  |    4 ++++
 net/mac80211/tx.c       |   14 ++++++++++++++
 net/wireless/nl80211.c  |    1 +
 4 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 76aae3d..3357907 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -705,6 +705,8 @@ enum nl80211_reg_rule_flags {
  * @NL80211_MNTR_FLAG_OTHER_BSS: disable BSSID filtering
  * @NL80211_MNTR_FLAG_COOK_FRAMES: report frames after processing.
  *	overrides all other flags.
+ * @NL80211_MNTR_FLAG_AP_MGT: this monitor interface is used for AP mode
+ * 	to be able to inject management frames.
  *
  * @__NL80211_MNTR_FLAG_AFTER_LAST: internal use
  * @NL80211_MNTR_FLAG_MAX: highest possible monitor flag
@@ -716,6 +718,7 @@ enum nl80211_mntr_flags {
 	NL80211_MNTR_FLAG_CONTROL,
 	NL80211_MNTR_FLAG_OTHER_BSS,
 	NL80211_MNTR_FLAG_COOK_FRAMES,
+	NL80211_MNTR_FLAG_AP_MGT,
 
 	/* keep last */
 	__NL80211_MNTR_FLAG_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index dd1fd51..fe65c64 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -255,6 +255,9 @@ struct station_info {
  * @MONITOR_FLAG_CONTROL: pass control frames
  * @MONITOR_FLAG_OTHER_BSS: disable BSSID filtering
  * @MONITOR_FLAG_COOK_FRAMES: report frames after processing
+ * @MONITOR_FLAG_AP_MGT: informs us this monitor interface is
+ *	used by a driver for AP mode to be able to inject management
+ * 	frames.
  */
 enum monitor_flags {
 	MONITOR_FLAG_FCSFAIL		= 1<<NL80211_MNTR_FLAG_FCSFAIL,
@@ -262,6 +265,7 @@ enum monitor_flags {
 	MONITOR_FLAG_CONTROL		= 1<<NL80211_MNTR_FLAG_CONTROL,
 	MONITOR_FLAG_OTHER_BSS		= 1<<NL80211_MNTR_FLAG_OTHER_BSS,
 	MONITOR_FLAG_COOK_FRAMES	= 1<<NL80211_MNTR_FLAG_COOK_FRAMES,
+	MONITOR_FLAG_AP_MGT		= 1<<NL80211_MNTR_FLAG_AP_MGT,
 };
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7b013fb..eed4f49 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -898,10 +898,24 @@ __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(tx->dev);
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len);
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
+	/* Frame injection is not allowed if beaconing is not allowed
+	 * or if we need radar detection. Beaconing is usually not allowed when
+	 * the mode or operation (Adhoc, AP, Mesh) does not support DFS.
+	 * Since AP mode uses monitor interfaces to inject/TX management
+	 * frames we make AP mode the exception to this rule as its
+	 * implementation can deal with radar detection by itself. */
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_MONITOR))
+		return TX_DROP;
+	if (!(sdata->u.mntr_flags & MONITOR_FLAG_AP_MGT) &&
+	   (tx->channel->flags & (IEEE80211_CHAN_NO_IBSS |
+	   IEEE80211_CHAN_RADAR)))
+		return TX_DROP;
+
 	skb->do_not_encrypt = 1;
 	tx->flags &= ~IEEE80211_TX_FRAGMENTED;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 09a5d0f..bce964c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -537,6 +537,7 @@ static const struct nla_policy mntr_flags_policy[NL80211_MNTR_FLAG_MAX + 1] = {
 	[NL80211_MNTR_FLAG_CONTROL] = { .type = NLA_FLAG },
 	[NL80211_MNTR_FLAG_OTHER_BSS] = { .type = NLA_FLAG },
 	[NL80211_MNTR_FLAG_COOK_FRAMES] = { .type = NLA_FLAG },
+	[NL80211_MNTR_FLAG_AP_MGT] = { .type = NLA_FLAG },
 };
 
 static int parse_monitor_flags(struct nlattr *nla, u32 *mntrflags)
-- 
1.6.1.rc3.51.g5832d

