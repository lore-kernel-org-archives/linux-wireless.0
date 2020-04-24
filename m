Return-Path: <SRS0=Yp73=6I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9B1C55199
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Apr 2020 16:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E7C421556
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Apr 2020 16:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgDXQrk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 24 Apr 2020 12:47:40 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:58004 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728629AbgDXQr0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Apr 2020 12:47:26 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jS1U3-000OcH-FE; Fri, 24 Apr 2020 19:47:23 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 24 Apr 2020 19:47:01 +0300
Message-Id: <iwlwifi.20200424194456.a522161a7372.I2a65ee35a5e0242f8a0e106f126356dff81ef59d@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200424164707.2715869-1-luca@coelho.fi>
References: <20200424164707.2715869-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/11] iwlwifi: mvm: add IML/ROM information to the assertion dumps
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Dump the IML/ROM error code and data, which are read from some
registers, when printing an assertion dump.  This makes it easier to
debug IML/ROM errors.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index ee8f152e7606..be57b8391850 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -586,6 +586,23 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u8 lmac_num)
 	IWL_ERR(mvm, "0x%08X | flow_handler\n", table.flow_handler);
 }
 
+static void iwl_mvm_dump_iml_error_log(struct iwl_mvm *mvm)
+{
+	struct iwl_trans *trans = mvm->trans;
+	u32 error;
+
+	error = iwl_read_umac_prph(trans, UMAG_SB_CPU_2_STATUS);
+
+	IWL_ERR(trans, "IML/ROM dump:\n");
+
+	if (error & 0xFFFF0000)
+		IWL_ERR(trans, "IML/ROM SYSASSERT:\n");
+
+	IWL_ERR(mvm, "0x%08X | IML/ROM error/state\n", error);
+	IWL_ERR(mvm, "0x%08X | IML/ROM data1\n",
+		iwl_read_umac_prph(trans, UMAG_SB_CPU_1_STATUS));
+}
+
 void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 {
 	if (!test_bit(STATUS_DEVICE_ENABLED, &mvm->trans->status)) {
@@ -601,6 +618,9 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 
 	iwl_mvm_dump_umac_error_log(mvm);
 
+	if (mvm->trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
+		iwl_mvm_dump_iml_error_log(mvm);
+
 	iwl_fw_error_print_fseq_regs(&mvm->fwrt);
 }
 
-- 
2.26.2

