Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24634 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYKHCBM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 21:01:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2008 18:01:12 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>, <yi.zhu@intel.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] cfg80211: add support for custom firmware regulatory solutions
Date: Fri, 7 Nov 2008 18:01:07 -0800
Message-ID: <1226109668-13778-2-git-send-email-lrodriguez@atheros.com> (sfid-20081108_030117_391300_C211E5E7)
In-Reply-To: <1226109668-13778-1-git-send-email-lrodriguez@atheros.com>
References: <1226109668-13778-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds API to cfg80211 to allow wireless drivers to inform
us if their firmware can handle regulatory considerations *and*
they cannot map these regulatory domains to an ISO / IEC 3166
alpha2. In these cases we skip the first regulatory hint instead
of expecting the driver to build their own regulatory structure,
providing us with an alpha2, or using the reg_notifier().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |    7 +++++++
 net/wireless/reg.c     |   13 ++++++++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index 618b8aa..aedefa5 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -181,6 +181,11 @@ struct ieee80211_supported_band {
  * struct wiphy - wireless hardware description
  * @idx: the wiphy index assigned to this item
  * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
+ * @fw_handles_regulatory: tells us the firmware for this device
+ * 	has its own regulatory solution and cannot identify the
+ * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
+ * 	we will disregard the first regulatory hint (when the
+ * 	initiator is %REGDOM_SET_BY_CORE).
  * @reg_notifier: the driver's regulatory notification callback
  */
 struct wiphy {
@@ -192,6 +197,8 @@ struct wiphy {
 	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
 	u16 interface_modes;
 
+	bool fw_handles_regulatory;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4dab993..0990059 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -816,12 +816,23 @@ static void handle_band(struct ieee80211_supported_band *sband)
 		handle_channel(&sband->channels[i]);
 }
 
+static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby)
+{
+	if (!last_request)
+		return true;
+	if (setby == REGDOM_SET_BY_CORE &&
+		  wiphy->fw_handles_regulatory)
+		return true;
+	return false;
+}
+
 static void update_all_wiphy_regulatory(enum reg_set_by setby)
 {
 	struct cfg80211_registered_device *drv;
 
 	list_for_each_entry(drv, &cfg80211_drv_list, list)
-		wiphy_update_regulatory(&drv->wiphy, setby);
+		if (!ignore_reg_update(&drv->wiphy, setby))
+			wiphy_update_regulatory(&drv->wiphy, setby);
 }
 
 void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
-- 
1.5.6.3

