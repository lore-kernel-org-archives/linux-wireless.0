Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC289C07EBF
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D79D2086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbfARTAX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:00:23 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48378 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729200AbfARTAW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:00:22 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNM-0004cj-0B; Fri, 18 Jan 2019 21:00:20 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 20:59:57 +0200
Message-Id: <20190118190004.22270-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/16] iwlwifi: add new cards for 22560, 9260 and killer series
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ihab Zhaika <ihab.zhaika@intel.com>

add few PCI ID'S for 22560, 9260 and killer series.

Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 24 ++++++++++
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  2 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 46 +++++++++++++++++--
 3 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 310bef797a43..285e02e1e7b7 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -281,6 +281,30 @@ const struct iwl_cfg killer1550s_2ac_cfg_qu_b0_jf_b0 = {
 	IWL_DEVICE_22500,
 };
 
+const struct iwl_cfg killer1650s_2ax_cfg_qu_b0_hr_b0 = {
+	.name = "Killer(R) Wireless-AX 1650i Wireless Network Adapter (22560NGW)",
+	.fw_name_pre = IWL_22000_QU_B_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
+const struct iwl_cfg killer1650i_2ax_cfg_qu_b0_hr_b0 = {
+	.name = "Killer(R) Wireless-AX 1650s Wireless Network Adapter (22560D2W)",
+	.fw_name_pre = IWL_22000_QU_B_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
 const struct iwl_cfg iwl22000_2ax_cfg_jf = {
 	.name = "Intel(R) Dual Band Wireless AX 22000",
 	.fw_name_pre = IWL_QU_B_JF_B_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 6695aa8fbfba..e50cf8c88dfd 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -573,6 +573,8 @@ extern const struct iwl_cfg iwl22000_2ac_cfg_jf;
 extern const struct iwl_cfg iwl22560_2ax_cfg_hr;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
 extern const struct iwl_cfg iwl22260_2ax_cfg;
+extern const struct iwl_cfg killer1650s_2ax_cfg_qu_b0_hr_b0;
+extern const struct iwl_cfg killer1650i_2ax_cfg_qu_b0_hr_b0;
 extern const struct iwl_cfg killer1650x_2ax_cfg;
 extern const struct iwl_cfg killer1650w_2ax_cfg;
 extern const struct iwl_cfg iwl9461_2ac_cfg_qu_b0_jf_b0;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 6694efc6a431..461135f8cef1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -566,6 +566,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2526, 0x0010, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0014, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0018, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x001C, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0030, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0034, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x0038, iwl9560_2ac_cfg)},
@@ -596,12 +597,14 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2526, 0x2030, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x2034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x4010, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x401C, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4030, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x40A4, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x42A4, iwl9462_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x8014, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x8010, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0xA014, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x271B, 0x0010, iwl9160_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x271B, 0x0014, iwl9160_2ac_cfg)},
@@ -871,18 +874,45 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xA370, 0x42A4, iwl9462_2ac_cfg_soc)},
 
 /* 22000 Series */
+	{IWL_PCI_DEVICE(0x02F0, 0x0070, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0074, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0078, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x007C, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x0310, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x02F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x02F0, 0x4070, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0070, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0074, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0078, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x007C, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x0310, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x06F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x06F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x06F0, 0x4070, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0000, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0030, iwl22000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x0040, iwl22560_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x0078, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0070, iwl22000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x2720, 0x0030, iwl22000_2ac_cfg_hr_cdb)},
-	{IWL_PCI_DEVICE(0x2720, 0x1080, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0074, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0078, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x007C, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0090, iwl22000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x0310, iwl22000_2ac_cfg_hr_cdb)},
+	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwl22000_2ac_cfg_hr_cdb)},
+	{IWL_PCI_DEVICE(0x2720, 0x1080, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x2720, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x2720, 0x4070, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0040, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x0074, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0078, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x007C, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x34F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x34F0, 0x4070, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0000, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40C0, 0x0010, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x40c0, 0x0090, iwl22560_2ax_cfg_su_cdb)},
@@ -890,13 +920,23 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x40C0, 0x0A10, iwl22560_2ax_cfg_su_cdb)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0040, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0070, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x0074, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x43F0, 0x0078, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x007C, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x43F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0x43F0, 0x4070, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0040, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0070, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x0074, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0078, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x007C, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x00B0, iwl22560_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0xA0F0, 0x0A10, iwl22560_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x1651, killer1650s_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0)},
+	{IWL_PCI_DEVICE(0xA0F0, 0x4070, iwl22560_2ax_cfg_hr)},
 
 	{IWL_PCI_DEVICE(0x2723, 0x0080, iwl22260_2ax_cfg)},
 	{IWL_PCI_DEVICE(0x2723, 0x0084, iwl22260_2ax_cfg)},
-- 
2.20.1

