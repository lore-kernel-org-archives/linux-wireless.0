Return-Path: <SRS0=IBNP=X5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F82C4CED1
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C93C215EA
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Oct 2019 13:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388274AbfJDNOW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:14:22 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46554 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388181AbfJDNOW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Oct 2019 09:14:22 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iGNPY-0000l2-8Z; Fri, 04 Oct 2019 16:14:20 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri,  4 Oct 2019 16:14:07 +0300
Message-Id: <20191004131414.27372-2-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191004131414.27372-1-luca@coelho.fi>
References: <20191004131414.27372-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 1/8] iwlwifi: don't access trans_cfg via cfg
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We copy cfg->trans to trans->trans_cfg at the very beginning, so don't
try to access it via cfg->trans anymore, because the cfg may be unset
in later cases.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-io.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index f8e4f0f5de0c..f09e368c7040 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -112,38 +112,38 @@ int iwl_dump_fh(struct iwl_trans *trans, char **buf);
  */
 static inline u32 iwl_umac_prph(struct iwl_trans *trans, u32 ofs)
 {
-	return ofs + trans->cfg->trans.umac_prph_offset;
+	return ofs + trans->trans_cfg->umac_prph_offset;
 }
 
 static inline u32 iwl_read_umac_prph_no_grab(struct iwl_trans *trans, u32 ofs)
 {
 	return iwl_read_prph_no_grab(trans, ofs +
-				     trans->cfg->trans.umac_prph_offset);
+				     trans->trans_cfg->umac_prph_offset);
 }
 
 static inline u32 iwl_read_umac_prph(struct iwl_trans *trans, u32 ofs)
 {
-	return iwl_read_prph(trans, ofs + trans->cfg->trans.umac_prph_offset);
+	return iwl_read_prph(trans, ofs + trans->trans_cfg->umac_prph_offset);
 }
 
 static inline void iwl_write_umac_prph_no_grab(struct iwl_trans *trans, u32 ofs,
 					       u32 val)
 {
-	iwl_write_prph_no_grab(trans,  ofs + trans->cfg->trans.umac_prph_offset,
+	iwl_write_prph_no_grab(trans,  ofs + trans->trans_cfg->umac_prph_offset,
 			       val);
 }
 
 static inline void iwl_write_umac_prph(struct iwl_trans *trans, u32 ofs,
 				       u32 val)
 {
-	iwl_write_prph(trans,  ofs + trans->cfg->trans.umac_prph_offset, val);
+	iwl_write_prph(trans,  ofs + trans->trans_cfg->umac_prph_offset, val);
 }
 
 static inline int iwl_poll_umac_prph_bit(struct iwl_trans *trans, u32 addr,
 					 u32 bits, u32 mask, int timeout)
 {
 	return iwl_poll_prph_bit(trans, addr +
-				 trans->cfg->trans.umac_prph_offset,
+				 trans->trans_cfg->umac_prph_offset,
 				 bits, mask, timeout);
 }
 
-- 
2.23.0

