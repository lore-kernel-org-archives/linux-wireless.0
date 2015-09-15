Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32801 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbIOFHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:05 -0400
Received: by pacex6 with SMTP id ex6so165313074pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:05 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/18] staging: wilc1000: use u16 instead of uint16_t
Date: Tue, 15 Sep 2015 14:06:15 +0900
Message-Id: <1442293588-15323-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_071652_137853_E6BDA803)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces uint16_t with u16 that is preferred kernel type.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_spi.c      |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c     | 12 ++++++------
 drivers/staging/wilc1000/wilc_wlan.h     |  6 +++---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 18 +++++++++---------
 drivers/staging/wilc1000/wilc_wlan_cfg.h |  8 ++++----
 5 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index d600417..c31e17a 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -453,7 +453,7 @@ static int spi_cmd_complete(u8 cmd, uint32_t adr, u8 *b, uint32_t sz, u8 clockle
 	if ((cmd == CMD_INTERNAL_READ) || (cmd == CMD_SINGLE_READ)
 	    || (cmd == CMD_DMA_READ) || (cmd == CMD_DMA_EXT_READ)) {
 		int retry;
-		/* uint16_t crc1, crc2; */
+		/* u16 crc1, crc2; */
 		u8 crc[2];
 		/**
 		 * Data Respnose header
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c287301..c76134a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -285,9 +285,9 @@ struct Ack_session_info;
 struct Ack_session_info {
 	uint32_t Ack_seq_num;
 	uint32_t Bigger_Ack_num;
-	uint16_t src_port;
-	uint16_t dst_port;
-	uint16_t status;
+	u16 src_port;
+	u16 dst_port;
+	u16 status;
 };
 
 typedef struct {
@@ -1848,7 +1848,7 @@ static int wilc_wlan_cfg_set(int start, uint32_t wid, u8 *buffer, uint32_t buffe
 		p->cfg_frame_offset = 0;
 
 	offset = p->cfg_frame_offset;
-	ret_size = p->cif_func.cfg_wid_set(p->cfg_frame.frame, offset, (uint16_t)wid, buffer, buffer_size);
+	ret_size = p->cif_func.cfg_wid_set(p->cfg_frame.frame, offset, (u16)wid, buffer, buffer_size);
 	offset += ret_size;
 	p->cfg_frame_offset = offset;
 
@@ -1887,7 +1887,7 @@ static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, uint32_t drvHa
 		p->cfg_frame_offset = 0;
 
 	offset = p->cfg_frame_offset;
-	ret_size = p->cif_func.cfg_wid_get(p->cfg_frame.frame, offset, (uint16_t)wid);
+	ret_size = p->cif_func.cfg_wid_get(p->cfg_frame.frame, offset, (u16)wid);
 	offset += ret_size;
 	p->cfg_frame_offset = offset;
 
@@ -1917,7 +1917,7 @@ static int wilc_wlan_cfg_get_val(uint32_t wid, u8 *buffer, uint32_t buffer_size)
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	int ret;
 
-	ret = p->cif_func.cfg_wid_get_val((uint16_t)wid, buffer, buffer_size);
+	ret = p->cif_func.cfg_wid_get_val((u16)wid, buffer, buffer_size);
 
 	return ret;
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index d7fd07b..0f26c13 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -304,9 +304,9 @@ typedef struct {
 } wilc_cfg_rsp_t;
 
 typedef struct {
-	int (*cfg_wid_set)(u8 *, uint32_t, uint16_t, u8 *, int);
-	int (*cfg_wid_get)(u8 *, uint32_t, uint16_t);
-	int (*cfg_wid_get_val)(uint16_t, u8 *, uint32_t);
+	int (*cfg_wid_set)(u8 *, uint32_t, u16, u8 *, int);
+	int (*cfg_wid_get)(u8 *, uint32_t, u16);
+	int (*cfg_wid_get_val)(u16, u8 *, uint32_t);
 	int (*rx_indicate)(u8 *, int, wilc_cfg_rsp_t *);
 	int (*cfg_init)(wilc_debug_func);
 } wilc_cfg_func_t;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 8223b5f..f5bbbe8 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -160,7 +160,7 @@ static wilc_cfg_str_t g_cfg_str[] = {
  *
  ********************************************/
 
-static int wilc_wlan_cfg_set_byte(u8 *frame, uint32_t offset, uint16_t id, u8 val8)
+static int wilc_wlan_cfg_set_byte(u8 *frame, uint32_t offset, u16 id, u8 val8)
 {
 	u8 *buf;
 
@@ -176,7 +176,7 @@ static int wilc_wlan_cfg_set_byte(u8 *frame, uint32_t offset, uint16_t id, u8 va
 	return 4;
 }
 
-static int wilc_wlan_cfg_set_hword(u8 *frame, uint32_t offset, uint16_t id, uint16_t val16)
+static int wilc_wlan_cfg_set_hword(u8 *frame, uint32_t offset, u16 id, u16 val16)
 {
 	u8 *buf;
 
@@ -194,7 +194,7 @@ static int wilc_wlan_cfg_set_hword(u8 *frame, uint32_t offset, uint16_t id, uint
 	return 5;
 }
 
-static int wilc_wlan_cfg_set_word(u8 *frame, uint32_t offset, uint16_t id, uint32_t val32)
+static int wilc_wlan_cfg_set_word(u8 *frame, uint32_t offset, u16 id, uint32_t val32)
 {
 	u8 *buf;
 
@@ -214,7 +214,7 @@ static int wilc_wlan_cfg_set_word(u8 *frame, uint32_t offset, uint16_t id, uint3
 	return 7;
 }
 
-static int wilc_wlan_cfg_set_str(u8 *frame, uint32_t offset, uint16_t id, u8 *str, uint32_t size)
+static int wilc_wlan_cfg_set_str(u8 *frame, uint32_t offset, u16 id, u8 *str, uint32_t size)
 {
 	u8 *buf;
 
@@ -233,7 +233,7 @@ static int wilc_wlan_cfg_set_str(u8 *frame, uint32_t offset, uint16_t id, u8 *st
 	return (size + 3);
 }
 
-static int wilc_wlan_cfg_set_bin(u8 *frame, uint32_t offset, uint16_t id, u8 *b, uint32_t size)
+static int wilc_wlan_cfg_set_bin(u8 *frame, uint32_t offset, u16 id, u8 *b, uint32_t size)
 {
 	u8 *buf;
 	uint32_t i;
@@ -385,7 +385,7 @@ static int wilc_wlan_parse_info_frame(u8 *info, int size)
  *
  ********************************************/
 
-static int wilc_wlan_cfg_set_wid(u8 *frame, uint32_t offset, uint16_t id, u8 *buf, int size)
+static int wilc_wlan_cfg_set_wid(u8 *frame, uint32_t offset, u16 id, u8 *buf, int size)
 {
 	u8 type = (id >> 12) & 0xf;
 	int ret = 0;
@@ -395,7 +395,7 @@ static int wilc_wlan_cfg_set_wid(u8 *frame, uint32_t offset, uint16_t id, u8 *bu
 			ret = wilc_wlan_cfg_set_byte(frame, offset, id, *buf);
 	} else if (type == 1) {                 /* half word command */
 		if (size >= 2)
-			ret = wilc_wlan_cfg_set_hword(frame, offset, id, *((uint16_t *)buf));
+			ret = wilc_wlan_cfg_set_hword(frame, offset, id, *((u16 *)buf));
 	} else if (type == 2) {                 /* word command */
 		if (size >= 4)
 			ret = wilc_wlan_cfg_set_word(frame, offset, id, *((uint32_t *)buf));
@@ -410,7 +410,7 @@ static int wilc_wlan_cfg_set_wid(u8 *frame, uint32_t offset, uint16_t id, u8 *bu
 	return ret;
 }
 
-static int wilc_wlan_cfg_get_wid(u8 *frame, uint32_t offset, uint16_t id)
+static int wilc_wlan_cfg_get_wid(u8 *frame, uint32_t offset, u16 id)
 {
 	u8 *buf;
 
@@ -425,7 +425,7 @@ static int wilc_wlan_cfg_get_wid(u8 *frame, uint32_t offset, uint16_t id)
 	return 2;
 }
 
-static int wilc_wlan_cfg_get_wid_value(uint16_t wid, u8 *buffer, uint32_t buffer_size)
+static int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, uint32_t buffer_size)
 {
 	uint32_t type = (wid >> 12) & 0xf;
 	int i, ret = 0;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index bcff29c..5af0617 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -11,13 +11,13 @@
 #define WILC_WLAN_CFG_H
 
 typedef struct {
-	uint16_t id;
-	uint16_t val;
+	u16 id;
+	u16 val;
 } wilc_cfg_byte_t;
 
 typedef struct {
-	uint16_t id;
-	uint16_t val;
+	u16 id;
+	u16 val;
 } wilc_cfg_hword_t;
 
 typedef struct {
-- 
2.5.1

