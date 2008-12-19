Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYLSCpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:18 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 20/43] iwl3945: move structures from iwl-3945.h to iwl-dev.h
Date: Fri, 19 Dec 2008 10:37:20 +0800
Message-Id: <1229654263-21454-21-git-send-email-yi.zhu@intel.com> (sfid-20081219_034553_187530_A0165C94)
In-Reply-To: <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

The patch moves few structres from iwl-3945.h to iwl-dev.h.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h |   46 -----------------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   49 +++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 760482e..f513930 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -121,34 +121,6 @@ struct iwl3945_tx_info {
 	struct sk_buff *skb[MAX_NUM_OF_TBS];
 };
 
-/**
- * struct iwl3945_tx_queue - Tx Queue for DMA
- * @q: generic Rx/Tx queue descriptor
- * @bd: base of circular buffer of TFDs
- * @cmd: array of command/Tx buffers
- * @dma_addr_cmd: physical address of cmd/tx buffer array
- * @txb: array of per-TFD driver data
- * @need_update: indicates need to update read/write index
- *
- * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
- * descriptors) and required locking structures.
- */
-struct iwl3945_tx_queue {
-	struct iwl_queue q;
-	struct iwl3945_tfd_frame *bd;
-	struct iwl3945_cmd *cmd;
-	dma_addr_t dma_addr_cmd;
-	struct iwl3945_tx_info *txb;
-	int need_update;
-	int active;
-};
-
-struct iwl3945_clip_group {
-	/* maximum power level to prevent clipping for each rate, derived by
-	 *   us from this band's saturation power in EEPROM */
-	const s8 clip_powers[IWL_MAX_RATES];
-};
-
 #include "iwl-agn-rs.h"
 
 #define IWL_TX_FIFO_AC0	0
@@ -303,16 +275,6 @@ struct iwl3945_rx_queue {
 #define IWL_INVALID_RATE     0xFF
 #define IWL_INVALID_VALUE    -1
 
-struct iwl3945_tid_data {
-	u16 seq_number;
-};
-
-struct iwl3945_hw_key {
-	enum ieee80211_key_alg alg;
-	int keylen;
-	u8 key[32];
-};
-
 union iwl3945_ht_rate_supp {
 	u16 rates;
 	struct {
@@ -351,14 +313,6 @@ struct iwl3945_qos_info {
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
 
-struct iwl3945_station_entry {
-	struct iwl3945_addsta_cmd sta;
-	struct iwl3945_tid_data tid[MAX_TID_COUNT];
-	u8 used;
-	u8 ps_status;
-	struct iwl3945_hw_key keyinfo;
-};
-
 /* uCode file layout */
 struct iwl3945_ucode {
 	__le32 ver;		/* major/minor/API/serial */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f63209a..73318a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -156,6 +156,12 @@ struct iwl4965_channel_tgh_info {
 
 #define IWL4965_MAX_RATE (33)
 
+struct iwl3945_clip_group {
+	/* maximum power level to prevent clipping for each rate, derived by
+	 *   us from this band's saturation power in EEPROM */
+	const s8 clip_powers[IWL_MAX_RATES];
+};
+
 /* current Tx power values to use, one for each rate for each channel.
  * requested power is limited by:
  * -- regulatory EEPROM limits for this channel
@@ -218,6 +224,27 @@ struct iwl_channel_info {
 	struct iwl3945_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
 };
 
+/**
+ * struct iwl3945_tx_queue - Tx Queue for DMA
+ * @q: generic Rx/Tx queue descriptor
+ * @bd: base of circular buffer of TFDs
+ * @cmd: array of command/Tx buffers
+ * @dma_addr_cmd: physical address of cmd/tx buffer array
+ * @txb: array of per-TFD driver data
+ * @need_update: indicates need to update read/write index
+ *
+ * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
+ * descriptors) and required locking structures.
+ */
+struct iwl3945_tx_queue {
+	struct iwl_queue q;
+	struct iwl3945_tfd_frame *bd;
+	struct iwl3945_cmd *cmd;
+	dma_addr_t dma_addr_cmd;
+	struct iwl3945_tx_info *txb;
+	int need_update;
+	int active;
+};
 
 #define IWL_TX_FIFO_AC0	0
 #define IWL_TX_FIFO_AC1	1
@@ -462,6 +489,24 @@ struct iwl_qos_info {
 #define STA_PS_STATUS_WAKE             0
 #define STA_PS_STATUS_SLEEP            1
 
+struct iwl3945_tid_data {
+	u16 seq_number;
+};
+
+struct iwl3945_hw_key {
+	enum ieee80211_key_alg alg;
+	int keylen;
+	u8 key[32];
+};
+
+struct iwl3945_station_entry {
+	struct iwl3945_addsta_cmd sta;
+	struct iwl3945_tid_data tid[MAX_TID_COUNT];
+	u8 used;
+	u8 ps_status;
+	struct iwl3945_hw_key keyinfo;
+};
+
 struct iwl_station_entry {
 	struct iwl_addsta_cmd sta;
 	struct iwl_tid_data tid[MAX_TID_COUNT];
@@ -800,6 +845,10 @@ struct iwl_priv {
 	struct iwl_channel_info *channel_info;	/* channel info array */
 	u8 channel_count;	/* # of channels */
 
+	/* each calibration channel group in the EEPROM has a derived
+	 * clip setting for each rate. 3945 only.*/
+	const struct iwl3945_clip_group clip39_groups[5];
+
 	/* thermal calibration */
 	s32 temperature;	/* degrees Kelvin */
 	s32 last_temperature;
-- 
1.5.3.6

