Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9820 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbbJBFXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 01:23:20 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/10] staging: wilc1000: remove function pointer rx_indicate
Date: Fri, 2 Oct 2015 14:22:10 +0900
Message-ID: <1443763332-7330-8-git-send-email-tony.cho@atmel.com> (sfid-20151002_073152_765188_4DDD33CD)
In-Reply-To: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
References: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer rx_indicate and just call the function
wilc_wlan_cfg_indicate_rx instead. Remove static from the function
declration.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c     | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h     | 1 -
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 3 +--
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 1 +
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a9a8d24..cd4598a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1198,7 +1198,7 @@ static void wilc_wlan_handle_rxq(void)
 
 
 
-					mac_cfg.rx_indicate(&buffer[pkt_offset + offset], pkt_len, &rsp);
+					wilc_wlan_cfg_indicate_rx(&buffer[pkt_offset + offset], pkt_len, &rsp);
 					if (rsp.type == WILC_CFG_RSP) {
 						/**
 						 *      wake up the waiting task...
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 9386939..5099cf0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -296,7 +296,6 @@ typedef struct {
 } wilc_cfg_rsp_t;
 
 typedef struct {
-	int (*rx_indicate)(u8 *, int, wilc_cfg_rsp_t *);
 	int (*cfg_init)(wilc_debug_func);
 } wilc_cfg_func_t;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 55d2083..2916d45 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -505,7 +505,7 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 	return ret;
 }
 
-static int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, wilc_cfg_rsp_t *rsp)
+int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, wilc_cfg_rsp_t *rsp)
 {
 	int ret = 1;
 	u8 msg_type;
@@ -566,6 +566,5 @@ static int wilc_wlan_cfg_init(wilc_debug_func func)
 }
 
 wilc_cfg_func_t mac_cfg = {
-	wilc_wlan_cfg_indicate_rx,
 	wilc_wlan_cfg_init,
 };
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 0efa2c5..fe2c0382 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -33,5 +33,6 @@ typedef struct {
 int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size);
 int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id);
 int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size);
+int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, wilc_cfg_rsp_t *rsp);
 
 #endif
-- 
1.9.1

