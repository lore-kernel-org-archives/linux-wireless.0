Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59244 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751253AbdFEUme (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:42:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:41:55 +0300
Message-Id: <20170605204218.30151-3-luca@coelho.fi> (sfid-20170605_224237_975239_1E817F8D)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 02/25] iwlwifi: mvm: document RX structures
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Document the structures used in RX and link them to the command ID.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 81 ++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  8 +++
 2 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index 67dffd725690..ad7ab6dd86cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -349,35 +349,106 @@ enum iwl_rx_mpdu_mac_info {
 	IWL_RX_MPDU_PHY_PHY_INDEX_MASK		= 0xf0,
 };
 
+/**
+ * struct iwl_rx_mpdu_desc - RX MPDU descriptor
+ */
 struct iwl_rx_mpdu_desc {
 	/* DW2 */
+	/**
+	 * @mpdu_len: MPDU length
+	 */
 	__le16 mpdu_len;
+	/**
+	 * @mac_flags1: &enum iwl_rx_mpdu_mac_flags1
+	 */
 	u8 mac_flags1;
+	/**
+	 * @mac_flags2: &enum iwl_rx_mpdu_mac_flags2
+	 */
 	u8 mac_flags2;
 	/* DW3 */
+	/**
+	 * @amsdu_info: &enum iwl_rx_mpdu_amsdu_info
+	 */
 	u8 amsdu_info;
+	/**
+	 * @phy_info: &enum iwl_rx_mpdu_phy_info
+	 */
 	__le16 phy_info;
+	/**
+	 * @mac_phy_idx: MAC/PHY index
+	 */
 	u8 mac_phy_idx;
 	/* DW4 - carries csum data only when rpa_en == 1 */
-	__le16 raw_csum; /* alledgedly unreliable */
+	/**
+	 * @raw_csum: raw checksum (alledgedly unreliable)
+	 */
+	__le16 raw_csum;
+	/**
+	 * @l3l4_flags: &enum iwl_rx_l3l4_flags
+	 */
 	__le16 l3l4_flags;
 	/* DW5 */
+	/**
+	 * @status: &enum iwl_rx_mpdu_status
+	 */
 	__le16 status;
+	/**
+	 * @hash_filter: hash filter value
+	 */
 	u8 hash_filter;
+	/**
+	 * @sta_id_flags: &enum iwl_rx_mpdu_sta_id_flags
+	 */
 	u8 sta_id_flags;
 	/* DW6 */
+	/**
+	 * @reorder_data: &enum iwl_rx_mpdu_reorder_data
+	 */
 	__le32 reorder_data;
 	/* DW7 - carries rss_hash only when rpa_en == 1 */
+	/**
+	 * @rss_hash: RSS hash value
+	 */
 	__le32 rss_hash;
 	/* DW8 - carries filter_match only when rpa_en == 1 */
+	/**
+	 * @filter_match: filter match value
+	 */
 	__le32 filter_match;
 	/* DW9 */
+	/**
+	 * @rate_n_flags: RX rate/flags encoding
+	 */
 	__le32 rate_n_flags;
 	/* DW10 */
-	u8 energy_a, energy_b, channel, mac_context;
+	/**
+	 * @energy_a: energy chain A
+	 */
+	u8 energy_a;
+	/**
+	 * @energy_b: energy chain B
+	 */
+	u8 energy_b;
+	/**
+	 * @channel: channel number
+	 */
+	u8 channel;
+	/**
+	 * @mac_context: MAC context mask
+	 */
+	u8 mac_context;
 	/* DW11 */
+	/**
+	 * @gp2_on_air_rise: GP2 timer value on air rise (INA)
+	 */
 	__le32 gp2_on_air_rise;
-	/* DW12 & DW13 - carries TSF only TSF_OVERLOAD bit == 0 */
+	/* DW12 & DW13 */
+	/**
+	 * @tsf_on_air_rise:
+	 * TSF value on air rise (INA), only valid if
+	 * %IWL_RX_MPDU_PHY_TSF_OVERLOAD isn't set
+	 */
 	__le64 tsf_on_air_rise;
 } __packed;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index ef8b47faa265..23edac4a7009 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -373,7 +373,15 @@ enum iwl_legacy_cmds {
 	 */
 	RSS_CONFIG_CMD = 0xb3,
 
+	/**
+	 * @REPLY_RX_PHY_CMD: &struct iwl_rx_phy_info
+	 */
 	REPLY_RX_PHY_CMD = 0xc0,
+
+	/**
+	 * @REPLY_RX_MPDU_CMD:
+	 * &struct iwl_rx_mpdu_res_start or &struct iwl_rx_mpdu_desc
+	 */
 	REPLY_RX_MPDU_CMD = 0xc1,
 	FRAME_RELEASE = 0xc3,
 	BA_NOTIF = 0xc5,
-- 
2.11.0
