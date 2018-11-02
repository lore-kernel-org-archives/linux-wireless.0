Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF274C6786F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B93642082E
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B93642082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbeKBUO7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:14:59 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:34008 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726049AbeKBUO6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:14:58 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIXJC-0007MW-GR; Fri, 02 Nov 2018 13:08:10 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  2 Nov 2018 13:07:50 +0200
Message-Id: <20181102110800.29817-6-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102110800.29817-1-luca@coelho.fi>
References: <20181102110800.29817-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/15] iwlwifi: mvm: switch management tx antenna only on tx failure
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

Switch the antenna used for management tx only if previous tx failed.
If previous tx succeeded, there is no reason to switch antennas.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 7 ++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     | 4 +---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 8 ++++----
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 6486cfb33f40..b9c45a40e251 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -965,11 +965,8 @@ static void iwl_mvm_mac_ctxt_set_tx(struct iwl_mvm *mvm,
 	tx->tx_flags = cpu_to_le32(tx_flags);
 
 	if (!fw_has_capa(&mvm->fw->ucode_capa,
-			 IWL_UCODE_TLV_CAPA_BEACON_ANT_SELECTION)) {
-		mvm->mgmt_last_antenna_idx =
-			iwl_mvm_next_antenna(mvm, iwl_mvm_get_valid_tx_ant(mvm),
-					     mvm->mgmt_last_antenna_idx);
-	}
+			 IWL_UCODE_TLV_CAPA_BEACON_ANT_SELECTION))
+		iwl_mvm_toggle_tx_ant(mvm, &mvm->mgmt_last_antenna_idx);
 
 	tx->rate_n_flags =
 		cpu_to_le32(BIT(mvm->mgmt_last_antenna_idx) <<
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 03fdc8b1892d..707bc7d1f37f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1522,6 +1522,11 @@ static inline u8 iwl_mvm_get_valid_rx_ant(struct iwl_mvm *mvm)
 	       mvm->fw->valid_rx_ant;
 }
 
+static inline void iwl_mvm_toggle_tx_ant(struct iwl_mvm *mvm, u8 *ant)
+{
+	*ant = iwl_mvm_next_antenna(mvm, iwl_mvm_get_valid_tx_ant(mvm), *ant);
+}
+
 static inline u32 iwl_mvm_get_phy_config(struct iwl_mvm *mvm)
 {
 	u32 phy_config = ~(FW_PHY_CFG_TX_CHAIN |
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 758aa1f75ca1..0d5b55ed8dda 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -845,6 +845,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	iwl_mvm_tof_init(mvm);
 
+	iwl_mvm_toggle_tx_ant(mvm, &mvm->mgmt_last_antenna_idx);
+
 	return op_mode;
 
  out_unregister:
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index cfb784fea77b..cb376e869144 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -205,9 +205,7 @@ iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum nl80211_band band,
 {
 	u32 tx_ant;
 
-	mvm->scan_last_antenna_idx =
-		iwl_mvm_next_antenna(mvm, iwl_mvm_get_valid_tx_ant(mvm),
-				     mvm->scan_last_antenna_idx);
+	iwl_mvm_toggle_tx_ant(mvm, &mvm->scan_last_antenna_idx);
 	tx_ant = BIT(mvm->scan_last_antenna_idx) << RATE_MCS_ANT_POS;
 
 	if (band == NL80211_BAND_2GHZ && !no_cck)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 320453f51ec7..ac4fa0363942 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -381,10 +381,6 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 			cpu_to_le32(TX_CMD_FLG_ACK | TX_CMD_FLG_BAR);
 	}
 
-	mvm->mgmt_last_antenna_idx =
-		iwl_mvm_next_antenna(mvm, iwl_mvm_get_valid_tx_ant(mvm),
-				     mvm->mgmt_last_antenna_idx);
-
 	/* Set the rate in the TX cmd */
 	tx_cmd->rate_n_flags = cpu_to_le32(iwl_mvm_get_tx_rate(mvm, info, sta));
 }
@@ -1501,6 +1497,10 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			break;
 		}
 
+		if ((status & TX_STATUS_MSK) != TX_STATUS_SUCCESS &&
+		    ieee80211_is_mgmt(hdr->frame_control))
+			iwl_mvm_toggle_tx_ant(mvm, &mvm->mgmt_last_antenna_idx);
+
 		/*
 		 * If we are freeing multiple frames, mark all the frames
 		 * but the first one as acked, since they were acknowledged
-- 
2.19.1

