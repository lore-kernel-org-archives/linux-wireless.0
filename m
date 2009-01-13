Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19391 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbZAMT6g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:58:36 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 11:58:36 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 06/12] cfg80211: add regdom_intersect_wiphy_regd()
Date: Tue, 13 Jan 2009 11:57:49 -0800
Message-ID: <1231876675-20518-7-git-send-email-lrodriguez@atheros.com> (sfid-20090113_205838_944901_8ECBF2BE)
In-Reply-To: <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds regdom_intersect_wiphy_regd() which can be used by drivers
on their reg_notifier() to further restrict the device's regulatory domain.
This is important for devices where calibration outside of the device's
supported regulatory domain is not supported or certified through proper
testing for operation.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |   14 ++++++++++++++
 net/wireless/reg.c     |   15 +++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index 16f020a..cb04e7b 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -423,4 +423,18 @@ extern int regulatory_set_custom_rd(
 	struct wiphy *wiphy,
 	const struct ieee80211_regdomain *custom_regd);
 
+/**
+ * regdom_intersect_wiphy_regd - do intersection on driver's regulatory domain
+ * @wiphy: the wireless device we want to process the intersected regulatory
+ *     domain on
+ *
+ * This function can be used on a driver's reg_notifier() when cfg80211's
+ * regulatory domain has been updated and a driver must follow nothing
+ * more than what was on its own driver regulatory domain. The driver must
+ * have previously called regulatory_hint() or regulatory_set_custom_rd().
+ * Note that the reg_notifier() is called with the cfg80211_drv_mutex already
+ * held.
+ */
+extern int regdom_intersect_wiphy_regd(struct wiphy *wiphy);
+
 #endif /* __NET_WIRELESS_H */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b05df36..88e8ff0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -979,6 +979,21 @@ void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
 		wiphy->reg_notifier(wiphy, setby);
 }
 
+/* Does not call the reg_notifier() */
+int regdom_intersect_wiphy_regd(struct wiphy *wiphy)
+{
+	const struct ieee80211_regdomain *regd;
+	BUG_ON(!wiphy->regd);
+	regd = regdom_intersect(wiphy->regd, cfg80211_regdomain);
+	if (!regd)
+		return -EINVAL;
+	kfree(wiphy->regd);
+	wiphy->regd = regd;
+	regd_update_regulatory(wiphy);
+	return 0;
+}
+EXPORT_SYMBOL(regdom_intersect_wiphy_regd);
+
 static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 			 const struct ieee80211_regdomain *src_regd)
 {
-- 
1.6.1.rc3.51.g5832d

