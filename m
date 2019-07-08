Return-Path: <SRS0=wMe8=VF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBDEC606C4
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Jul 2019 15:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65BCF216F4
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Jul 2019 15:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387891AbfGHPzp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Jul 2019 11:55:45 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54328 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733062AbfGHPzp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jul 2019 11:55:45 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hkVzS-0000OC-5C; Mon, 08 Jul 2019 18:55:43 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>, stable@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Jul 2019 18:55:33 +0300
Message-Id: <20190708155534.18241-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190708155534.18241-1-luca@coelho.fi>
References: <20190708155534.18241-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 1/2] iwlwifi: add new cards for 9000 and 20000 series
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ihab Zhaika <ihab.zhaika@intel.com>

add two new PCI ID's for 9000 and 20000 series

Cc: stable@vger.kernel.org
Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index ccc83fd74649..fe645380bd2f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -604,6 +604,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2526, 0x40A4, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x42A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2526, 0x6014, iwl9260_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x8014, iwl9260_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x8010, iwl9260_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0xA014, iwl9260_2ac_160_cfg)},
@@ -971,6 +972,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x7A70, 0x0310, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7A70, 0x0510, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7A70, 0x0A10, iwlax211_2ax_cfg_so_gf_a0)},
+	{IWL_PCI_DEVICE(0x7AF0, 0x0090, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7AF0, 0x0310, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7AF0, 0x0510, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7AF0, 0x0A10, iwlax211_2ax_cfg_so_gf_a0)},
-- 
2.20.1

