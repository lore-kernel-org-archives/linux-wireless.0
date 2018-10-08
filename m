Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AF0C64EB8
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12F892087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:18:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12F892087C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbeJHP24 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:28:56 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:56438 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725973AbeJHP24 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:28:56 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g9Qji-0003w6-RG; Mon, 08 Oct 2018 11:17:55 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  8 Oct 2018 11:17:33 +0300
Message-Id: <20181008081735.3401-17-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181008081735.3401-1-luca@coelho.fi>
References: <20181008081735.3401-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/18] iwlwifi: mvm: make iwl_mvm_scd_queue_redirect() static
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This function is only used in the file where it's declared,
so just make it static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h | 4 ----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index ec4925c89295..24631866a174 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -674,9 +674,9 @@ static int iwl_mvm_get_shared_queue(struct iwl_mvm *mvm,
  * in such a case, otherwise - if no redirection required - it does nothing,
  * unless the %force param is true.
  */
-int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
-			       int ac, int ssn, unsigned int wdg_timeout,
-			       bool force)
+static int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
+				      int ac, int ssn, unsigned int wdg_timeout,
+				      bool force)
 {
 	struct iwl_scd_txq_cfg_cmd cmd = {
 		.scd_queue = queue,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 0fc211108149..492cfd37521b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -572,8 +572,4 @@ void iwl_mvm_modify_all_sta_disable_tx(struct iwl_mvm *mvm,
 void iwl_mvm_csa_client_absent(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk);
 
-int iwl_mvm_scd_queue_redirect(struct iwl_mvm *mvm, int queue, int tid,
-			       int ac, int ssn, unsigned int wdg_timeout,
-			       bool force);
-
 #endif /* __sta_h__ */
-- 
2.19.0

