Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:65103 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762749AbXG0J3C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:02 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 10/17] iwlwifi: endianity cleaning of iwl_print_rx_config_cmd
Date: Fri, 27 Jul 2007 17:26:34 +0800
Message-Id: <11855284201330-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284183313-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
 <11855284072074-git-send-email-yi.zhu@intel.com>
 <1185528408776-git-send-email-yi.zhu@intel.com>
 <11855284103871-git-send-email-yi.zhu@intel.com>
 <11855284122218-git-send-email-yi.zhu@intel.com>
 <11855284142478-git-send-email-yi.zhu@intel.com>
 <11855284161716-git-send-email-yi.zhu@intel.com>
 <11855284183313-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches cleans up endianity issues in iwl_print_rx_config_cmd,
which produced a lot of spares errors.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 92c21d1..8f9714f 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -4664,11 +4664,13 @@ static void iwl_print_rx_config_cmd(struct iwl_rxon_cmd *rxon)
 {
 	IWL_DEBUG_RADIO("RX CONFIG:\n");
 	printk_buf(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
-	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", rxon->channel);
+	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
 	IWL_DEBUG_RADIO("u32 flags: 0x%08X " BIT_FMT32 "\n",
-			rxon->flags, BIT_ARG32(rxon->flags));
+			le32_to_cpu(rxon->flags),
+			BIT_ARG32(le32_to_cpu(rxon->flags)));
 	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x " BIT_FMT32 "\n",
-			rxon->filter_flags, BIT_ARG32(rxon->filter_flags));
+			le32_to_cpu(rxon->filter_flags),
+			BIT_ARG32(le32_to_cpu(rxon->filter_flags)));
 	IWL_DEBUG_RADIO("u8 dev_type: 0x%x\n", rxon->dev_type);
 	IWL_DEBUG_RADIO("u8 ofdm_basic_rates: 0x%02x " BIT_FMT8 "\n",
 			rxon->ofdm_basic_rates,
@@ -4679,7 +4681,7 @@ static void iwl_print_rx_config_cmd(struct iwl_rxon_cmd *rxon)
 			MAC_ARG(rxon->node_addr));
 	IWL_DEBUG_RADIO("u8[6] bssid_addr: " MAC_FMT "\n",
 			MAC_ARG(rxon->bssid_addr));
-	IWL_DEBUG_RADIO("u16 assoc_id: 0x%x\n", rxon->assoc_id);
+	IWL_DEBUG_RADIO("u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
 }
 
 #endif
-- 
1.5.2
