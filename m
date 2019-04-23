Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BC6C282E1
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9903B206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfDWJKz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:10:55 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:58974 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726555AbfDWJKy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:10:54 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrS0-0000FN-O9; Tue, 23 Apr 2019 12:10:52 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 05/16] iwlwifi: mvm: report FTM start time TSF when applicable
Date:   Tue, 23 Apr 2019 12:10:32 +0300
Message-Id: <20190423091043.7156-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423091043.7156-1-luca@coelho.fi>
References: <20190423091043.7156-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

When the interface that is requesting an FTM measurement is connected
to a BSS, it is possible that the FTM request was originated by an
RRM request from the AP. In this case the station needs to report
the measurement start time in terms of the TSF of the AP.

Since there is no indication in the FTM request itself if the TSF
is needed, always report the TSF if the station is associated.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../intel/iwlwifi/mvm/ftm-initiator.c         | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index b15a4db7198e..fec38a47696e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -187,12 +187,24 @@ static void iwl_mvm_ftm_cmd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	for (i = 0; i < ETH_ALEN; i++)
 		cmd->macaddr_mask[i] = ~req->mac_addr_mask[i];
 
-	if (vif->bss_conf.assoc)
+	if (vif->bss_conf.assoc) {
 		memcpy(cmd->range_req_bssid, vif->bss_conf.bssid, ETH_ALEN);
-	else
+
+		/* AP's TSF is only relevant if associated */
+		for (i = 0; i < req->n_peers; i++) {
+			if (req->peers[i].report_ap_tsf) {
+				struct iwl_mvm_vif *mvmvif =
+					iwl_mvm_vif_from_mac80211(vif);
+
+				cmd->tsf_mac_id = cpu_to_le32(mvmvif->id);
+				return;
+			}
+		}
+	} else {
 		eth_broadcast_addr(cmd->range_req_bssid);
+	}
 
-	/* TODO: fill in tsf_mac_id if needed */
+	/* Don't report AP's TSF */
 	cmd->tsf_mac_id = cpu_to_le32(0xff);
 }
 
@@ -527,6 +539,8 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 				fw_ap = (void *)&fw_resp_v6->ap[i];
 
 			result.final = fw_resp->ap[i].last_burst;
+			result.ap_tsf = le32_to_cpu(fw_ap->start_tsf);
+			result.ap_tsf_valid = 1;
 		} else {
 			/* the first part is the same for old and new APIs */
 			fw_ap = (void *)&fw_resp_v5->ap[i];
-- 
2.20.1

