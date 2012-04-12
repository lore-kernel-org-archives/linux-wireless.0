Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966032Ab2DLV6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/24] iwlwifi: move channel switch related functions
Date: Thu, 12 Apr 2012 14:54:01 -0700
Message-Id: <1334267661-14654-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235904_438293_A74FFD56)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

With the creation of iwl-agn-devices.c,
iwl-core.c can be cleaned up a bit more by
moving beacon time related functions from
iwl-core.c to iwl-agn-devices.c

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-devices.c |   74 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c        |   73 -----------------------
 drivers/net/wireless/iwlwifi/iwl-core.h        |    4 -
 3 files changed, 74 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c b/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
index bc9cb5c..08718ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
@@ -71,6 +71,80 @@ static void iwl1000_nic_config(struct iwl_priv *priv)
 				~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
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
+/*
+ * extended beacon time format
+ * time in usec will be changed into a 32-bit value in extended:internal format
+ * the extended part is the beacon counts
+ * the internal part is the time in usec within one beacon interval
+ */
+static u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec,
+				u32 beacon_interval)
+{
+	u32 quot;
+	u32 rem;
+	u32 interval = beacon_interval * TIME_UNIT;
+
+	if (!interval || !usec)
+		return 0;
+
+	quot = (usec / interval) &
+		(iwl_beacon_time_mask_high(priv, IWLAGN_EXT_BEACON_TIME_POS) >>
+		IWLAGN_EXT_BEACON_TIME_POS);
+	rem = (usec % interval) & iwl_beacon_time_mask_low(priv,
+				   IWLAGN_EXT_BEACON_TIME_POS);
+
+	return (quot << IWLAGN_EXT_BEACON_TIME_POS) + rem;
+}
+
+/* base is usually what we get from ucode with each received frame,
+ * the same as HW timer counter counting down
+ */
+static __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
+			   u32 addon, u32 beacon_interval)
+{
+	u32 base_low = base & iwl_beacon_time_mask_low(priv,
+				IWLAGN_EXT_BEACON_TIME_POS);
+	u32 addon_low = addon & iwl_beacon_time_mask_low(priv,
+				IWLAGN_EXT_BEACON_TIME_POS);
+	u32 interval = beacon_interval * TIME_UNIT;
+	u32 res = (base & iwl_beacon_time_mask_high(priv,
+				IWLAGN_EXT_BEACON_TIME_POS)) +
+				(addon & iwl_beacon_time_mask_high(priv,
+				IWLAGN_EXT_BEACON_TIME_POS));
+
+	if (base_low > addon_low)
+		res += base_low - addon_low;
+	else if (base_low < addon_low) {
+		res += interval + base_low - addon_low;
+		res += (1 << IWLAGN_EXT_BEACON_TIME_POS);
+	} else
+		res += (1 << IWLAGN_EXT_BEACON_TIME_POS);
+
+	return cpu_to_le32(res);
+}
+
 static const struct iwl_sensitivity_ranges iwl1000_sensitivity = {
 	.min_nrg_cck = 95,
 	.auto_corr_min_ofdm = 90,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 0f86f1c..0fde81d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -783,79 +783,6 @@ int iwl_cmd_echo_test(struct iwl_priv *priv)
 	return ret;
 }
 
-/**
- * iwl_beacon_time_mask_low - mask of lower 32 bit of beacon time
- * @priv -- pointer to iwl_priv data structure
- * @tsf_bits -- number of bits need to shift for masking)
- */
-static inline u32 iwl_beacon_time_mask_low(struct iwl_priv *priv,
-					   u16 tsf_bits)
-{
-	return (1 << tsf_bits) - 1;
-}
-
-/**
- * iwl_beacon_time_mask_high - mask of higher 32 bit of beacon time
- * @priv -- pointer to iwl_priv data structure
- * @tsf_bits -- number of bits need to shift for masking)
- */
-static inline u32 iwl_beacon_time_mask_high(struct iwl_priv *priv,
-					    u16 tsf_bits)
-{
-	return ((1 << (32 - tsf_bits)) - 1) << tsf_bits;
-}
-
-/*
- * extended beacon time format
- * time in usec will be changed into a 32-bit value in extended:internal format
- * the extended part is the beacon counts
- * the internal part is the time in usec within one beacon interval
- */
-u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval)
-{
-	u32 quot;
-	u32 rem;
-	u32 interval = beacon_interval * TIME_UNIT;
-
-	if (!interval || !usec)
-		return 0;
-
-	quot = (usec / interval) &
-		(iwl_beacon_time_mask_high(priv, IWLAGN_EXT_BEACON_TIME_POS) >>
-		IWLAGN_EXT_BEACON_TIME_POS);
-	rem = (usec % interval) & iwl_beacon_time_mask_low(priv,
-				   IWLAGN_EXT_BEACON_TIME_POS);
-
-	return (quot << IWLAGN_EXT_BEACON_TIME_POS) + rem;
-}
-
-/* base is usually what we get from ucode with each received frame,
- * the same as HW timer counter counting down
- */
-__le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
-			   u32 addon, u32 beacon_interval)
-{
-	u32 base_low = base & iwl_beacon_time_mask_low(priv,
-				IWLAGN_EXT_BEACON_TIME_POS);
-	u32 addon_low = addon & iwl_beacon_time_mask_low(priv,
-				IWLAGN_EXT_BEACON_TIME_POS);
-	u32 interval = beacon_interval * TIME_UNIT;
-	u32 res = (base & iwl_beacon_time_mask_high(priv,
-				IWLAGN_EXT_BEACON_TIME_POS)) +
-				(addon & iwl_beacon_time_mask_high(priv,
-				IWLAGN_EXT_BEACON_TIME_POS));
-
-	if (base_low > addon_low)
-		res += base_low - addon_low;
-	else if (base_low < addon_low) {
-		res += interval + base_low - addon_low;
-		res += (1 << IWLAGN_EXT_BEACON_TIME_POS);
-	} else
-		res += (1 << IWLAGN_EXT_BEACON_TIME_POS);
-
-	return cpu_to_le32(res);
-}
-
 void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 96a2f8d..5cbe609 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -176,10 +176,6 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
 
-u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval);
-__le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
-			   u32 addon, u32 beacon_interval);
-
 extern void iwl_send_bt_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv,
 				       u8 flags, bool clear);
-- 
1.7.0.4

