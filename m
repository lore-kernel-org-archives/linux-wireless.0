Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33112 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbJBHlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 03:41:52 -0400
Received: by pacex6 with SMTP id ex6so100070067pac.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 00:41:52 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 08/12] staging: wilc1000: use int instead of int8_t
Date: Fri,  2 Oct 2015 16:41:17 +0900
Message-Id: <1443771681-15540-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_094155_512854_2CC21F5A)
In-Reply-To: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces int8_t with int.
The int8_t should be int. It's used as an index into an array
or -1 for not found.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: replaces s8 with int suggested by dan.

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d781003..3c8c2e1 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -263,9 +263,9 @@ static void clear_duringIP(unsigned long arg)
 	g_obtainingIP = false;
 }
 
-int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
+int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 {
-	int8_t state = -1;
+	int state = -1;
 	int i;
 
 	if (u32LastScannedNtwrksCountShadow == 0) {
@@ -288,7 +288,7 @@ int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 
 void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
 {
-	int8_t ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
+	int ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
 	u32 ap_index = 0;
 	u8 rssi_index = 0;
 
-- 
2.6.0

