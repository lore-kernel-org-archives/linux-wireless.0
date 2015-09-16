Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36735 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbbIPLLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 07:11:42 -0400
Received: by padhk3 with SMTP id hk3so206655478pad.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 04:11:42 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/10] staging: wilc1000: wilc_wlan.c: use BIT(x) macro
Date: Wed, 16 Sep 2015 20:11:26 +0900
Message-Id: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150916_131146_123690_6202309A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove bit shift macro that is custom defined, then replace BIT(x)
macro.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7496c1f..add9eeb 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -2177,7 +2177,6 @@ _fail_:
 
 }
 
-#define BIT31 (1 << 31)
 u16 Set_machw_change_vir_if(bool bValue)
 {
 	u16 ret;
@@ -2191,9 +2190,9 @@ u16 Set_machw_change_vir_if(bool bValue)
 	}
 
 	if (bValue)
-		reg |= (BIT31);
+		reg |= BIT(31);
 	else
-		reg &= ~(BIT31);
+		reg &= ~BIT(31);
 
 	ret = (&g_wlan)->hif_func.hif_write_reg(WILC_CHANGING_VIR_IF, reg);
 
-- 
2.5.1

