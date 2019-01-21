Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CD8C282E6
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4AB52084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbfAUHux (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:50:53 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49148 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728409AbfAUHuw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:50:52 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULx-0006cr-Ar; Mon, 21 Jan 2019 09:50:41 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:22 +0200
Message-Id: <20190121075026.25059-13-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/16] iwlwifi: memcpy from dev_cmd and not dev_cmd->hdr
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Liad Kaufman <liad.kaufman@intel.com>

Klocwork complains about copying from dev_cmd->hdr if
copying more than 4 bytes since it means part of the
copy is from the next field. This isn't a real bug,
but for not failing Klocwork next time - fix this.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index af2791502b7d..d2bd7f528a20 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -412,7 +412,7 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx_amsdu(struct iwl_trans *trans,
 		goto out_err;
 
 	/* building the A-MSDU might have changed this data, memcpy it now */
-	memcpy(&txq->first_tb_bufs[idx], &dev_cmd->hdr, IWL_FIRST_TB_SIZE);
+	memcpy(&txq->first_tb_bufs[idx], dev_cmd, IWL_FIRST_TB_SIZE);
 	return tfd;
 
 out_err:
@@ -473,7 +473,7 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx(struct iwl_trans *trans,
 	tb_phys = iwl_pcie_get_first_tb_dma(txq, idx);
 
 	/* The first TB points to bi-directional DMA data */
-	memcpy(&txq->first_tb_bufs[idx], &dev_cmd->hdr, IWL_FIRST_TB_SIZE);
+	memcpy(&txq->first_tb_bufs[idx], dev_cmd, IWL_FIRST_TB_SIZE);
 
 	iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, IWL_FIRST_TB_SIZE);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index ee990a7a5411..7073116c73b7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -2438,8 +2438,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	}
 
 	/* building the A-MSDU might have changed this data, so memcpy it now */
-	memcpy(&txq->first_tb_bufs[txq->write_ptr], &dev_cmd->hdr,
-	       IWL_FIRST_TB_SIZE);
+	memcpy(&txq->first_tb_bufs[txq->write_ptr], dev_cmd, IWL_FIRST_TB_SIZE);
 
 	tfd = iwl_pcie_get_tfd(trans, txq, txq->write_ptr);
 	/* Set up entry for this TFD in Tx byte-count array */
-- 
2.20.1

