Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbYEOF4R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:17 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 03/26] mac80211: separate Tx and Rx MCS when configuring HT
Date: Thu, 15 May 2008 13:53:55 +0800
Message-Id: <1210830858-3410-4-git-send-email-yi.zhu@intel.com> (sfid-20080515_075622_724247_48BBE34C)
In-Reply-To: <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch follows the 11n spec in separation between Tx and Rx MCS
capabilities. Up until now, when configuring the HT possible set of Tx
MCS only Rx MCS were considered, assuming they are the same as the Tx MCS.
This patch fixed this by looking at low level driver Tx capabilities.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   14 ++--
 include/linux/ieee80211.h                   |   18 ++++-
 net/mac80211/main.c                         |   96 +++++++++++++++++----------
 3 files changed, 83 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 1a2d376..c713b27 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3958,6 +3958,13 @@ static void iwl4965_dealloc_ucode_pci(struct iwl_priv *priv)
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_boot);
 }
 
+static void iwl4965_nic_start(struct iwl_priv *priv)
+{
+	/* Remove all resets to allow NIC to operate */
+	iwl_write32(priv, CSR_RESET, 0);
+}
+
+
 /**
  * iwl4965_read_ucode - Read uCode images from disk file.
  *
@@ -4447,8 +4454,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 		}
 
 		/* start card; "initialize" will load runtime ucode */
-		/* Remove all resets to allow NIC to operate */
-		iwl_write32(priv, CSR_RESET, 0);
+		iwl4965_nic_start(priv);
 
 		IWL_DEBUG_INFO(DRV_NAME " is coming up\n");
 
@@ -6842,10 +6848,6 @@ static int __init iwl4965_init(void)
 
 	return ret;
 
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	pci_unregister_driver(&iwl_driver);
-#endif
 error_register:
 	iwl4965_rate_control_unregister();
 	return ret;
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a9102bc..3c2ac0c 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -306,8 +306,18 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_HT_CAP_SGI_40			0x0040
 #define IEEE80211_HT_CAP_DELAY_BA		0x0400
 #define IEEE80211_HT_CAP_MAX_AMSDU		0x0800
+/* 802.11n HT capability AMPDU settings */
 #define IEEE80211_HT_CAP_AMPDU_FACTOR		0x03
 #define IEEE80211_HT_CAP_AMPDU_DENSITY		0x1C
+/* 802.11n HT capability MSC set */
+#define IEEE80211_SUPP_MCS_SET_UEQM		4
+#define IEEE80211_HT_CAP_MAX_STREAMS		4
+#define IEEE80211_SUPP_MCS_SET_LEN		10
+/* maximum streams the spec allows */
+#define IEEE80211_HT_CAP_MCS_TX_DEFINED		0x01
+#define IEEE80211_HT_CAP_MCS_TX_RX_DIFF		0x02
+#define IEEE80211_HT_CAP_MCS_TX_STREAMS		0x0C
+#define IEEE80211_HT_CAP_MCS_TX_UEQM		0x10
 /* 802.11n HT IE masks */
 #define IEEE80211_HT_IE_CHA_SEC_OFFSET		0x03
 #define IEEE80211_HT_IE_CHA_WIDTH		0x04
@@ -316,10 +326,10 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_HT_IE_NON_HT_STA_PRSNT	0x0010
 
 /* MIMO Power Save Modes */
-#define WLAN_HT_CAP_MIMO_PS_STATIC         0
-#define WLAN_HT_CAP_MIMO_PS_DYNAMIC        1
-#define WLAN_HT_CAP_MIMO_PS_INVALID        2
-#define WLAN_HT_CAP_MIMO_PS_DISABLED       3
+#define WLAN_HT_CAP_MIMO_PS_STATIC	0
+#define WLAN_HT_CAP_MIMO_PS_DYNAMIC	1
+#define WLAN_HT_CAP_MIMO_PS_INVALID	2
+#define WLAN_HT_CAP_MIMO_PS_DISABLED	3
 
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 3601636..b0fddb7 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -35,8 +35,6 @@
 #include "debugfs.h"
 #include "debugfs_netdev.h"
 
-#define SUPP_MCS_SET_LEN 16
-
 /*
  * For seeing transmitted packets on monitor interfaces
  * we have a radiotap header too.
@@ -1068,56 +1066,84 @@ u32 ieee80211_handle_ht(struct ieee80211_local *local, int enable_ht,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_ht_info ht_conf;
 	struct ieee80211_ht_bss_info ht_bss_conf;
-	int i;
 	u32 changed = 0;
+	int i;
+	u8 max_tx_streams = IEEE80211_HT_CAP_MAX_STREAMS;
+	u8 tx_mcs_set_cap;
 
 	sband = local->hw.wiphy->bands[conf->channel->band];
 
+	memset(&ht_conf, 0, sizeof(struct ieee80211_ht_info));
+	memset(&ht_bss_conf, 0, sizeof(struct ieee80211_ht_bss_info));
+
 	/* HT is not supported */
 	if (!sband->ht_info.ht_supported) {
 		conf->flags &= ~IEEE80211_CONF_SUPPORT_HT_MODE;
-		return 0;
+		goto out;
 	}
 
-	memset(&ht_conf, 0, sizeof(struct ieee80211_ht_info));
-	memset(&ht_bss_conf, 0, sizeof(struct ieee80211_ht_bss_info));
-
-	if (enable_ht) {
-		if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE))
+	/* disable HT */
+	if (!enable_ht) {
+		if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE)
 			changed |= BSS_CHANGED_HT;
+		conf->flags &= ~IEEE80211_CONF_SUPPORT_HT_MODE;
+		conf->ht_conf.ht_supported = 0;
+		goto out;
+	}
 
-		conf->flags |= IEEE80211_CONF_SUPPORT_HT_MODE;
-		ht_conf.ht_supported = 1;
 
-		ht_conf.cap = req_ht_cap->cap & sband->ht_info.cap;
-		ht_conf.cap &= ~(IEEE80211_HT_CAP_MIMO_PS);
-		ht_conf.cap |= sband->ht_info.cap & IEEE80211_HT_CAP_MIMO_PS;
+	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE))
+		changed |= BSS_CHANGED_HT;
 
-		for (i = 0; i < SUPP_MCS_SET_LEN; i++)
-			ht_conf.supp_mcs_set[i] =
-					sband->ht_info.supp_mcs_set[i] &
-					req_ht_cap->supp_mcs_set[i];
+	conf->flags |= IEEE80211_CONF_SUPPORT_HT_MODE;
+	ht_conf.ht_supported = 1;
 
-		ht_bss_conf.primary_channel = req_bss_cap->primary_channel;
-		ht_bss_conf.bss_cap = req_bss_cap->bss_cap;
-		ht_bss_conf.bss_op_mode = req_bss_cap->bss_op_mode;
+	ht_conf.cap = req_ht_cap->cap & sband->ht_info.cap;
+	ht_conf.cap &= ~(IEEE80211_HT_CAP_MIMO_PS);
+	ht_conf.cap |= sband->ht_info.cap & IEEE80211_HT_CAP_MIMO_PS;
+	ht_bss_conf.primary_channel = req_bss_cap->primary_channel;
+	ht_bss_conf.bss_cap = req_bss_cap->bss_cap;
+	ht_bss_conf.bss_op_mode = req_bss_cap->bss_op_mode;
 
-		ht_conf.ampdu_factor = req_ht_cap->ampdu_factor;
-		ht_conf.ampdu_density = req_ht_cap->ampdu_density;
+	ht_conf.ampdu_factor = req_ht_cap->ampdu_factor;
+	ht_conf.ampdu_density = req_ht_cap->ampdu_density;
 
-		/* if bss configuration changed store the new one */
-		if (memcmp(&conf->ht_conf, &ht_conf, sizeof(ht_conf)) ||
-		    memcmp(&conf->ht_bss_conf, &ht_bss_conf, sizeof(ht_bss_conf))) {
-			changed |= BSS_CHANGED_HT;
-			memcpy(&conf->ht_conf, &ht_conf, sizeof(ht_conf));
-			memcpy(&conf->ht_bss_conf, &ht_bss_conf, sizeof(ht_bss_conf));
-		}
-	} else {
-		if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE)
-			changed |= BSS_CHANGED_HT;
-		conf->flags &= ~IEEE80211_CONF_SUPPORT_HT_MODE;
-	}
+	/* Bits 96-100 */
+	tx_mcs_set_cap = sband->ht_info.supp_mcs_set[12];
 
+	/* configure suppoerted Tx MCS according to requested MCS
+	 * (based in most cases on Rx capabilities of peer) and self
+	 * Tx MCS capabilities (as defined by low level driver HW
+	 * Tx capabilities) */
+	if (!(tx_mcs_set_cap & IEEE80211_HT_CAP_MCS_TX_DEFINED))
+		goto check_changed;
+
+	/* Counting from 0 therfore + 1 */
+	if (tx_mcs_set_cap & IEEE80211_HT_CAP_MCS_TX_RX_DIFF)
+		max_tx_streams = ((tx_mcs_set_cap &
+				IEEE80211_HT_CAP_MCS_TX_STREAMS) >> 2) + 1;
+
+	for (i = 0; i < max_tx_streams; i++)
+		ht_conf.supp_mcs_set[i] =
+			sband->ht_info.supp_mcs_set[i] &
+					req_ht_cap->supp_mcs_set[i];
+
+	if (tx_mcs_set_cap & IEEE80211_HT_CAP_MCS_TX_UEQM)
+		for (i = IEEE80211_SUPP_MCS_SET_UEQM;
+		     i < IEEE80211_SUPP_MCS_SET_LEN; i++)
+			ht_conf.supp_mcs_set[i] =
+				sband->ht_info.supp_mcs_set[i] &
+					req_ht_cap->supp_mcs_set[i];
+
+check_changed:
+	/* if bss configuration changed store the new one */
+	if (memcmp(&conf->ht_conf, &ht_conf, sizeof(ht_conf)) ||
+	    memcmp(&conf->ht_bss_conf, &ht_bss_conf, sizeof(ht_bss_conf))) {
+		changed |= BSS_CHANGED_HT;
+		memcpy(&conf->ht_conf, &ht_conf, sizeof(ht_conf));
+		memcpy(&conf->ht_bss_conf, &ht_bss_conf, sizeof(ht_bss_conf));
+	}
+out:
 	return changed;
 }
 
-- 
1.5.3.6

