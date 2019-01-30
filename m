Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1CBC282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6652420855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbfA3L4T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:56:19 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52846 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730226AbfA3L4T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:56:19 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooTG-0003x8-KR; Wed, 30 Jan 2019 13:55:59 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:27 +0200
Message-Id: <20190130115528.19922-17-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/17] iwlwifi: mvm: add fall through comments where needed
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Some switch-cases were missing a fall through comment, so the compiler
may warn.  Fix that by adding the comments where needed.  In other
cases there was more text in the comment, which the compiler doesn't
recognize, so either remove the extra text or move it to a separate
comment line as appropriate.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/led.c      | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c       | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     | 6 +++---
 6 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/led.c b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
index 9bb1de1cad64..4348bb00e761 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2017        Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -28,6 +29,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2017        Intel Deutschland GmbH
+ * Copyright(c) 2018        Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -113,6 +115,7 @@ int iwl_mvm_leds_init(struct iwl_mvm *mvm)
 	switch (mode) {
 	case IWL_LED_BLINK:
 		IWL_ERR(mvm, "Blink led mode not supported, used default\n");
+		/* fall through */
 	case IWL_LED_DEFAULT:
 	case IWL_LED_RF_STATE:
 		mode = IWL_LED_RF_STATE;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 8837d7667f36..4e676a6936c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3901,6 +3901,7 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 			mvmvif->ap_ibss_active = true;
 			break;
 		}
+		/* fall through */
 	case NL80211_IFTYPE_ADHOC:
 		/*
 		 * The AP binding flow is handled as part of the start_ap flow
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index f369173db11c..86e40bae57e3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -109,6 +109,7 @@ u8 iwl_mvm_get_ctrl_pos(struct cfg80211_chan_def *chandef)
 		return PHY_VHT_CTRL_POS_4_ABOVE;
 	default:
 		WARN(1, "Invalid channel definition");
+		/* fall through */
 	case 0:
 		/*
 		 * The FW is expected to check the control channel position only
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 235ab26ca429..fbd3014e8b82 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -222,7 +222,7 @@ static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
 		    !(rx_pkt_status & RX_MPDU_RES_STATUS_TTAK_OK))
 			return 0;
 		*crypt_len = IEEE80211_TKIP_IV_LEN;
-		/* fall through if TTAK OK */
+		/* fall through */
 
 	case RX_MPDU_RES_STATUS_SEC_WEP_ENC:
 		if (!(rx_pkt_status & RX_MPDU_RES_STATUS_ICV_OK))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 79860f6ac7ca..995847e1cd7d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -310,7 +310,7 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			stats->flag |= RX_FLAG_MMIC_ERROR;
 
 		*crypt_len = IEEE80211_TKIP_IV_LEN;
-		/* fall through if TTAK OK */
+		/* fall through */
 	case IWL_RX_MPDU_STATUS_SEC_WEP:
 		if (!(status & IWL_RX_MPDU_STATUS_ICV_OK))
 			return -1;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index af8156ba8084..853bf679dc26 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1616,10 +1616,10 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 		if (mvm->scan_status & IWL_MVM_SCAN_SCHED_MASK)
 			return iwl_mvm_scan_stop(mvm, IWL_MVM_SCAN_SCHED,
 						 true);
-
-		/* fall through, something is wrong if no scan was
-		 * running but we ran out of scans.
+		/* Something is wrong if no scan was running but we
+		 * ran out of scans.
 		 */
+		/* fall through */
 	default:
 		WARN_ON(1);
 		break;
-- 
2.20.1

