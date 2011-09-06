Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26702 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1IFRPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 13:15:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/10] iwlagn: only perform necessary calibration at init time
Date: Tue,  6 Sep 2011 09:31:16 -0700
Message-Id: <1315326685-22213-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110906_191512_470132_5E562310)
In-Reply-To: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During init time, only the necessary calibration should be performed. This
not only save time, also avoid uCode crash because lack of necessary information.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index cb06196..82bfef4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3213,12 +3213,7 @@ enum iwl_ucode_calib_cfg {
 					IWL_CALIB_CFG_LO_IDX |		\
 					IWL_CALIB_CFG_TX_IQ_IDX |	\
 					IWL_CALIB_CFG_RX_IQ_IDX |	\
-					IWL_CALIB_CFG_NOISE_IDX |	\
-					IWL_CALIB_CFG_CRYSTAL_IDX |	\
-					IWL_CALIB_CFG_TEMPERATURE_IDX |	\
-					IWL_CALIB_CFG_PAPD_IDX |	\
-					IWL_CALIB_CFG_SENSITIVITY_IDX |	\
-					IWL_CALIB_CFG_TX_PWR_IDX)
+					IWL_CALIB_CFG_CRYSTAL_IDX)
 
 #define IWL_CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_MSK	cpu_to_le32(BIT(0))
 
-- 
1.7.0.4

