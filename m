Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB694C282DB
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77E7A2084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbfAUHun (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:50:43 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49092 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727903AbfAUHuk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:50:40 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULu-0006cr-IK; Mon, 21 Jan 2019 09:50:38 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:18 +0200
Message-Id: <20190121075026.25059-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/16] iwlwifi: mvm: Do not set RTS/CTS protection for P2P Device MAC
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

As this is not needed and might cause interoperability issues
during pairing with devices that would not reply to RTS frames.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index a79c79701cc4..11714eb8da5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -793,8 +793,6 @@ static int iwl_mvm_mac_ctxt_cmd_p2p_device(struct iwl_mvm *mvm,
 
 	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
-	cmd.protection_flags |= cpu_to_le32(MAC_PROT_FLG_TGG_PROTECT);
-
 	/* Override the filter flags to accept only probe requests */
 	cmd.filter_flags = cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
 
-- 
2.20.1

