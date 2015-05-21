Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5409 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422755AbbEUTxR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 15:53:17 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/10] iwlwifi: pcie: don't disable the busmaster DMA clock for family 8000
Date: Thu, 21 May 2015 22:53:03 +0300
Message-Id: <1432237990-5890-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150521_215330_400216_D8083EA9)
In-Reply-To: <1432237819.26813.4.camel@intel.com>
References: <1432237819.26813.4.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Disabling the clocks is a standard procedure while stopping the
device. On family 8000 however, disabling the bus master DMA clock
increases the NIC's power consumption.

To fix this, skip this call if the device family is
IWL_DEVICE_FAMILY_8000.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 47bbf57..d6f6515 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1049,9 +1049,11 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 		iwl_pcie_rx_stop(trans);
 
 		/* Power-down device's busmaster DMA clocks */
-		iwl_write_prph(trans, APMG_CLK_DIS_REG,
-			       APMG_CLK_VAL_DMA_CLK_RQT);
-		udelay(5);
+		if (trans->cfg->device_family != IWL_DEVICE_FAMILY_8000) {
+			iwl_write_prph(trans, APMG_CLK_DIS_REG,
+				       APMG_CLK_VAL_DMA_CLK_RQT);
+			udelay(5);
+		}
 	}
 
 	/* Make sure (redundant) we've released our request to stay awake */
-- 
2.1.4

