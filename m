Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981B4C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73F3A20882
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbfA3L4G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:56:06 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52820 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727050AbfA3L4G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:56:06 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooTF-0003x8-U4; Wed, 30 Jan 2019 13:55:58 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:26 +0200
Message-Id: <20190130115528.19922-16-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/17] iwlwifi: dvm: fix some fall through warnings
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Some case statements were missing a comment about falling through or
had more text than the compiler can recognize.  Fix that.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c   | 6 ++++--
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 6f17a5e24e82..e224b23f0ba8 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -2,6 +2,7 @@
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2018 Intel Corporation
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portionhelp of the ieee80211 subsystem header files.
@@ -592,7 +593,7 @@ static int iwlagn_set_decrypted_flag(struct iwl_priv *priv,
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_BAD_KEY_TTAK)
 			break;
-
+		/* fall through */
 	case RX_RES_STATUS_SEC_TYPE_WEP:
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_BAD_ICV_MIC) {
@@ -601,6 +602,7 @@ static int iwlagn_set_decrypted_flag(struct iwl_priv *priv,
 			IWL_DEBUG_RX(priv, "Packet destroyed\n");
 			return -1;
 		}
+		/* fall through */
 	case RX_RES_STATUS_SEC_TYPE_CCMP:
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_DECRYPT_OK) {
@@ -729,7 +731,7 @@ static u32 iwlagn_translate_rx_status(struct iwl_priv *priv, u32 decrypt_in)
 			decrypt_out |= RX_RES_STATUS_BAD_KEY_TTAK;
 			break;
 		}
-		/* fall through if TTAK OK */
+		/* fall through */
 	default:
 		if (!(decrypt_in & RX_MPDU_RES_STATUS_ICV_OK))
 			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
index 8d7aafb4d9e9..f190f7beb3a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
@@ -3,6 +3,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -418,7 +419,7 @@ static u16 iwl_limit_dwell(struct iwl_priv *priv, u16 dwell_time)
 		limit = (limits[1] * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
 		limit /= 2;
 		dwell_time = min(limit, dwell_time);
-		/* fall through to limit further */
+		/* fall through */
 	case 1:
 		limit = (limits[0] * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
 		limit /= n_active;
-- 
2.20.1

