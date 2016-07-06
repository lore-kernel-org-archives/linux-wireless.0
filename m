Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33520 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753885AbcGFKpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:45:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:13 +0300
Message-Id: <1467801651-1816-18-git-send-email-luca@coelho.fi> (sfid-20160706_124511_591344_B69113F9)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 18/56] iwlwifi: mvm: fix RX mpdu status enum
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

FW sets status for each RX packet.
Enum in the driver doesn't match with FW definition - fix it.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index 1994331..acc5cd5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -296,7 +296,7 @@ enum iwl_rx_mpdu_status {
 	IWL_RX_MPDU_STATUS_OVERRUN_OK		= BIT(1),
 	IWL_RX_MPDU_STATUS_SRC_STA_FOUND	= BIT(2),
 	IWL_RX_MPDU_STATUS_KEY_VALID		= BIT(3),
-	IWL_RX_MPDU_STATUS_KEY_ERROR		= BIT(4),
+	IWL_RX_MPDU_STATUS_KEY_PARAM_OK		= BIT(4),
 	IWL_RX_MPDU_STATUS_ICV_OK		= BIT(5),
 	IWL_RX_MPDU_STATUS_MIC_OK		= BIT(6),
 	IWL_RX_MPDU_RES_STATUS_TTAK_OK		= BIT(7),
@@ -311,7 +311,7 @@ enum iwl_rx_mpdu_status {
 	IWL_RX_MPDU_STATUS_WEP_MATCH		= BIT(12),
 	IWL_RX_MPDU_STATUS_EXT_IV_MATCH		= BIT(13),
 	IWL_RX_MPDU_STATUS_KEY_ID_MATCH		= BIT(14),
-	IWL_RX_MPDU_STATUS_KEY_COLOR		= BIT(15),
+	IWL_RX_MPDU_STATUS_ROBUST_MNG_FRAME	= BIT(15),
 };
 
 enum iwl_rx_mpdu_hash_filter {
-- 
2.8.1

