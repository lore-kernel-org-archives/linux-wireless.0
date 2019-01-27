Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23250C282C9
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0DB52146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfA0KTn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:19:43 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51400 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726816AbfA0KTm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:19:42 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXH-0001vC-Ol; Sun, 27 Jan 2019 12:19:32 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:18:59 +0200
Message-Id: <20190127101908.6428-13-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/21] iwlwifi: update product name for 9260 and 9560
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ihab Zhaika <ihab.zhaika@intel.com>

update the product name for the some of the cards from
the series of 9260 and 9560

Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   6 +
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  29 +++
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   5 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 188 +++++++++---------
 4 files changed, 134 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 285e02e1e7b7..eb93711d474b 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -269,6 +269,12 @@ const struct iwl_cfg iwl9560_2ac_cfg_qu_b0_jf_b0 = {
 	IWL_DEVICE_22500,
 };
 
+const struct iwl_cfg iwl9560_2ac_160_cfg_qu_b0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9560 160MHz",
+	.fw_name_pre = IWL_QU_B_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
 const struct iwl_cfg killer1550i_2ac_cfg_qu_b0_jf_b0 = {
 	.name = "Killer (R) Wireless-AC 1550i Wireless Network Adapter (9560NGW)",
 	.fw_name_pre = IWL_QU_B_JF_B_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index 09618f176f4f..113bcf7735a0 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -163,6 +163,12 @@ const struct iwl_cfg iwl9260_2ac_cfg = {
 	IWL_DEVICE_9000,
 };
 
+const struct iwl_cfg iwl9260_2ac_160_cfg = {
+	.name = "Intel(R) Wireless-AC 9260 160MHz",
+	.fw_name_pre = IWL9260_FW_PRE,
+	IWL_DEVICE_9000,
+};
+
 const struct iwl_cfg iwl9260_killer_2ac_cfg = {
 	.name = "Killer (R) Wireless-AC 1550 Wireless Network Adapter (9260NGW)",
 	.fw_name_pre = IWL9260_FW_PRE,
@@ -211,6 +217,12 @@ const struct iwl_cfg iwl9560_2ac_cfg = {
 	IWL_DEVICE_9000,
 };
 
+const struct iwl_cfg iwl9560_2ac_160_cfg = {
+	.name = "Intel(R) Wireless-AC 9560 160MHz",
+	.fw_name_pre = IWL9260_FW_PRE,
+	IWL_DEVICE_9000,
+};
+
 const struct iwl_cfg iwl9560_2ac_cfg_soc = {
 	.name = "Intel(R) Dual Band Wireless AC 9560",
 	.fw_name_pre = IWL9000_FW_PRE,
@@ -219,6 +231,14 @@ const struct iwl_cfg iwl9560_2ac_cfg_soc = {
 	.soc_latency = 5000,
 };
 
+const struct iwl_cfg iwl9560_2ac_160_cfg_soc = {
+	.name = "Intel(R) Wireless-AC 9560 160MHz",
+	.fw_name_pre = IWL9000_FW_PRE,
+	IWL_DEVICE_9000,
+	.integrated = true,
+	.soc_latency = 5000,
+};
+
 const struct iwl_cfg iwl9560_killer_2ac_cfg_soc = {
 	.name = "Killer (R) Wireless-AC 1550i Wireless Network Adapter (9560NGW)",
 	.fw_name_pre = IWL9000_FW_PRE,
@@ -271,6 +291,15 @@ const struct iwl_cfg iwl9560_2ac_cfg_shared_clk = {
 	.extra_phy_cfg_flags = FW_PHY_CFG_SHARED_CLK
 };
 
+const struct iwl_cfg iwl9560_2ac_160_cfg_shared_clk = {
+	.name = "Intel(R) Wireless-AC 9560 160MHz",
+	.fw_name_pre = IWL9000_FW_PRE,
+	IWL_DEVICE_9000,
+	.integrated = true,
+	.soc_latency = 5000,
+	.extra_phy_cfg_flags = FW_PHY_CFG_SHARED_CLK
+};
+
 const struct iwl_cfg iwl9560_killer_2ac_cfg_shared_clk = {
 	.name = "Killer (R) Wireless-AC 1550i Wireless Network Adapter (9560NGW)",
 	.fw_name_pre = IWL9000_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 7698cadd4ff9..ff942532fac3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -545,20 +545,24 @@ extern const struct iwl_cfg iwl8275_2ac_cfg;
 extern const struct iwl_cfg iwl4165_2ac_cfg;
 extern const struct iwl_cfg iwl9160_2ac_cfg;
 extern const struct iwl_cfg iwl9260_2ac_cfg;
+extern const struct iwl_cfg iwl9260_2ac_160_cfg;
 extern const struct iwl_cfg iwl9260_killer_2ac_cfg;
 extern const struct iwl_cfg iwl9270_2ac_cfg;
 extern const struct iwl_cfg iwl9460_2ac_cfg;
 extern const struct iwl_cfg iwl9560_2ac_cfg;
+extern const struct iwl_cfg iwl9560_2ac_160_cfg;
 extern const struct iwl_cfg iwl9460_2ac_cfg_soc;
 extern const struct iwl_cfg iwl9461_2ac_cfg_soc;
 extern const struct iwl_cfg iwl9462_2ac_cfg_soc;
 extern const struct iwl_cfg iwl9560_2ac_cfg_soc;
+extern const struct iwl_cfg iwl9560_2ac_160_cfg_soc;
 extern const struct iwl_cfg iwl9560_killer_2ac_cfg_soc;
 extern const struct iwl_cfg iwl9560_killer_s_2ac_cfg_soc;
 extern const struct iwl_cfg iwl9460_2ac_cfg_shared_clk;
 extern const struct iwl_cfg iwl9461_2ac_cfg_shared_clk;
 extern const struct iwl_cfg iwl9462_2ac_cfg_shared_clk;
 extern const struct iwl_cfg iwl9560_2ac_cfg_shared_clk;
+extern const struct iwl_cfg iwl9560_2ac_160_cfg_shared_clk;
 extern const struct iwl_cfg iwl9560_killer_2ac_cfg_shared_clk;
 extern const struct iwl_cfg iwl9560_killer_s_2ac_cfg_shared_clk;
 extern const struct iwl_cfg iwl22000_2ac_cfg_hr;
@@ -574,6 +578,7 @@ extern const struct iwl_cfg killer1650w_2ax_cfg;
 extern const struct iwl_cfg iwl9461_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl9462_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl9560_2ac_cfg_qu_b0_jf_b0;
+extern const struct iwl_cfg iwl9560_2ac_160_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg killer1550i_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg killer1550s_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_jf;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 461135f8cef1..a22e47639a4e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -513,10 +513,10 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x24FD, 0x9074, iwl8265_2ac_cfg)},
 
 /* 9000 Series */
-	{IWL_PCI_DEVICE(0x02F0, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0030, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0038, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x003C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x02F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -531,17 +531,17 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x02F0, 0x02A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x2030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x2034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x4030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x02F0, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x02F0, 0x2030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x02F0, 0x2034, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x02F0, 0x4030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x02F0, 0x4034, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x40A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x42A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0030, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0038, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x06F0, 0x003C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x06F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -556,21 +556,21 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x06F0, 0x02A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x06F0, 0x2030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x06F0, 0x2034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x06F0, 0x4030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x06F0, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x06F0, 0x2030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x06F0, 0x2034, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x06F0, 0x4030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x06F0, 0x4034, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x40A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x42A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0014, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0018, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x001C, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0030, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl9260_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0014, iwl9260_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0018, iwl9260_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x001C, iwl9260_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0030, iwl9560_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0034, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x0038, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x003C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x0038, iwl9560_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x003C, iwl9560_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0060, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0064, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x00A0, iwl9460_2ac_cfg)},
@@ -594,26 +594,26 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2526, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x1552, iwl9560_killer_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x1610, iwl9270_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x2030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x2526, 0x2034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x2526, 0x4010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x401C, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x4030, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2526, 0x2030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2526, 0x2034, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2526, 0x4010, iwl9260_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x401C, iwl9260_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x4030, iwl9560_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x4034, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x40A4, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x42A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x2526, 0x8014, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0x8010, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2526, 0xA014, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x8014, iwl9260_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x8010, iwl9260_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0xA014, iwl9260_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x271B, 0x0010, iwl9160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x271B, 0x0014, iwl9160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x271B, 0x0210, iwl9160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x271B, 0x0214, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x271C, 0x0214, iwl9260_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2720, 0x0034, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2720, 0x0038, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2720, 0x003C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x0034, iwl9560_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x0038, iwl9560_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x003C, iwl9560_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -631,17 +631,17 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x1210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x2720, 0x2030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x2720, 0x2034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x2720, 0x4030, iwl9560_2ac_cfg)},
-	{IWL_PCI_DEVICE(0x2720, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2720, 0x2030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2720, 0x2034, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2720, 0x4030, iwl9560_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x4034, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x40A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x42A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0030, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x30DC, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x0038, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x003C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x0038, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x003C, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x30DC, 0x0060, iwl9460_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x30DC, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x30DC, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -659,17 +659,17 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x30DC, 0x1210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x30DC, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x30DC, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x2030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x2034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x4030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x30DC, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x2030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x2034, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x4030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x30DC, 0x4034, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x30DC, 0x40A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x30DC, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x30DC, 0x42A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x31DC, 0x0030, iwl9560_2ac_cfg_shared_clk)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0030, iwl9560_2ac_160_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x0034, iwl9560_2ac_cfg_shared_clk)},
-	{IWL_PCI_DEVICE(0x31DC, 0x0038, iwl9560_2ac_cfg_shared_clk)},
-	{IWL_PCI_DEVICE(0x31DC, 0x003C, iwl9560_2ac_cfg_shared_clk)},
+	{IWL_PCI_DEVICE(0x31DC, 0x0038, iwl9560_2ac_160_cfg_shared_clk)},
+	{IWL_PCI_DEVICE(0x31DC, 0x003C, iwl9560_2ac_160_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x0060, iwl9460_2ac_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x0064, iwl9461_2ac_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x00A0, iwl9462_2ac_cfg_shared_clk)},
@@ -687,18 +687,18 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x31DC, 0x1210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x31DC, 0x1551, iwl9560_killer_s_2ac_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x1552, iwl9560_killer_2ac_cfg_shared_clk)},
-	{IWL_PCI_DEVICE(0x31DC, 0x2030, iwl9560_2ac_cfg_shared_clk)},
-	{IWL_PCI_DEVICE(0x31DC, 0x2034, iwl9560_2ac_cfg_shared_clk)},
-	{IWL_PCI_DEVICE(0x31DC, 0x4030, iwl9560_2ac_cfg_shared_clk)},
-	{IWL_PCI_DEVICE(0x31DC, 0x4034, iwl9560_2ac_cfg_shared_clk)},
+	{IWL_PCI_DEVICE(0x31DC, 0x2030, iwl9560_2ac_160_cfg_shared_clk)},
+	{IWL_PCI_DEVICE(0x31DC, 0x2034, iwl9560_2ac_160_cfg_shared_clk)},
+	{IWL_PCI_DEVICE(0x31DC, 0x4030, iwl9560_2ac_160_cfg_shared_clk)},
+	{IWL_PCI_DEVICE(0x31DC, 0x4034, iwl9560_2ac_160_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x40A4, iwl9462_2ac_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x4234, iwl9560_2ac_cfg_shared_clk)},
 	{IWL_PCI_DEVICE(0x31DC, 0x42A4, iwl9462_2ac_cfg_shared_clk)},
 
-	{IWL_PCI_DEVICE(0x34F0, 0x0030, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0038, iwl9560_2ac_cfg_qu_b0_jf_b0)},
-	{IWL_PCI_DEVICE(0x34F0, 0x003C, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0038, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x003C, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0060, iwl9461_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0064, iwl9461_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x00A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
@@ -713,18 +713,18 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x34F0, 0x02A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x1551, killer1550s_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x1552, killer1550i_2ac_cfg_qu_b0_jf_b0)},
-	{IWL_PCI_DEVICE(0x34F0, 0x2030, iwl9560_2ac_cfg_qu_b0_jf_b0)},
-	{IWL_PCI_DEVICE(0x34F0, 0x2034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
-	{IWL_PCI_DEVICE(0x34F0, 0x4030, iwl9560_2ac_cfg_qu_b0_jf_b0)},
-	{IWL_PCI_DEVICE(0x34F0, 0x4034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x2030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x2034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x4030, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x4034, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x40A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x4234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x42A4, iwl9462_2ac_cfg_qu_b0_jf_b0)},
 
-	{IWL_PCI_DEVICE(0x3DF0, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0030, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x3DF0, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x0038, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x003C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x0038, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x003C, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x3DF0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x3DF0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x3DF0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -742,17 +742,17 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x3DF0, 0x1210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x3DF0, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x3DF0, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x2030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x2034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x4030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x3DF0, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x2030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x2034, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x4030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x3DF0, 0x4034, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x3DF0, 0x40A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x3DF0, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x3DF0, 0x42A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0030, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0038, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x003C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x43F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -770,19 +770,19 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x43F0, 0x1210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x43F0, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x2030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x2034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x4030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x43F0, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x43F0, 0x2030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x43F0, 0x2034, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x43F0, 0x4030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x43F0, 0x4034, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x40A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x42A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0000, iwl9460_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0010, iwl9460_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0030, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x0038, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x003C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x0038, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x003C, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0060, iwl9460_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -808,18 +808,18 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x9DF0, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x1552, iwl9560_killer_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x2010, iwl9460_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x2030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x2034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x2030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x2034, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl9460_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x4030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0x9DF0, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x4030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x9DF0, 0x4034, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x40A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x42A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0030, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0038, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x003C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -837,17 +837,17 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA0F0, 0x1210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x2030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x2034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x4030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x2030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x2034, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x4030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x4034, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x40A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x42A4, iwl9462_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA370, 0x0030, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0030, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA370, 0x0034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA370, 0x0038, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA370, 0x003C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x0038, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x003C, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA370, 0x0060, iwl9460_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA370, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA370, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -865,10 +865,10 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA370, 0x1210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0xA370, 0x1551, iwl9560_killer_s_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA370, 0x1552, iwl9560_killer_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA370, 0x2030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA370, 0x2034, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA370, 0x4030, iwl9560_2ac_cfg_soc)},
-	{IWL_PCI_DEVICE(0xA370, 0x4034, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x2030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x2034, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x4030, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA370, 0x4034, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA370, 0x40A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA370, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA370, 0x42A4, iwl9462_2ac_cfg_soc)},
@@ -891,7 +891,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x06F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x06F0, 0x4070, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0000, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x0030, iwl22000_2ac_cfg_hr_cdb)},
+	{IWL_PCI_DEVICE(0x2720, 0x0030, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x0040, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0070, iwl22000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x0074, iwl22560_2ax_cfg_hr)},
-- 
2.20.1

