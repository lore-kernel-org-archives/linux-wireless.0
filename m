Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150CAC282DB
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1CAC2084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfAUHvA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:51:00 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49164 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726240AbfAUHvA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:51:00 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULy-0006cr-Pq; Mon, 21 Jan 2019 09:50:43 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:24 +0200
Message-Id: <20190121075026.25059-15-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/16] iwlwifi: avoid access out of memory allocated
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

The value in num_lmac can be bigger than mem_cfg->lmac array,
warn in case it's bigger.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: 68025d5f9bfe ("iwlwifi: dbg: refactor dump code to improve readability")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 56e99b5661f7..a97bf17da14d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -748,6 +748,9 @@ static int iwl_fw_rxf_len(struct iwl_fw_runtime *fwrt,
 	ADD_LEN(fifo_len, mem_cfg->rxfifo2_size, hdr_len);
 
 	/* Count RXF1 sizes */
+	if (WARN_ON(mem_cfg->num_lmacs > MAX_NUM_LMAC))
+		mem_cfg->num_lmacs = MAX_NUM_LMAC;
+
 	for (i = 0; i < mem_cfg->num_lmacs; i++)
 		ADD_LEN(fifo_len, mem_cfg->lmac[i].rxfifo1_size, hdr_len);
 
@@ -766,6 +769,9 @@ static int iwl_fw_txf_len(struct iwl_fw_runtime *fwrt,
 		goto dump_internal_txf;
 
 	/* Count TXF sizes */
+	if (WARN_ON(mem_cfg->num_lmacs > MAX_NUM_LMAC))
+		mem_cfg->num_lmacs = MAX_NUM_LMAC;
+
 	for (i = 0; i < mem_cfg->num_lmacs; i++) {
 		int j;
 
-- 
2.20.1

