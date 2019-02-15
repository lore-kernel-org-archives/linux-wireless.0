Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A13C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1B7D21929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfBOLuJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:50:09 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60552 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727717AbfBOLuJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:50:09 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gubzx-0008TN-77; Fri, 15 Feb 2019 13:49:41 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Feb 2019 13:49:17 +0200
Message-Id: <20190215114924.2545-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/20] iwlwifi: mvm: support non-transmitting AP
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Add an option to not send beacons and probe responses. This is
used for testing multiple-bssid.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 10 ++++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index 6a3edea3d580..dff14f1ec55f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -117,6 +117,7 @@
 #define IWL_MVM_TCM_LOWLAT_ENABLE_THRESH	100 /* packets/10 seconds */
 #define IWL_MVM_UAPSD_NONAGG_PERIOD		5000 /* msecs */
 #define IWL_MVM_UAPSD_NOAGG_LIST_LEN		IWL_MVM_UAPSD_NOAGG_BSSIDS_NUM
+#define IWL_MVM_NON_TRANSMITTING_AP		0
 #define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE      2
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE_TW   1
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 003a20630252..6a70dece447d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1016,6 +1016,9 @@ int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 	if (WARN_ON(!beacon))
 		return -EINVAL;
 
+	if (IWL_MVM_NON_TRANSMITTING_AP)
+		return 0;
+
 	if (!fw_has_capa(&mvm->fw->ucode_capa,
 			 IWL_UCODE_TLV_CAPA_CSA_AND_TBTT_OFFLOAD))
 		return iwl_mvm_mac_ctxt_send_beacon_v6(mvm, vif, beacon);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ac62eb8c4b36..898bfda93029 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
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
@@ -719,6 +719,9 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 		IEEE80211_TX_CTL_TX_OFFCHAN;
 	int queue = -1;
 
+	if (IWL_MVM_NON_TRANSMITTING_AP && ieee80211_is_probe_resp(fc))
+		return -1;
+
 	memcpy(&info, skb->cb, sizeof(info));
 
 	if (WARN_ON_ONCE(info.flags & IEEE80211_TX_CTL_AMPDU))
@@ -1078,6 +1081,9 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	fc = hdr->frame_control;
 	hdrlen = ieee80211_hdrlen(fc);
 
+	if (IWL_MVM_NON_TRANSMITTING_AP && ieee80211_is_probe_resp(fc))
+		return -1;
+
 	if (WARN_ON_ONCE(!mvmsta))
 		return -1;
 
-- 
2.20.1

