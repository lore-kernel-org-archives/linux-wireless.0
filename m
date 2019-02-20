Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBDCC4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9179206DD
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfBTMES (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:04:18 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34558 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727542AbfBTMER (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:04:17 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwQbl-000411-Aj; Wed, 20 Feb 2019 14:04:14 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 20 Feb 2019 14:04:00 +0200
Message-Id: <20190220120400.8814-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190220120400.8814-1-luca@coelho.fi>
References: <20190220120400.8814-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 8/8] iwlwifi: add new cards for 22000 and killer series and change the market name
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ihab Zhaika <ihab.zhaika@intel.com>

Add a few PCI ID'S for 22000 and killer series in addition to
chainging the marketing name.

Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  8 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 98 +++++++++++--------
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  4 +-
 4 files changed, 64 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 2d472a04807f..fdc56f821b5a 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -223,8 +223,8 @@ const struct iwl_cfg iwl22000_2ac_cfg_jf = {
 	IWL_DEVICE_22500,
 };
 
-const struct iwl_cfg iwl22560_2ax_cfg_hr = {
-	.name = "Intel(R) Wireless-AX 22560",
+const struct iwl_cfg iwl_ax101_cfg_qu_hr = {
+	.name = "Intel(R) Wi-Fi 6 AX101",
 	.fw_name_pre = IWL_22000_QU_B_HR_B_FW_PRE,
 	IWL_DEVICE_22500,
 	/*
@@ -249,7 +249,7 @@ const struct iwl_cfg iwl22260_2ax_cfg = {
 };
 
 const struct iwl_cfg killer1650x_2ax_cfg = {
-	.name = "Killer(R) Wireless-AX 1650x Wireless Network Adapter (22260NGW)",
+	.name = "Killer(R) Wireless-AX 1650x Wireless Network Adapter (200NGW)",
 	.fw_name_pre = IWL_CC_A_FW_PRE,
 	IWL_DEVICE_22500,
 	/*
@@ -262,7 +262,7 @@ const struct iwl_cfg killer1650x_2ax_cfg = {
 };
 
 const struct iwl_cfg killer1650w_2ax_cfg = {
-	.name = "Killer(R) Wireless-AX 1650w Wireless Network Adapter (22260D2W)",
+	.name = "Killer(R) Wireless-AX 1650w Wireless Network Adapter (200D2W)",
 	.fw_name_pre = IWL_CC_A_FW_PRE,
 	IWL_DEVICE_22500,
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 7f2fa5cc8c2c..f5f87773667b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -548,7 +548,7 @@ extern const struct iwl_cfg iwl9560_killer_s_2ac_cfg_shared_clk;
 extern const struct iwl_cfg iwl22000_2ac_cfg_hr;
 extern const struct iwl_cfg iwl22000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwl22000_2ac_cfg_jf;
-extern const struct iwl_cfg iwl22560_2ax_cfg_hr;
+extern const struct iwl_cfg iwl_ax101_cfg_qu_hr;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
 extern const struct iwl_cfg iwl22260_2ax_cfg;
 extern const struct iwl_cfg killer1650s_2ax_cfg_qu_b0_hr_b0;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index fb7a0def9355..2b94e4cef56c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -517,6 +517,8 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x02F0, 0x0034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0040, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -525,6 +527,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x02F0, 0x0234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0238, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x023C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0260, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x0264, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x02F0, 0x02A0, iwl9462_2ac_cfg_soc)},
@@ -542,6 +545,8 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x06F0, 0x0034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0040, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -550,6 +555,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x06F0, 0x0234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0238, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x023C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0260, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x0264, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x06F0, 0x02A0, iwl9462_2ac_cfg_soc)},
@@ -615,6 +621,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x0034, iwl9560_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x0038, iwl9560_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x003C, iwl9560_2ac_160_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -623,6 +630,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x0234, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x0238, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2720, 0x023C, iwl9560_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2720, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0260, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x0264, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2720, 0x02A0, iwl9462_2ac_cfg_soc)},
@@ -700,6 +708,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x34F0, 0x0034, iwl9560_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0038, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x003C, iwl9560_2ac_160_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0060, iwl9461_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0064, iwl9461_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x00A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
@@ -708,6 +717,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x34F0, 0x0234, iwl9560_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0238, iwl9560_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x023C, iwl9560_2ac_cfg_qu_b0_jf_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0260, iwl9461_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0264, iwl9461_2ac_cfg_qu_b0_jf_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x02A0, iwl9462_2ac_cfg_qu_b0_jf_b0)},
@@ -754,6 +764,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x43F0, 0x0034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -762,6 +773,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x43F0, 0x0234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0238, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x023C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0260, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0264, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x43F0, 0x02A0, iwl9462_2ac_cfg_soc)},
@@ -821,6 +833,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA0F0, 0x0034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0038, iwl9560_2ac_160_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x003C, iwl9560_2ac_160_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0044, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0060, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0064, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x00A0, iwl9462_2ac_cfg_soc)},
@@ -829,6 +842,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA0F0, 0x0234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0238, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x023C, iwl9560_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0244, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0260, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0264, iwl9461_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x02A0, iwl9462_2ac_cfg_soc)},
@@ -876,73 +890,75 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x0030, iwl9560_2ac_cfg_qnj_jf_b0)},
 
 /* 22000 Series */
-	{IWL_PCI_DEVICE(0x02F0, 0x0070, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0074, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0078, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x02F0, 0x007C, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x02F0, 0x0310, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0070, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0074, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0078, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x007C, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0310, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x02F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x02F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
-	{IWL_PCI_DEVICE(0x02F0, 0x4070, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0070, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0074, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0078, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x007C, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x06F0, 0x0310, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x4070, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0070, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0074, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0078, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x007C, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0310, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x06F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x06F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
-	{IWL_PCI_DEVICE(0x06F0, 0x4070, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x0000, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x0040, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x4070, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0000, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0040, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0070, iwl22000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x2720, 0x0074, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x0078, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x007C, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0074, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0078, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x007C, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0090, iwl22000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x0310, iwl22000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwl22000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x2720, 0x1080, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x1080, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x2720, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
-	{IWL_PCI_DEVICE(0x2720, 0x4070, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0040, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0074, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0078, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x007C, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x4070, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0040, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0074, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0078, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x007C, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x34F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
-	{IWL_PCI_DEVICE(0x34F0, 0x4070, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x4070, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0000, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0010, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40c0, 0x0090, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0310, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0A10, iwl22560_2ax_cfg_su_cdb)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0040, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0070, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0074, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x0078, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x43F0, 0x007C, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0040, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0070, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0074, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0078, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x007C, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0x43F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
-	{IWL_PCI_DEVICE(0x43F0, 0x4070, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0040, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0070, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0074, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0078, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x007C, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x00B0, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x0A10, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x4070, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0040, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0070, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0074, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0078, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x007C, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x00B0, iwl_ax101_cfg_qu_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0A10, iwl_ax101_cfg_qu_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
-	{IWL_PCI_DEVICE(0xA0F0, 0x4070, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x4070, iwl_ax101_cfg_qu_hr)},
 
 	{IWL_PCI_DEVICE(0x2723, 0x0080, iwl22260_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x0084, iwl22260_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x0088, iwl22260_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x008C, iwl22260_2ax_cfg)},
+	{IWL_PCI_DEVICE(0x2723, 0x1653, killer1650w_2ax_cfg)},
+	{IWL_PCI_DEVICE(0x2723, 0x1654, killer1650x_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x4080, iwl22260_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x4088, iwl22260_2ax_cfg)},
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e2579a0bcc25..fe8269d023de 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3540,10 +3540,10 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 			   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_GF)) {
 			trans->cfg = &iwlax210_2ax_cfg_so_gf_a0;
 		}
-	} else if (cfg == &iwl22560_2ax_cfg_hr) {
+	} else if (cfg == &iwl_ax101_cfg_qu_hr) {
 		if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		    CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR)) {
-			trans->cfg = &iwl22560_2ax_cfg_hr;
+			trans->cfg = &iwl_ax101_cfg_qu_hr;
 		} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 			   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_JF)) {
 			trans->cfg = &iwl22000_2ax_cfg_jf;
-- 
2.20.1

