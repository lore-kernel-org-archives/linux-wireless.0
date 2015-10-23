Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51648 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbbJWFZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:25:57 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/28] staging: wilc1000: isr_bh_routine: remove unused variable nic
Date: Fri, 23 Oct 2015 14:28:17 +0900
Message-ID: <1445578124-31486-1-git-send-email-glen.lee@atmel.com> (sfid-20151023_072559_707631_C13C5A90)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused variable nic.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ce2bd53..b036b96 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -242,10 +242,6 @@ static irqreturn_t isr_uh_routine(int irq, void *user_data)
 
 irqreturn_t isr_bh_routine(int irq, void *userdata)
 {
-	struct wilc *nic;
-
-	nic = (struct wilc *)userdata;
-
 	/*While mac is closing cacncel the handling of any interrupts received*/
 	if (g_linux_wlan->close) {
 		PRINT_ER("Driver is CLOSING: Can't handle BH interrupt\n");
-- 
1.9.1

