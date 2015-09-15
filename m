Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33661 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbbIOFG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:06:56 -0400
Received: by pacex6 with SMTP id ex6so165309201pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:06:56 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/18] staging: wilc1000: rename WILC_WFI_cfg80211_ops
Date: Tue, 15 Sep 2015 14:06:12 +0900
Message-Id: <1442293588-15323-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_070726_826097_0270F6B7)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_cfg80211_ops with wilc_cfg80211_ops to
avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 068e648..5941696 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3556,7 +3556,7 @@ int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)      /* ton
 
 
 #endif /*WILC_AP_EXTERNAL_MLME*/
-static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
+static struct cfg80211_ops wilc_cfg80211_ops = {
 
 	.set_monitor_channel = set_channel,
 	.scan = scan,
@@ -3669,7 +3669,7 @@ struct wireless_dev *WILC_WFI_CfgAlloc(void)
 	}
 
 	/*Creating a new wiphy, linking wireless structure with the wiphy structure*/
-	wdev->wiphy = wiphy_new(&WILC_WFI_cfg80211_ops, sizeof(struct WILC_WFI_priv));
+	wdev->wiphy = wiphy_new(&wilc_cfg80211_ops, sizeof(struct WILC_WFI_priv));
 	if (!wdev->wiphy) {
 		PRINT_ER("Cannot allocate wiphy\n");
 		goto _fail_mem_;
-- 
2.5.1

