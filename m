Return-Path: <SRS0=Izt1=2N=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B61FC3F68F
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Dec 2019 12:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B73D20828
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Dec 2019 12:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfLWM4U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Dec 2019 07:56:20 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:54590 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726257AbfLWM4U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Dec 2019 07:56:20 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1ijNFv-0000nB-HE; Mon, 23 Dec 2019 14:56:18 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     stable@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 23 Dec 2019 14:56:12 +0200
Message-Id: <20191223125612.1475700-1-luca@coelho.fi>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v5.4] Revert "iwlwifi: assign directly to iwl_trans->cfg in QuZ detection"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Anders Kaseorg <andersk@mit.edu>

This reverts commit 968dcfb4905245dc64d65312c0d17692fa087b99.

Both that commit and commit 809805a820c6445f7a701ded24fdc6bbc841d1e4
attempted to fix the same bug (dead assignments to the local variable
cfg), but they did so in incompatible ways. When they were both merged,
independently of each other, the combination actually caused the bug to
reappear, leading to a firmware crash on boot for some cards.

https://bugzilla.kernel.org/show_bug.cgi?id=205719

Signed-off-by: Anders Kaseorg <andersk@mit.edu>
Acked-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 040cec17d3ad..b0b7eca1754e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1111,18 +1111,18 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* same thing for QuZ... */
 	if (iwl_trans->hw_rev == CSR_HW_REV_TYPE_QUZ) {
-		if (iwl_trans->cfg == &iwl_ax101_cfg_qu_hr)
-			iwl_trans->cfg = &iwl_ax101_cfg_quz_hr;
-		else if (iwl_trans->cfg == &iwl_ax201_cfg_qu_hr)
-			iwl_trans->cfg = &iwl_ax201_cfg_quz_hr;
-		else if (iwl_trans->cfg == &iwl9461_2ac_cfg_qu_b0_jf_b0)
-			iwl_trans->cfg = &iwl9461_2ac_cfg_quz_a0_jf_b0_soc;
-		else if (iwl_trans->cfg == &iwl9462_2ac_cfg_qu_b0_jf_b0)
-			iwl_trans->cfg = &iwl9462_2ac_cfg_quz_a0_jf_b0_soc;
-		else if (iwl_trans->cfg == &iwl9560_2ac_cfg_qu_b0_jf_b0)
-			iwl_trans->cfg = &iwl9560_2ac_cfg_quz_a0_jf_b0_soc;
-		else if (iwl_trans->cfg == &iwl9560_2ac_160_cfg_qu_b0_jf_b0)
-			iwl_trans->cfg = &iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc;
+		if (cfg == &iwl_ax101_cfg_qu_hr)
+			cfg = &iwl_ax101_cfg_quz_hr;
+		else if (cfg == &iwl_ax201_cfg_qu_hr)
+			cfg = &iwl_ax201_cfg_quz_hr;
+		else if (cfg == &iwl9461_2ac_cfg_qu_b0_jf_b0)
+			cfg = &iwl9461_2ac_cfg_quz_a0_jf_b0_soc;
+		else if (cfg == &iwl9462_2ac_cfg_qu_b0_jf_b0)
+			cfg = &iwl9462_2ac_cfg_quz_a0_jf_b0_soc;
+		else if (cfg == &iwl9560_2ac_cfg_qu_b0_jf_b0)
+			cfg = &iwl9560_2ac_cfg_quz_a0_jf_b0_soc;
+		else if (cfg == &iwl9560_2ac_160_cfg_qu_b0_jf_b0)
+			cfg = &iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc;
 	}
 
 #endif
-- 
2.24.0

