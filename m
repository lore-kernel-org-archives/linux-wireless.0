Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37781 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031601AbbKFCSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:18:15 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 62/73] staging: wilc1000: remove typedef from wilc_cfg_rsp_t
Date: Fri, 6 Nov 2015 11:20:01 +0900
Message-ID: <1446776412-30670-13-git-send-email-glen.lee@atmel.com> (sfid-20151106_031818_217780_38830875)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct wilc_cfg_rsp_t and
renames it to wilc_cfg_rsp.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c     | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h     | 4 ++--
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c61048b..7b8e70b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1023,7 +1023,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 						has_packet = 1;
 					}
 				} else {
-					wilc_cfg_rsp_t rsp;
+					struct wilc_cfg_rsp rsp;
 
 					wilc_wlan_cfg_indicate_rx(&buffer[pkt_offset + offset], pkt_len, &rsp);
 					if (rsp.type == WILC_CFG_RSP) {
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 6c784fd..368b7ff 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -271,10 +271,10 @@ struct wilc_cfg_frame {
 	u8 frame[MAX_CFG_FRAME_SIZE];
 };
 
-typedef struct {
+struct wilc_cfg_rsp {
 	int type;
 	u32 seq_no;
-} wilc_cfg_rsp_t;
+};
 
 int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size);
 int wilc_wlan_start(void);
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index a34a81c..e237963 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -505,7 +505,7 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 	return ret;
 }
 
-int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, wilc_cfg_rsp_t *rsp)
+int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, struct wilc_cfg_rsp *rsp)
 {
 	int ret = 1;
 	u8 msg_type;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 30e60ec..443b2d5 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -33,7 +33,7 @@ typedef struct {
 int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size);
 int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id);
 int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size);
-int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, wilc_cfg_rsp_t *rsp);
+int wilc_wlan_cfg_indicate_rx(u8 *frame, int size, struct wilc_cfg_rsp *rsp);
 int wilc_wlan_cfg_init(wilc_debug_func func);
 
 #endif
-- 
1.9.1

