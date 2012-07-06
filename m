Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32314 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513Ab2GFWU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 18:20:56 -0400
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	<arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
Subject: [PATCH v3 3/3] cfg80211: rename reg_device_remove() to wiphy_regulatory_deregister()
Date: Fri, 6 Jul 2012 15:20:26 -0700
Message-ID: <1341613226-11774-4-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120707_002114_573776_B3735E6B)
In-Reply-To: <1341613226-11774-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1341613226-11774-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
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
index 153f7dc..13c7b0c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -648,9 +648,11 @@ void wiphy_unregister(struct wiphy *wiphy)
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

