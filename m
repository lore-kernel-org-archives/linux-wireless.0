Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F15C65BD1
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 879E620882
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:17:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 879E620882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbeJHP2O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:14 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56286 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726113AbeJHP2N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:13 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9QjW-0003w6-2Z; Mon, 08 Oct 2018 11:17:42 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:19 +0300
Message-Id: <20181008081735.3401-3-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/18] iwlwifi: pcie: don't pad AMSDU packets
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

When we TX AMSDU, we shouldn't pad the packet. In the past,
we were building AMSDU only in transport layer, and gen2
functions are built based on this. However, now that op mode
may build AMSDUs, we need to take care of padding also in
gen2 "non-pcie-amsdu" path.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index b71cf55480fc..09cdc15f7645 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -454,7 +454,8 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx(struct iwl_trans *trans,
 				    struct sk_buff *skb,
 				    struct iwl_cmd_meta *out_meta,
 				    int hdr_len,
-				    int tx_cmd_len)
+				    int tx_cmd_len,
+				    bool pad)
 {
 	int idx = iwl_pcie_get_cmd_index(txq, txq->write_ptr);
 	struct iwl_tfh_tfd *tfd = iwl_pcie_get_tfd(trans, txq, idx);
@@ -478,7 +479,10 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx(struct iwl_trans *trans,
 	len = tx_cmd_len + sizeof(struct iwl_cmd_header) + hdr_len -
 	      IWL_FIRST_TB_SIZE;
 
-	tb1_len = ALIGN(len, 4);
+	if (pad)
+		tb1_len = ALIGN(len, 4);
+	else
+		tb1_len = len;
 
 	/* map the data for TB1 */
 	tb1_addr = ((u8 *)&dev_cmd->hdr) + IWL_FIRST_TB_SIZE;
@@ -551,7 +555,7 @@ struct iwl_tfh_tfd *iwl_pcie_gen2_build_tfd(struct iwl_trans *trans,
 						    out_meta, hdr_len, len);
 
 	return iwl_pcie_gen2_build_tx(trans, txq, dev_cmd, skb, out_meta,
-				      hdr_len, len);
+				      hdr_len, len, !amsdu);
 }
 
 int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
-- 
2.19.0

