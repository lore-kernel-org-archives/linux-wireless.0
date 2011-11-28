Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38986 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1K1VrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 16:47:23 -0500
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3 1/2] cfg80211: fix race on init and driver registration
Date: Mon, 28 Nov 2011 16:47:15 -0500
Message-Id: <1322516836-5474-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_224726_522632_B6FCF8A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a theoretical race that if hit will trigger
a crash. The race is between when we issue the first
regulatory hint, regulatory_hint_core(), gets processed
by the workqueue and between when the first device
gets registered to the wireless core. This is not easy
to reproduce but it was easy to do so through the
regulatory simulator I have been working on. This
is a port of the fix I implemented there [1].

[1] https://github.com/mcgrof/regsim/commit/a246ccf81f059cb662eee288aa13100f631e4cc8

Cc: stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/reg.c |   43 +++++++++++++++++++++++++++----------------
 1 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 76b35df..a5f0ac7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -57,8 +57,17 @@
 #define REG_DBG_PRINT(args...)
 #endif
 
+static struct regulatory_request core_request_world = {
+	.initiator = NL80211_REGDOM_SET_BY_CORE,
+	.alpha2[0] = '0',
+	.alpha2[1] = '0',
+	.intersect = false,
+	.processed = true,
+	.country_ie_env = ENVIRON_ANY,
+};
+
 /* Receipt of information from last regulatory request */
-static struct regulatory_request *last_request;
+static struct regulatory_request *last_request = &core_request_world;
 
 /* To trigger userspace events */
 static struct platform_device *reg_pdev;
@@ -150,7 +159,7 @@ static char user_alpha2[2];
 module_param(ieee80211_regdom, charp, 0444);
 MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
 
-static void reset_regdomains(void)
+static void reset_regdomains(bool full_reset)
 {
 	/* avoid freeing static information or freeing something twice */
 	if (cfg80211_regdomain == cfg80211_world_regdom)
@@ -165,6 +174,13 @@ static void reset_regdomains(void)
 
 	cfg80211_world_regdom = &world_regdom;
 	cfg80211_regdomain = NULL;
+
+	if (!full_reset)
+		return;
+
+	if (last_request != &core_request_world)
+		kfree(last_request);
+	last_request = &core_request_world;
 }
 
 /*
@@ -175,7 +191,7 @@ static void update_world_regdomain(const struct ieee80211_regdomain *rd)
 {
 	BUG_ON(!last_request);
 
-	reset_regdomains();
+	reset_regdomains(false);
 
 	cfg80211_world_regdom = rd;
 	cfg80211_regdomain = rd;
@@ -1409,7 +1425,8 @@ static int __regulatory_hint(struct wiphy *wiphy,
 	}
 
 new_request:
-	kfree(last_request);
+	if (last_request != &core_request_world)
+		kfree(last_request);
 
 	last_request = pending_request;
 	last_request->intersect = intersect;
@@ -1579,9 +1596,6 @@ static int regulatory_hint_core(const char *alpha2)
 {
 	struct regulatory_request *request;
 
-	kfree(last_request);
-	last_request = NULL;
-
 	request = kzalloc(sizeof(struct regulatory_request),
 			  GFP_KERNEL);
 	if (!request)
@@ -1779,7 +1793,7 @@ static void restore_regulatory_settings(bool reset_user)
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
 
-	reset_regdomains();
+	reset_regdomains(true);
 	restore_alpha2(alpha2, reset_user);
 
 	/*
@@ -2085,7 +2099,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		int r;
 
 		if (last_request->initiator != NL80211_REGDOM_SET_BY_DRIVER) {
-			reset_regdomains();
+			reset_regdomains(false);
 			cfg80211_regdomain = rd;
 			return 0;
 		}
@@ -2106,7 +2120,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		if (r)
 			return r;
 
-		reset_regdomains();
+		reset_regdomains(false);
 		cfg80211_regdomain = rd;
 		return 0;
 	}
@@ -2131,7 +2145,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 
 		rd = NULL;
 
-		reset_regdomains();
+		reset_regdomains(false);
 		cfg80211_regdomain = intersected_rd;
 
 		return 0;
@@ -2151,7 +2165,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	kfree(rd);
 	rd = NULL;
 
-	reset_regdomains();
+	reset_regdomains(false);
 	cfg80211_regdomain = intersected_rd;
 
 	return 0;
@@ -2304,11 +2318,8 @@ void /* __init_or_exit */ regulatory_exit(void)
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
 
-	reset_regdomains();
-
-	kfree(last_request);
+	reset_regdomains(true);
 
-	last_request = NULL;
 	dev_set_uevent_suppress(&reg_pdev->dev, true);
 
 	platform_device_unregister(reg_pdev);
-- 
1.7.4.15.g7811d

