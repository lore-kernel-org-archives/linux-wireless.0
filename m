Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18761 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbXHBCSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 22:18:47 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/4] iwlwifi: Endianity fix in iwl4965_calc_rssi function
Date: Thu,  2 Aug 2007 10:16:03 +0800
Message-Id: <1186020969666-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11860209683483-git-send-email-yi.zhu@intel.com>
References: <1186020965807-git-send-email-yi.zhu@intel.com>
 <11860209683483-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endianity issues in iwl4965_calc_rssi function.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index f501f82..2e97e6b 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -3670,11 +3670,12 @@ static int iwl4965_calc_rssi(struct iwl4965_rx_phy_res *rx_resp)
 	 *   contents are always there, not configurable by host.  */
 	struct iwl4965_rx_non_cfg_phy *ncphy =
 	    (struct iwl4965_rx_non_cfg_phy *)rx_resp->non_cfg_phy;
-	u32 agc = (ncphy->agc_info & IWL_AGC_DB_MASK) >> IWL_AGC_DB_POS;
+	u32 agc = (le16_to_cpu(ncphy->agc_info) & IWL_AGC_DB_MASK)
+			>> IWL_AGC_DB_POS;
 
 	u32 valid_antennae =
-	    (rx_resp->phy_flags & RX_PHY_FLAGS_ANTENNAE_MASK) >>
-	    RX_PHY_FLAGS_ANTENNAE_OFFSET;
+	    (le16_to_cpu(rx_resp->phy_flags) & RX_PHY_FLAGS_ANTENNAE_MASK)
+			>> RX_PHY_FLAGS_ANTENNAE_OFFSET;
 	u8 max_rssi = 0;
 	u32 i;
 
-- 
1.5.2
