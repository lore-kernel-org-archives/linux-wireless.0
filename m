Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35891 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbbIPLLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 07:11:54 -0400
Received: by padhk3 with SMTP id hk3so206659757pad.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 04:11:54 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/10] staging: wilc1000: replace int8_t with int
Date: Wed, 16 Sep 2015 20:11:30 +0900
Message-Id: <1442401895-7463-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150916_131157_520727_AB220D06)
In-Reply-To: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces int8_t with int. just use return type as int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3ecf5b1..e04d97e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -275,9 +275,9 @@ static void clear_duringIP(unsigned long arg)
 }
 #endif
 
-int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
+int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 {
-	int8_t state = -1;
+	int state = -1;
 	int i;
 
 	if (u32LastScannedNtwrksCountShadow == 0) {
@@ -300,7 +300,7 @@ int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
 
 void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
 {
-	int8_t ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
+	int ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
 	u32 ap_index = 0;
 	u8 rssi_index = 0;
 
-- 
2.5.1

