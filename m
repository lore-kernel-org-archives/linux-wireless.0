Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13DBC0044C
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B00CC2148E
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:07:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B00CC2148E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbeKLF5K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:57:10 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35924 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731519AbeKLF5J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:09 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1D-0000JG-QE; Sun, 11 Nov 2018 22:07:40 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:19 +0200
Message-Id: <20181111200732.8159-4-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111200732.8159-1-luca@coelho.fi>
References: <20181111200732.8159-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/16] iwlwifi: mvm: remove assignment of the reciprocal
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The firmware stopped looking at this field long ago.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/mac.h   | 27 +++++++------------
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 12 ---------
 2 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
index 1dd23f846fb9..d0b79fb461bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
@@ -151,9 +151,9 @@ enum iwl_tsf_id {
  * @beacon_time: beacon transmit time in system time
  * @beacon_tsf: beacon transmit time in TSF
  * @bi: beacon interval in TU
- * @bi_reciprocal: 2^32 / bi
+ * @reserved1: reserved
  * @dtim_interval: dtim transmit time in TU
- * @dtim_reciprocal: 2^32 / dtim_interval
+ * @reserved2: reserved
  * @mcast_qid: queue ID for multicast traffic.
  *	NOTE: obsolete from VER2 and on
  * @beacon_template: beacon template ID
@@ -162,9 +162,9 @@ struct iwl_mac_data_ap {
 	__le32 beacon_time;
 	__le64 beacon_tsf;
 	__le32 bi;
-	__le32 bi_reciprocal;
+	__le32 reserved1;
 	__le32 dtim_interval;
-	__le32 dtim_reciprocal;
+	__le32 reserved2;
 	__le32 mcast_qid;
 	__le32 beacon_template;
 } __packed; /* AP_MAC_DATA_API_S_VER_2 */
@@ -174,14 +174,14 @@ struct iwl_mac_data_ap {
  * @beacon_time: beacon transmit time in system time
  * @beacon_tsf: beacon transmit time in TSF
  * @bi: beacon interval in TU
- * @bi_reciprocal: 2^32 / bi
+ * @reserved: reserved
  * @beacon_template: beacon template ID
  */
 struct iwl_mac_data_ibss {
 	__le32 beacon_time;
 	__le64 beacon_tsf;
 	__le32 bi;
-	__le32 bi_reciprocal;
+	__le32 reserved;
 	__le32 beacon_template;
 } __packed; /* IBSS_MAC_DATA_API_S_VER_1 */
 
@@ -191,9 +191,9 @@ struct iwl_mac_data_ibss {
  * @dtim_time: DTIM arrival time in system time
  * @dtim_tsf: DTIM arrival time in TSF
  * @bi: beacon interval in TU, applicable only when associated
- * @bi_reciprocal: 2^32 / bi , applicable only when associated
+ * @reserved1: reserved
  * @dtim_interval: DTIM interval in TU, applicable only when associated
- * @dtim_reciprocal: 2^32 / dtim_interval , applicable only when associated
+ * @reserved2: reserved
  * @listen_interval: in beacon intervals, applicable only when associated
  * @assoc_id: unique ID assigned by the AP during association
  * @assoc_beacon_arrive_time: TSF of first beacon after association
@@ -203,9 +203,9 @@ struct iwl_mac_data_sta {
 	__le32 dtim_time;
 	__le64 dtim_tsf;
 	__le32 bi;
-	__le32 bi_reciprocal;
+	__le32 reserved1;
 	__le32 dtim_interval;
-	__le32 dtim_reciprocal;
+	__le32 reserved2;
 	__le32 listen_interval;
 	__le32 assoc_id;
 	__le32 assoc_beacon_arrive_time;
@@ -378,13 +378,6 @@ struct iwl_mac_ctx_cmd {
 	};
 } __packed; /* MAC_CONTEXT_CMD_API_S_VER_1 */
 
-static inline u32 iwl_mvm_reciprocal(u32 v)
-{
-	if (!v)
-		return 0;
-	return 0xFFFFFFFF / v;
-}
-
 #define IWL_NONQOS_SEQ_GET	0x1
 #define IWL_NONQOS_SEQ_SET	0x2
 struct iwl_nonqos_seq_query_cmd {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index b9c45a40e251..3b93293d4559 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -767,13 +767,8 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 	}
 
 	ctxt_sta->bi = cpu_to_le32(vif->bss_conf.beacon_int);
-	ctxt_sta->bi_reciprocal =
-		cpu_to_le32(iwl_mvm_reciprocal(vif->bss_conf.beacon_int));
 	ctxt_sta->dtim_interval = cpu_to_le32(vif->bss_conf.beacon_int *
 					      vif->bss_conf.dtim_period);
-	ctxt_sta->dtim_reciprocal =
-		cpu_to_le32(iwl_mvm_reciprocal(vif->bss_conf.beacon_int *
-					       vif->bss_conf.dtim_period));
 
 	ctxt_sta->listen_interval = cpu_to_le32(mvm->hw->conf.listen_interval);
 	ctxt_sta->assoc_id = cpu_to_le32(vif->bss_conf.aid);
@@ -832,8 +827,6 @@ static int iwl_mvm_mac_ctxt_cmd_ibss(struct iwl_mvm *mvm,
 
 	/* cmd.ibss.beacon_time/cmd.ibss.beacon_tsf are curently ignored */
 	cmd.ibss.bi = cpu_to_le32(vif->bss_conf.beacon_int);
-	cmd.ibss.bi_reciprocal =
-		cpu_to_le32(iwl_mvm_reciprocal(vif->bss_conf.beacon_int));
 
 	/* TODO: Assumes that the beacon id == mac context id */
 	cmd.ibss.beacon_template = cpu_to_le32(mvmvif->id);
@@ -1180,13 +1173,8 @@ static void iwl_mvm_mac_ctxt_cmd_fill_ap(struct iwl_mvm *mvm,
 	}
 
 	ctxt_ap->bi = cpu_to_le32(vif->bss_conf.beacon_int);
-	ctxt_ap->bi_reciprocal =
-		cpu_to_le32(iwl_mvm_reciprocal(vif->bss_conf.beacon_int));
 	ctxt_ap->dtim_interval = cpu_to_le32(vif->bss_conf.beacon_int *
 					     vif->bss_conf.dtim_period);
-	ctxt_ap->dtim_reciprocal =
-		cpu_to_le32(iwl_mvm_reciprocal(vif->bss_conf.beacon_int *
-					       vif->bss_conf.dtim_period));
 
 	if (!fw_has_api(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_API_STA_TYPE))
-- 
2.19.1

