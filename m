Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD079C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3FEC218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfCVOA2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:00:28 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46278 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727630AbfCVOA1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:00:27 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Kho-0000bK-JY; Fri, 22 Mar 2019 15:59:32 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:59:03 +0200
Message-Id: <20190322135903.10631-25-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 24/24] iwlwifi: remove misconfigured pci ids from 22260 series
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ihab Zhaika <ihab.zhaika@intel.com>

Two of the PCI ID entries for the 22260 series were incorrectly using
the subsystem vendor ID (which we ignore) as the PCI device ID.  This is
obviously wrong and can be simply removed since we already have the
correct entries in the list.

Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index d7b866e0e7ae..0329b626ada6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -959,12 +959,9 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2723, 0x008C, iwl22260_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x1653, killer1650w_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x1654, killer1650x_2ax_cfg)},
+	{IWL_PCI_DEVICE(0x2723, 0x2080, iwl22260_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x4080, iwl22260_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x4088, iwl22260_2ax_cfg)},
-
-	{IWL_PCI_DEVICE(0x1a56, 0x1653, killer1650w_2ax_cfg)},
-	{IWL_PCI_DEVICE(0x1a56, 0x1654, killer1650x_2ax_cfg)},
-
 	{IWL_PCI_DEVICE(0x2725, 0x0090, iwlax210_2ax_cfg_so_hr_a0)},
 	{IWL_PCI_DEVICE(0x7A70, 0x0090, iwlax210_2ax_cfg_so_hr_a0)},
 	{IWL_PCI_DEVICE(0x7A70, 0x0310, iwlax210_2ax_cfg_so_hr_a0)},
-- 
2.20.1

