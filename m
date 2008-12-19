Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32389 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbYLSCpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:33 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 31/43] iwlwifi: clean up printing
Date: Fri, 19 Dec 2008 10:37:31 +0800
Message-Id: <1229654263-21454-32-git-send-email-yi.zhu@intel.com> (sfid-20081219_034618_573885_B97AB9CC)
In-Reply-To: <1229654263-21454-31-git-send-email-yi.zhu@intel.com>
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
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-31-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Use IWL_ macros where possible to unify debug output usage.
Define new unconditional printouts IWL_ERR, IWL_WARN, IWL_INFO,
and IWL_CRIT which don't use hidden priv pointer.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   36 ++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   24 +++++++----------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    8 ++---
 drivers/net/wireless/iwlwifi/iwl-debug.h    |   12 +++++---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    3 --
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   38 ++++++++++++---------------
 8 files changed, 58 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index e744ab6..f382b6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -465,8 +465,9 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
  * Fill uCode API rate_n_flags field, based on "search" or "active" table.
  */
 /* FIXME:RS:remove this function and put the flags statically in the table */
-static u32 rate_n_flags_from_tbl(struct iwl_scale_tbl_info *tbl,
-				       int index, u8 use_green)
+static u32 rate_n_flags_from_tbl(struct iwl_priv *priv,
+				 struct iwl_scale_tbl_info *tbl,
+				 int index, u8 use_green)
 {
 	u32 rate_n_flags = 0;
 
@@ -477,8 +478,7 @@ static u32 rate_n_flags_from_tbl(struct iwl_scale_tbl_info *tbl,
 
 	} else if (is_Ht(tbl->lq_type)) {
 		if (index > IWL_LAST_OFDM_RATE) {
-			printk(KERN_ERR RS_NAME": Invalid HT rate index %d\n",
-			       index);
+			IWL_ERR(priv, "Invalid HT rate index %d\n", index);
 			index = IWL_LAST_OFDM_RATE;
 		}
 		rate_n_flags = RATE_MCS_HT_MSK;
@@ -490,8 +490,7 @@ static u32 rate_n_flags_from_tbl(struct iwl_scale_tbl_info *tbl,
 		else
 			rate_n_flags |=	iwl_rates[index].plcp_mimo3;
 	} else {
-		printk(KERN_ERR RS_NAME": Invalid tbl->lq_type %d\n",
-		       tbl->lq_type);
+		IWL_ERR(priv, "Invalid tbl->lq_type %d\n", tbl->lq_type);
 	}
 
 	rate_n_flags |= ((tbl->ant_type << RATE_MCS_ANT_POS) &
@@ -511,8 +510,7 @@ static u32 rate_n_flags_from_tbl(struct iwl_scale_tbl_info *tbl,
 			rate_n_flags |= RATE_MCS_GF_MSK;
 			if (is_siso(tbl->lq_type) && tbl->is_SGI) {
 				rate_n_flags &= ~RATE_MCS_SGI_MSK;
-				printk(KERN_ERR RS_NAME
-				       ": GF was set with SGI:SISO\n");
+				IWL_ERR(priv, "GF was set with SGI:SISO\n");
 			}
 		}
 	}
@@ -763,7 +761,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 		low = scale_index;
 
 out:
-	return rate_n_flags_from_tbl(tbl, low, is_green);
+	return rate_n_flags_from_tbl(lq_sta->drv, tbl, low, is_green);
 }
 
 /*
@@ -1180,7 +1178,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 						rate, rate_mask);
 		return -1;
 	}
-	tbl->current_rate = rate_n_flags_from_tbl(tbl, rate, is_green);
+	tbl->current_rate = rate_n_flags_from_tbl(priv, tbl, rate, is_green);
 
 	IWL_DEBUG_RATE("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate, is_green);
@@ -1240,7 +1238,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 			     rate, rate_mask);
 		return -1;
 	}
-	tbl->current_rate = rate_n_flags_from_tbl(tbl, rate, is_green);
+	tbl->current_rate = rate_n_flags_from_tbl(priv, tbl, rate, is_green);
 	IWL_DEBUG_RATE("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate, is_green);
 	return 0;
@@ -1443,8 +1441,9 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 				if (tpt >= search_tbl->expected_tpt[index])
 					break;
 			}
-			search_tbl->current_rate = rate_n_flags_from_tbl(
-						search_tbl, index, is_green);
+			search_tbl->current_rate =
+				rate_n_flags_from_tbl(priv, search_tbl,
+						      index, is_green);
 			goto out;
 		}
 		tbl->action++;
@@ -1555,8 +1554,9 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 				if (tpt >= search_tbl->expected_tpt[index])
 					break;
 			}
-			search_tbl->current_rate = rate_n_flags_from_tbl(
-						search_tbl, index, is_green);
+			search_tbl->current_rate =
+				rate_n_flags_from_tbl(priv, search_tbl,
+						      index, is_green);
 			goto out;
 
 		}
@@ -1948,7 +1948,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 lq_update:
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq) {
-		rate = rate_n_flags_from_tbl(tbl, index, is_green);
+		rate = rate_n_flags_from_tbl(priv, tbl, index, is_green);
 		rs_fill_link_cmd(priv, lq_sta, rate);
 		iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 	}
@@ -2032,7 +2032,7 @@ lq_update:
 	}
 
 out:
-	tbl->current_rate = rate_n_flags_from_tbl(tbl, index, is_green);
+	tbl->current_rate = rate_n_flags_from_tbl(priv, tbl, index, is_green);
 	i = index;
 	lq_sta->last_txrate_idx = i;
 
@@ -2085,7 +2085,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	if (!rs_is_valid_ant(valid_tx_ant, tbl->ant_type))
 	    rs_toggle_antenna(valid_tx_ant, &rate, tbl);
 
-	rate = rate_n_flags_from_tbl(tbl, rate_idx, use_green);
+	rate = rate_n_flags_from_tbl(priv, tbl, rate_idx, use_green);
 	tbl->current_rate = rate;
 	rs_set_expected_tpt_table(lq_sta, tbl);
 	rs_fill_link_cmd(NULL, lq_sta, rate);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5c2f82f..2b64394 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1638,16 +1638,16 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 		goto err_release;
 	}
 	if (api_ver != api_max)
-		IWL_ERROR("Firmware has old API version. Expected v%u, "
+		IWL_ERR(priv, "Firmware has old API version. Expected v%u, "
 			  "got v%u. New firmware can be obtained "
 			  "from http://www.intellinuxwireless.org.\n",
 			  api_max, api_ver);
 
-	printk(KERN_INFO DRV_NAME " loaded firmware version %u.%u.%u.%u\n",
-		       IWL_UCODE_MAJOR(priv->ucode_ver),
-		       IWL_UCODE_MINOR(priv->ucode_ver),
-		       IWL_UCODE_API(priv->ucode_ver),
-		       IWL_UCODE_SERIAL(priv->ucode_ver));
+	IWL_INFO(priv, "loaded firmware version %u.%u.%u.%u\n",
+	       IWL_UCODE_MAJOR(priv->ucode_ver),
+	       IWL_UCODE_MINOR(priv->ucode_ver),
+	       IWL_UCODE_API(priv->ucode_ver),
+	       IWL_UCODE_SERIAL(priv->ucode_ver));
 
 	IWL_DEBUG_INFO("f/w package hdr ucode version raw = 0x%x\n",
 		       priv->ucode_ver);
@@ -3366,8 +3366,7 @@ static ssize_t store_debug_level(struct device *d,
 
 	ret = strict_strtoul(buf, 0, &val);
 	if (ret)
-		printk(KERN_INFO DRV_NAME
-		       ": %s is not in hex or decimal form.\n", buf);
+		IWL_ERR(priv, "%s is not in hex or decimal form.\n", buf);
 	else
 		priv->debug_level = val;
 
@@ -3446,8 +3445,7 @@ static ssize_t store_tx_power(struct device *d,
 
 	ret = strict_strtoul(buf, 10, &val);
 	if (ret)
-		printk(KERN_INFO DRV_NAME
-		       ": %s is not in decimal form.\n", buf);
+		IWL_INFO(priv, "%s is not in decimal form.\n", buf);
 	else
 		iwl_set_tx_power(priv, val, false);
 
@@ -3824,8 +3822,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		/* both attempts failed: */
 		if (err) {
-			printk(KERN_WARNING "%s: No suitable DMA available.\n",
-				DRV_NAME);
+			IWL_WARN(priv, "No suitable DMA available.\n");
 			goto out_pci_disable_device;
 		}
 	}
@@ -3851,8 +3848,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	IWL_DEBUG_INFO("pci_resource_base = %p\n", priv->hw_base);
 
 	iwl_hw_detect(priv);
-	printk(KERN_INFO DRV_NAME
-		": Detected Intel Wireless WiFi Link %s REV=0x%X\n",
+	IWL_INFO(priv, "Detected Intel Wireless WiFi Link %s REV=0x%X\n",
 		priv->cfg->name, priv->hw_rev);
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6425943..c889e3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -512,16 +512,14 @@ static int iwlcore_init_geos(struct iwl_priv *priv)
 
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     priv->cfg->sku & IWL_SKU_A) {
-		dev_printk(KERN_INFO, &(priv->hw->wiphy->dev),
-			   "Incorrectly detected BG card as ABG.  Please send "
-			   "your PCI ID 0x%04X:0x%04X to maintainer.\n",
+		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
+			"Please send your PCI ID 0x%04X:0x%04X to maintainer.\n",
 			   priv->pci_dev->device,
 			   priv->pci_dev->subsystem_device);
 		priv->cfg->sku &= ~IWL_SKU_A;
 	}
 
-	dev_printk(KERN_INFO, &(priv->hw->wiphy->dev),
-		   "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
+	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
 		   priv->bands[IEEE80211_BAND_2GHZ].n_channels,
 		   priv->bands[IEEE80211_BAND_5GHZ].n_channels);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index e15bc3c..9ed5c3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -31,6 +31,13 @@
 
 struct iwl_priv;
 
+#define IWL_ERROR(f, a...) dev_err(&(priv->pci_dev->dev), f, ## a)
+#define IWL_WARNING(f, a...) dev_warn(&(priv->pci_dev->dev), f, ## a)
+#define IWL_ERR(p, f, a...) dev_err(&((p)->pci_dev->dev), f, ## a)
+#define IWL_WARN(p, f, a...) dev_warn(&((p)->pci_dev->dev), f, ## a)
+#define IWL_INFO(p, f, a...) dev_info(&((p)->pci_dev->dev), f, ## a)
+#define IWL_CRIT(p, f, a...) dev_crit(&((p)->pci_dev->dev), f, ## a)
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define IWL_DEBUG(level, fmt, args...)					    \
 do {									    \
@@ -163,11 +170,6 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DL_TX_REPLY		(1 << 30)
 #define IWL_DL_QOS		(1 << 31)
 
-#define IWL_ERROR(f, a...)		\
-		dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), f, ## a)
-#define IWL_WARNING(f, a...)		\
-		dev_printk(KERN_WARNING, &(priv->hw->wiphy->dev), f, ## a)
-
 #define IWL_DEBUG_INFO(f, a...)		IWL_DEBUG(IWL_DL_INFO, f, ## a)
 #define IWL_DEBUG_MAC80211(f, a...)	IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
 #define IWL_DEBUG_MACDUMP(f, a...)	IWL_DEBUG(IWL_DL_MACDUMP, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index feb4091..df5906f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -164,9 +164,6 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
 	const size_t bufsz = sizeof(buf);
 
-	printk(KERN_DEBUG "offset is: 0x%x\tlen is: 0x%x\n",
-	priv->dbgfs->sram_offset, priv->dbgfs->sram_len);
-
 	iwl_grab_nic_access(priv);
 	for (i = priv->dbgfs->sram_len; i > 0; i -= 4) {
 		val = iwl_read_targ_mem(priv, priv->dbgfs->sram_offset + \
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 610a7c2..18c630d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -262,8 +262,7 @@ void iwl_rx_allocate(struct iwl_priv *priv)
 		rxb->skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
 				     GFP_KERNEL);
 		if (!rxb->skb) {
-			dev_printk(KERN_CRIT, &(priv->hw->wiphy->dev),
-					   "Can not allocate SKB buffers\n");
+			IWL_CRIT(priv, "Can not allocate SKB buffers\n");
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 3cb4363..dd41531 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -802,7 +802,7 @@ static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 		break;
 
 	default:
-		printk(KERN_ERR "Unknown encode alg %d\n", keyconf->alg);
+		IWL_ERR(priv, "Unknown encode alg %d\n", keyconf->alg);
 		break;
 	}
 }
@@ -1339,7 +1339,7 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 		return ret;
 
 	if (tid_data->tfds_in_queue == 0) {
-		printk(KERN_ERR "HW queue is empty\n");
+		IWL_ERR(priv, "HW queue is empty\n");
 		tid_data->agg.state = IWL_AGG_ON;
 		ieee80211_start_tx_ba_cb_irqsafe(priv->hw, ra, tid);
 	} else {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0ecb8b8..7ee42fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2241,7 +2241,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 		break;
 
 	default:
-		printk(KERN_ERR "Unknown encode alg %d\n", keyinfo->alg);
+		IWL_ERR(priv, "Unknown encode alg %d\n", keyinfo->alg);
 		break;
 	}
 }
@@ -3510,8 +3510,7 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv)
 		    alloc_skb(IWL_RX_BUF_SIZE, __GFP_NOWARN | GFP_ATOMIC);
 		if (!rxb->skb) {
 			if (net_ratelimit())
-				printk(KERN_CRIT DRV_NAME
-				       ": Can not allocate SKB buffers\n");
+				IWL_CRIT(priv, ": Can not allocate SKB buffers\n");
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */
@@ -4884,15 +4883,13 @@ static int iwl3945_init_geos(struct iwl_priv *priv)
 
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     priv->cfg->sku & IWL_SKU_A) {
-		printk(KERN_INFO DRV_NAME
-		       ": Incorrectly detected BG card as ABG.  Please send "
-		       "your PCI ID 0x%04X:0x%04X to maintainer.\n",
-		       priv->pci_dev->device, priv->pci_dev->subsystem_device);
+		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
+			"Please send your PCI ID 0x%04X:0x%04X to maintainer.\n",
+			priv->pci_dev->device, priv->pci_dev->subsystem_device);
 		 priv->cfg->sku &= ~IWL_SKU_A;
 	}
 
-	printk(KERN_INFO DRV_NAME
-	       ": Tunable channels: %d 802.11bg, %d 802.11a channels\n",
+	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
 	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
 	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);
 
@@ -5309,11 +5306,12 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 			  "from http://www.intellinuxwireless.org.\n",
 			  api_max, api_ver);
 
-	printk(KERN_INFO DRV_NAME " loaded firmware version %u.%u.%u.%u\n",
-		       IWL_UCODE_MAJOR(priv->ucode_ver),
-		       IWL_UCODE_MINOR(priv->ucode_ver),
-		       IWL_UCODE_API(priv->ucode_ver),
-		       IWL_UCODE_SERIAL(priv->ucode_ver));
+	IWL_INFO(priv, "loaded firmware version %u.%u.%u.%u\n",
+		IWL_UCODE_MAJOR(priv->ucode_ver),
+		IWL_UCODE_MINOR(priv->ucode_ver),
+		IWL_UCODE_API(priv->ucode_ver),
+		IWL_UCODE_SERIAL(priv->ucode_ver));
+
 	IWL_DEBUG_INFO("f/w package hdr ucode version raw = 0x%x\n",
 		       priv->ucode_ver);
 	IWL_DEBUG_INFO("f/w package hdr runtime inst size = %u\n", inst_size);
@@ -7209,8 +7207,7 @@ static ssize_t store_debug_level(struct device *d,
 
 	ret = strict_strtoul(buf, 0, &val);
 	if (ret)
-		printk(KERN_INFO DRV_NAME
-		       ": %s is not in hex or decimal form.\n", buf);
+		IWL_INFO(priv, "%s is not in hex or decimal form.\n", buf);
 	else
 		priv->debug_level = val;
 
@@ -7252,8 +7249,7 @@ static ssize_t store_tx_power(struct device *d,
 
 	val = simple_strtoul(p, &p, 10);
 	if (p == buf)
-		printk(KERN_INFO DRV_NAME
-		       ": %s is not in decimal form.\n", buf);
+		IWL_INFO(priv, ": %s is not in decimal form.\n", buf);
 	else
 		iwl3945_hw_reg_set_txpower(priv, val);
 
@@ -7810,7 +7806,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	if (!err)
 		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 	if (err) {
-		printk(KERN_WARNING DRV_NAME ": No suitable DMA available.\n");
+		IWL_WARN(priv, "No suitable DMA available.\n");
 		goto out_pci_disable_device;
 	}
 
@@ -7918,8 +7914,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		goto out_free_channel_map;
 	}
 
-	printk(KERN_INFO DRV_NAME
-		": Detected Intel Wireless WiFi Link %s\n", priv->cfg->name);
+	IWL_INFO(priv, "Detected Intel Wireless WiFi Link %s\n",
+		priv->cfg->name);
 
 	/***********************************
 	 * 7. Initialize Module Parameters
-- 
1.5.3.6

