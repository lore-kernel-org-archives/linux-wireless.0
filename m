Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39974 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYLSCpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:14 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <sameo@linux.intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/43] iwl3945: iwl3945_queue and iwl3945_channel_info replacement
Date: Fri, 19 Dec 2008 10:37:15 +0800
Message-Id: <1229654263-21454-16-git-send-email-yi.zhu@intel.com> (sfid-20081219_034612_408165_6C0A6DFE)
In-Reply-To: <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

This patch replaces the queue and channel info 3945 structures with the iwl
ones.

The initial goal was to replace the channel info structure. Once we do that,
and then include iwl-dev.h instead of iwl-3945.h, we still get build errors
due to several routines and macro redefinitions. This is why this patch also
includes:
- TFD39_MAX_PAYLOAD definition for 3945.
- CMD_SIZE, CMD_HUGE, CMD_SKB duplication removal.
- iwl3945_queue replacement in order to also get rid of the duplicated
get_cmd_index routine.

Getting rid of any of those needs the iwl-dev.h inclusion which then creates
build errors due to definitions duplication. This is why we include all those
in the same patch.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    3 -
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   20 ++--
 drivers/net/wireless/iwlwifi/iwl-3945.h     |  155 +-------------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   33 ++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   69 ++++--------
 5 files changed, 71 insertions(+), 209 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 1182e68..5d461bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -265,9 +265,6 @@ struct iwl3945_eeprom {
 #define TFD_TX_CMD_SLOTS 256
 #define TFD_CMD_SLOTS 32
 
-#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl3945_cmd) - \
-			      sizeof(struct iwl3945_cmd_meta))
-
 /*
  * RX related structures and functions
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 538bbfc..d4f49fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -306,7 +306,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv,
 				     int txq_id, int index)
 {
 	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl3945_queue *q = &txq->q;
+	struct iwl_queue *q = &txq->q;
 	struct iwl3945_tx_info *tx_info;
 
 	BUG_ON(txq_id == IWL_CMD_QUEUE_NUM);
@@ -320,7 +320,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv,
 		iwl3945_hw_txq_free_tfd(priv, txq);
 	}
 
-	if (iwl3945_queue_space(q) > q->low_mark && (txq_id >= 0) &&
+	if (iwl_queue_space(q) > q->low_mark && (txq_id >= 0) &&
 			(txq_id != IWL_CMD_QUEUE_NUM) &&
 			priv->mac80211_registered)
 		ieee80211_wake_queue(priv->hw, txq_id);
@@ -1619,7 +1619,7 @@ static inline u8 iwl3945_hw_reg_fix_power_index(int index)
  */
 static void iwl3945_hw_reg_set_scan_power(struct iwl3945_priv *priv, u32 scan_tbl_index,
 			       s32 rate_index, const s8 *clip_pwrs,
-			       struct iwl3945_channel_info *ch_info,
+			       struct iwl_channel_info *ch_info,
 			       int band_index)
 {
 	struct iwl3945_scan_power_info *scan_power_info;
@@ -1676,7 +1676,7 @@ static void iwl3945_hw_reg_set_scan_power(struct iwl3945_priv *priv, u32 scan_tb
 int iwl3945_hw_reg_send_txpower(struct iwl3945_priv *priv)
 {
 	int rate_idx, i;
-	const struct iwl3945_channel_info *ch_info = NULL;
+	const struct iwl_channel_info *ch_info = NULL;
 	struct iwl3945_txpowertable_cmd txpower = {
 		.channel = priv->active_rxon.channel,
 	};
@@ -1749,7 +1749,7 @@ int iwl3945_hw_reg_send_txpower(struct iwl3945_priv *priv)
  *	 and send changes to NIC
  */
 static int iwl3945_hw_reg_set_new_power(struct iwl3945_priv *priv,
-			     struct iwl3945_channel_info *ch_info)
+			     struct iwl_channel_info *ch_info)
 {
 	struct iwl3945_channel_power_info *power_info;
 	int power_changed = 0;
@@ -1811,7 +1811,7 @@ static int iwl3945_hw_reg_set_new_power(struct iwl3945_priv *priv,
  *	 based strictly on regulatory (eeprom and spectrum mgt) limitations
  *	 (no consideration for h/w clipping limitations).
  */
-static int iwl3945_hw_reg_get_ch_txpower_limit(struct iwl3945_channel_info *ch_info)
+static int iwl3945_hw_reg_get_ch_txpower_limit(struct iwl_channel_info *ch_info)
 {
 	s8 max_power;
 
@@ -1841,7 +1841,7 @@ static int iwl3945_hw_reg_get_ch_txpower_limit(struct iwl3945_channel_info *ch_i
  */
 static int iwl3945_hw_reg_comp_txpower_temp(struct iwl3945_priv *priv)
 {
-	struct iwl3945_channel_info *ch_info = NULL;
+	struct iwl_channel_info *ch_info = NULL;
 	int delta_index;
 	const s8 *clip_pwrs; /* array of h/w max power levels for each rate */
 	u8 a_band;
@@ -1902,7 +1902,7 @@ static int iwl3945_hw_reg_comp_txpower_temp(struct iwl3945_priv *priv)
 
 int iwl3945_hw_reg_set_txpower(struct iwl3945_priv *priv, s8 power)
 {
-	struct iwl3945_channel_info *ch_info;
+	struct iwl_channel_info *ch_info;
 	s8 max_power;
 	u8 a_band;
 	u8 i;
@@ -2000,7 +2000,7 @@ static void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
  *	 channel in each group 1-4.  Group 5 All B/G channels are in group 0.
  */
 static u16 iwl3945_hw_reg_get_ch_grp_index(struct iwl3945_priv *priv,
-				       const struct iwl3945_channel_info *ch_info)
+				       const struct iwl_channel_info *ch_info)
 {
 	struct iwl3945_eeprom_txpower_group *ch_grp = &priv->eeprom.groups[0];
 	u8 group;
@@ -2163,7 +2163,7 @@ static void iwl3945_hw_reg_init_channel_groups(struct iwl3945_priv *priv)
  */
 int iwl3945_txpower_set_from_eeprom(struct iwl3945_priv *priv)
 {
-	struct iwl3945_channel_info *ch_info = NULL;
+	struct iwl_channel_info *ch_info = NULL;
 	struct iwl3945_channel_power_info *pwr_info;
 	int delta_index;
 	u8 rate_index;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index dd15b32..46bbd81 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -48,6 +48,7 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 #include "iwl-3945-hw.h"
 #include "iwl-debug.h"
 #include "iwl-power.h"
+#include "iwl-dev.h"
 #include "iwl-3945-led.h"
 
 /* Highest firmware API version supported */
@@ -111,26 +112,7 @@ struct iwl3945_rx_mem_buffer {
 	struct list_head list;
 };
 
-/*
- * Generic queue structure
- *
- * Contains common data for Rx and Tx queues
- */
-struct iwl3945_queue {
-	int n_bd;              /* number of BDs in this queue */
-	int write_ptr;       /* 1-st empty entry (index) host_w*/
-	int read_ptr;         /* last used entry (index) host_r*/
-	dma_addr_t dma_addr;   /* physical addr for BD's */
-	int n_window;	       /* safe queue window */
-	u32 id;
-	int low_mark;	       /* low watermark, resume queue if free
-				* space more than this */
-	int high_mark;         /* high watermark, stop queue if free
-				* space less than this */
-} __attribute__ ((packed));
-
-int iwl3945_queue_space(const struct iwl3945_queue *q);
-int iwl3945_x2_queue_used(const struct iwl3945_queue *q, int i);
+int iwl3945_x2_queue_used(const struct iwl_queue *q, int i);
 
 #define MAX_NUM_OF_TBS          (20)
 
@@ -152,7 +134,7 @@ struct iwl3945_tx_info {
  * descriptors) and required locking structures.
  */
 struct iwl3945_tx_queue {
-	struct iwl3945_queue q;
+	struct iwl_queue q;
 	struct iwl3945_tfd_frame *bd;
 	struct iwl3945_cmd *cmd;
 	dma_addr_t dma_addr_cmd;
@@ -161,73 +143,6 @@ struct iwl3945_tx_queue {
 	int active;
 };
 
-#define IWL_NUM_SCAN_RATES         (2)
-
-struct iwl3945_channel_tgd_info {
-	u8 type;
-	s8 max_power;
-};
-
-struct iwl3945_channel_tgh_info {
-	s64 last_radar_time;
-};
-
-/* current Tx power values to use, one for each rate for each channel.
- * requested power is limited by:
- * -- regulatory EEPROM limits for this channel
- * -- hardware capabilities (clip-powers)
- * -- spectrum management
- * -- user preference (e.g. iwconfig)
- * when requested power is set, base power index must also be set. */
-struct iwl3945_channel_power_info {
-	struct iwl3945_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_index;	/* actual (compenst'd) index into gain table */
-	s8 base_power_index;	/* gain index for power at factory temp. */
-	s8 requested_power;	/* power (dBm) requested for this chnl/rate */
-};
-
-/* current scan Tx power values to use, one for each scan rate for each
- * channel. */
-struct iwl3945_scan_power_info {
-	struct iwl3945_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_index;	/* actual (compenst'd) index into gain table */
-	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
-};
-
-/*
- * One for each channel, holds all channel setup data
- * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
- *     with one another!
- */
-#define IWL4965_MAX_RATE (33)
-
-struct iwl3945_channel_info {
-	struct iwl3945_channel_tgd_info tgd;
-	struct iwl3945_channel_tgh_info tgh;
-	struct iwl_eeprom_channel eeprom;	/* EEPROM regulatory limit */
-	struct iwl_eeprom_channel fat_eeprom;	/* EEPROM regulatory limit for
-						 * FAT channel */
-
-	u8 channel;	  /* channel number */
-	u8 flags;	  /* flags copied from EEPROM */
-	s8 max_power_avg; /* (dBm) regul. eeprom, normal Tx, any rate */
-	s8 curr_txpow;	  /* (dBm) regulatory/spectrum/user (not h/w) */
-	s8 min_power;	  /* always 0 */
-	s8 scan_power;	  /* (dBm) regul. eeprom, direct scans, any rate */
-
-	u8 group_index;	  /* 0-4, maps channel to group1/2/3/4/5 */
-	u8 band_index;	  /* 0-4, maps channel to band1/2/3/4/5 */
-	enum ieee80211_band band;
-
-	/* Radio/DSP gain settings for each "normal" data Tx rate.
-	 * These include, in addition to RF and DSP gain, a few fields for
-	 *   remembering/modifying gain settings (indexes). */
-	struct iwl3945_channel_power_info power_info[IWL4965_MAX_RATE];
-
-	/* Radio/DSP gain settings for each scan rate, for directed scans. */
-	struct iwl3945_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
-};
-
 struct iwl3945_clip_group {
 	/* maximum power level to prevent clipping for each rate, derived by
 	 *   us from this band's saturation power in EEPROM */
@@ -266,15 +181,6 @@ struct iwl3945_frame {
 #define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
 #define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
 
-enum {
-	/* CMD_SIZE_NORMAL = 0, */
-	CMD_SIZE_HUGE = (1 << 0),
-	/* CMD_SYNC = 0, */
-	CMD_ASYNC = (1 << 1),
-	/* CMD_NO_SKB = 0, */
-	CMD_WANT_SKB = (1 << 2),
-};
-
 struct iwl3945_cmd;
 struct iwl3945_priv;
 
@@ -328,7 +234,7 @@ struct iwl3945_host_cmd {
 	const void *data;
 };
 
-#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl3945_cmd) - \
+#define TFD39_MAX_PAYLOAD_SIZE (sizeof(struct iwl3945_cmd) - \
 			      sizeof(struct iwl3945_cmd_meta))
 
 /*
@@ -453,13 +359,6 @@ struct iwl3945_station_entry {
 	struct iwl3945_hw_key keyinfo;
 };
 
-/* one for each uCode image (inst/data, boot/init/runtime) */
-struct fw_desc {
-	void *v_addr;		/* access by driver */
-	dma_addr_t p_addr;	/* access by card's busmaster DMA */
-	u32 len;		/* bytes */
-};
-
 /* uCode file layout */
 struct iwl3945_ucode {
 	__le32 ver;		/* major/minor/API/serial */
@@ -629,16 +528,6 @@ extern int iwl3945_txpower_set_from_eeprom(struct iwl3945_priv *priv);
 extern u8 iwl3945_sync_sta(struct iwl3945_priv *priv, int sta_id,
 		 u16 tx_rate, u8 flags);
 
-
-#ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
-
-enum {
-	MEASUREMENT_READY = (1 << 0),
-	MEASUREMENT_ACTIVE = (1 << 1),
-};
-
-#endif
-
 #ifdef CONFIG_IWL3945_RFKILL
 struct iwl3945_priv;
 
@@ -682,7 +571,7 @@ struct iwl3945_priv {
 
 	/* we allocate array of iwl3945_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
-	struct iwl3945_channel_info *channel_info;	/* channel info array */
+	struct iwl_channel_info *channel_info;	/* channel info array */
 	u8 channel_count;	/* # of channels */
 
 	/* each calibration channel group in the EEPROM has a derived
@@ -873,39 +762,7 @@ static inline int iwl3945_is_associated(struct iwl3945_priv *priv)
 	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
 }
 
-static inline int is_channel_valid(const struct iwl3945_channel_info *ch_info)
-{
-	if (ch_info == NULL)
-		return 0;
-	return (ch_info->flags & EEPROM_CHANNEL_VALID) ? 1 : 0;
-}
-
-static inline int is_channel_radar(const struct iwl3945_channel_info *ch_info)
-{
-	return (ch_info->flags & EEPROM_CHANNEL_RADAR) ? 1 : 0;
-}
-
-static inline u8 is_channel_a_band(const struct iwl3945_channel_info *ch_info)
-{
-	return ch_info->band == IEEE80211_BAND_5GHZ;
-}
-
-static inline u8 is_channel_bg_band(const struct iwl3945_channel_info *ch_info)
-{
-	return ch_info->band == IEEE80211_BAND_2GHZ;
-}
-
-static inline int is_channel_passive(const struct iwl3945_channel_info *ch)
-{
-	return (!(ch->flags & EEPROM_CHANNEL_ACTIVE)) ? 1 : 0;
-}
-
-static inline int is_channel_ibss(const struct iwl3945_channel_info *ch)
-{
-	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
-}
-
-extern const struct iwl3945_channel_info *iwl3945_get_channel_info(
+extern const struct iwl_channel_info *iwl3945_get_channel_info(
 	const struct iwl3945_priv *priv, enum ieee80211_band band, u16 channel);
 
 extern int iwl3945_rs_next_rate(struct iwl3945_priv *priv, int rate);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 73a0b6c..f63209a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -39,6 +39,7 @@
 #include "iwl-rfkill.h"
 #include "iwl-eeprom.h"
 #include "iwl-4965-hw.h"
+#include "iwl-3945-hw.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
 #include "iwl-debug.h"
@@ -153,6 +154,30 @@ struct iwl4965_channel_tgh_info {
 	s64 last_radar_time;
 };
 
+#define IWL4965_MAX_RATE (33)
+
+/* current Tx power values to use, one for each rate for each channel.
+ * requested power is limited by:
+ * -- regulatory EEPROM limits for this channel
+ * -- hardware capabilities (clip-powers)
+ * -- spectrum management
+ * -- user preference (e.g. iwconfig)
+ * when requested power is set, base power index must also be set. */
+struct iwl3945_channel_power_info {
+	struct iwl3945_tx_power tpc;	/* actual radio and DSP gain settings */
+	s8 power_table_index;	/* actual (compenst'd) index into gain table */
+	s8 base_power_index;	/* gain index for power at factory temp. */
+	s8 requested_power;	/* power (dBm) requested for this chnl/rate */
+};
+
+/* current scan Tx power values to use, one for each scan rate for each
+ * channel. */
+struct iwl3945_scan_power_info {
+	struct iwl3945_tx_power tpc;	/* actual radio and DSP gain settings */
+	s8 power_table_index;	/* actual (compenst'd) index into gain table */
+	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
+};
+
 /*
  * One for each channel, holds all channel setup data
  * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
@@ -183,6 +208,14 @@ struct iwl_channel_info {
 	s8 fat_scan_power;	/* (dBm) eeprom, direct scans, any rate */
 	u8 fat_flags;		/* flags copied from EEPROM */
 	u8 fat_extension_channel; /* HT_IE_EXT_CHANNEL_* */
+
+	/* Radio/DSP gain settings for each "normal" data Tx rate.
+	 * These include, in addition to RF and DSP gain, a few fields for
+	 *   remembering/modifying gain settings (indexes). */
+	struct iwl3945_channel_power_info power_info[IWL4965_MAX_RATE];
+
+	/* Radio/DSP gain settings for each scan rate, for directed scans. */
+	struct iwl3945_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
 };
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 9eb5b12..2e51f8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -53,6 +53,7 @@
 #include "iwl-3945.h"
 #include "iwl-3945-fh.h"
 #include "iwl-helpers.h"
+#include "iwl-dev.h"
 
 static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
 				  struct iwl3945_tx_queue *txq);
@@ -132,44 +133,17 @@ static const struct ieee80211_supported_band *iwl3945_get_band(
  * (#0-3) for data tx via EDCA.  An additional 2 HCCA queues are unused.
  ***************************************************/
 
-int iwl3945_queue_space(const struct iwl3945_queue *q)
-{
-	int s = q->read_ptr - q->write_ptr;
-
-	if (q->read_ptr > q->write_ptr)
-		s -= q->n_bd;
-
-	if (s <= 0)
-		s += q->n_window;
-	/* keep some reserve to not confuse empty and full situations */
-	s -= 2;
-	if (s < 0)
-		s = 0;
-	return s;
-}
-
-int iwl3945_x2_queue_used(const struct iwl3945_queue *q, int i)
+int iwl3945_x2_queue_used(const struct iwl_queue *q, int i)
 {
 	return q->write_ptr > q->read_ptr ?
 		(i >= q->read_ptr && i < q->write_ptr) :
 		!(i < q->read_ptr && i >= q->write_ptr);
 }
 
-
-static inline u8 get_cmd_index(struct iwl3945_queue *q, u32 index, int is_huge)
-{
-	/* This is for scan command, the big buffer at end of command array */
-	if (is_huge)
-		return q->n_window;	/* must be power of 2 */
-
-	/* Otherwise, use normal size buffers */
-	return index & (q->n_window - 1);
-}
-
 /**
  * iwl3945_queue_init - Initialize queue's high/low-water and read/write indexes
  */
-static int iwl3945_queue_init(struct iwl3945_priv *priv, struct iwl3945_queue *q,
+static int iwl3945_queue_init(struct iwl3945_priv *priv, struct iwl_queue *q,
 			  int count, int slots_num, u32 id)
 {
 	q->n_bd = count;
@@ -297,7 +271,7 @@ int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
  */
 void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq)
 {
-	struct iwl3945_queue *q = &txq->q;
+	struct iwl_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
 	int len;
 
@@ -582,7 +556,7 @@ static const char *get_cmd_string(u8 cmd)
 static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_cmd *cmd)
 {
 	struct iwl3945_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
-	struct iwl3945_queue *q = &txq->q;
+	struct iwl_queue *q = &txq->q;
 	struct iwl3945_tfd_frame *tfd;
 	u32 *control_flags;
 	struct iwl3945_cmd *out_cmd;
@@ -597,7 +571,7 @@ static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_c
 	/* If any of the command structures end up being larger than
 	 * the TFD_MAX_PAYLOAD_SIZE, and it sent as a 'small' command then
 	 * we will need to increase the size of the TFD entries */
-	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
+	BUG_ON((fix_size > TFD39_MAX_PAYLOAD_SIZE) &&
 	       !(cmd->meta.flags & CMD_SIZE_HUGE));
 
 
@@ -606,7 +580,7 @@ static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_c
 		return -EIO;
 	}
 
-	if (iwl3945_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
+	if (iwl_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
 		IWL_ERROR("No space for Tx\n");
 		return -ENOSPC;
 	}
@@ -2173,7 +2147,7 @@ static void iwl3945_set_flags_for_phymode(struct iwl3945_priv *priv,
 static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv,
 					      int mode)
 {
-	const struct iwl3945_channel_info *ch_info;
+	const struct iwl_channel_info *ch_info;
 
 	memset(&priv->staging_rxon, 0, sizeof(priv->staging_rxon));
 
@@ -2243,7 +2217,7 @@ static void iwl3945_connection_init_rx_config(struct iwl3945_priv *priv,
 static int iwl3945_set_mode(struct iwl3945_priv *priv, int mode)
 {
 	if (mode == NL80211_IFTYPE_ADHOC) {
-		const struct iwl3945_channel_info *ch_info;
+		const struct iwl_channel_info *ch_info;
 
 		ch_info = iwl3945_get_channel_info(priv,
 			priv->band,
@@ -2461,7 +2435,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 	u32 *control_flags;
 	int txq_id = skb_get_queue_mapping(skb);
 	struct iwl3945_tx_queue *txq = NULL;
-	struct iwl3945_queue *q = NULL;
+	struct iwl_queue *q = NULL;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	struct iwl3945_cmd *out_cmd = NULL;
@@ -2658,7 +2632,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 	if (rc)
 		return rc;
 
-	if ((iwl3945_queue_space(q) < q->high_mark)
+	if ((iwl_queue_space(q) < q->high_mark)
 	    && priv->mac80211_registered) {
 		if (wait_write_ptr) {
 			spin_lock_irqsave(&priv->lock, flags);
@@ -3311,7 +3285,7 @@ static void iwl3945_cmd_queue_reclaim(struct iwl3945_priv *priv,
 				      int txq_id, int index)
 {
 	struct iwl3945_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl3945_queue *q = &txq->q;
+	struct iwl_queue *q = &txq->q;
 	int nfreed = 0;
 
 	if ((index >= q->n_bd) || (iwl3945_x2_queue_used(q, index) == 0)) {
@@ -4534,8 +4508,9 @@ static void iwl3945_init_band_reference(const struct iwl3945_priv *priv, int ban
  *
  * Based on band and channel number.
  */
-const struct iwl3945_channel_info *iwl3945_get_channel_info(const struct iwl3945_priv *priv,
-						    enum ieee80211_band band, u16 channel)
+const struct iwl_channel_info *
+iwl3945_get_channel_info(const struct iwl3945_priv *priv,
+			 enum ieee80211_band band, u16 channel)
 {
 	int i;
 
@@ -4570,7 +4545,7 @@ static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 	const u8 *eeprom_ch_index = NULL;
 	const struct iwl_eeprom_channel *eeprom_ch_info = NULL;
 	int band, ch;
-	struct iwl3945_channel_info *ch_info;
+	struct iwl_channel_info *ch_info;
 
 	if (priv->channel_count) {
 		IWL_DEBUG_INFO("Channel map already initialized.\n");
@@ -4594,7 +4569,7 @@ static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 
 	IWL_DEBUG_INFO("Parsing data for %d channels.\n", priv->channel_count);
 
-	priv->channel_info = kzalloc(sizeof(struct iwl3945_channel_info) *
+	priv->channel_info = kzalloc(sizeof(struct iwl_channel_info) *
 				     priv->channel_count, GFP_KERNEL);
 	if (!priv->channel_info) {
 		IWL_ERROR("Could not allocate channel_info\n");
@@ -4756,7 +4731,7 @@ static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
 {
 	const struct ieee80211_channel *channels = NULL;
 	const struct ieee80211_supported_band *sband;
-	const struct iwl3945_channel_info *ch_info;
+	const struct iwl_channel_info *ch_info;
 	u16 passive_dwell = 0;
 	u16 active_dwell = 0;
 	int added, i;
@@ -4868,7 +4843,7 @@ static void iwl3945_init_hw_rates(struct iwl3945_priv *priv,
  */
 static int iwl3945_init_geos(struct iwl3945_priv *priv)
 {
-	struct iwl3945_channel_info *ch;
+	struct iwl_channel_info *ch;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *channels;
 	struct ieee80211_channel *geo_ch;
@@ -6598,7 +6573,7 @@ static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
 static int iwl3945_mac_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct iwl3945_priv *priv = hw->priv;
-	const struct iwl3945_channel_info *ch_info;
+	const struct iwl_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
 	unsigned long flags;
 	int ret = 0;
@@ -7129,7 +7104,7 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 	struct iwl3945_priv *priv = hw->priv;
 	int i, avail;
 	struct iwl3945_tx_queue *txq;
-	struct iwl3945_queue *q;
+	struct iwl_queue *q;
 	unsigned long flags;
 
 	IWL_DEBUG_MAC80211("enter\n");
@@ -7144,7 +7119,7 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 	for (i = 0; i < AC_NUM; i++) {
 		txq = &priv->txq[i];
 		q = &txq->q;
-		avail = iwl3945_queue_space(q);
+		avail = iwl_queue_space(q);
 
 		stats[i].len = q->n_window - avail;
 		stats[i].limit = q->n_window - q->high_mark;
-- 
1.5.3.6

