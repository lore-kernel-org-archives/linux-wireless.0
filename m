Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40326 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaAVKfD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:35:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/7] cfg80211: make device_type const
Date: Wed, 22 Jan 2014 11:34:55 +0100
Message-Id: <1390386898-14316-5-git-send-email-johannes@sipsolutions.net> (sfid-20140122_113533_563598_0726A3A3)
In-Reply-To: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
References: <1390386898-14316-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instances of struct device_type are never modified, make them const.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 2 +-
 net/wireless/reg.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d89dee2..b5ff39a 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -737,7 +737,7 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 }
 EXPORT_SYMBOL(cfg80211_unregister_wdev);
 
-static struct device_type wiphy_type = {
+static const struct device_type wiphy_type = {
 	.name	= "wlan",
 };
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f6a6a8b..64b1f73 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -91,7 +91,7 @@ static struct regulatory_request __rcu *last_request =
 /* To trigger userspace events */
 static struct platform_device *reg_pdev;
 
-static struct device_type reg_device_type = {
+static const struct device_type reg_device_type = {
 	.uevent = reg_device_uevent,
 };
 
-- 
1.8.5.1

