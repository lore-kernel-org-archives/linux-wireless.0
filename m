Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9764 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbJBFXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 01:23:01 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/10] staging: wilc1000: remove function pointer cfg_wid_set
Date: Fri, 2 Oct 2015 14:22:07 +0900
Message-ID: <1443763332-7330-5-git-send-email-tony.cho@atmel.com> (sfid-20151002_072305_022206_6D3E9A42)
In-Reply-To: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
References: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer cfg_wid_set and call the function
wilc_wlan_cfg_set_wid instead. Remove static from the function declaration.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c     | 5 +++--
 drivers/staging/wilc1000/wilc_wlan.h     | 1 -
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 3 +--
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 2 ++
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 9475ec7..442fe5f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -9,6 +9,7 @@
 
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
+#include "wilc_wlan_cfg.h"
 
 /********************************************
  *
@@ -1763,8 +1764,8 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		p->cfg_frame_offset = 0;
 
 	offset = p->cfg_frame_offset;
-	ret_size = mac_cfg.cfg_wid_set(p->cfg_frame.frame, offset, (u16)wid,
-				       buffer, buffer_size);
+	ret_size = wilc_wlan_cfg_set_wid(p->cfg_frame.frame, offset, (u16)wid,
+					 buffer, buffer_size);
 	offset += ret_size;
 	p->cfg_frame_offset = offset;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 1ba433c..90417d9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -296,7 +296,6 @@ typedef struct {
 } wilc_cfg_rsp_t;
 
 typedef struct {
-	int (*cfg_wid_set)(u8 *, u32, u16, u8 *, int);
 	int (*cfg_wid_get)(u8 *, u32, u16);
 	int (*cfg_wid_get_val)(u16, u8 *, u32);
 	int (*rx_indicate)(u8 *, int, wilc_cfg_rsp_t *);
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index d761a37..e5296c1 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -386,7 +386,7 @@ static int wilc_wlan_parse_info_frame(u8 *info, int size)
  *
  ********************************************/
 
-static int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size)
+int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size)
 {
 	u8 type = (id >> 12) & 0xf;
 	int ret = 0;
@@ -566,7 +566,6 @@ static int wilc_wlan_cfg_init(wilc_debug_func func)
 }
 
 wilc_cfg_func_t mac_cfg = {
-	wilc_wlan_cfg_set_wid,
 	wilc_wlan_cfg_get_wid,
 	wilc_wlan_cfg_get_wid_value,
 	wilc_wlan_cfg_indicate_rx,
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index ef88358..326c716 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -30,4 +30,6 @@ typedef struct {
 	u8 *str;
 } wilc_cfg_str_t;
 
+int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size);
+
 #endif
-- 
1.9.1

