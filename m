Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6278 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753878AbeDRLkq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:40:46 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 10/22] staging: wilc1000: added identifiers name in function definations
Date: Wed, 18 Apr 2018 17:09:12 +0530
Message-ID: <1524051564-15497-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134050_223845_5CEC7780)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix identifier names required for functions definition issues reported
by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 4abbfa7..20e4659 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -222,7 +222,7 @@ struct txq_entry_t {
 	int buffer_size;
 	void *priv;
 	int status;
-	void (*tx_complete_func)(void *, int);
+	void (*tx_complete_func)(void *priv, int status);
 };
 
 struct rxq_entry_t {
@@ -238,18 +238,18 @@ struct rxq_entry_t {
  ********************************************/
 struct wilc;
 struct wilc_hif_func {
-	int (*hif_init)(struct wilc *, bool resume);
-	int (*hif_deinit)(struct wilc *);
-	int (*hif_read_reg)(struct wilc *, u32, u32 *);
-	int (*hif_write_reg)(struct wilc *, u32, u32);
-	int (*hif_block_rx)(struct wilc *, u32, u8 *, u32);
-	int (*hif_block_tx)(struct wilc *, u32, u8 *, u32);
-	int (*hif_read_int)(struct wilc *, u32 *);
-	int (*hif_clear_int_ext)(struct wilc *, u32);
-	int (*hif_read_size)(struct wilc *, u32 *);
-	int (*hif_block_tx_ext)(struct wilc *, u32, u8 *, u32);
-	int (*hif_block_rx_ext)(struct wilc *, u32, u8 *, u32);
-	int (*hif_sync_ext)(struct wilc *, int);
+	int (*hif_init)(struct wilc *wilc, bool resume);
+	int (*hif_deinit)(struct wilc *wilc);
+	int (*hif_read_reg)(struct wilc *wilc, u32 addr, u32 *data);
+	int (*hif_write_reg)(struct wilc *wilc, u32 addr, u32 data);
+	int (*hif_block_rx)(struct wilc *wilc, u32 addr, u8 *buf, u32 size);
+	int (*hif_block_tx)(struct wilc *wilc, u32 addr, u8 *buf, u32 size);
+	int (*hif_read_int)(struct wilc *wilc, u32 *int_status);
+	int (*hif_clear_int_ext)(struct wilc *wilc, u32 val);
+	int (*hif_read_size)(struct wilc *wilc, u32 *size);
+	int (*hif_block_tx_ext)(struct wilc *wilc, u32 addr, u8 *buf, u32 size);
+	int (*hif_block_rx_ext)(struct wilc *wilc, u32 addr, u8 *buf, u32 size);
+	int (*hif_sync_ext)(struct wilc *wilc, int nint);
 	int (*enable_interrupt)(struct wilc *nic);
 	void (*disable_interrupt)(struct wilc *nic);
 };
-- 
2.7.4
