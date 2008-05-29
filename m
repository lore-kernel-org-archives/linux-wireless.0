Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31371 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbYE2Ihq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:46 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 29/43] iwlwifi: iwl-5000 add rxon_assoc
Date: Thu, 29 May 2008 16:35:14 +0800
Message-Id: <1212050128-17132-30-git-send-email-yi.zhu@intel.com> (sfid-20080529_110545_631830_D3DE30C7)
In-Reply-To: <1212050128-17132-29-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-24-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-25-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-26-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-27-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-28-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-29-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds rxon assoc command for 5000 HW.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   48 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |   17 +++++++++
 2 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 6a10526..217c6a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1250,7 +1250,55 @@ static int iwl5000_hw_valid_rtc_data_addr(u32 addr)
 		(addr < IWL50_RTC_DATA_UPPER_BOUND);
 }
 
+static int iwl5000_send_rxon_assoc(struct iwl_priv *priv)
+{
+	int ret = 0;
+	struct iwl5000_rxon_assoc_cmd rxon_assoc;
+	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
+	const struct iwl_rxon_cmd *rxon2 = &priv->active_rxon;
+
+	if ((rxon1->flags == rxon2->flags) &&
+	    (rxon1->filter_flags == rxon2->filter_flags) &&
+	    (rxon1->cck_basic_rates == rxon2->cck_basic_rates) &&
+	    (rxon1->ofdm_ht_single_stream_basic_rates ==
+	     rxon2->ofdm_ht_single_stream_basic_rates) &&
+	    (rxon1->ofdm_ht_dual_stream_basic_rates ==
+	     rxon2->ofdm_ht_dual_stream_basic_rates) &&
+	    (rxon1->ofdm_ht_triple_stream_basic_rates ==
+	     rxon2->ofdm_ht_triple_stream_basic_rates) &&
+	    (rxon1->acquisition_data == rxon2->acquisition_data) &&
+	    (rxon1->rx_chain == rxon2->rx_chain) &&
+	    (rxon1->ofdm_basic_rates == rxon2->ofdm_basic_rates)) {
+		IWL_DEBUG_INFO("Using current RXON_ASSOC.  Not resending.\n");
+		return 0;
+	}
+
+	rxon_assoc.flags = priv->staging_rxon.flags;
+	rxon_assoc.filter_flags = priv->staging_rxon.filter_flags;
+	rxon_assoc.ofdm_basic_rates = priv->staging_rxon.ofdm_basic_rates;
+	rxon_assoc.cck_basic_rates = priv->staging_rxon.cck_basic_rates;
+	rxon_assoc.reserved1 = 0;
+	rxon_assoc.reserved2 = 0;
+	rxon_assoc.reserved3 = 0;
+	rxon_assoc.ofdm_ht_single_stream_basic_rates =
+	    priv->staging_rxon.ofdm_ht_single_stream_basic_rates;
+	rxon_assoc.ofdm_ht_dual_stream_basic_rates =
+	    priv->staging_rxon.ofdm_ht_dual_stream_basic_rates;
+	rxon_assoc.rx_chain_select_flags = priv->staging_rxon.rx_chain;
+	rxon_assoc.ofdm_ht_triple_stream_basic_rates =
+		 priv->staging_rxon.ofdm_ht_triple_stream_basic_rates;
+	rxon_assoc.acquisition_data = priv->staging_rxon.acquisition_data;
+
+	ret = iwl_send_cmd_pdu_async(priv, REPLY_RXON_ASSOC,
+				     sizeof(rxon_assoc), &rxon_assoc, NULL);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
 static struct iwl_hcmd_ops iwl5000_hcmd = {
+	.rxon_assoc = iwl5000_send_rxon_assoc,
 };
 
 static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 2652e37..fb6f5ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -630,6 +630,20 @@ struct iwl_rxon_cmd {
 	__le16 reserved6;
 } __attribute__ ((packed));
 
+struct iwl5000_rxon_assoc_cmd {
+	__le32 flags;
+	__le32 filter_flags;
+	u8 ofdm_basic_rates;
+	u8 cck_basic_rates;
+	__le16 reserved1;
+	u8 ofdm_ht_single_stream_basic_rates;
+	u8 ofdm_ht_dual_stream_basic_rates;
+	u8 ofdm_ht_triple_stream_basic_rates;
+	u8 reserved2;
+	__le16 rx_chain_select_flags;
+	__le16 acquisition_data;
+	__le32 reserved3;
+} __attribute__ ((packed));
 
 /*
  * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
@@ -645,6 +659,9 @@ struct iwl4965_rxon_assoc_cmd {
 	__le16 reserved;
 } __attribute__ ((packed));
 
+
+
+
 /*
  * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
  */
-- 
1.5.3.6

