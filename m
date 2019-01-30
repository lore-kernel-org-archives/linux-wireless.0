Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UPPERCASE_50_75,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B01C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3116820855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbfA3Lzy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:55:54 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52784 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730765AbfA3Lzy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:55:54 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooTA-0003x8-5U; Wed, 30 Jan 2019 13:55:52 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:20 +0200
Message-Id: <20190130115528.19922-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/17] iwlwifi: dbg_ini: update ini triggers enum
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Align the triggers enum in the driver to the one in the FW.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   | 92 +++++++++----------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index 2b4b902cffc4..422f4333ba35 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -217,15 +217,12 @@ struct iwl_fw_ini_trigger_tlv {
 /**
  * enum iwl_fw_ini_trigger_id
  * @IWL_FW_TRIGGER_ID_FW_ASSERT: FW assert
- * @IWL_FW_TRIGGER_ID_FW_TFD_Q_HANG: TFD queue hang
  * @IWL_FW_TRIGGER_ID_FW_HW_ERROR: HW assert
- * @IWL_FW_TRIGGER_ID_FW_TRIGGER_ERROR: FW error notification
- * @IWL_FW_TRIGGER_ID_FW_TRIGGER_WARNING: FW warning notification
- * @IWL_FW_TRIGGER_ID_FW_TRIGGER_INFO: FW info notification
- * @IWL_FW_TRIGGER_ID_FW_TRIGGER_DEBUG: FW debug notification
+ * @IWL_FW_TRIGGER_ID_FW_TFD_Q_HANG: TFD queue hang
+ * @IWL_FW_TRIGGER_ID_FW_DEBUG_HOST_TRIGGER: FW debug notification
+ * @IWL_FW_TRIGGER_ID_FW_GENERIC_NOTIFOCATION: FW generic notification
  * @IWL_FW_TRIGGER_ID_USER_TRIGGER: User trigger
  * @IWL_FW_TRIGGER_ID_HOST_PEER_CLIENT_INACTIVITY: peer inactivity
- * @FW_DEBUG_TLV_TRIGGER_ID_HOST_DID_INITIATED_EVENT: undefined
  * @IWL_FW_TRIGGER_ID_HOST_TX_LATENCY_THRESHOLD_CROSSED: TX latency
  *	threshold was crossed
  * @IWL_FW_TRIGGER_ID_HOST_TX_RESPONSE_STATUS_FAILED: TX failed
@@ -259,50 +256,53 @@ struct iwl_fw_ini_trigger_tlv {
  * @IWL_FW_TRIGGER_ID_NUM: number of trigger IDs
  */
 enum iwl_fw_ini_trigger_id {
+	IWL_FW_TRIGGER_ID_INVALID				= 0,
+
 	/* Errors triggers */
 	IWL_FW_TRIGGER_ID_FW_ASSERT				= 1,
-	IWL_FW_TRIGGER_ID_FW_TFD_Q_HANG				= 2,
-	IWL_FW_TRIGGER_ID_FW_HW_ERROR				= 3,
-	/* Generic triggers */
-	IWL_FW_TRIGGER_ID_FW_TRIGGER_ERROR			= 4,
-	IWL_FW_TRIGGER_ID_FW_TRIGGER_WARNING			= 5,
-	IWL_FW_TRIGGER_ID_FW_TRIGGER_INFO			= 6,
-	IWL_FW_TRIGGER_ID_FW_TRIGGER_DEBUG			= 7,
-	/* User Trigger */
-	IWL_FW_TRIGGER_ID_USER_TRIGGER				= 8,
+	IWL_FW_TRIGGER_ID_FW_HW_ERROR				= 2,
+	IWL_FW_TRIGGER_ID_FW_TFD_Q_HANG				= 3,
+
+	/* FW triggers */
+	IWL_FW_TRIGGER_ID_FW_DEBUG_HOST_TRIGGER			= 4,
+	IWL_FW_TRIGGER_ID_FW_GENERIC_NOTIFOCATION		= 5,
+
+	/* User trigger */
+	IWL_FW_TRIGGER_ID_USER_TRIGGER				= 6,
+
 	/* Host triggers */
-	IWL_FW_TRIGGER_ID_HOST_PEER_CLIENT_INACTIVITY		= 9,
-	IWL_FW_TRIGGER_ID_HOST_DID_INITIATED_EVENT		= 10,
-	IWL_FW_TRIGGER_ID_HOST_TX_LATENCY_THRESHOLD_CROSSED	= 11,
-	IWL_FW_TRIGGER_ID_HOST_TX_RESPONSE_STATUS_FAILED	= 12,
-	IWL_FW_TRIGGER_ID_HOST_OS_REQ_DEAUTH_PEER		= 13,
-	IWL_FW_TRIGGER_ID_HOST_STOP_GO_REQUEST			= 14,
-	IWL_FW_TRIGGER_ID_HOST_START_GO_REQUEST			= 15,
-	IWL_FW_TRIGGER_ID_HOST_JOIN_GROUP_REQUEST		= 16,
-	IWL_FW_TRIGGER_ID_HOST_SCAN_START			= 17,
-	IWL_FW_TRIGGER_ID_HOST_SCAN_SUBITTED			= 18,
-	IWL_FW_TRIGGER_ID_HOST_SCAN_PARAMS			= 19,
-	IWL_FW_TRIGGER_ID_HOST_CHECK_FOR_HANG			= 20,
-	IWL_FW_TRIGGER_ID_HOST_BAR_RECEIVED			= 21,
-	IWL_FW_TRIGGER_ID_HOST_AGG_TX_RESPONSE_STATUS_FAILED	= 22,
-	IWL_FW_TRIGGER_ID_HOST_EAPOL_TX_RESPONSE_FAILED		= 23,
-	IWL_FW_TRIGGER_ID_HOST_FAKE_TX_RESPONSE_SUSPECTED	= 24,
-	IWL_FW_TRIGGER_ID_HOST_AUTH_REQ_FROM_ASSOC_CLIENT	= 25,
-	IWL_FW_TRIGGER_ID_HOST_ROAM_COMPLETE			= 26,
-	IWL_FW_TRIGGER_ID_HOST_AUTH_ASSOC_FAST_FAILED		= 27,
-	IWL_FW_TRIGGER_ID_HOST_D3_START				= 28,
-	IWL_FW_TRIGGER_ID_HOST_D3_END				= 29,
-	IWL_FW_TRIGGER_ID_HOST_BSS_MISSED_BEACONS		= 30,
-	IWL_FW_TRIGGER_ID_HOST_P2P_CLIENT_MISSED_BEACONS	= 31,
-	IWL_FW_TRIGGER_ID_HOST_PEER_CLIENT_TX_FAILURES		= 32,
-	IWL_FW_TRIGGER_ID_HOST_TX_WFD_ACTION_FRAME_FAILED	= 33,
-	IWL_FW_TRIGGER_ID_HOST_AUTH_ASSOC_FAILED		= 34,
-	IWL_FW_TRIGGER_ID_HOST_SCAN_COMPLETE			= 35,
-	IWL_FW_TRIGGER_ID_HOST_SCAN_ABORT			= 36,
-	IWL_FW_TRIGGER_ID_HOST_NIC_ALIVE			= 37,
-	IWL_FW_TRIGGER_ID_HOST_CHANNEL_SWITCH_COMPLETE          = 38,
+	IWL_FW_TRIGGER_ID_HOST_PEER_CLIENT_INACTIVITY		= 7,
+	IWL_FW_TRIGGER_ID_HOST_TX_LATENCY_THRESHOLD_CROSSED	= 8,
+	IWL_FW_TRIGGER_ID_HOST_TX_RESPONSE_STATUS_FAILED	= 9,
+	IWL_FW_TRIGGER_ID_HOST_OS_REQ_DEAUTH_PEER		= 10,
+	IWL_FW_TRIGGER_ID_HOST_STOP_GO_REQUEST			= 11,
+	IWL_FW_TRIGGER_ID_HOST_START_GO_REQUEST			= 12,
+	IWL_FW_TRIGGER_ID_HOST_JOIN_GROUP_REQUEST		= 13,
+	IWL_FW_TRIGGER_ID_HOST_SCAN_START			= 14,
+	IWL_FW_TRIGGER_ID_HOST_SCAN_SUBMITTED			= 15,
+	IWL_FW_TRIGGER_ID_HOST_SCAN_PARAMS			= 16,
+	IWL_FW_TRIGGER_ID_HOST_CHECK_FOR_HANG			= 17,
+	IWL_FW_TRIGGER_ID_HOST_BAR_RECEIVED			= 18,
+	IWL_FW_TRIGGER_ID_HOST_AGG_TX_RESPONSE_STATUS_FAILED	= 19,
+	IWL_FW_TRIGGER_ID_HOST_EAPOL_TX_RESPONSE_FAILED		= 20,
+	IWL_FW_TRIGGER_ID_HOST_FAKE_TX_RESPONSE_SUSPECTED	= 21,
+	IWL_FW_TRIGGER_ID_HOST_AUTH_REQ_FROM_ASSOC_CLIENT	= 22,
+	IWL_FW_TRIGGER_ID_HOST_ROAM_COMPLETE			= 23,
+	IWL_FW_TRIGGER_ID_HOST_AUTH_ASSOC_FAST_FAILED		= 24,
+	IWL_FW_TRIGGER_ID_HOST_D3_START				= 25,
+	IWL_FW_TRIGGER_ID_HOST_D3_END				= 26,
+	IWL_FW_TRIGGER_ID_HOST_BSS_MISSED_BEACONS		= 27,
+	IWL_FW_TRIGGER_ID_HOST_P2P_CLIENT_MISSED_BEACONS	= 28,
+	IWL_FW_TRIGGER_ID_HOST_PEER_CLIENT_TX_FAILURES		= 29,
+	IWL_FW_TRIGGER_ID_HOST_TX_WFD_ACTION_FRAME_FAILED	= 30,
+	IWL_FW_TRIGGER_ID_HOST_AUTH_ASSOC_FAILED		= 31,
+	IWL_FW_TRIGGER_ID_HOST_SCAN_COMPLETE			= 32,
+	IWL_FW_TRIGGER_ID_HOST_SCAN_ABORT			= 33,
+	IWL_FW_TRIGGER_ID_HOST_NIC_ALIVE			= 34,
+	IWL_FW_TRIGGER_ID_HOST_CHANNEL_SWITCH_COMPLETE		= 35,
+
 	IWL_FW_TRIGGER_ID_NUM,
-}; /* FW_INI_TRIGGER_ID_E_VER_1 */
+}; /* FW_DEBUG_TLV_TRIGGER_ID_E_VER_1 */
 
 /**
  * enum iwl_fw_ini_apply_point
-- 
2.20.1

