Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36310 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbbIQHtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 03:49:03 -0400
Received: by padhk3 with SMTP id hk3so13291773pad.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2015 00:49:02 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 3/8] staging: wilc1000: replace int8_t with int
Date: Thu, 17 Sep 2015 16:48:44 +0900
Message-Id: <1442476129-14908-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150917_094906_942064_41313F88)
In-Reply-To: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces int8_t with int. just use return type as int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2 : rebase latest staging-testing

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a2c80db..e9e6d9c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -272,9 +272,9 @@ static void clear_duringIP(unsigned long arg)
 }
 #endif
 
-int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
+int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 {
-	int8_t state = -1;
+	int state = -1;
 	int i;
 
 	if (u32LastScannedNtwrksCountShadow == 0) {
@@ -297,7 +297,7 @@ int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 
 void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
 {
-	int8_t ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
+	int ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
 	u32 ap_index = 0;
 	u8 rssi_index = 0;
 
-- 
2.5.1

