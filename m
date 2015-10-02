Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9805 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbbJBFXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 01:23:14 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/10] staging: wilc1000: remove function pointer cfg_wid_get_val
Date: Fri, 2 Oct 2015 14:22:09 +0900
Message-ID: <1443763332-7330-7-git-send-email-tony.cho@atmel.com> (sfid-20151002_073240_780720_8A206C2C)
In-Reply-To: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
References: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes cfg_wid_get_val and call the function
wilc_wlan_cfg_get_wid_value. Remove static from the function declaration.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c     | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h     | 1 -
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 3 +--
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 1 +
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index fbc0829..a9a8d24 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1833,7 +1833,7 @@ int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
 {
 	int ret;
 
-	ret = mac_cfg.cfg_wid_get_val((u16)wid, buffer, buffer_size);
+	ret = wilc_wlan_cfg_get_wid_value((u16)wid, buffer, buffer_size);
 
 	return ret;
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index bbf3e02..9386939 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -296,7 +296,6 @@ typedef struct {
 } wilc_cfg_rsp_t;
 
 typedef struct {
-	int (*cfg_wid_get_val)(u16, u8 *, u32);
 	int (*rx_indicate)(u8 *, int, wilc_cfg_rsp_t *);
 	int (*cfg_init)(wilc_debug_func);
 } wilc_cfg_func_t;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 7007381..55d2083 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -426,7 +426,7 @@ int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id)
 	return 2;
 }
 
-static int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
+int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 {
 	u32 type = (wid >> 12) & 0xf;
 	int i, ret = 0;
@@ -566,7 +566,6 @@ static int wilc_wlan_cfg_init(wilc_debug_func func)
 }
 
 wilc_cfg_func_t mac_cfg = {
-	wilc_wlan_cfg_get_wid_value,
 	wilc_wlan_cfg_indicate_rx,
 	wilc_wlan_cfg_init,
 };
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 2edd749..0efa2c5 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -32,5 +32,6 @@ typedef struct {
 
 int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size);
 int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id);
+int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size);
 
 #endif
-- 
1.9.1

