Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56456 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab2GLStm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 14:49:42 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so4121581pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 11:49:42 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH v5 3/5] cfg80211: rename reg_device_remove() to wiphy_regulatory_deregister()
Date: Thu, 12 Jul 2012 11:49:19 -0700
Message-Id: <1342118961-13008-4-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20120712_204945_707954_0168EDE3)
In-Reply-To: <1342118961-13008-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1342118961-13008-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

This makes it clearer what we're doing. This now makes a bit
more sense given that regardless of the wiphy if the cell
base station hint feature is supported we will be modifying the
way the regulatory core behaves.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/core.c |    8 +++++---
 net/wireless/reg.c  |    2 +-
 net/wireless/reg.h  |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 4c11c7f..9a64b65 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -653,9 +653,11 @@ void wiphy_unregister(struct wiphy *wiphy)
 	/* nothing */
 	cfg80211_unlock_rdev(rdev);
 
-	/* If this device got a regulatory hint tell core its
-	 * free to listen now to a new shiny device regulatory hint */
-	reg_device_remove(wiphy);
+	/*
+	 * If this device got a regulatory hint tell core its
+	 * free to listen now to a new shiny device regulatory hint
+	 */
+	wiphy_regulatory_deregister(wiphy);
 
 	cfg80211_rdev_list_generation++;
 	device_del(&rdev->wiphy.dev);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 05af62d..43b7750 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2388,7 +2388,7 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
 }
 
 /* Caller must hold cfg80211_mutex */
-void reg_device_remove(struct wiphy *wiphy)
+void wiphy_regulatory_deregister(struct wiphy *wiphy)
 {
 	struct wiphy *request_wiphy = NULL;
 
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 519492f..f36b15f 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -27,7 +27,7 @@ int regulatory_hint_user(const char *alpha2,
 
 int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env);
 void wiphy_regulatory_register(struct wiphy *wiphy);
-void reg_device_remove(struct wiphy *wiphy);
+void wiphy_regulatory_deregister(struct wiphy *wiphy);
 
 int __init regulatory_init(void);
 void regulatory_exit(void);
-- 
1.7.10.rc1.22.gf5241

