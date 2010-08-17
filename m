Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60213 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab0HQJYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 05:24:08 -0400
Subject: [PATCH] iwlwifi: fix 3945 filter flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <877hjqpl2e.fsf@sycorax.lbl.gov>
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	 <1279917523.10769.1.camel@wwguy-huron>
	 <1280135867.3693.5.camel@jlt3.sipsolutions.net>
	 <87mxtd5xlq.fsf@sycorax.lbl.gov>
	 <1280212629.19098.0.camel@jlt3.sipsolutions.net>
	 <87bp9l6f4k.fsf@sycorax.lbl.gov>
	 <1280746705.3923.11.camel@jlt3.sipsolutions.net>
	 <878w4pvx5e.fsf@sycorax.lbl.gov>
	 <1280766201.24503.0.camel@jlt3.sipsolutions.net>
	 <87aap4z70b.fsf@sycorax.lbl.gov>
	 <1280817596.3874.0.camel@jlt3.sipsolutions.net>
	 <87mxt3n9xh.fsf@sycorax.lbl.gov>
	 <1280908365.3768.4.camel@jlt3.sipsolutions.net>
	 <87aap28m8v.fsf@sycorax.lbl.gov>
	 <1280934185.3768.8.camel@jlt3.sipsolutions.net>
	 <8739uu8lg2.fsf@sycorax.lbl.gov>
	 <1280934689.17718.3.camel@jlt3.sipsolutions.net>
	 <8762zq76p3.fsf@sycorax.lbl.gov>
	 <1281964617.3683.23.camel@jlt3.sipsolutions.net>
	 <877hjqpl2e.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 11:24:01 +0200
Message-ID: <1282037041.3747.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Applying the filter flags directly as done since

commit 3474ad635db371b0d8d0ee40086f15d223d5b6a4
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Apr 29 04:43:05 2010 -0700

    iwlwifi: apply filter flags directly

broke 3945 under some unknown circumstances, as
reported by Alex.

Since I want to keep the direct application of
filter flags on iwlagn, duplicate the code into
both 3945 and agn and remove committing the
RXON that broke things from the 3945 version.

Cc: stable@kernel.org [2.6.35]
Reported-by: Alex Romosan <romosan@sycorax.lbl.gov>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   45 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   45 ------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   51 +++++++++++++++++++++++++++-
 4 files changed, 94 insertions(+), 50 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2010-08-17 11:08:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2010-08-17 11:10:50.000000000 +0200
@@ -3669,6 +3669,49 @@ out_exit:
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
+static void iwlagn_configure_filter(struct ieee80211_hw *hw,
+				    unsigned int changed_flags,
+				    unsigned int *total_flags,
+				    u64 multicast)
+{
+	struct iwl_priv *priv = hw->priv;
+	__le32 filter_or = 0, filter_nand = 0;
+
+#define CHK(test, flag)	do { \
+	if (*total_flags & (test))		\
+		filter_or |= (flag);		\
+	else					\
+		filter_nand |= (flag);		\
+	} while (0)
+
+	IWL_DEBUG_MAC80211(priv, "Enter: changed: 0x%x, total: 0x%x\n",
+			changed_flags, *total_flags);
+
+	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
+	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK);
+	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
+
+#undef CHK
+
+	mutex_lock(&priv->mutex);
+
+	priv->staging_rxon.filter_flags &= ~filter_nand;
+	priv->staging_rxon.filter_flags |= filter_or;
+
+	iwlcore_commit_rxon(priv);
+
+	mutex_unlock(&priv->mutex);
+
+	/*
+	 * Receiving all multicast frames is always enabled by the
+	 * default flags setup in iwl_connection_init_rx_config()
+	 * since we currently do not support programming multicast
+	 * filters into the device.
+	 */
+	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
+			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
+}
+
 static void iwl_mac_flush(struct ieee80211_hw *hw, bool drop)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -3869,7 +3912,7 @@ static struct ieee80211_ops iwl_hw_ops =
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
 	.config = iwl_mac_config,
-	.configure_filter = iwl_configure_filter,
+	.configure_filter = iwlagn_configure_filter,
 	.set_key = iwl_mac_set_key,
 	.update_tkip_key = iwl_mac_update_tkip_key,
 	.conf_tx = iwl_mac_conf_tx,
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2010-08-17 11:08:18.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2010-08-17 11:10:49.000000000 +0200
@@ -1328,51 +1328,6 @@ out:
 EXPORT_SYMBOL(iwl_apm_init);
 
 
-
-void iwl_configure_filter(struct ieee80211_hw *hw,
-			  unsigned int changed_flags,
-			  unsigned int *total_flags,
-			  u64 multicast)
-{
-	struct iwl_priv *priv = hw->priv;
-	__le32 filter_or = 0, filter_nand = 0;
-
-#define CHK(test, flag)	do { \
-	if (*total_flags & (test))		\
-		filter_or |= (flag);		\
-	else					\
-		filter_nand |= (flag);		\
-	} while (0)
-
-	IWL_DEBUG_MAC80211(priv, "Enter: changed: 0x%x, total: 0x%x\n",
-			changed_flags, *total_flags);
-
-	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
-	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK);
-	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
-
-#undef CHK
-
-	mutex_lock(&priv->mutex);
-
-	priv->staging_rxon.filter_flags &= ~filter_nand;
-	priv->staging_rxon.filter_flags |= filter_or;
-
-	iwlcore_commit_rxon(priv);
-
-	mutex_unlock(&priv->mutex);
-
-	/*
-	 * Receiving all multicast frames is always enabled by the
-	 * default flags setup in iwl_connection_init_rx_config()
-	 * since we currently do not support programming multicast
-	 * filters into the device.
-	 */
-	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
-			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
-}
-EXPORT_SYMBOL(iwl_configure_filter);
-
 int iwl_set_hw_params(struct iwl_priv *priv)
 {
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.h	2010-08-17 11:08:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.h	2010-08-17 11:08:57.000000000 +0200
@@ -372,9 +372,6 @@ int iwl_set_decrypted_flag(struct iwl_pr
 			   u32 decrypt_res,
 			   struct ieee80211_rx_status *stats);
 void iwl_irq_handle_error(struct iwl_priv *priv);
-void iwl_configure_filter(struct ieee80211_hw *hw,
-			  unsigned int changed_flags,
-			  unsigned int *total_flags, u64 multicast);
 int iwl_set_hw_params(struct iwl_priv *priv);
 void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif);
 void iwl_bss_info_changed(struct ieee80211_hw *hw,
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2010-08-17 11:08:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2010-08-17 11:11:30.000000000 +0200
@@ -3396,6 +3396,55 @@ static int iwl3945_mac_sta_add(struct ie
 
 	return 0;
 }
+
+static void iwl3945_configure_filter(struct ieee80211_hw *hw,
+				     unsigned int changed_flags,
+				     unsigned int *total_flags,
+				     u64 multicast)
+{
+	struct iwl_priv *priv = hw->priv;
+	__le32 filter_or = 0, filter_nand = 0;
+
+#define CHK(test, flag)	do { \
+	if (*total_flags & (test))		\
+		filter_or |= (flag);		\
+	else					\
+		filter_nand |= (flag);		\
+	} while (0)
+
+	IWL_DEBUG_MAC80211(priv, "Enter: changed: 0x%x, total: 0x%x\n",
+			changed_flags, *total_flags);
+
+	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
+	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK);
+	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
+
+#undef CHK
+
+	mutex_lock(&priv->mutex);
+
+	priv->staging_rxon.filter_flags &= ~filter_nand;
+	priv->staging_rxon.filter_flags |= filter_or;
+
+	/*
+	 * Committing directly here breaks for some reason,
+	 * but we'll eventually commit the filter flags
+	 * change anyway.
+	 */
+
+	mutex_unlock(&priv->mutex);
+
+	/*
+	 * Receiving all multicast frames is always enabled by the
+	 * default flags setup in iwl_connection_init_rx_config()
+	 * since we currently do not support programming multicast
+	 * filters into the device.
+	 */
+	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
+			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
+}
+
+
 /*****************************************************************************
  *
  * sysfs attributes
@@ -3801,7 +3850,7 @@ static struct ieee80211_ops iwl3945_hw_o
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
 	.config = iwl_mac_config,
-	.configure_filter = iwl_configure_filter,
+	.configure_filter = iwl3945_configure_filter,
 	.set_key = iwl3945_mac_set_key,
 	.conf_tx = iwl_mac_conf_tx,
 	.reset_tsf = iwl_mac_reset_tsf,


