Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36413 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbbINDYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2015 23:24:42 -0400
Received: by padhk3 with SMTP id hk3so129775466pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2015 20:24:41 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 02/31] staging: wilc1000: rename WILC_WFI_CfgScan
Date: Mon, 14 Sep 2015 12:24:02 +0900
Message-Id: <1442201071-16155-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150914_052449_701508_9FF7311E)
In-Reply-To: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442201071-16155-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_WFI_CfgScan with scan to avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: remove "wilc_" prefix

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c2060ff..2c39179 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -712,7 +712,7 @@ static int set_channel(struct wiphy *wiphy,
 }
 
 /**
- *  @brief      WILC_WFI_CfgScan
+ *  @brief      scan
  *  @details    Request to do a scan. If returning zero, the scan request is given
  *                      the driver, and will be valid until passed to cfg80211_scan_done().
  *                      For scan results, call cfg80211_inform_bss(); you can call this outside
@@ -728,7 +728,7 @@ static int set_channel(struct wiphy *wiphy,
  *	kernel version 3.8.8 supported
  *	tony, sswd, WILC-KR, 2013-10-29
  */
-static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
+static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct WILC_WFI_priv *priv;
 	u32 i;
@@ -3559,7 +3559,7 @@ int WILC_WFI_del_virt_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 static struct cfg80211_ops WILC_WFI_cfg80211_ops = {
 
 	.set_monitor_channel = set_channel,
-	.scan = WILC_WFI_CfgScan,
+	.scan = scan,
 	.connect = WILC_WFI_CfgConnect,
 	.disconnect = WILC_WFI_disconnect,
 	.add_key = WILC_WFI_add_key,
-- 
2.5.1

