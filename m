Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39174 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab1KWPEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:04:55 -0500
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/2] cfg80211: fix race on init and driver registration
Date: Wed, 23 Nov 2011 10:04:46 -0500
Message-Id: <1322060687-6512-2-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_160458_865343_B56E9050)
In-Reply-To: <1322060687-6512-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322060687-6512-1-git-send-email-mcgrof@qca.qualcomm.com>
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
 net/wireless/reg.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 76b35df..df73b96 100644
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
@@ -165,6 +174,10 @@ static void reset_regdomains(void)
 
 	cfg80211_world_regdom = &world_regdom;
 	cfg80211_regdomain = NULL;
+
+	if (last_request != &core_request_world)
+		kfree(last_request);
+	last_request = &core_request_world;
 }
 
 /*
@@ -1409,7 +1422,8 @@ static int __regulatory_hint(struct wiphy *wiphy,
 	}
 
 new_request:
-	kfree(last_request);
+	if (last_request != &core_request_world)
+		kfree(last_request);
 
 	last_request = pending_request;
 	last_request->intersect = intersect;
@@ -1579,9 +1593,6 @@ static int regulatory_hint_core(const char *alpha2)
 {
 	struct regulatory_request *request;
 
-	kfree(last_request);
-	last_request = NULL;
-
 	request = kzalloc(sizeof(struct regulatory_request),
 			  GFP_KERNEL);
 	if (!request)
@@ -1823,6 +1834,10 @@ static void restore_regulatory_settings(bool reset_user)
 	/* First restore to the basic regulatory settings */
 	cfg80211_regdomain = cfg80211_world_regdom;
 
+	if (last_request != &core_request_world)
+		kfree(last_request);
+	last_request = &core_request_world;
+
 	mutex_unlock(&reg_mutex);
 	mutex_unlock(&cfg80211_mutex);
 
@@ -2306,9 +2321,6 @@ void /* __init_or_exit */ regulatory_exit(void)
 
 	reset_regdomains();
 
-	kfree(last_request);
-
-	last_request = NULL;
 	dev_set_uevent_suppress(&reg_pdev->dev, true);
 
 	platform_device_unregister(reg_pdev);
-- 
1.7.4.15.g7811d

