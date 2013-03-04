Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41869 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab3CDOA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:00:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dor Shaish <dor.shaish@intel.com>
Subject: [PATCH 08/11] iwlwifi: mvm: Remove overriding calibrations for the 7000 family
Date: Mon,  4 Mar 2013 15:00:48 +0100
Message-Id: <1362405651-26456-8-git-send-email-johannes@sipsolutions.net> (sfid-20130304_150104_875479_AC085E95)
In-Reply-To: <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
References: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
 <1362405651-26456-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dor Shaish <dor.shaish@intel.com>

This fix removes the override of calibration request values sent
to the FW.
Due to that, the sending of default values to now implemented
calibrations is removed.

Signed-off-by: Dor Shaish <dor.shaish@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c | 114 ----------------------------------
 1 file changed, 114 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index d3c067e..500f818 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -79,17 +79,8 @@
 #define UCODE_VALID_OK	cpu_to_le32(0x1)
 
 /* Default calibration values for WkP - set to INIT image w/o running */
-static const u8 wkp_calib_values_bb_filter[] = { 0xbf, 0x00, 0x5f, 0x00, 0x2f,
-						 0x00, 0x18, 0x00 };
-static const u8 wkp_calib_values_rx_dc[] = { 0x7f, 0x7f, 0x7f, 0x7f, 0x7f,
-					     0x7f, 0x7f, 0x7f };
-static const u8 wkp_calib_values_tx_lo[] = { 0x00, 0x00, 0x00, 0x00 };
-static const u8 wkp_calib_values_tx_iq[] = { 0xff, 0x00, 0xff, 0x00, 0x00,
-					     0x00 };
-static const u8 wkp_calib_values_rx_iq[] = { 0xff, 0x00, 0x00, 0x00 };
 static const u8 wkp_calib_values_rx_iq_skew[] = { 0x00, 0x00, 0x01, 0x00 };
 static const u8 wkp_calib_values_tx_iq_skew[] = { 0x01, 0x00, 0x00, 0x00 };
-static const u8 wkp_calib_values_xtal[] = { 0xd2, 0xd2 };
 
 struct iwl_calib_default_data {
 	u16 size;
@@ -99,12 +90,7 @@ struct iwl_calib_default_data {
 #define CALIB_SIZE_N_DATA(_buf) {.size = sizeof(_buf), .data = &_buf}
 
 static const struct iwl_calib_default_data wkp_calib_default_data[12] = {
-	[5] = CALIB_SIZE_N_DATA(wkp_calib_values_rx_dc),
-	[6] = CALIB_SIZE_N_DATA(wkp_calib_values_bb_filter),
-	[7] = CALIB_SIZE_N_DATA(wkp_calib_values_tx_lo),
-	[8] = CALIB_SIZE_N_DATA(wkp_calib_values_tx_iq),
 	[9] = CALIB_SIZE_N_DATA(wkp_calib_values_tx_iq_skew),
-	[10] = CALIB_SIZE_N_DATA(wkp_calib_values_rx_iq),
 	[11] = CALIB_SIZE_N_DATA(wkp_calib_values_rx_iq_skew),
 };
 
@@ -261,103 +247,6 @@ static int iwl_send_phy_cfg_cmd(struct iwl_mvm *mvm)
 				    sizeof(phy_cfg_cmd), &phy_cfg_cmd);
 }
 
-/* Starting with the new PHY DB implementation - New calibs are enabled */
-/* Value - 0x405e7 */
-#define IWL_CALIB_DEFAULT_FLOW_INIT	(IWL_CALIB_CFG_XTAL_IDX		|\
-					 IWL_CALIB_CFG_TEMPERATURE_IDX	|\
-					 IWL_CALIB_CFG_VOLTAGE_READ_IDX	|\
-					 IWL_CALIB_CFG_DC_IDX		|\
-					 IWL_CALIB_CFG_BB_FILTER_IDX	|\
-					 IWL_CALIB_CFG_LO_LEAKAGE_IDX	|\
-					 IWL_CALIB_CFG_TX_IQ_IDX	|\
-					 IWL_CALIB_CFG_RX_IQ_IDX	|\
-					 IWL_CALIB_CFG_AGC_IDX)
-
-#define IWL_CALIB_DEFAULT_EVENT_INIT	0x0
-
-/* Value 0x41567 */
-#define IWL_CALIB_DEFAULT_FLOW_RUN	(IWL_CALIB_CFG_XTAL_IDX		|\
-					 IWL_CALIB_CFG_TEMPERATURE_IDX	|\
-					 IWL_CALIB_CFG_VOLTAGE_READ_IDX	|\
-					 IWL_CALIB_CFG_BB_FILTER_IDX	|\
-					 IWL_CALIB_CFG_DC_IDX		|\
-					 IWL_CALIB_CFG_TX_IQ_IDX	|\
-					 IWL_CALIB_CFG_RX_IQ_IDX	|\
-					 IWL_CALIB_CFG_SENSITIVITY_IDX	|\
-					 IWL_CALIB_CFG_AGC_IDX)
-
-#define IWL_CALIB_DEFAULT_EVENT_RUN	(IWL_CALIB_CFG_XTAL_IDX		|\
-					 IWL_CALIB_CFG_TEMPERATURE_IDX	|\
-					 IWL_CALIB_CFG_VOLTAGE_READ_IDX	|\
-					 IWL_CALIB_CFG_TX_PWR_IDX	|\
-					 IWL_CALIB_CFG_DC_IDX		|\
-					 IWL_CALIB_CFG_TX_IQ_IDX	|\
-					 IWL_CALIB_CFG_SENSITIVITY_IDX)
-
-/*
- * Sets the calibrations trigger values that will be sent to the FW for runtime
- * and init calibrations.
- * The ones given in the FW TLV are not correct.
- */
-static void iwl_set_default_calib_trigger(struct iwl_mvm *mvm)
-{
-	struct iwl_tlv_calib_ctrl default_calib;
-
-	/*
-	 * WkP FW TLV calib bits are wrong, overwrite them.
-	 * This defines the dynamic calibrations which are implemented in the
-	 * uCode both for init(flow) calculation and event driven calibs.
-	 */
-
-	/* Init Image */
-	default_calib.event_trigger = cpu_to_le32(IWL_CALIB_DEFAULT_EVENT_INIT);
-	default_calib.flow_trigger = cpu_to_le32(IWL_CALIB_DEFAULT_FLOW_INIT);
-
-	if (default_calib.event_trigger !=
-	    mvm->fw->default_calib[IWL_UCODE_INIT].event_trigger)
-		IWL_ERR(mvm,
-			"Updating the event calib for INIT image: 0x%x -> 0x%x\n",
-			mvm->fw->default_calib[IWL_UCODE_INIT].event_trigger,
-			default_calib.event_trigger);
-	if (default_calib.flow_trigger !=
-	    mvm->fw->default_calib[IWL_UCODE_INIT].flow_trigger)
-		IWL_ERR(mvm,
-			"Updating the flow calib for INIT image: 0x%x -> 0x%x\n",
-			mvm->fw->default_calib[IWL_UCODE_INIT].flow_trigger,
-			default_calib.flow_trigger);
-
-	memcpy((void *)&mvm->fw->default_calib[IWL_UCODE_INIT],
-	       &default_calib, sizeof(struct iwl_tlv_calib_ctrl));
-	IWL_ERR(mvm,
-		"Setting uCode init calibrations event 0x%x, trigger 0x%x\n",
-		default_calib.event_trigger,
-		default_calib.flow_trigger);
-
-	/* Run time image */
-	default_calib.event_trigger = cpu_to_le32(IWL_CALIB_DEFAULT_EVENT_RUN);
-	default_calib.flow_trigger = cpu_to_le32(IWL_CALIB_DEFAULT_FLOW_RUN);
-
-	if (default_calib.event_trigger !=
-	    mvm->fw->default_calib[IWL_UCODE_REGULAR].event_trigger)
-		IWL_ERR(mvm,
-			"Updating the event calib for RT image: 0x%x -> 0x%x\n",
-			mvm->fw->default_calib[IWL_UCODE_REGULAR].event_trigger,
-			default_calib.event_trigger);
-	if (default_calib.flow_trigger !=
-	    mvm->fw->default_calib[IWL_UCODE_REGULAR].flow_trigger)
-		IWL_ERR(mvm,
-			"Updating the flow calib for RT image: 0x%x -> 0x%x\n",
-			mvm->fw->default_calib[IWL_UCODE_REGULAR].flow_trigger,
-			default_calib.flow_trigger);
-
-	memcpy((void *)&mvm->fw->default_calib[IWL_UCODE_REGULAR],
-	       &default_calib, sizeof(struct iwl_tlv_calib_ctrl));
-	IWL_ERR(mvm,
-		"Setting uCode runtime calibs event 0x%x, trigger 0x%x\n",
-		default_calib.event_trigger,
-		default_calib.flow_trigger);
-}
-
 static int iwl_set_default_calibrations(struct iwl_mvm *mvm)
 {
 	u8 cmd_raw[16]; /* holds the variable size commands */
@@ -437,9 +326,6 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	if (ret)
 		goto error;
 
-	/* Override the calibrations from TLV and the const of fw */
-	iwl_set_default_calib_trigger(mvm);
-
 	/* WkP doesn't have all calibrations, need to set default values */
 	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
 		ret = iwl_set_default_calibrations(mvm);
-- 
1.8.0

