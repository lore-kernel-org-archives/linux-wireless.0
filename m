Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:54783 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbbKWS14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 13:27:56 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	=?UTF-8?q?Jan=20Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>,
	Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH v2 6/8] cfg80211: reg: Add NL80211_RRF_USER_REGD_NEEDED flag
Date: Mon, 23 Nov 2015 19:27:19 +0100
Message-Id: <1448303241-27747-7-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192804_844242_D8C85F7B)
In-Reply-To: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to prevent accidental use of Intelligent Transportation System
band (5.9 GHz), we require system integrators to provide custom
userspace regulatory database enabling the use of the band. However,
drivers that provide their own regulatory database (such as ath9k) would
not enable that band in this case, because they do not allow using other
bands than those specified in their database.

The NL80211_RRF_USER_REGD_NEEDED flag introduced in this commit allows
drivers to specify that certain band is enabled only if it is
additionally enabled in user-supplied regulatory database. If the band
is not present there, the channels are simply disabled.

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h |  4 ++++
 net/wireless/reg.c           | 15 +++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b47ac3e..75026d3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -118,6 +118,8 @@ enum ieee80211_band {
  * @IEEE80211_CHAN_NO_10MHZ: 10 MHz bandwidth is not permitted
  *	on this channel.
  * @IEEE80211_CHAN_OCB_ONLY: only OCB mode is allowed on this channel.
+ * @IEEE80211_CHAN_USER_REGD_NEEDED: can only be used if allowed by
+ *	user-supplied regulatory domain.
  *
  */
 enum ieee80211_channel_flags {
@@ -135,6 +137,7 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_20MHZ		= 1<<11,
 	IEEE80211_CHAN_NO_10MHZ		= 1<<12,
 	IEEE80211_CHAN_OCB_ONLY		= 1<<13,
+	IEEE80211_CHAN_USER_REGD_NEEDED	= 1<<14,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 07e6105..ae17589 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2866,6 +2866,9 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_NO_80MHZ: 80MHz operation not allowed
  * @NL80211_RRF_NO_160MHZ: 160MHz operation not allowed
  * @NL80211_RRF_OCB_ONLY: only OCB mode can be used here
+ * @NL80211_RRF_USER_REGD_NEEDED: when specified in driver's
+ *	CUSTOM_REG regulatory domain, the band can only be used if it
+ *	is also allowed in user-supplied regulatory domain.
  */
 enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_OFDM		= 1<<0,
@@ -2884,6 +2887,7 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_80MHZ		= 1<<15,
 	NL80211_RRF_NO_160MHZ		= 1<<16,
 	NL80211_RRF_OCB_ONLY		= 1<<17,
+	NL80211_RRF_USER_REGD_NEEDED	= 1<<18,
 };
 
 #define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8b7110d..9d9d826 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1050,6 +1050,8 @@ static u32 map_regdom_flags(u32 rd_flags)
 		channel_flags |= IEEE80211_CHAN_NO_160MHZ;
 	if (rd_flags & NL80211_RRF_OCB_ONLY)
 		channel_flags |= IEEE80211_CHAN_OCB_ONLY;
+	if (rd_flags & NL80211_RRF_USER_REGD_NEEDED)
+		channel_flags |= IEEE80211_CHAN_USER_REGD_NEEDED;
 	return channel_flags;
 }
 
@@ -1280,6 +1282,16 @@ static void handle_channel(struct wiphy *wiphy,
 		return;
 	}
 
+	if (lr->initiator == NL80211_REGDOM_SET_BY_USER &&
+	    flags & IEEE80211_CHAN_USER_REGD_NEEDED) {
+		/* The driver allows using this frequency only if it
+		 * is allowed in user-supplied regulatory domain,
+		 * which is the case here. This is the only place
+		 * where a disabled channel can be enabled again.
+		 */
+		flags &= ~IEEE80211_CHAN_DISABLED;
+	}
+
 	chan->dfs_state = NL80211_DFS_USABLE;
 	chan->dfs_state_entered = jiffies;
 
@@ -1798,6 +1810,9 @@ static void handle_channel_custom(struct wiphy *wiphy,
 
 	chan->beacon_found = false;
 
+	if (reg_rule->flags & NL80211_RRF_USER_REGD_NEEDED)
+		chan->flags |= IEEE80211_CHAN_DISABLED;
+
 	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
 		chan->flags = chan->orig_flags | bw_flags |
 			      map_regdom_flags(reg_rule->flags);
-- 
2.5.3

