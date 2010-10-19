Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:43502 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754865Ab0JSH4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 03:56:53 -0400
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0361895010
	for <linux-wireless@vger.kernel.org>; Tue, 19 Oct 2010 16:56:51 +0900 (JST)
Subject: [PATCH 1/2] ath5k: Optimize descriptor alignment
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 19 Oct 2010 16:56:48 +0900
Message-ID: <20101019075648.19979.42181.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar to Felix Fietkau <nbd@openwrt.org> "ath9k_hw: optimize all descriptor
access functions" (13db2a80244908833502189a24de82a856668b8a).

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/desc.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/desc.h b/drivers/net/wireless/ath/ath5k/desc.h
index b2adb2a..2509d0b 100644
--- a/drivers/net/wireless/ath/ath5k/desc.h
+++ b/drivers/net/wireless/ath/ath5k/desc.h
@@ -26,7 +26,7 @@
 struct ath5k_hw_rx_ctl {
 	u32	rx_control_0; /* RX control word 0 */
 	u32	rx_control_1; /* RX control word 1 */
-} __packed;
+} __packed __aligned(4);
 
 /* RX control word 1 fields/flags */
 #define AR5K_DESC_RX_CTL1_BUF_LEN		0x00000fff /* data buffer length */
@@ -39,7 +39,7 @@ struct ath5k_hw_rx_ctl {
 struct ath5k_hw_rx_status {
 	u32	rx_status_0; /* RX status word 0 */
 	u32	rx_status_1; /* RX status word 1 */
-} __packed;
+} __packed __aligned(4);
 
 /* 5210/5211 */
 /* RX status word 0 fields/flags */
@@ -129,7 +129,7 @@ enum ath5k_phy_error_code {
 struct ath5k_hw_2w_tx_ctl {
 	u32	tx_control_0; /* TX control word 0 */
 	u32	tx_control_1; /* TX control word 1 */
-} __packed;
+} __packed __aligned(4);
 
 /* TX control word 0 fields/flags */
 #define AR5K_2W_TX_DESC_CTL0_FRAME_LEN		0x00000fff /* frame length */
@@ -185,7 +185,7 @@ struct ath5k_hw_4w_tx_ctl {
 	u32	tx_control_1; /* TX control word 1 */
 	u32	tx_control_2; /* TX control word 2 */
 	u32	tx_control_3; /* TX control word 3 */
-} __packed;
+} __packed __aligned(4);
 
 /* TX control word 0 fields/flags */
 #define AR5K_4W_TX_DESC_CTL0_FRAME_LEN		0x00000fff /* frame length */
@@ -244,7 +244,7 @@ struct ath5k_hw_4w_tx_ctl {
 struct ath5k_hw_tx_status {
 	u32	tx_status_0; /* TX status word 0 */
 	u32	tx_status_1; /* TX status word 1 */
-} __packed;
+} __packed __aligned(4);
 
 /* TX status word 0 fields/flags */
 #define AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK	0x00000001 /* TX success */
@@ -282,7 +282,7 @@ struct ath5k_hw_tx_status {
 struct ath5k_hw_5210_tx_desc {
 	struct ath5k_hw_2w_tx_ctl	tx_ctl;
 	struct ath5k_hw_tx_status	tx_stat;
-} __packed;
+} __packed __aligned(4);
 
 /*
  * 5212 hardware TX descriptor
@@ -290,7 +290,7 @@ struct ath5k_hw_5210_tx_desc {
 struct ath5k_hw_5212_tx_desc {
 	struct ath5k_hw_4w_tx_ctl	tx_ctl;
 	struct ath5k_hw_tx_status	tx_stat;
-} __packed;
+} __packed __aligned(4);
 
 /*
  * Common hardware RX descriptor
@@ -298,7 +298,7 @@ struct ath5k_hw_5212_tx_desc {
 struct ath5k_hw_all_rx_desc {
 	struct ath5k_hw_rx_ctl		rx_ctl;
 	struct ath5k_hw_rx_status	rx_stat;
-} __packed;
+} __packed __aligned(4);
 
 /*
  * Atheros hardware DMA descriptor
@@ -313,7 +313,7 @@ struct ath5k_desc {
 		struct ath5k_hw_5212_tx_desc	ds_tx5212;
 		struct ath5k_hw_all_rx_desc	ds_rx;
 	} ud;
-} __packed;
+} __packed __aligned(4);
 
 #define AR5K_RXDESC_INTREQ	0x0020
 

