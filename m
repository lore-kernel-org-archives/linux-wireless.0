Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42179 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbAALms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2015 06:42:48 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so26617529wid.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jan 2015 03:42:46 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] cfg80211: introduce sync regdom set API for self-managed
Date: Thu,  1 Jan 2015 13:42:42 +0200
Message-Id: <1420112563-3981-1-git-send-email-arik@wizery.com> (sfid-20150101_124317_934243_E2078303)
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
 net/wireless/reg.c     | 17 +++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bd672ea..cb0bba2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3827,6 +3827,20 @@ int regulatory_set_wiphy_regd(struct wiphy *wiphy,
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
index 9a5411c..9b5662f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2928,6 +2928,23 @@ int regulatory_set_wiphy_regd(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(regulatory_set_wiphy_regd);
 
+int regulatory_set_wiphy_regd_sync_rtnl(struct wiphy *wiphy,
+					struct ieee80211_regdomain *rd)
+{
+	int ret;
+
+	ASSERT_RTNL();
+
+	ret = regulatory_set_wiphy_regd(wiphy, rd);
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

