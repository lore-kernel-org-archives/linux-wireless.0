Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62414 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493Ab1D3Qkq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/14] iwlagn: avoid hangs when restarting device
Date: Sat, 30 Apr 2011 09:17:27 -0700
Message-Id: <1304180260-13875-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184052_659192_6CBF610A)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a device error happens while the uCode is
being loaded or initialised, we will attempt
to restart the device (which will likely fail
again, but that's not the issue here). During
this new restart, we turn off the device, but
as the uCode failed to initialise it already
is turned off. As a consequence, grabbing NIC
access will fail and cause excessive messages
and hangs.

To fix this issue, introduce a new status bit
and only attempt to reprogram the device when
it isn't already disabled.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   21 +++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.c    |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 +
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e202a40..75e1035 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2363,12 +2363,21 @@ void iwlagn_stop_device(struct iwl_priv *priv)
 	/* device going down, Stop using ICT table */
 	iwl_disable_ict(priv);
 
-	iwlagn_txq_ctx_stop(priv);
-	iwlagn_rxq_stop(priv);
-
-	/* Power-down device's busmaster DMA clocks */
-	iwl_write_prph(priv, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
-	udelay(5);
+	/*
+	 * If a HW restart happens during firmware loading,
+	 * then the firmware loading might call this function
+	 * and later it might be called again due to the
+	 * restart. So don't process again if the device is
+	 * already dead.
+	 */
+	if (test_bit(STATUS_DEVICE_ENABLED, &priv->status)) {
+                iwlagn_txq_ctx_stop(priv);
+                iwlagn_rxq_stop(priv);
+
+                /* Power-down device's busmaster DMA clocks */
+                iwl_write_prph(priv, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
+                udelay(5);
+        }
 
 	/* Make sure (redundant) we've released our request to stay awake */
 	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index af72fd5..66da1de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -995,6 +995,8 @@ void iwl_apm_stop(struct iwl_priv *priv)
 {
 	IWL_DEBUG_INFO(priv, "Stop card, put in low power state\n");
 
+	clear_bit(STATUS_DEVICE_ENABLED, &priv->status);
+
 	/* Stop device's DMA activity */
 	iwl_apm_stop_master(priv);
 
@@ -1109,6 +1111,8 @@ int iwl_apm_init(struct iwl_priv *priv)
 	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
+	set_bit(STATUS_DEVICE_ENABLED, &priv->status);
+
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 32a990f..6226e3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -592,6 +592,7 @@ void iwlcore_free_geos(struct iwl_priv *priv);
 #define STATUS_SCAN_HW		15
 #define STATUS_POWER_PMI	16
 #define STATUS_FW_ERROR		17
+#define STATUS_DEVICE_ENABLED	18
 
 
 static inline int iwl_is_ready(struct iwl_priv *priv)
-- 
1.7.0.4

