Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:46263 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbAGOrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 09:47:24 -0500
Received: by mail-wg0-f53.google.com with SMTP id x13so1318156wgg.12
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 06:47:23 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 1/2] cfg80211: introduce sync regdom set API for self-managed
Date: Wed,  7 Jan 2015 16:47:19 +0200
Message-Id: <1420642040-4530-1-git-send-email-arik@wizery.com> (sfid-20150107_154727_340148_6B0E2F51)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A self-managed device will sometimes need to set its regdomain synchronously.
Notably it should be set before usermode has a chance to query it. Expose
a new API to accomplish this which requires the RTNL.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h | 14 ++++++++++++++
 net/wireless/reg.c     | 31 +++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f38645f..39d102d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3830,6 +3830,20 @@ int regulatory_set_wiphy_regd(struct wiphy *wiphy,
 			      struct ieee80211_regdomain *rd);
 
 /**
+ * regulatory_set_wiphy_regd_sync_rtnl - set regdom for self-managed drivers
+ * @wiphy: the wireless device we want to process the regulatory domain on
+ * @rd: the regulatory domain information to use for this wiphy
+ *
+ * This functions requires the RTNL to be held and applies the new regdomain
+ * synchronously to this wiphy. For more details see
+ * regulatory_set_wiphy_regd().
+ *
+ * Return: 0 on success. -EINVAL, -EPERM
+ */
+int regulatory_set_wiphy_regd_sync_rtnl(struct wiphy *wiphy,
+					struct ieee80211_regdomain *rd);
+
+/**
  * wiphy_apply_custom_regulatory - apply a custom driver regulatory domain
  * @wiphy: the wireless device we want to process the regulatory domain on
  * @regd: the custom regulatory domain to use for this wiphy
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index fde4e17..521f3a4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2909,8 +2909,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	return 0;
 }
 
-int regulatory_set_wiphy_regd(struct wiphy *wiphy,
-			      struct ieee80211_regdomain *rd)
+static int __regulatory_set_wiphy_regd(struct wiphy *wiphy,
+				       struct ieee80211_regdomain *rd)
 {
 	const struct ieee80211_regdomain *regd;
 	const struct ieee80211_regdomain *prev_regd;
@@ -2940,12 +2940,39 @@ int regulatory_set_wiphy_regd(struct wiphy *wiphy,
 	spin_unlock(&reg_requests_lock);
 
 	kfree(prev_regd);
+	return 0;
+}
+
+int regulatory_set_wiphy_regd(struct wiphy *wiphy,
+			      struct ieee80211_regdomain *rd)
+{
+	int ret = __regulatory_set_wiphy_regd(wiphy, rd);
+
+	if (ret)
+		return ret;
 
 	schedule_work(&reg_work);
 	return 0;
 }
 EXPORT_SYMBOL(regulatory_set_wiphy_regd);
 
+int regulatory_set_wiphy_regd_sync_rtnl(struct wiphy *wiphy,
+					struct ieee80211_regdomain *rd)
+{
+	int ret;
+
+	ASSERT_RTNL();
+
+	ret = __regulatory_set_wiphy_regd(wiphy, rd);
+	if (ret)
+		return ret;
+
+	/* process the request immediately */
+	reg_process_self_managed_hints();
+	return 0;
+}
+EXPORT_SYMBOL(regulatory_set_wiphy_regd_sync_rtnl);
+
 void wiphy_regulatory_register(struct wiphy *wiphy)
 {
 	struct regulatory_request *lr;
-- 
2.1.0

