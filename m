Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39974 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbYLSCpF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:05 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <sameo@linux.intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/43] iwl3945: Remove DRV_NAME dependenies
Date: Fri, 19 Dec 2008 10:37:09 +0800
Message-Id: <1229654263-21454-10-git-send-email-yi.zhu@intel.com> (sfid-20081219_034524_220084_AD0467B3)
In-Reply-To: <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

As DRV_NAME is defined in 2 different header files, including both is not
possible.
This patch defines this constant from iwl3945-base.c and iwl-agn.c. It also
redefines the IWL_ERROR and IWL_WARNING macros to use dev_printk, as the
IWL_DEBUG_* macros do.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Acked-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h           |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c           |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    9 ++++--
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   11 ++++---
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    4 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c           |   21 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    1 -
 drivers/net/wireless/iwlwifi/iwl-rx.c             |    4 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c       |   31 +++++++++++---------
 11 files changed, 55 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index d5154ec..7e9ba54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -43,7 +43,6 @@
 /* Hardware specific file defines the PCI IDs table for that hardware module */
 extern struct pci_device_id iwl3945_hw_card_ids[];
 
-#define DRV_NAME	"iwl3945"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
 #include "iwl-3945-hw.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 5a72bc0..bb96170 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -902,7 +902,6 @@ static s32 iwl4965_get_tx_atten_grp(u16 channel)
 	    channel <= CALIB_IWL_TX_ATTEN_GR4_LCH)
 		return CALIB_CH_GROUP_4;
 
-	IWL_ERROR("Can't find txatten group for channel %d.\n", channel);
 	return -1;
 }
 
@@ -1319,8 +1318,11 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	/* get txatten group, used to select 1) thermal txpower adjustment
 	 *   and 2) mimo txpower balance between Tx chains. */
 	txatten_grp = iwl4965_get_tx_atten_grp(channel);
-	if (txatten_grp < 0)
+	if (txatten_grp < 0) {
+		IWL_ERROR("Can't find txatten group for channel %d.\n",
+			  channel);
 		return -EINVAL;
+	}
 
 	IWL_DEBUG_TXPOWER("channel %d belongs to txatten group %d\n",
 			  channel, txatten_grp);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
index b8137ee..392d96d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
@@ -40,10 +40,11 @@
  * be #ifdef'd out once the driver is stable and folks aren't actively
  * making changes
  */
-int iwl_agn_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
+int iwl_agn_check_rxon_cmd(struct iwl_priv *priv)
 {
 	int error = 0;
 	int counter = 1;
+	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 
 	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
 		error |= le32_to_cpu(rxon->flags &
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 50e4dd5..e744ab6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -477,7 +477,8 @@ static u32 rate_n_flags_from_tbl(struct iwl_scale_tbl_info *tbl,
 
 	} else if (is_Ht(tbl->lq_type)) {
 		if (index > IWL_LAST_OFDM_RATE) {
-			IWL_ERROR("invalid HT rate index %d\n", index);
+			printk(KERN_ERR RS_NAME": Invalid HT rate index %d\n",
+			       index);
 			index = IWL_LAST_OFDM_RATE;
 		}
 		rate_n_flags = RATE_MCS_HT_MSK;
@@ -489,7 +490,8 @@ static u32 rate_n_flags_from_tbl(struct iwl_scale_tbl_info *tbl,
 		else
 			rate_n_flags |=	iwl_rates[index].plcp_mimo3;
 	} else {
-		IWL_ERROR("Invalid tbl->lq_type %d\n", tbl->lq_type);
+		printk(KERN_ERR RS_NAME": Invalid tbl->lq_type %d\n",
+		       tbl->lq_type);
 	}
 
 	rate_n_flags |= ((tbl->ant_type << RATE_MCS_ANT_POS) &
@@ -509,7 +511,8 @@ static u32 rate_n_flags_from_tbl(struct iwl_scale_tbl_info *tbl,
 			rate_n_flags |= RATE_MCS_GF_MSK;
 			if (is_siso(tbl->lq_type) && tbl->is_SGI) {
 				rate_n_flags &= ~RATE_MCS_SGI_MSK;
-				IWL_ERROR("GF was set with SGI:SISO\n");
+				printk(KERN_ERR RS_NAME
+				       ": GF was set with SGI:SISO\n");
 			}
 		}
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 289c0e0..5c2f82f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -44,6 +44,8 @@
 
 #include <asm/div64.h>
 
+#define DRV_NAME        "iwlagn"
+
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -61,9 +63,7 @@
 
 /*
  * module name, copyright, version, etc.
- * NOTE: DRV_NAME is defined in iwlwifi.h for use by iwl-debug.h and printk
  */
-
 #define DRV_DESCRIPTION	"Intel(R) Wireless WiFi Link AGN driver for Linux"
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -180,7 +180,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 	 * 5000, but will not damage 4965 */
 	priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
 
-	ret = iwl_agn_check_rxon_cmd(&priv->staging_rxon);
+	ret = iwl_agn_check_rxon_cmd(priv);
 	if (ret) {
 		IWL_ERROR("Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
@@ -4126,13 +4126,14 @@ static int __init iwl_init(void)
 
 	ret = iwlagn_rate_control_register();
 	if (ret) {
-		IWL_ERROR("Unable to register rate control algorithm: %d\n", ret);
+		printk(KERN_ERR DRV_NAME
+		       "Unable to register rate control algorithm: %d\n", ret);
 		return ret;
 	}
 
 	ret = pci_register_driver(&iwl_driver);
 	if (ret) {
-		IWL_ERROR("Unable to initialize PCI module\n");
+		printk(KERN_ERR DRV_NAME "Unable to initialize PCI module\n");
 		goto error_register;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 88467b0..56f9a24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -69,6 +69,8 @@
 #ifndef __iwl_commands_h__
 #define __iwl_commands_h__
 
+struct iwl_priv;
+
 /* uCode version contains 4 values: Major/Minor/API/Serial */
 #define IWL_UCODE_MAJOR(ver)	(((ver) & 0xFF000000) >> 24)
 #define IWL_UCODE_MINOR(ver)	(((ver) & 0x00FF0000) >> 16)
@@ -3455,6 +3457,6 @@ struct iwl_rx_packet {
 	} u;
 } __attribute__ ((packed));
 
-int iwl_agn_check_rxon_cmd(struct iwl_rxon_cmd *rxon);
+int iwl_agn_check_rxon_cmd(struct iwl_priv *priv);
 
 #endif				/* __iwl_commands_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 67fd6e1..32de3d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -170,7 +170,8 @@ struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 	struct ieee80211_hw *hw =
 		ieee80211_alloc_hw(sizeof(struct iwl_priv), hw_ops);
 	if (hw == NULL) {
-		IWL_ERROR("Can not allocate network device\n");
+		printk(KERN_ERR "%s: Can not allocate network device\n",
+		       cfg->name);
 		goto out;
 	}
 
@@ -511,18 +512,18 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     priv->cfg->sku & IWL_SKU_A) {
-		printk(KERN_INFO DRV_NAME
-		       ": Incorrectly detected BG card as ABG.  Please send "
-		       "your PCI ID 0x%04X:0x%04X to maintainer.\n",
-		       priv->pci_dev->device, priv->pci_dev->subsystem_device);
+		dev_printk(KERN_INFO, &(priv->hw->wiphy->dev),
+			   "Incorrectly detected BG card as ABG.  Please send "
+			   "your PCI ID 0x%04X:0x%04X to maintainer.\n",
+			   priv->pci_dev->device,
+			   priv->pci_dev->subsystem_device);
 		priv->cfg->sku &= ~IWL_SKU_A;
 	}
 
-	printk(KERN_INFO DRV_NAME
-	       ": Tunable channels: %d 802.11bg, %d 802.11a channels\n",
-	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
-	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);
-
+	dev_printk(KERN_INFO, &(priv->hw->wiphy->dev),
+		   "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
+		   priv->bands[IEEE80211_BAND_2GHZ].n_channels,
+		   priv->bands[IEEE80211_BAND_5GHZ].n_channels);
 
 	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index f00e30d..aa20d72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -159,8 +159,10 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DL_TX_REPLY      (1 << 30)
 #define IWL_DL_QOS           (1 << 31)
 
-#define IWL_ERROR(f, a...) printk(KERN_ERR DRV_NAME ": " f, ## a)
-#define IWL_WARNING(f, a...) printk(KERN_WARNING DRV_NAME ": " f, ## a)
+#define IWL_ERROR(f, a...) dev_printk(KERN_ERR, \
+			&(priv->hw->wiphy->dev), f, ## a)
+#define IWL_WARNING(f, a...) dev_printk(KERN_WARNING, \
+			&(priv->hw->wiphy->dev), f, ## a)
 #define IWL_DEBUG_INFO(f, a...)    IWL_DEBUG(IWL_DL_INFO, f, ## a)
 
 #define IWL_DEBUG_MAC80211(f, a...)     IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0468fcc..73a0b6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -36,7 +36,6 @@
 #include <linux/kernel.h>
 #include <net/ieee80211_radiotap.h>
 
-#define DRV_NAME        "iwlagn"
 #include "iwl-rfkill.h"
 #include "iwl-eeprom.h"
 #include "iwl-4965-hw.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index c5f1aa0..610a7c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -262,8 +262,8 @@ void iwl_rx_allocate(struct iwl_priv *priv)
 		rxb->skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
 				     GFP_KERNEL);
 		if (!rxb->skb) {
-			printk(KERN_CRIT DRV_NAME
-				   "Can not allocate SKB buffers\n");
+			dev_printk(KERN_CRIT, &(priv->hw->wiphy->dev),
+					   "Can not allocate SKB buffers\n");
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c85e136..142d89d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -46,6 +46,8 @@
 
 #include <asm/div64.h>
 
+#define DRV_NAME	"iwl3945"
+
 #include "iwl-3945-core.h"
 #include "iwl-commands.h"
 #include "iwl-3945.h"
@@ -71,7 +73,6 @@ int iwl3945_param_queues_num = IWL39_MAX_NUM_QUEUES; /* def: 8 Tx queues */
 
 /*
  * module name, copyright, version, etc.
- * NOTE: DRV_NAME is defined in iwlwifi.h for use by iwl-debug.h and printk
  */
 
 #define DRV_DESCRIPTION	\
@@ -848,10 +849,11 @@ static int iwl3945_set_rxon_channel(struct iwl3945_priv *priv,
  * be #ifdef'd out once the driver is stable and folks aren't actively
  * making changes
  */
-static int iwl3945_check_rxon_cmd(struct iwl3945_rxon_cmd *rxon)
+static int iwl3945_check_rxon_cmd(struct iwl3945_priv *priv)
 {
 	int error = 0;
 	int counter = 1;
+	struct iwl3945_rxon_cmd *rxon = &priv->staging_rxon;
 
 	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
 		error |= le32_to_cpu(rxon->flags &
@@ -1033,7 +1035,7 @@ static int iwl3945_commit_rxon(struct iwl3945_priv *priv)
 	    ~(RXON_FLG_DIS_DIV_MSK | RXON_FLG_ANT_SEL_MSK);
 	priv->staging_rxon.flags |= iwl3945_get_antenna_flags(priv);
 
-	rc = iwl3945_check_rxon_cmd(&priv->staging_rxon);
+	rc = iwl3945_check_rxon_cmd(priv);
 	if (rc) {
 		IWL_ERROR("Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
@@ -7821,19 +7823,11 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * 1. Allocating HW data
 	 * ********************/
 
-	if ((iwl3945_param_queues_num > IWL39_MAX_NUM_QUEUES) ||
-	    (iwl3945_param_queues_num < IWL_MIN_NUM_QUEUES)) {
-		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
-			  IWL_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
-		err = -EINVAL;
-		goto out;
-	}
-
 	/* mac80211 allocates memory for this device instance, including
 	 *   space for this driver's private structure */
 	hw = ieee80211_alloc_hw(sizeof(struct iwl3945_priv), &iwl3945_hw_ops);
 	if (hw == NULL) {
-		IWL_ERROR("Can not allocate network device\n");
+		printk(KERN_ERR DRV_NAME "Can not allocate network device\n");
 		err = -ENOMEM;
 		goto out;
 	}
@@ -7845,6 +7839,14 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->pci_dev = pdev;
 	priv->cfg = cfg;
 
+	if ((iwl3945_param_queues_num > IWL39_MAX_NUM_QUEUES) ||
+	    (iwl3945_param_queues_num < IWL_MIN_NUM_QUEUES)) {
+		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
+			  IWL_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
+		err = -EINVAL;
+		goto out;
+	}
+
 	/* Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan. */
 	if (iwl3945_param_disable_hw_scan) {
@@ -8311,13 +8313,14 @@ static int __init iwl3945_init(void)
 
 	ret = iwl3945_rate_control_register();
 	if (ret) {
-		IWL_ERROR("Unable to register rate control algorithm: %d\n", ret);
+		printk(KERN_ERR DRV_NAME
+		       "Unable to register rate control algorithm: %d\n", ret);
 		return ret;
 	}
 
 	ret = pci_register_driver(&iwl3945_driver);
 	if (ret) {
-		IWL_ERROR("Unable to initialize PCI module\n");
+		printk(KERN_ERR DRV_NAME "Unable to initialize PCI module\n");
 		goto error_register;
 	}
 
-- 
1.5.3.6

