Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131B4C33CAF
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 19:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1746207E0
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 19:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579202562;
	bh=F9CnNPMiYGhc4/q6hw9QUNtDZtY/v7pM+nnOx9qb4BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=her/GUFaisHTDq7PS9xO7HwZ7RTnjVM+4U0OjkF7qZNZWtvnrLChCiK86bLvYDKGt
	 D0SZJrjrUjIm9CZfzbTEMumP3E4hNbLDN/gidYU1Kbvo7Wvyt4+TW0dZ6tcOuXVlRX
	 O8/pGp0vQRGMQZFJDCrZxMxnY4y4DO2bAzzNk6fQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437726AbgAPTWk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 14:22:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730878AbgAPQxY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 343BC2176D;
        Thu, 16 Jan 2020 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193603;
        bh=F9CnNPMiYGhc4/q6hw9QUNtDZtY/v7pM+nnOx9qb4BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGAK2YEjv7J6ltKm/5XP1QQDEMUhU1/Zxg4EhcAxi9HWMZfZ/9efR5JrOP9vSnzJx
         36NK2tHMFxE5ZIrm6Q7zkNXGaGqIcxq8OvG7b24J8S+yaoMybjXsySPzWg7ptJ6jXg
         uXRZjN1HrPQLR1NI/YR38UdVedUwlE1SFkMVa5e8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 142/205] iwlwifi: mvm: fix support for single antenna diversity
Date:   Thu, 16 Jan 2020 11:41:57 -0500
Message-Id: <20200116164300.6705-142-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit bb99ff9baa02beb9216c86678999342197c849cc ]

When the single antenna diversity support was sent upstream, only some
definitions were sent, due to a bad revert.

Fix this by adding the actual code.

Fixes: 5952e0ec3f05 ("iwlwifi: mvm: add support for single antenna diversity")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index d9eb2b286438..c59cbb8cbdd7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -514,6 +514,18 @@ static int iwl_send_phy_cfg_cmd(struct iwl_mvm *mvm)
 	struct iwl_phy_cfg_cmd phy_cfg_cmd;
 	enum iwl_ucode_type ucode_type = mvm->fwrt.cur_fw_img;
 
+	if (iwl_mvm_has_unified_ucode(mvm) &&
+	    !mvm->trans->cfg->tx_with_siso_diversity) {
+		return 0;
+	} else if (mvm->trans->cfg->tx_with_siso_diversity) {
+		/*
+		 * TODO: currently we don't set the antenna but letting the NIC
+		 * to decide which antenna to use. This should come from BIOS.
+		 */
+		phy_cfg_cmd.phy_cfg =
+			cpu_to_le32(FW_PHY_CFG_CHAIN_SAD_ENABLED);
+	}
+
 	/* Set parameters */
 	phy_cfg_cmd.phy_cfg = cpu_to_le32(iwl_mvm_get_phy_config(mvm));
 
@@ -1344,12 +1356,12 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		ret = iwl_send_phy_db_data(mvm->phy_db);
 		if (ret)
 			goto error;
-
-		ret = iwl_send_phy_cfg_cmd(mvm);
-		if (ret)
-			goto error;
 	}
 
+	ret = iwl_send_phy_cfg_cmd(mvm);
+	if (ret)
+		goto error;
+
 	ret = iwl_mvm_send_bt_init_conf(mvm);
 	if (ret)
 		goto error;
-- 
2.20.1

