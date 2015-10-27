Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:57910 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbbJ0JZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:25:31 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 05/27] staging: wilc1000: wilc_wlan_handle_isr_ext: add argument struct wilc
Date: Tue, 27 Oct 2015 18:27:41 +0900
Message-ID: <1445938083-20445-5-git-send-email-glen.lee@atmel.com> (sfid-20151027_102534_731967_A68AC5CC)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds argument struct wilc and pass wilc to the function.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index be6f631..5141fe0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1260,7 +1260,7 @@ static void wilc_sleeptimer_isr_ext(u32 int_stats1)
 #endif
 }
 
-static void wilc_wlan_handle_isr_ext(u32 int_status)
+static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 #ifdef MEMORY_STATIC
@@ -1364,7 +1364,7 @@ void wilc_handle_isr(void *wilc)
 		wilc_pllupdate_isr_ext(int_status);
 
 	if (int_status & DATA_INT_EXT) {
-		wilc_wlan_handle_isr_ext(int_status);
+		wilc_wlan_handle_isr_ext(wilc, int_status);
 	#ifndef WILC_OPTIMIZE_SLEEP_INT
 		/* Chip is up and talking*/
 		genuChipPSstate = CHIP_WAKEDUP;
-- 
1.9.1

