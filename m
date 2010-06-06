Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab0FFG4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/23] iwlwifi: beacon format related helper function
Date: Sat,  5 Jun 2010 23:56:24 -0700
Message-Id: <1275807398-18184-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Move the ucode beacon formation related helper function from 3945 to
iwlcore, so both _3945 and _agn devices can utilize those functions.

When driver pass the beacon related timing information to uCode in both
spectrum measurement and channel switch commands, the beacon timing
parameter require in uCode beacon format; those helper functions will do
the conversation from uSec to the correct uCode format

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    4 ++
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 ++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   55 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   16 ++++++++
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |   22 ++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   56 +-------------------------
 10 files changed, 113 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 6be2992..dba91e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -158,6 +158,8 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 			BIT(IWL_CALIB_TX_IQ_PERD)	|
 			BIT(IWL_CALIB_BASE_BAND);
 
+	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7a34ef6..295b67a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2433,6 +2433,7 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.rx_wrt_ptr_reg = FH39_RSCSR_CHNL0_WPTR;
 	priv->hw_params.max_beacon_itrvl = IWL39_MAX_UCODE_BEACON_INTERVAL;
+	priv->hw_params.beacon_time_tsf_bits = IWL3945_EXT_BEACON_TIME_POS;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a0669ea..fe7aa73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -672,6 +672,7 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
 
 	priv->hw_params.sens = &iwl4965_sensitivity;
+	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a28af7e..c320d41 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -208,6 +208,8 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 		BIT(IWL_CALIB_TX_IQ_PERD)	|
 		BIT(IWL_CALIB_BASE_BAND);
 
+	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
+
 	return 0;
 }
 
@@ -252,6 +254,8 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 		BIT(IWL_CALIB_TX_IQ)		|
 		BIT(IWL_CALIB_BASE_BAND);
 
+	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 73713f6..5f6dbd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -187,6 +187,8 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 		BIT(IWL_CALIB_TX_IQ)		|
 		BIT(IWL_CALIB_BASE_BAND);
 
+	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
+
 	return 0;
 }
 
@@ -232,6 +234,8 @@ static int iwl6050_hw_set_hw_params(struct iwl_priv *priv)
 		BIT(IWL_CALIB_TX_IQ)		|
 		BIT(IWL_CALIB_BASE_BAND);
 
+	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 245cb90..b05b813 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2710,6 +2710,61 @@ void iwl_bg_monitor_recover(unsigned long data)
 }
 EXPORT_SYMBOL(iwl_bg_monitor_recover);
 
+
+/*
+ * extended beacon time format
+ * time in usec will be changed into a 32-bit value in extended:internal format
+ * the extended part is the beacon counts
+ * the internal part is the time in usec within one beacon interval
+ */
+u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval)
+{
+	u32 quot;
+	u32 rem;
+	u32 interval = beacon_interval * TIME_UNIT;
+
+	if (!interval || !usec)
+		return 0;
+
+	quot = (usec / interval) &
+		(iwl_beacon_time_mask_high(priv,
+		priv->hw_params.beacon_time_tsf_bits) >>
+		priv->hw_params.beacon_time_tsf_bits);
+	rem = (usec % interval) & iwl_beacon_time_mask_low(priv,
+				   priv->hw_params.beacon_time_tsf_bits);
+
+	return (quot << priv->hw_params.beacon_time_tsf_bits) + rem;
+}
+EXPORT_SYMBOL(iwl_usecs_to_beacons);
+
+/* base is usually what we get from ucode with each received frame,
+ * the same as HW timer counter counting down
+ */
+__le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
+			   u32 addon, u32 beacon_interval)
+{
+	u32 base_low = base & iwl_beacon_time_mask_low(priv,
+					priv->hw_params.beacon_time_tsf_bits);
+	u32 addon_low = addon & iwl_beacon_time_mask_low(priv,
+					priv->hw_params.beacon_time_tsf_bits);
+	u32 interval = beacon_interval * TIME_UNIT;
+	u32 res = (base & iwl_beacon_time_mask_high(priv,
+				priv->hw_params.beacon_time_tsf_bits)) +
+				(addon & iwl_beacon_time_mask_high(priv,
+				priv->hw_params.beacon_time_tsf_bits));
+
+	if (base_low > addon_low)
+		res += base_low - addon_low;
+	else if (base_low < addon_low) {
+		res += interval + base_low - addon_low;
+		res += (1 << priv->hw_params.beacon_time_tsf_bits);
+	} else
+		res += (1 << priv->hw_params.beacon_time_tsf_bits);
+
+	return cpu_to_le32(res);
+}
+EXPORT_SYMBOL(iwl_add_beacon_time);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 69738f1..48d96fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -79,6 +79,8 @@ struct iwl_cmd;
 	.subvendor = PCI_ANY_ID, .subdevice = (subdev), \
 	.driver_data = (kernel_ulong_t)&(cfg)
 
+#define TIME_UNIT		1024
+
 #define IWL_SKU_G       0x1
 #define IWL_SKU_A       0x2
 #define IWL_SKU_N       0x8
@@ -591,6 +593,9 @@ static inline u16 iwl_pcie_link_ctl(struct iwl_priv *priv)
 }
 
 void iwl_bg_monitor_recover(unsigned long data);
+u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval);
+__le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
+			   u32 addon, u32 beacon_interval);
 
 #ifdef CONFIG_PM
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8b7731a..6663df2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -662,6 +662,7 @@ struct iwl_sensitivity_ranges {
  * @sw_crypto: 0 for hw, 1 for sw
  * @max_xxx_size: for ucode uses
  * @ct_kill_threshold: temperature threshold
+ * @beacon_time_tsf_bits: number of valid tsf bits for beacon time
  * @calib_init_cfg: setup initial calibrations for the hw
  * @struct iwl_sensitivity_ranges: range of sensitivity values
  */
@@ -688,6 +689,7 @@ struct iwl_hw_params {
 	u32 ct_kill_threshold; /* value in hw-dependent units */
 	u32 ct_kill_exit_threshold; /* value in hw-dependent units */
 				    /* for 1000, 6000 series and up */
+	u16 beacon_time_tsf_bits;
 	u32 calib_init_cfg;
 	const struct iwl_sensitivity_ranges *sens;
 };
@@ -1062,6 +1064,20 @@ struct iwl_force_reset {
 	unsigned long last_force_reset_jiffies;
 };
 
+/* extend beacon time format bit shifting  */
+/*
+ * for _3945 devices
+ * bits 31:24 - extended
+ * bits 23:0  - interval
+ */
+#define IWL3945_EXT_BEACON_TIME_POS	24
+/*
+ * for _agn devices
+ * bits 31:22 - extended
+ * bits 21:0  - interval
+ */
+#define IWLAGN_EXT_BEACON_TIME_POS	22
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 6984639..621abe3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -175,4 +175,26 @@ static inline void iwl_enable_interrupts(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_INT_MASK, priv->inta_mask);
 }
 
+/**
+ * iwl_beacon_time_mask_low - mask of lower 32 bit of beacon time
+ * @priv -- pointer to iwl_priv data structure
+ * @tsf_bits -- number of bits need to shift for masking)
+ */
+static inline u32 iwl_beacon_time_mask_low(struct iwl_priv *priv,
+					   u16 tsf_bits)
+{
+	return (1 << tsf_bits) - 1;
+}
+
+/**
+ * iwl_beacon_time_mask_high - mask of higher 32 bit of beacon time
+ * @priv -- pointer to iwl_priv data structure
+ * @tsf_bits -- number of bits need to shift for masking)
+ */
+static inline u32 iwl_beacon_time_mask_high(struct iwl_priv *priv,
+					    u16 tsf_bits)
+{
+	return ((1 << (32 - tsf_bits)) - 1) << tsf_bits;
+}
+
 #endif				/* __iwl_helpers_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f2ec752..eeeb6e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -665,55 +665,6 @@ drop:
 	return -1;
 }
 
-#define BEACON_TIME_MASK_LOW	0x00FFFFFF
-#define BEACON_TIME_MASK_HIGH	0xFF000000
-#define TIME_UNIT		1024
-
-/*
- * extended beacon time format
- * time in usec will be changed into a 32-bit value in 8:24 format
- * the high 1 byte is the beacon counts
- * the lower 3 bytes is the time in usec within one beacon interval
- */
-
-static u32 iwl3945_usecs_to_beacons(u32 usec, u32 beacon_interval)
-{
-	u32 quot;
-	u32 rem;
-	u32 interval = beacon_interval * 1024;
-
-	if (!interval || !usec)
-		return 0;
-
-	quot = (usec / interval) & (BEACON_TIME_MASK_HIGH >> 24);
-	rem = (usec % interval) & BEACON_TIME_MASK_LOW;
-
-	return (quot << 24) + rem;
-}
-
-/* base is usually what we get from ucode with each received frame,
- * the same as HW timer counter counting down
- */
-
-static __le32 iwl3945_add_beacon_time(u32 base, u32 addon, u32 beacon_interval)
-{
-	u32 base_low = base & BEACON_TIME_MASK_LOW;
-	u32 addon_low = addon & BEACON_TIME_MASK_LOW;
-	u32 interval = beacon_interval * TIME_UNIT;
-	u32 res = (base & BEACON_TIME_MASK_HIGH) +
-	    (addon & BEACON_TIME_MASK_HIGH);
-
-	if (base_low > addon_low)
-		res += base_low - addon_low;
-	else if (base_low < addon_low) {
-		res += interval + base_low - addon_low;
-		res += (1 << 24);
-	} else
-		res += (1 << 24);
-
-	return cpu_to_le32(res);
-}
-
 static int iwl3945_get_measurement(struct iwl_priv *priv,
 			       struct ieee80211_measurement_params *params,
 			       u8 type)
@@ -731,8 +682,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 	int duration = le16_to_cpu(params->duration);
 
 	if (iwl_is_associated(priv))
-		add_time =
-		    iwl3945_usecs_to_beacons(
+		add_time = iwl_usecs_to_beacons(priv,
 			le64_to_cpu(params->start_time) - priv->_3945.last_tsf,
 			le16_to_cpu(priv->rxon_timing.beacon_interval));
 
@@ -747,8 +697,8 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 
 	if (iwl_is_associated(priv))
 		spectrum.start_time =
-		    iwl3945_add_beacon_time(priv->_3945.last_beacon_time,
-				add_time,
+			iwl_add_beacon_time(priv,
+				priv->_3945.last_beacon_time, add_time,
 				le16_to_cpu(priv->rxon_timing.beacon_interval));
 	else
 		spectrum.start_time = 0;
-- 
1.7.0.4

