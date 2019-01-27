Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447D0C282C9
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1285E2146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfA0KT2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:19:28 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51318 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726765AbfA0KT1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:19:27 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXB-0001vC-W8; Sun, 27 Jan 2019 12:19:26 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:18:53 +0200
Message-Id: <20190127101908.6428-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/21] iwlwifi: mvm: Disconnect on large beacon loss
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Some buggy APs stop sending beacons, but continue to ack our null data
packets or even run some traffic. It's better not to stick connected to
such an AP forever, so disconnect after some larger beacon loss
threshold is crossed.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 5 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index c868ebfa10ce..7cfdd07d8736 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1415,8 +1415,9 @@ void iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
 	 * TODO: the threshold should be adjusted based on latency conditions,
 	 * and/or in case of a CS flow on one of the other AP vifs.
 	 */
-	if (le32_to_cpu(mb->consec_missed_beacons_since_last_rx) >
-	     IWL_MVM_MISSED_BEACONS_THRESHOLD)
+	if (rx_missed_bcon > IWL_MVM_MISSED_BEACONS_THRESHOLD_LONG)
+		iwl_mvm_connection_loss(mvm, vif, "missed beacons");
+	else if (rx_missed_bcon_since_rx > IWL_MVM_MISSED_BEACONS_THRESHOLD)
 		ieee80211_beacon_loss(vif);
 
 	trigger = iwl_fw_dbg_trigger_on(&mvm->fwrt, ieee80211_vif_to_wdev(vif),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 5d28080e257e..55f08e433331 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -94,6 +94,8 @@
 /* RSSI offset for WkP */
 #define IWL_RSSI_OFFSET 50
 #define IWL_MVM_MISSED_BEACONS_THRESHOLD 8
+#define IWL_MVM_MISSED_BEACONS_THRESHOLD_LONG 16
+
 /* A TimeUnit is 1024 microsecond */
 #define MSEC_TO_TU(_msec)	(_msec*1000/1024)
 
-- 
2.20.1

