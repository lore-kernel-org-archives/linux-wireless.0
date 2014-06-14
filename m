Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52437 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbaFNNxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:53:24 -0400
Received: by mail-pb0-f44.google.com with SMTP id md12so2171916pbc.31
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:53:24 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id is5sm9029986pbb.8.2014.06.14.06.53.22
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:53:23 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/16] rsi: Changed the SDIO interrupt variables and some clean up.
Date: Sat, 14 Jun 2014 19:23:15 +0530
Message-Id: <1402753995-14133-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_155329_169154_016868F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed the SDIO interrupt variables and some clean ups.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    8 +++++---
 drivers/net/wireless/rsi/rsi_sdio.h         |    8 ++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 20d11cc..4834a9a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -401,14 +401,16 @@ void rsi_interrupt_handler(struct rsi_hw *adapter)
 			case BUFFER_AVAILABLE:
 				dev->rx_info.watch_bufferfull_count = 0;
 				dev->rx_info.buffer_full = false;
+				dev->rx_info.semi_buffer_full = false;
 				dev->rx_info.mgmt_buffer_full = false;
 				rsi_sdio_ack_intr(common->priv,
 						  (1 << PKT_BUFF_AVAILABLE));
-				rsi_set_event((&common->tx_thread.event));
+				rsi_set_event(&common->tx_thread.event);
+
 				rsi_dbg(ISR_ZONE,
-					"%s: ==> BUFFER_AVILABLE <==\n",
+					"%s: ==> BUFFER_AVAILABLE <==\n",
 					__func__);
-				dev->rx_info.buf_avilable_counter++;
+				dev->rx_info.buf_available_counter++;
 				break;
 
 			case FIRMWARE_ASSERT_IND:
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index df4b5e2..c7e8f2b 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -30,7 +30,7 @@
 
 enum sdio_interrupt_type {
 	BUFFER_FULL         = 0x0,
-	BUFFER_AVAILABLE    = 0x1,
+	BUFFER_AVAILABLE    = 0x2,
 	FIRMWARE_ASSERT_IND = 0x3,
 	MSDU_PACKET_PENDING = 0x4,
 	UNKNOWN_INT         = 0XE
@@ -42,7 +42,7 @@ enum sdio_interrupt_type {
 #define PKT_MGMT_BUFF_FULL                      2
 #define MSDU_PKT_PENDING                        3
 /* Interrupt Bit Related Macros */
-#define PKT_BUFF_AVAILABLE                      0
+#define PKT_BUFF_AVAILABLE                      1
 #define FW_ASSERT_IND                           2
 
 #define RSI_DEVICE_BUFFER_STATUS_REGISTER       0xf3
@@ -84,7 +84,7 @@ enum sdio_interrupt_type {
 #define TA_HOLD_THREAD_VALUE         cpu_to_le32(0xF)
 #define TA_RELEASE_THREAD_VALUE      cpu_to_le32(0xF)
 #define TA_BASE_ADDR                 0x2200
-#define MISC_CFG_BASE_ADDR           0x4150
+#define MISC_CFG_BASE_ADDR           0x4105
 
 struct receive_info {
 	bool buffer_full;
@@ -98,7 +98,7 @@ struct receive_info {
 	u32 total_sdio_msdu_pending_intr;
 	u32 total_sdio_unknown_intr;
 	u32 buf_full_counter;
-	u32 buf_avilable_counter;
+	u32 buf_available_counter;
 };
 
 struct rsi_91x_sdiodev {
-- 
1.7.1

