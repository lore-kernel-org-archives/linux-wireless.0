Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab2BQUXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/26] iwlwifi: move firmware_loading_complete to iwl_nic
Date: Fri, 17 Feb 2012 11:13:39 -0800
Message-Id: <1329506034-1394-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212440_801651_7EBA10B5)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

Move firmware_loading_complete from iwl_priv to iwl_nic and rename it
to more accurately reflect what it does.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h   |    2 --
 drivers/net/wireless/iwlwifi/iwl-ucode.c |    4 ++--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9e902f7..12803d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1273,7 +1273,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	iwl_power_initialize(priv);
 	iwl_tt_initialize(priv);
 
-	init_completion(&priv->firmware_loading_complete);
+	init_completion(&nic(priv)->request_firmware_complete);
 
 	err = iwl_request_firmware(priv, true);
 	if (err)
@@ -1296,7 +1296,7 @@ out:
 
 void __devexit iwl_remove(struct iwl_priv * priv)
 {
-	wait_for_completion(&priv->firmware_loading_complete);
+	wait_for_completion(&nic(priv)->request_firmware_complete);
 
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 3321010..0d0b4bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -864,8 +864,6 @@ struct iwl_priv {
 	struct iwl_rx_phy_res last_phy_res;
 	bool last_phy_res_valid;
 
-	struct completion firmware_loading_complete;
-
 	u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
 	u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 0ba8ea9..51a8fb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -1273,7 +1273,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
-	complete(&priv->firmware_loading_complete);
+	complete(&nic->request_firmware_complete);
 	return;
 
  try_again:
@@ -1287,7 +1287,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	IWL_ERR(priv, "failed to allocate pci memory\n");
 	iwl_dealloc_ucode(trans(priv));
  out_unbind:
-	complete(&priv->firmware_loading_complete);
+	complete(&nic->request_firmware_complete);
 	device_release_driver(trans(priv)->dev);
 	release_firmware(ucode_raw);
 }
-- 
1.7.0.4

