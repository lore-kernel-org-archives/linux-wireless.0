Return-Path: <SRS0=u4Rx=5I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_50_75,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33991C4332B
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 13:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 073DC20722
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Mar 2020 13:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgCWNUU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:20:20 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:43464 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728372AbgCWNUU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Mar 2020 09:20:20 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jGMzW-00023f-Jk; Mon, 23 Mar 2020 15:19:42 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 23 Mar 2020 15:19:22 +0200
Message-Id: <iwlwifi.20200323151304.33326d1b70b4.Ib1afb7b0c89e9dc2d26e6d32ea19e978c17ba1dd@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323131925.208376-1-luca@coelho.fi>
References: <20200323131925.208376-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/14] iwlwifi: add HW step to new cfg device table
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We need to use different firmware versions for different HW steps with
certain devices.  Prepare for this differentiation by adding HW step
to the new device table.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 67 +++++++++++++------
 2 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 09eec2ef1b07..13f38c21cbd7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -488,6 +488,7 @@ struct iwl_dev_info {
 	u16 subdevice;
 	u16 mac_type;
 	u16 rf_type;
+	u8 mac_step;
 	u8 rf_id;
 	u8 no_160;
 	u8 cores;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 76c8df244dba..ee692e45bdb3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -807,15 +807,17 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 
-#define _IWL_DEV_INFO(_device, _subdevice, _mac_type, _rf_type, _rf_id,    \
-		      _no_160, _cores, _cfg, _name)			   \
+#define _IWL_DEV_INFO(_device, _subdevice, _mac_type, _mac_step, _rf_type, \
+		      _rf_id, _no_160, _cores, _cfg, _name)		   \
 	{ .device = (_device), .subdevice = (_subdevice), .cfg = &(_cfg),  \
 	  .name = _name, .mac_type = _mac_type, .rf_type = _rf_type,	   \
-	  .no_160 = _no_160, .cores = _cores, .rf_id = _rf_id, }
+	  .no_160 = _no_160, .cores = _cores, .rf_id = _rf_id,		   \
+	  .mac_step = _mac_step }
 
 #define IWL_DEV_INFO(_device, _subdevice, _cfg, _name) \
 	_IWL_DEV_INFO(_device, _subdevice, IWL_CFG_ANY, IWL_CFG_ANY,	   \
-		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY, _cfg, _name)
+		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_ANY,  \
+		      _cfg, _name)
 
 static const struct iwl_dev_info iwl_dev_info_table[] = {
 #if IS_ENABLED(CONFIG_IWLMVM)
@@ -831,81 +833,99 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x271C, 0x0214, iwl9260_2ac_cfg, iwl9260_1_name),
 
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
 		      IWL_CFG_160, IWL_CFG_CORES_BT,
 		      iwl9560_2ac_cfg_soc, iwl9461_160_name),
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
 		      IWL_CFG_NO_160, IWL_CFG_CORES_BT,
 		      iwl9560_2ac_cfg_soc, iwl9461_name),
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
 		      IWL_CFG_160, IWL_CFG_CORES_BT,
 		      iwl9560_2ac_cfg_soc, iwl9462_160_name),
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
 		      IWL_CFG_NO_160, IWL_CFG_CORES_BT,
 		      iwl9560_2ac_cfg_soc, iwl9462_name),
 
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
 		      IWL_CFG_160, IWL_CFG_CORES_BT,
 		      iwl9560_2ac_cfg_soc, iwl9560_160_name),
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
 		      IWL_CFG_NO_160, IWL_CFG_CORES_BT,
 		      iwl9560_2ac_cfg_soc, iwl9560_name),
 
 	_IWL_DEV_INFO(0x2526, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
 		      IWL_CFG_160, IWL_CFG_CORES_BT,
 		      iwl9260_2ac_cfg, iwl9461_160_name),
 	_IWL_DEV_INFO(0x2526, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
 		      IWL_CFG_NO_160, IWL_CFG_CORES_BT,
 		      iwl9260_2ac_cfg, iwl9461_name),
 	_IWL_DEV_INFO(0x2526, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
 		      IWL_CFG_160, IWL_CFG_CORES_BT,
 		      iwl9260_2ac_cfg, iwl9462_160_name),
 	_IWL_DEV_INFO(0x2526, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
 		      IWL_CFG_NO_160, IWL_CFG_CORES_BT,
 		      iwl9260_2ac_cfg, iwl9462_name),
 
 	_IWL_DEV_INFO(0x2526, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
 		      IWL_CFG_160, IWL_CFG_CORES_BT,
 		      iwl9260_2ac_cfg, iwl9560_160_name),
 	_IWL_DEV_INFO(0x2526, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_MAC_TYPE_PNJ, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
 		      IWL_CFG_NO_160, IWL_CFG_CORES_BT,
 		      iwl9260_2ac_cfg, iwl9560_name),
 
 	_IWL_DEV_INFO(0x2526, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_RF_TYPE_TH, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_TH, IWL_CFG_ANY,
 		      IWL_CFG_160, IWL_CFG_CORES_BT_GNSS,
 		      iwl9260_2ac_cfg, iwl9270_160_name),
 	_IWL_DEV_INFO(0x2526, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_RF_TYPE_TH, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_TH, IWL_CFG_ANY,
 		      IWL_CFG_NO_160, IWL_CFG_CORES_BT_GNSS,
 		      iwl9260_2ac_cfg, iwl9270_name),
 
 	_IWL_DEV_INFO(0x271B, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_RF_TYPE_TH1, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_TH1, IWL_CFG_ANY,
 		      IWL_CFG_160, IWL_CFG_CORES_BT,
 		      iwl9260_2ac_cfg, iwl9162_160_name),
 	_IWL_DEV_INFO(0x271B, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_RF_TYPE_TH1, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_TH1, IWL_CFG_ANY,
 		      IWL_CFG_NO_160, IWL_CFG_CORES_BT,
 		      iwl9260_2ac_cfg, iwl9162_name),
 
 	_IWL_DEV_INFO(0x2526, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_RF_TYPE_TH, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_TH, IWL_CFG_ANY,
 		      IWL_CFG_160, IWL_CFG_CORES_BT,
 		      iwl9260_2ac_cfg, iwl9260_160_name),
 	_IWL_DEV_INFO(0x2526, IWL_CFG_ANY,
-		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_RF_TYPE_TH, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_TH, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_TH, IWL_CFG_ANY,
 		      IWL_CFG_NO_160, IWL_CFG_CORES_BT,
 		      iwl9260_2ac_cfg, iwl9260_name),
 
@@ -960,6 +980,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		    (dev_info->mac_type == (u16)IWL_CFG_ANY ||
 		     dev_info->mac_type ==
 		     CSR_HW_REV_TYPE(iwl_trans->hw_rev)) &&
+		    (dev_info->mac_step == (u8)IWL_CFG_ANY ||
+		     dev_info->mac_step ==
+		     CSR_HW_REV_STEP(iwl_trans->hw_rev)) &&
 		    (dev_info->rf_type == (u16)IWL_CFG_ANY ||
 		     dev_info->rf_type ==
 		     CSR_HW_RFID_TYPE(iwl_trans->hw_rf_id)) &&
-- 
2.25.1

