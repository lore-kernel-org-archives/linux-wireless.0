Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3BMXsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 18:48:01 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, green@qca.qualcomm.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/3] cfg80211: allow drivers to selectively disable 80/160 MHz
Date: Thu, 14 Feb 2013 00:47:53 +0100
Message-Id: <1360799274-16088-3-git-send-email-johannes@sipsolutions.net> (sfid-20130214_004806_895522_090B81FA)
In-Reply-To: <1360799274-16088-1-git-send-email-johannes@sipsolutions.net>
References: <1360799274-16088-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some drivers might support 80 or 160 MHz only on some
channels for whatever reason, so allow them to disable
these channel widths. Also maintain the new flags when
regulatory bandwidth limitations would disable these
wide channels.

Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 12 ++++++++++++
 net/wireless/chan.c    | 13 ++++++++++++-
 net/wireless/reg.c     |  8 ++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 767599c..80cf5af 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -100,6 +100,16 @@ enum ieee80211_band {
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
@@ -109,6 +119,8 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_HT40PLUS	= 1<<4,
 	IEEE80211_CHAN_NO_HT40MINUS	= 1<<5,
 	IEEE80211_CHAN_NO_OFDM		= 1<<6,
+	IEEE80211_CHAN_NO_80MHZ		= 1<<7,
+	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 810c23c..fd556ac 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -375,6 +375,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	case NL80211_CHAN_WIDTH_80:
 		if (!vht_cap->vht_supported)
 			return false;
+		prohibited_flags |= IEEE80211_CHAN_NO_80MHZ;
 		width = 80;
 		break;
 	case NL80211_CHAN_WIDTH_160:
@@ -382,6 +383,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			return false;
 		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ))
 			return false;
+		prohibited_flags |= IEEE80211_CHAN_NO_160MHZ;
 		width = 160;
 		break;
 	default:
@@ -389,7 +391,16 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 		return false;
 	}
 
-	/* TODO: missing regulatory check on 80/160 bandwidth */
+	/*
+	 * TODO: What if there are only certain 80/160/80+80 MHz channels
+	 *	 allowed by the driver, or only certain combinations?
+	 *	 For 40 MHz the driver can set the NO_HT40 flags, but for
+	 *	 80/160 MHz and in particular 80+80 MHz this isn't really
+	 *	 feasible and we only have NO_80MHZ/NO_160MHZ so far but
+	 *	 no way to cover 80+80 MHz or more complex restrictions.
+	 *	 Note that such restrictions also need to be advertised to
+	 *	 userspace, for example for P2P channel selection.
+	 */
 
 	if (width > 20)
 		prohibited_flags |= IEEE80211_CHAN_NO_OFDM;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index bf35e1f..dee9ab4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -866,6 +866,10 @@ static void handle_channel(struct wiphy *wiphy,
 
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
+		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(160))
+		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
 
 	if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
@@ -1264,6 +1268,10 @@ static void handle_channel_custom(struct wiphy *wiphy,
 
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

