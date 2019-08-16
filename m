Return-Path: <SRS0=l5SL=WM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CDAC3A59C
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 12:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30C6D2064A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 12:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfHPM4G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Aug 2019 08:56:06 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:36150 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726541AbfHPM4E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Aug 2019 08:56:04 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hyblz-00066W-8G; Fri, 16 Aug 2019 15:56:03 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 16 Aug 2019 15:55:54 +0300
Message-Id: <20190816125554.8659-5-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190816125554.8659-1-luca@coelho.fi>
References: <20190816125554.8659-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 4/4] iwlwifi: pcie: fix recognition of QuZ devices
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

If the HW revision of Qu devices we found is QuZ, then we need to
switch the configuration accordingly in order to use the correct FW.

Add a block of ifs in order do that.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index de711c1160d3..7c5aaeaf7fe5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1063,6 +1063,23 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		else if (iwl_trans->cfg == &iwl9560_2ac_160_cfg_qu_b0_jf_b0)
 			iwl_trans->cfg = &iwl9560_2ac_160_cfg_qu_c0_jf_b0;
 	}
+
+	/* same thing for QuZ... */
+	if (iwl_trans->hw_rev == CSR_HW_REV_TYPE_QUZ) {
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
+	}
+
 #endif
 
 	pci_set_drvdata(pdev, iwl_trans);
-- 
2.23.0.rc1

