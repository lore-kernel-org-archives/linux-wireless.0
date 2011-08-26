Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2067 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab1HZGx0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/60] iwlagn: introduce iwl-shared.h
Date: Thu, 25 Aug 2011 23:10:36 -0700
Message-Id: <1314339092-20797-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085518_220601_90F054A5)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It will hold declaration of functions and forward declaration of struct that
are used by several layers.
This will allow modules not to include iwl_priv. iwl_bus and iwl_trans are
still visible to all.

All the layers share the module parameters, move the struct to iwl-shared.h.
Also add all module parameters to iwl_mod_params instead of having them as
global static. This includes

* debug_level
* ant_coupling
* bt_ch_announce
* wanted_ucode_alternative

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-2000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    3 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   32 +++++----
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 -
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   24 -------
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-led.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-pci.c      |    5 +-
 drivers/net/wireless/iwlwifi/iwl-power.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-shared.h   |  100 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.c    |    1 +
 18 files changed, 140 insertions(+), 48 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-shared.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index ccdbed5..4314c61 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -43,6 +43,7 @@
 #include "iwl-agn.h"
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
+#include "iwl-shared.h"
 
 /* Highest firmware API version supported */
 #define IWL1000_UCODE_API_MAX 6
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 3e1cdd3..e623870 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -44,6 +44,7 @@
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-6000-hw.h"
+#include "iwl-shared.h"
 
 /* Highest firmware API version supported */
 #define IWL2030_UCODE_API_MAX 6
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a9adee5..c79f1f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -46,6 +46,7 @@
 #include "iwl-agn-hw.h"
 #include "iwl-5000-hw.h"
 #include "iwl-trans.h"
+#include "iwl-shared.h"
 
 /* Highest firmware API version supported */
 #define IWL5000_UCODE_API_MAX 5
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 850f924..bf84fa6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -45,6 +45,7 @@
 #include "iwl-agn-hw.h"
 #include "iwl-6000-hw.h"
 #include "iwl-trans.h"
+#include "iwl-shared.h"
 
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 4
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 4edb6cf..dd95f47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -40,6 +40,7 @@
 #include "iwl-agn.h"
 #include "iwl-sta.h"
 #include "iwl-trans.h"
+#include "iwl-shared.h"
 
 static inline u32 iwlagn_get_scd_ssn(struct iwlagn_tx_resp *tx_resp)
 {
@@ -609,6 +610,8 @@ struct iwl_mod_params iwlagn_mod_params = {
 	.bt_coex_active = true,
 	.no_sleep_autoadjust = true,
 	.power_level = IWL_POWER_INDEX_1,
+	.bt_ch_announce = 1,
+	.wanted_ucode_alternative = 1,
 	/* the rest are 0 by default */
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index d562e93..2829bf8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -31,6 +31,7 @@
 #include "iwl-agn-calib.h"
 #include "iwl-helpers.h"
 #include "iwl-trans.h"
+#include "iwl-shared.h"
 
 static int iwlagn_disable_bss(struct iwl_priv *priv,
 			      struct iwl_rxon_context *ctx,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7f50d9d..cb8a9f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -51,6 +51,7 @@
 #include "iwl-sta.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
+#include "iwl-shared.h"
 #include "iwl-bus.h"
 #include "iwl-trans.h"
 
@@ -79,9 +80,6 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
-static int iwlagn_ant_coupling;
-static bool iwlagn_bt_ch_announce = 1;
-
 void iwl_update_chain_flags(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx;
@@ -818,8 +816,6 @@ static int iwlagn_load_legacy_firmware(struct iwl_priv *priv,
 	return 0;
 }
 
-static int iwlagn_wanted_ucode_alternative = 1;
-
 static int iwlagn_load_firmware(struct iwl_priv *priv,
 				const struct firmware *ucode_raw,
 				struct iwlagn_firmware_pieces *pieces,
@@ -829,7 +825,8 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 	struct iwl_ucode_tlv *tlv;
 	size_t len = ucode_raw->size;
 	const u8 *data;
-	int wanted_alternative = iwlagn_wanted_ucode_alternative, tmp;
+	int wanted_alternative = iwlagn_mod_params.wanted_ucode_alternative;
+	int tmp;
 	u64 alternatives;
 	u32 tlv_len;
 	enum iwl_ucode_tlv_type tlv_type;
@@ -1619,7 +1616,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	}
 
 	/* enable/disable bt channel inhibition */
-	priv->bt_ch_announce = iwlagn_bt_ch_announce;
+	priv->bt_ch_announce = iwlagn_mod_params.bt_ch_announce;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (!(iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) && !full_log)
@@ -3618,11 +3615,12 @@ int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg)
 
 	/* is antenna coupling more than 35dB ? */
 	priv->bt_ant_couple_ok =
-		(iwlagn_ant_coupling > IWL_BT_ANTENNA_COUPLING_THRESHOLD) ?
-		true : false;
+		(iwlagn_mod_params.ant_coupling >
+			IWL_BT_ANTENNA_COUPLING_THRESHOLD) ?
+			true : false;
 
 	/* enable/disable bt channel inhibition */
-	priv->bt_ch_announce = iwlagn_bt_ch_announce;
+	priv->bt_ch_announce = iwlagn_mod_params.bt_ch_announce;
 	IWL_DEBUG_INFO(priv, "BT channel inhibition is %s\n",
 		       (priv->bt_ch_announce) ? "On" : "Off");
 
@@ -3863,7 +3861,8 @@ module_exit(iwl_exit);
 module_init(iwl_init);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-module_param_named(debug, iwl_debug_level, uint, S_IRUGO | S_IWUSR);
+module_param_named(debug, iwlagn_mod_params.debug_level, uint,
+		   S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 
@@ -3879,16 +3878,19 @@ MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
 module_param_named(fw_restart, iwlagn_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
 
-module_param_named(ucode_alternative, iwlagn_wanted_ucode_alternative, int,
-		   S_IRUGO);
+module_param_named(ucode_alternative,
+		   iwlagn_mod_params.wanted_ucode_alternative,
+		   int, S_IRUGO);
 MODULE_PARM_DESC(ucode_alternative,
 		 "specify ucode alternative to use from ucode file");
 
-module_param_named(antenna_coupling, iwlagn_ant_coupling, int, S_IRUGO);
+module_param_named(antenna_coupling, iwlagn_mod_params.ant_coupling,
+		   int, S_IRUGO);
 MODULE_PARM_DESC(antenna_coupling,
 		 "specify antenna coupling in dB (defualt: 0 dB)");
 
-module_param_named(bt_ch_inhibition, iwlagn_bt_ch_announce, bool, S_IRUGO);
+module_param_named(bt_ch_inhibition, iwlagn_mod_params.bt_ch_announce,
+		   bool, S_IRUGO);
 MODULE_PARM_DESC(bt_ch_inhibition,
 		 "Disable BT channel inhibition (default: enable)");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index a2f2f28..ea2a5fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -108,8 +108,6 @@ extern struct iwl_cfg iwl105_bgn_cfg;
 extern struct iwl_cfg iwl135_bg_cfg;
 extern struct iwl_cfg iwl135_bgn_cfg;
 
-extern struct iwl_mod_params iwlagn_mod_params;
-
 extern struct ieee80211_ops iwlagn_hw_ops;
 
 int iwl_reset_ict(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0d8fd5b..6c11f0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -42,11 +42,10 @@
 #include "iwl-sta.h"
 #include "iwl-agn.h"
 #include "iwl-helpers.h"
+#include "iwl-shared.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
 
-u32 iwl_debug_level;
-
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 #define MAX_BIT_RATE_40_MHZ 150 /* Mbps */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2c8b4a5..fe46d0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -101,23 +101,6 @@ struct iwl_lib_ops {
 	void (*temperature)(struct iwl_priv *priv);
 };
 
-struct iwl_mod_params {
-	int sw_crypto;		/* def: 0 = using hardware encryption */
-	int num_of_queues;	/* def: HW dependent */
-	int disable_11n;	/* def: 0 = 11n capabilities enabled */
-	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
-	int antenna;  		/* def: 0 = both antennas (use diversity) */
-	int restart_fw;		/* def: 1 = restart firmware */
-	bool plcp_check;	/* def: true = enable plcp health check */
-	bool ack_check;		/* def: false = disable ack health check */
-	bool wd_disable;	/* def: false = enable stuck queue check */
-	bool bt_coex_active;	/* def: true = enable bt coex */
-	int led_mode;		/* def: 0 = system default */
-	bool no_sleep_autoadjust; /* def: true = disable autoadjust */
-	bool power_save;	/* def: false = disable power save */
-	int power_level;	/* def: 1 = power level */
-};
-
 /*
  * @max_ll_items: max number of OTP blocks
  * @shadow_ram_support: shadow support for OTP memory
@@ -389,13 +372,6 @@ u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval);
 __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 			   u32 addon, u32 beacon_interval);
 
-#ifdef CONFIG_PM
-int iwl_suspend(struct iwl_priv *priv);
-int iwl_resume(struct iwl_priv *priv);
-#endif /* !CONFIG_PM */
-
-int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg);
-void __devexit iwl_remove(struct iwl_priv * priv);
 
 /*****************************************************
 *  Error Handling Debugging
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index f9a407e..0869eaa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -30,7 +30,6 @@
 #define __iwl_debug_h__
 
 struct iwl_priv;
-extern u32 iwl_debug_level;
 
 #define IWL_ERR(p, f, a...) dev_err(p->bus->dev, f, ## a)
 #define IWL_WARN(p, f, a...) dev_warn(p->bus->dev, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index dd34c7c..d0e65c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -50,6 +50,7 @@
 #include "iwl-agn-tt.h"
 #include "iwl-bus.h"
 #include "iwl-trans.h"
+#include "iwl-shared.h"
 
 #define DRV_NAME        "iwlagn"
 
@@ -1513,7 +1514,7 @@ struct iwl_priv {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	/* debugging info */
 	u32 debug_level; /* per device debugging will override global
-			    iwl_debug_level if set */
+			    iwlagn_mod_params.debug_level if set */
 #endif /* CONFIG_IWLWIFI_DEBUG */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	/* debugfs */
@@ -1562,6 +1563,8 @@ static inline void iwl_txq_ctx_deactivate(struct iwl_priv *priv, int txq_id)
 	clear_bit(txq_id, &priv->txq_ctx_active_msk);
 }
 
+extern struct iwl_mod_params iwlagn_mod_params;
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 /*
  * iwl_get_debug_level: Return active debug level for device
@@ -1575,12 +1578,12 @@ static inline u32 iwl_get_debug_level(struct iwl_priv *priv)
 	if (priv->debug_level)
 		return priv->debug_level;
 	else
-		return iwl_debug_level;
+		return iwlagn_mod_params.debug_level;
 }
 #else
 static inline u32 iwl_get_debug_level(struct iwl_priv *priv)
 {
-	return iwl_debug_level;
+	return iwlagn_mod_params.debug_level;
 }
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 1a5252d..d8049fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -40,6 +40,7 @@
 #include "iwl-agn.h"
 #include "iwl-io.h"
 #include "iwl-trans.h"
+#include "iwl-shared.h"
 
 /* Throughput		OFF time(ms)	ON time (ms)
  *	>300			25		25
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 69d4ec4..a2441dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -64,8 +64,11 @@
 #include <linux/pci-aspm.h>
 
 #include "iwl-bus.h"
+#include "iwl-shared.h"
 #include "iwl-agn.h"
-#include "iwl-core.h"
+
+/* TODO: iwl_set_bit and friends should be implemented in bus layer
+ * this would allow us not to include iwl-io.h here */
 #include "iwl-io.h"
 
 /* PCI registers */
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index cd64df0..b60e692 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -43,6 +43,7 @@
 #include "iwl-debug.h"
 #include "iwl-power.h"
 #include "iwl-trans.h"
+#include "iwl-shared.h"
 
 /*
  * Setting power level allows the card to go to sleep when not busy.
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 8e31400..8b3a089 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -40,6 +40,7 @@
 #include "iwl-helpers.h"
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
+#include "iwl-shared.h"
 
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
new file mode 100644
index 0000000..5d48d05
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -0,0 +1,100 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#ifndef __iwl_shared_h__
+#define __iwl_shared_h__
+
+struct iwl_cfg;
+struct iwl_priv;
+
+extern struct iwl_mod_params iwlagn_mod_params;
+
+struct iwl_mod_params {
+	int sw_crypto;		/* def: 0 = using hardware encryption */
+	int num_of_queues;	/* def: HW dependent */
+	int disable_11n;	/* def: 0 = 11n capabilities enabled */
+	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
+	int antenna;		/* def: 0 = both antennas (use diversity) */
+	int restart_fw;		/* def: 1 = restart firmware */
+	bool plcp_check;	/* def: true = enable plcp health check */
+	bool ack_check;		/* def: false = disable ack health check */
+	bool wd_disable;	/* def: false = enable stuck queue check */
+	bool bt_coex_active;	/* def: true = enable bt coex */
+	int led_mode;		/* def: 0 = system default */
+	bool no_sleep_autoadjust; /* def: true = disable autoadjust */
+	bool power_save;	/* def: false = disable power save */
+	int power_level;	/* def: 1 = power level */
+	u32 debug_level;	/* levels are IWL_DL_* */
+	int ant_coupling;
+	bool bt_ch_announce;
+	int wanted_ucode_alternative;
+};
+
+#ifdef CONFIG_PM
+int iwl_suspend(struct iwl_priv *priv);
+int iwl_resume(struct iwl_priv *priv);
+#endif /* !CONFIG_PM */
+
+int iwl_probe(struct iwl_bus *bus, struct iwl_cfg *cfg);
+void __devexit iwl_remove(struct iwl_priv * priv);
+
+#endif /* #__iwl_shared_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 3001bfb..e4a70fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -68,6 +68,7 @@
 /*TODO remove uneeded includes when the transport layer tx_free will be here */
 #include "iwl-agn.h"
 #include "iwl-core.h"
+#include "iwl-shared.h"
 
 static int iwl_trans_rx_alloc(struct iwl_priv *priv)
 {
-- 
1.7.0.4

