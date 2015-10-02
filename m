Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9779 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbJBFXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 01:23:07 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/10] staging: wilc1000: remove function pointer cfg_wid_get
Date: Fri, 2 Oct 2015 14:22:08 +0900
Message-ID: <1443763332-7330-6-git-send-email-tony.cho@atmel.com> (sfid-20151002_072311_804122_B92A81BC)
In-Reply-To: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
References: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

Remove function pointer cfg_wid_get and call the function
wilc_wlan_cfg_get_wid instead. Remove static from the function declaration.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c     | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h     | 1 -
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 3 +--
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 1 +
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 442fe5f..fbc0829 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1804,7 +1804,7 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 		p->cfg_frame_offset = 0;
 
 	offset = p->cfg_frame_offset;
-	ret_size = mac_cfg.cfg_wid_get(p->cfg_frame.frame, offset, (u16)wid);
+	ret_size = wilc_wlan_cfg_get_wid(p->cfg_frame.frame, offset, (u16)wid);
 	offset += ret_size;
 	p->cfg_frame_offset = offset;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 90417d9..bbf3e02 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -296,7 +296,6 @@ typedef struct {
 } wilc_cfg_rsp_t;
 
 typedef struct {
-	int (*cfg_wid_get)(u8 *, u32, u16);
 	int (*cfg_wid_get_val)(u16, u8 *, u32);
 	int (*rx_indicate)(u8 *, int, wilc_cfg_rsp_t *);
 	int (*cfg_init)(wilc_debug_func);
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index e5296c1..7007381 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -411,7 +411,7 @@ int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size)
 	return ret;
 }
 
-static int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id)
+int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id)
 {
 	u8 *buf;
 
@@ -566,7 +566,6 @@ static int wilc_wlan_cfg_init(wilc_debug_func func)
 }
 
 wilc_cfg_func_t mac_cfg = {
-	wilc_wlan_cfg_get_wid,
 	wilc_wlan_cfg_get_wid_value,
 	wilc_wlan_cfg_indicate_rx,
 	wilc_wlan_cfg_init,
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 326c716..2edd749 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -31,5 +31,6 @@ typedef struct {
 } wilc_cfg_str_t;
 
 int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size);
+int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id);
 
 #endif
-- 
1.9.1

