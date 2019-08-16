Return-Path: <SRS0=l5SL=WM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8627BC3A59E
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 12:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6904D2064A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 12:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfHPM4E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Aug 2019 08:56:04 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:36138 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726032AbfHPM4D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Aug 2019 08:56:03 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hybly-00066W-04; Fri, 16 Aug 2019 15:56:02 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 16 Aug 2019 15:55:52 +0300
Message-Id: <20190816125554.8659-3-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190816125554.8659-1-luca@coelho.fi>
References: <20190816125554.8659-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 2/4] iwlwifi: pcie: fix the byte count table format for 22560 devices
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Starting from 22560, the byte count is expected to be in
bytes and we have now 14 bits. Ajust the code to this.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 38d110338987..9ef6b8fe03c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -99,10 +99,7 @@ void iwl_pcie_gen2_update_byte_tbl(struct iwl_trans_pcie *trans_pcie,
 	u16 len = byte_cnt;
 	__le16 bc_ent;
 
-	if (trans_pcie->bc_table_dword)
-		len = DIV_ROUND_UP(len, 4);
-
-	if (WARN_ON(len > 0xFFF || idx >= txq->n_window))
+	if (WARN(idx >= txq->n_window, "%d >= %d\n", idx, txq->n_window))
 		return;
 
 	filled_tfd_size = offsetof(struct iwl_tfh_tfd, tbs) +
@@ -117,11 +114,20 @@ void iwl_pcie_gen2_update_byte_tbl(struct iwl_trans_pcie *trans_pcie,
 	 */
 	num_fetch_chunks = DIV_ROUND_UP(filled_tfd_size, 64) - 1;
 
-	bc_ent = cpu_to_le16(len | (num_fetch_chunks << 12));
-	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
+		/* Starting from 22560, the HW expects bytes */
+		WARN_ON(trans_pcie->bc_table_dword);
+		WARN_ON(len > 0x3FFF);
+		bc_ent = cpu_to_le16(len | (num_fetch_chunks << 14));
 		scd_bc_tbl_gen3->tfd_offset[idx] = bc_ent;
-	else
+	} else {
+		/* Until 22560, the HW expects DW */
+		WARN_ON(!trans_pcie->bc_table_dword);
+		len = DIV_ROUND_UP(len, 4);
+		WARN_ON(len > 0xFFF);
+		bc_ent = cpu_to_le16(len | (num_fetch_chunks << 12));
 		scd_bc_tbl->tfd_offset[idx] = bc_ent;
+	}
 }
 
 /*
-- 
2.23.0.rc1

