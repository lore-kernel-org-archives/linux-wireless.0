Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:47900 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947159AbcBSIj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 03:39:58 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/6] staging: wilc1000: removes unnecessary wilc_debug print log
Date: Fri, 19 Feb 2016 17:37:09 +0900
Message-ID: <1455871032-7625-3-git-send-email-leo.kim@atmel.com> (sfid-20160219_094034_971834_74F11ECC)
In-Reply-To: <1455871032-7625-1-git-send-email-leo.kim@atmel.com>
References: <1455871032-7625-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary wilc_debug print log and the check routine.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 2719c3d..a51c66b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -529,9 +529,6 @@ void chip_wakeup(struct wilc *wilc)
 
 				wilc->hif_func->hif_read_reg(wilc, 0xf1,
 							     &clk_status_reg);
-
-				if ((clk_status_reg & 0x1) == 0)
-					wilc_debug(N_ERR, "clocks still OFF. Wake up failed\n");
 			}
 			if ((clk_status_reg & 0x1) == 0) {
 				wilc->hif_func->hif_write_reg(wilc, 0xf0,
-- 
1.9.1

