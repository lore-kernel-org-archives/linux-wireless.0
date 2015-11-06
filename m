Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37745 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031547AbbKFCSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:18:03 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 60/73] staging: wilc1000: remove typedef from wilc_cfg_frame_t
Date: Fri, 6 Nov 2015 11:19:59 +0900
Message-ID: <1446776412-30670-11-git-send-email-glen.lee@atmel.com> (sfid-20151106_031808_451736_C07C54D3)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct wilc_cfg_frame_t and
renames it to wilc_cfg_frame.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 283c506..c61048b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -11,7 +11,7 @@ typedef struct {
 	wilc_wlan_io_func_t io_func;
 	wilc_hif_func_t hif_func;
 	int cfg_frame_in_use;
-	wilc_cfg_frame_t cfg_frame;
+	struct wilc_cfg_frame cfg_frame;
 	u32 cfg_frame_offset;
 	int cfg_seq_no;
 
@@ -1462,7 +1462,7 @@ void wilc_wlan_cleanup(struct net_device *dev)
 static int wilc_wlan_cfg_commit(int type, u32 drv_handler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
-	wilc_cfg_frame_t *cfg = &p->cfg_frame;
+	struct wilc_cfg_frame *cfg = &p->cfg_frame;
 	int total_len = p->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
 	int seq_no = p->cfg_seq_no % 256;
 	int driver_handler = (u32)drv_handler;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 74f6210..d15c848 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -263,13 +263,13 @@ typedef struct {
 
 #define MAX_CFG_FRAME_SIZE	1468
 
-typedef struct {
+struct wilc_cfg_frame {
 	u8 ether_header[14];
 	u8 ip_header[20];
 	u8 udp_header[8];
 	u8 wid_header[8];
 	u8 frame[MAX_CFG_FRAME_SIZE];
-} wilc_cfg_frame_t;
+};
 
 typedef struct {
 	int (*wlan_tx)(u8 *, u32, wilc_tx_complete_func_t);
-- 
1.9.1

