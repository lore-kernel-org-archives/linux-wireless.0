Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbZGSNAq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 09:00:46 -0400
From: Stefan Weil <weil@mail.berlios.de>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Stefan Weil <weil@mail.berlios.de>,
	Kalle Valo <kalle.valo@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: fix spelling
Date: Sun, 19 Jul 2009 15:00:39 +0200
Message-Id: <1248008439-4703-1-git-send-email-weil@mail.berlios.de>
In-Reply-To: <87y6qmtssc.fsf@nokia.com>
References: <87y6qmtssc.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes (comments and debug output):
* couldnt -> couldn't
* frmware -> firmware
* recevied -> received

Cc: Kalle Valo <kalle.valo@nokia.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Linux wireless <linux-wireless@vger.kernel.org>
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/net/wireless/wl12xx/wl1251_acx.c |    4 ++--
 drivers/net/wireless/wl12xx/wl1251_ops.c |    4 ++--
 drivers/net/wireless/wl12xx/wl1251_rx.h  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
index 5a8d21c..a46c92a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -84,7 +84,7 @@ int wl1251_acx_default_key(struct wl1251 *wl, u8 key_id)
 	ret = wl1251_cmd_configure(wl, DOT11_DEFAULT_KEY,
 				   default_key, sizeof(*default_key));
 	if (ret < 0) {
-		wl1251_error("Couldnt set default key");
+		wl1251_error("Couldn't set default key");
 		goto out;
 	}
 
@@ -231,7 +231,7 @@ int wl1251_acx_feature_cfg(struct wl1251 *wl)
 	ret = wl1251_cmd_configure(wl, ACX_FEATURE_CFG,
 				   feature, sizeof(*feature));
 	if (ret < 0) {
-		wl1251_error("Couldnt set HW encryption");
+		wl1251_error("Couldn't set HW encryption");
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_ops.c b/drivers/net/wireless/wl12xx/wl1251_ops.c
index 96a45f5..e7b9aab 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ops.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ops.c
@@ -423,7 +423,7 @@ static void wl1251_irq_work(struct work_struct *work)
 		wl->rx_counter =
 			wl1251_mem_read32(wl, wl->data_path->rx_control_addr);
 
-		/* We handle a frmware bug here */
+		/* We handle a firmware bug here */
 		switch ((wl->rx_counter - wl->rx_handled) & 0xf) {
 		case 0:
 			wl1251_debug(DEBUG_IRQ, "RX: FW and host in sync");
@@ -575,7 +575,7 @@ static int wl1251_hw_init_data_path_config(struct wl1251 *wl)
 	wl->data_path = kzalloc(sizeof(struct acx_data_path_params_resp),
 				GFP_KERNEL);
 	if (!wl->data_path) {
-		wl1251_error("Couldnt allocate data path parameters");
+		wl1251_error("Couldn't allocate data path parameters");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.h b/drivers/net/wireless/wl12xx/wl1251_rx.h
index 81156b9..563a3fd 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.h
@@ -88,7 +88,7 @@ struct wl1251_rx_descriptor {
 	u8 type;
 
 	/*
-	 * Recevied Rate:
+	 * Received Rate:
 	 * 0x0A - 1MBPS
 	 * 0x14 - 2MBPS
 	 * 0x37 - 5_5MBPS
-- 
1.5.6.5

