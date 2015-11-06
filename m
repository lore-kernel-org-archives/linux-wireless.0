Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37284 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031044AbbKFCPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:15:10 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 47/73] staging: wilc1000: rename drvHandler in wilc_wlan_cfg_commit function
Date: Fri, 6 Nov 2015 11:13:08 +0900
Message-ID: <1446776014-28094-47-git-send-email-glen.lee@atmel.com> (sfid-20151106_033757_186990_AEDAD15E)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename drvHandler to drv_handler that is third argument of
wilc_wlan_cfg_commit function to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d7834c5..2e1d9b8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1449,13 +1449,13 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	p->hif_func.hif_deinit(NULL);
 }
 
-static int wilc_wlan_cfg_commit(int type, u32 drvHandler)
+static int wilc_wlan_cfg_commit(int type, u32 drv_handler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	wilc_cfg_frame_t *cfg = &p->cfg_frame;
 	int total_len = p->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
 	int seq_no = p->cfg_seq_no % 256;
-	int driver_handler = (u32)drvHandler;
+	int driver_handler = (u32)drv_handler;
 
 	if (type == WILC_CFG_SET)
 		cfg->wid_header[0] = 'W';
-- 
1.9.1

