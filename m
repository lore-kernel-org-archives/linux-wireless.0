Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49590 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab2LLSef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 13:34:35 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: allow drivers to selectively disable 80/160 MHz
Date: Wed, 12 Dec 2012 19:34:55 +0100
Message-Id: <1355337296-5815-2-git-send-email-johannes@sipsolutions.net> (sfid-20121212_193440_164192_B4EC9D77)
In-Reply-To: <1355337296-5815-1-git-send-email-johannes@sipsolutions.net>
References: <1355337296-5815-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some drivers might support 80 or 160 MHz only on some
channels for whatever reason, so allow them to disable
these channel widths. Also maintain the new flags when
regulatory bandwidth limitations would disable these
wide channels.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 12 ++++++++++++
 net/wireless/chan.c    |  7 ++++++-
 net/wireless/reg.c     |  8 ++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index acbf5e0..b6942a6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -99,6 +99,16 @@ enum ieee80211_band {
  * @IEEE80211_CHAN_NO_HT40MINUS: extension channel below this channel
  * 	is not permitted.
  * @IEEE80211_CHAN_NO_OFDM: OFDM is not allowed on this channel.
+ * @IEEE80211_CHAN_NO_80MHZ: If the driver supports 80 MHz on the band,
+ *	this flag indicates that an 80 MHz channel cannot use this
+ *	channel as the control or any of the secondary channels.
+ *	This may be due to the driver or due to regulatory bandwidth
+ *	restrictions.
+ * @IEEE80211_CHAN_NO_160MHZ: If the driver supports 160 MHz on the band,
+ *	this flag indicates that an 160 MHz channel cannot use this
+ *	channel as the control or any of the secondary channels.
+ *	This may be due to the driver or due to regulatory bandwidth
+ *	restrictions.
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
@@ -108,6 +118,8 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_HT40PLUS	= 1<<4,
 	IEEE80211_CHAN_NO_HT40MINUS	= 1<<5,
 	IEEE80211_CHAN_NO_OFDM		= 1<<6,
+	IEEE80211_CHAN_NO_80MHZ		= 1<<7,
+	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 10b3475..32d1dd4 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -253,6 +253,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	case NL80211_CHAN_WIDTH_80:
 		if (!vht_cap->vht_supported)
 			return false;
+		prohibited_flags |= IEEE80211_CHAN_NO_80MHZ;
 		width = 80;
 		break;
 	case NL80211_CHAN_WIDTH_160:
@@ -260,6 +261,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			return false;
 		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ))
 			return false;
+		prohibited_flags |= IEEE80211_CHAN_NO_160MHZ;
 		width = 160;
 		break;
 	default:
@@ -272,7 +274,10 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	 *	 allowed by the driver, or only certain combinations?
 	 *	 For 40 MHz the driver can set the NO_HT40 flags, but for
 	 *	 80/160 MHz and in particular 80+80 MHz this isn't really
-	 *	 feasible -- should we ask the driver here?
+	 *	 feasible and we only have NO_80MHZ/NO_160MHZ so far but
+	 *	 no way to cover 80+80 MHz or more complex restrictions.
+	 *	 Note that the restrictions also need to be advertised to
+	 *	 userspace, for example for P2P channel selection.
 	 */
 
 	if (width > 20)
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e1eb503..4d374f8 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -899,6 +899,10 @@ static void handle_channel(struct wiphy *wiphy,
 
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
+		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(160))
+		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
 
 	if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
@@ -1291,6 +1295,10 @@ static void handle_channel_custom(struct wiphy *wiphy,
 
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
+		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(160))
+		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
 
 	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
 	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
-- 
1.8.0

