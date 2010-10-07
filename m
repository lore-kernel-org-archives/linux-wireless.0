Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59931 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab0JGXIx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/22] iwlagn: fix default calibration table size
Date: Thu,  7 Oct 2010 16:08:00 -0700
Message-Id: <1286492881-15743-22-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

iwlagn driver uses the IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE
as the chain noise reset calibration index and
IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE+1 as the chain noise gain
calibration index, if not specified by the TLV value in the new
firmware format.

However, this is broken if we need to add more calibrations like
the temperature offset calibration because we increased
IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE by 1.

To fix this issue, define IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE
and use it as the calibration index instead. We still keep the
IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE as a sanity check for
the TLV value given by ucode.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1b682dd..c4fe3f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2062,7 +2062,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	struct iwlagn_ucode_capabilities ucode_capa = {
 		.max_probe_length = 200,
 		.standard_phy_calibration_size =
-			IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE,
+			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE,
 	};
 
 	memset(&pieces, 0, sizeof(pieces));
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index fe65256..74b78d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3784,7 +3784,8 @@ struct iwl_enhance_sensitivity_cmd {
  */
 
 /* Phy calibration command for series */
-
+/* The default calibrate table size if not specified by firmware */
+#define IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE	18
 enum {
 	IWL_PHY_CALIBRATE_DIFF_GAIN_CMD		= 7,
 	IWL_PHY_CALIBRATE_DC_CMD		= 8,
-- 
1.7.0.4

