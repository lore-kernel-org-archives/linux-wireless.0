Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C028C04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CBFD2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CBFD2172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbeI1OpA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:45:00 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53404 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729107AbeI1Oo5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:44:57 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2W-0004tY-El; Fri, 28 Sep 2018 11:22:20 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:21:57 +0300
Message-Id: <20180928082210.20762-6-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/18] iwlwifi: mvm: allow channel reorder optimization during scan
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ayala Beker <ayala.beker@intel.com>

Allow the FW to reorder HB channels and first scan HB channels with
assumed APs, in order to reduce the scan duration.

Currently enable it for all scan requests types.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c    | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index 310b01e3cce1..18741889ec30 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -596,9 +596,12 @@ enum iwl_umac_scan_general_flags {
  * enum iwl_umac_scan_general_flags2 - UMAC scan general flags #2
  * @IWL_UMAC_SCAN_GEN_FLAGS2_NOTIF_PER_CHNL: Whether to send a complete
  *	notification per channel or not.
+ * @IWL_UMAC_SCAN_GEN_FLAGS2_ALLOW_CHNL_REORDER: Whether to allow channel
+ *	reorder optimization or not.
  */
 enum iwl_umac_scan_general_flags2 {
-	IWL_UMAC_SCAN_GEN_FLAGS2_NOTIF_PER_CHNL	= BIT(0),
+	IWL_UMAC_SCAN_GEN_FLAGS2_NOTIF_PER_CHNL		= BIT(0),
+	IWL_UMAC_SCAN_GEN_FLAGS2_ALLOW_CHNL_REORDER	= BIT(1),
 };
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index e9048a98e793..ffcd0ca86041 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1448,6 +1448,9 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		if (gen_flags & IWL_UMAC_SCAN_GEN_FLAGS_LMAC2_FRAGMENTED)
 			cmd->v8.num_of_fragments[SCAN_HB_LMAC_IDX] =
 							IWL_SCAN_NUM_OF_FRAGS;
+
+		cmd->v8.general_flags2 =
+			IWL_UMAC_SCAN_GEN_FLAGS2_ALLOW_CHNL_REORDER;
 	}
 
 	cmd->scan_start_mac_id = scan_vif->id;
-- 
2.19.0

