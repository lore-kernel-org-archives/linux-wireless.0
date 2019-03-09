Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD28C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D4FD20866
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfCIJWr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 04:22:47 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41788 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725764AbfCIJWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 04:22:47 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2YBo-0000qV-SW; Sat, 09 Mar 2019 11:22:45 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat,  9 Mar 2019 11:22:32 +0200
Message-Id: <20190309092237.10294-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190309092237.10294-1-luca@coelho.fi>
References: <20190309092237.10294-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 3/8] iwlwifi: mvm: report all NO_DATA events to mac80211
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Report all NO_DATA events to mac80211 so they get captured
in radiotap for usage in sniffer scenarios; map the info
type to a reasonable radiotap type for this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  8 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  6 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 31 ++++++++++++-------
 3 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index bca6f6b536d9..dd70bdc27d58 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1650,8 +1650,8 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			struct iwl_rx_cmd_buffer *rxb, int queue);
-void iwl_mvm_rx_monitor_ndp(struct iwl_mvm *mvm, struct napi_struct *napi,
-			    struct iwl_rx_cmd_buffer *rxb, int queue);
+void iwl_mvm_rx_monitor_no_data(struct iwl_mvm *mvm, struct napi_struct *napi,
+				struct iwl_rx_cmd_buffer *rxb, int queue);
 void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm, struct napi_struct *napi,
 			      struct iwl_rx_cmd_buffer *rxb, int queue);
 int iwl_mvm_notify_rx_queue(struct iwl_mvm *mvm, u32 rxq_mask,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ba27dce4c2bb..ad8dea01c638 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1105,7 +1105,7 @@ static void iwl_mvm_rx_mq(struct iwl_op_mode *op_mode,
 	else if (cmd == WIDE_ID(LEGACY_GROUP, FRAME_RELEASE))
 		iwl_mvm_rx_frame_release(mvm, napi, rxb, 0);
 	else if (cmd == WIDE_ID(DATA_PATH_GROUP, RX_NO_DATA_NOTIF))
-		iwl_mvm_rx_monitor_ndp(mvm, napi, rxb, 0);
+		iwl_mvm_rx_monitor_no_data(mvm, napi, rxb, 0);
 	else
 		iwl_mvm_rx_common(mvm, rxb, pkt);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 1e03acf30762..0b1b208de767 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1679,8 +1679,8 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rcu_read_unlock();
 }
 
-void iwl_mvm_rx_monitor_ndp(struct iwl_mvm *mvm, struct napi_struct *napi,
-			    struct iwl_rx_cmd_buffer *rxb, int queue)
+void iwl_mvm_rx_monitor_no_data(struct iwl_mvm *mvm, struct napi_struct *napi,
+				struct iwl_rx_cmd_buffer *rxb, int queue)
 {
 	struct ieee80211_rx_status *rx_status;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
@@ -1701,10 +1701,6 @@ void iwl_mvm_rx_monitor_ndp(struct iwl_mvm *mvm, struct napi_struct *napi,
 	if (unlikely(test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)))
 		return;
 
-	/* Currently only NDP type is supported */
-	if (info_type != RX_NO_DATA_INFO_TYPE_NDP)
-		return;
-
 	energy_a = (rssi & RX_NO_DATA_CHAIN_A_MSK) >> RX_NO_DATA_CHAIN_A_POS;
 	energy_b = (rssi & RX_NO_DATA_CHAIN_B_MSK) >> RX_NO_DATA_CHAIN_B_POS;
 	channel = (rssi & RX_NO_DATA_CHANNEL_MSK) >> RX_NO_DATA_CHANNEL_POS;
@@ -1726,9 +1722,22 @@ void iwl_mvm_rx_monitor_ndp(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	/* 0-length PSDU */
 	rx_status->flag |= RX_FLAG_NO_PSDU;
-	/* currently this is the only type for which we get this notif */
-	rx_status->zero_length_psdu_type =
-		IEEE80211_RADIOTAP_ZERO_LEN_PSDU_SOUNDING;
+
+	switch (info_type) {
+	case RX_NO_DATA_INFO_TYPE_NDP:
+		rx_status->zero_length_psdu_type =
+			IEEE80211_RADIOTAP_ZERO_LEN_PSDU_SOUNDING;
+		break;
+	case RX_NO_DATA_INFO_TYPE_MU_UNMATCHED:
+	case RX_NO_DATA_INFO_TYPE_HE_TB_UNMATCHED:
+		rx_status->zero_length_psdu_type =
+			IEEE80211_RADIOTAP_ZERO_LEN_PSDU_NOT_CAPTURED;
+		break;
+	default:
+		rx_status->zero_length_psdu_type =
+			IEEE80211_RADIOTAP_ZERO_LEN_PSDU_VENDOR;
+		break;
+	}
 
 	/* This may be overridden by iwl_mvm_rx_he() to HE_RU */
 	switch (rate_n_flags & RATE_MCS_CHAN_WIDTH_MSK) {
-- 
2.20.1

