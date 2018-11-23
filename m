Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0423C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FB80206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FB80206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503792AbeKWWLG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:11:06 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38370 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388237AbeKWWLF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:11:05 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bk-0008GU-F1; Fri, 23 Nov 2018 13:26:48 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:30 +0200
Message-Id: <20181123112631.29360-15-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/15] iwlwifi: pcie: set cmd_len in the correct place
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

command len is set too early in the code, since when building
AMSDU, the size changes. This causes the byte count table to
have the wrong size.

Fixes: a0ec0169b7a9 ("iwlwifi: support new tx api")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 0c5f11d2c5da..16e8c3eb09b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -583,18 +583,6 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	spin_lock(&txq->lock);
 
-	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
-		struct iwl_tx_cmd_gen3 *tx_cmd_gen3 =
-			(void *)dev_cmd->payload;
-
-		cmd_len = le16_to_cpu(tx_cmd_gen3->len);
-	} else {
-		struct iwl_tx_cmd_gen2 *tx_cmd_gen2 =
-			(void *)dev_cmd->payload;
-
-		cmd_len = le16_to_cpu(tx_cmd_gen2->len);
-	}
-
 	if (iwl_queue_space(trans, txq) < txq->high_mark) {
 		iwl_stop_queue(trans, txq);
 
@@ -632,6 +620,18 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		return -1;
 	}
 
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
+		struct iwl_tx_cmd_gen3 *tx_cmd_gen3 =
+			(void *)dev_cmd->payload;
+
+		cmd_len = le16_to_cpu(tx_cmd_gen3->len);
+	} else {
+		struct iwl_tx_cmd_gen2 *tx_cmd_gen2 =
+			(void *)dev_cmd->payload;
+
+		cmd_len = le16_to_cpu(tx_cmd_gen2->len);
+	}
+
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_pcie_gen2_update_byte_tbl(trans_pcie, txq, cmd_len,
 				      iwl_pcie_gen2_get_num_tbs(trans, tfd));
-- 
2.19.1

