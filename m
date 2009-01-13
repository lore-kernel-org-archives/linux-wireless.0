Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19372 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZAMT61 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:58:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:58:27 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 03/12] cfg80211: add option for wiphys to disregard country IEs
Date: Tue, 13 Jan 2009 11:57:46 -0800
Message-ID: <1231876675-20518-4-git-send-email-lrodriguez@atheros.com> (sfid-20090113_205830_652452_BF4A95A2)
In-Reply-To: <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Country IEs can be disregarded based on regulatory policy by
a driver. This is only possible, of course, if the driver already
has its own regulatory domain.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |    4 ++++
 net/wireless/reg.c     |   17 +++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index 9e73aae..ea89958 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -181,6 +181,9 @@ struct ieee80211_supported_band {
  * struct wiphy - wireless hardware description
  * @idx: the wiphy index assigned to this item
  * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
+ * @ignore_country_ies: tells us the wireless core should ignore country IEs
+ *	received by itself or by other wireless drivers. This will only
+ *	apply if the driver has provided a regulatory_hint()
  * @fw_handles_regulatory: tells us the firmware for this device
  * 	has its own regulatory solution and cannot identify the
  * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
@@ -202,6 +205,7 @@ struct wiphy {
 	u16 interface_modes;
 
 	bool fw_handles_regulatory;
+	bool ignore_country_ies;
 
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1a5b37a..49c9c25 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -782,12 +782,16 @@ static u32 map_regdom_flags(u32 rd_flags)
 	return channel_flags;
 }
 
-/* Follow the driver's regulatory domain, if present, unless a country
- * IE has been processed */
+/* Follow the driver's regulatory domain if a driver always prefers
+ * that. If no preference is specified we follow the driver's regulatory
+ * domain unless a country IE has been processed */
 static int reg_follow_driver_regd(struct wiphy *wiphy)
 {
-	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE &&
-	    wiphy->regd)
+	if (!wiphy->regd)
+		return false;
+	if (wiphy->ignore_country_ies)
+		return true;
+	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE)
 		return true;
 	return false;
 }
@@ -890,7 +894,7 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		 *
 		 * http://tinyurl.com/11d-clarification
 		 */
-		if (r == -ERANGE &&
+		if (!reg_follow_driver_regd(wiphy) && r == -ERANGE &&
 		    last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
 #ifdef CONFIG_CFG80211_REG_DEBUG
 			printk(KERN_DEBUG "cfg80211: Leaving channel %d MHz "
@@ -902,7 +906,8 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		/* In this case we know the country IE has at least one reg rule
 		 * for the band so we respect its band definitions */
 #ifdef CONFIG_CFG80211_REG_DEBUG
-			if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
+			if (!reg_follow_driver_regd(wiphy) &&
+			    last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
 				printk(KERN_DEBUG "cfg80211: Disabling "
 					"channel %d MHz on %s due to "
 					"Country IE\n",
-- 
1.6.1.rc3.51.g5832d

