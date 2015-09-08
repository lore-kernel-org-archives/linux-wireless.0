Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34541 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbbIHP4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 11:56:16 -0400
Received: by padhy16 with SMTP id hy16so125284728pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 08:56:16 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/30] staging: wilc1000: rename WILC_WFI_CfgScan
Date: Wed,  9 Sep 2015 00:55:39 +0900
Message-Id: <1441727767-26026-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150908_175619_490906_B17849EF)
In-Reply-To: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441727767-26026-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_CfgScan with wilc_cfg80211_scan to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 585ea5e..087f36e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -712,7 +712,7 @@ static int wilc_cfg80211_set_monitor_channel(struct wiphy *wiphy,
 }
 
 /**
- *  @brief      WILC_WFI_CfgScan
+ *  @brief      wilc_cfg80211_scan
  *  @details    Request to do a scan. If returning zero, the scan request is given
  *                      the driver, and will be valid until passed to cfg80211_scan_done().
  *                      For scan results, call cfg80211_inform_bss(); you can call this outside
@@ -728,7 +728,7 @@ static int wilc_cfg80211_set_monitor_channel(struct wiphy *wiphy,
  *	kernel version 3.8.8 supported
  *	tony, sswd, WILC-KR, 2013-10-29
  */
-static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
+static int wilc_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct WILC_WFI_priv *priv;
 	u32 i;
@@ -3604,7 +3604,7 @@ int WILC_WFI_del_virt_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 
 	.set_monitor_channel = wilc_cfg80211_set_monitor_channel,
-	.scan = WILC_WFI_CfgScan,
+	.scan = wilc_cfg80211_scan,
 	.connect = WILC_WFI_CfgConnect,
 	.disconnect = WILC_WFI_disconnect,
 	.add_key = WILC_WFI_add_key,
-- 
2.5.1

