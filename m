Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50930 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbZA0AXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 19:23:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 16:23:32 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>, <Jouni.Malinen@atheros.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: do not TX injected frames when not allowed
Date: Mon, 26 Jan 2009 16:22:51 -0800
Message-ID: <1233015771-1309-1-git-send-email-lrodriguez@atheros.com> (sfid-20090127_012346_222778_33B21D3F)
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

This now works, I moved the check as recommended by Johannes to
ieee80211_monitor_start_xmit(), the issues I ran into earlier seem
to be due to a work around set in place for 11w.

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
index 7b013fb..e752f6d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1432,11 +1432,25 @@ int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 int ieee80211_monitor_start_xmit(struct sk_buff *skb,
 				 struct net_device *dev)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_channel *chan = local->hw.conf.channel;
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
 	u16 len_rthdr;
 
+	/* Frame injection is not allowed if beaconing is not allowed
+	 * or if we need radar detection. Beaconing is usually not allowed when
+	 * the mode or operation (Adhoc, AP, Mesh) does not support DFS.
+	 * Since AP mode uses monitor interfaces to inject/TX management
+	 * frames we make AP mode the exception to this rule as its
+	 * implementation can deal with radar detection by itself. */
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_MONITOR))
+		return TX_DROP;
+	if (!(sdata->u.mntr_flags & MONITOR_FLAG_AP_MGT) &&
+	   (chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR)))
+		return TX_DROP;
+
 	/* check for not even having the fixed radiotap header part */
 	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
 		goto fail; /* too short to be possibly valid */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4baa875..693cb73 100644
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
1.5.6.4

