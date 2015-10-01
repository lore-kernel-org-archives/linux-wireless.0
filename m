Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35987 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbbJANod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 09:44:33 -0400
Received: by pablk4 with SMTP id lk4so74731579pab.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 06:44:33 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/12] staging: wilc1000: use s8 instead of int8_t
Date: Thu,  1 Oct 2015 22:43:55 +0900
Message-Id: <1443707039-18433-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151001_154436_297338_5AEAB4C6)
In-Reply-To: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces int8_t with s8 that is a preferred type.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d781003..56c97c9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -263,9 +263,9 @@ static void clear_duringIP(unsigned long arg)
 	g_obtainingIP = false;
 }
 
-int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
+s8 is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 {
-	int8_t state = -1;
+	s8 state = -1;
 	int i;
 
 	if (u32LastScannedNtwrksCountShadow == 0) {
@@ -288,7 +288,7 @@ int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 
 void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
 {
-	int8_t ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
+	s8 ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
 	u32 ap_index = 0;
 	u8 rssi_index = 0;
 
-- 
2.6.0

