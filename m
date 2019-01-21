Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FE6C282DB
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE47F2084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfAUHvE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:51:04 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49172 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726240AbfAUHvD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:51:03 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULw-0006cr-Jk; Mon, 21 Jan 2019 09:50:41 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:21 +0200
Message-Id: <20190121075026.25059-12-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/16] iwlwifi: tighten boundary checks
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liad Kaufman <liad.kaufman@intel.com>

The driver assumes certain sizes and lengths aren't crossed in some
places.  Make sure this indeed happens.

Found by Klocwork.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 24 +++++++++++++++----
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  6 ++++-
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 5f16879ab26a..56e99b5661f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -835,6 +835,8 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	if (!fwrt->trans->cfg->dccm_offset || !fwrt->trans->cfg->dccm_len) {
 		const struct fw_img *img;
 
+		if (fwrt->cur_fw_img >= IWL_UCODE_TYPE_MAX)
+			return NULL;
 		img = &fwrt->fw->img[fwrt->cur_fw_img];
 		sram_ofs = img->sec[IWL_UCODE_SECTION_DATA].offset;
 		sram_len = img->sec[IWL_UCODE_SECTION_DATA].len;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 2adef6e3e0ac..ac62eb8c4b36 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1024,7 +1024,12 @@ static void iwl_mvm_tx_airtime(struct iwl_mvm *mvm,
 			       int airtime)
 {
 	int mac = mvmsta->mac_id_n_color & FW_CTXT_ID_MSK;
-	struct iwl_mvm_tcm_mac *mdata = &mvm->tcm.data[mac];
+	struct iwl_mvm_tcm_mac *mdata;
+
+	if (mac >= NUM_MAC_INDEX_DRIVER)
+		return;
+
+	mdata = &mvm->tcm.data[mac];
 
 	if (mvm->tcm.paused)
 		return;
@@ -1035,14 +1040,21 @@ static void iwl_mvm_tx_airtime(struct iwl_mvm *mvm,
 	mdata->tx.airtime += airtime;
 }
 
-static void iwl_mvm_tx_pkt_queued(struct iwl_mvm *mvm,
-				  struct iwl_mvm_sta *mvmsta, int tid)
+static int iwl_mvm_tx_pkt_queued(struct iwl_mvm *mvm,
+				 struct iwl_mvm_sta *mvmsta, int tid)
 {
 	u32 ac = tid_to_mac80211_ac[tid];
 	int mac = mvmsta->mac_id_n_color & FW_CTXT_ID_MSK;
-	struct iwl_mvm_tcm_mac *mdata = &mvm->tcm.data[mac];
+	struct iwl_mvm_tcm_mac *mdata;
+
+	if (mac >= NUM_MAC_INDEX_DRIVER)
+		return -EINVAL;
+
+	mdata = &mvm->tcm.data[mac];
 
 	mdata->tx.pkts[ac]++;
+
+	return 0;
 }
 
 /*
@@ -1162,7 +1174,9 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	spin_unlock(&mvmsta->lock);
 
-	iwl_mvm_tx_pkt_queued(mvm, mvmsta, tid == IWL_MAX_TID_COUNT ? 0 : tid);
+	if (iwl_mvm_tx_pkt_queued(mvm, mvmsta,
+				  tid == IWL_MAX_TID_COUNT ? 0 : tid))
+		goto drop;
 
 	return 0;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 156ca1b1f621..af2791502b7d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -214,7 +214,11 @@ static int iwl_pcie_gen2_set_tb(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int idx = iwl_pcie_gen2_get_num_tbs(trans, tfd);
-	struct iwl_tfh_tb *tb = &tfd->tbs[idx];
+	struct iwl_tfh_tb *tb;
+
+	if (WARN_ON(idx >= IWL_NUM_OF_TBS))
+		return -EINVAL;
+	tb = &tfd->tbs[idx];
 
 	/* Each TFD can point to a maximum max_tbs Tx buffers */
 	if (le16_to_cpu(tfd->num_tbs) >= trans_pcie->max_tbs) {
-- 
2.20.1

