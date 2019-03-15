Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B64C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB0912077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbfCOQgu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:36:50 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44282 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729522AbfCOQgt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:36:49 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4pp9-0004qp-Co; Fri, 15 Mar 2019 18:36:47 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:26 +0200
Message-Id: <20190315163634.17315-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/16] iwlwifi: mvm: use dump worker during restart instead of sync dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

In restart flow, the driver requests HW restart from mac80211
and then mac80211 uses a worker to do the restart flow. In that flow a
sync dump is performed. Instead, schedule the dump worker before
requesting HW restart from mac80211. This approach simplifies the
restart flow.
Also, it is neeeded in order to differentiate between the handling of SW
and HW errors in a future commit.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  9 ---------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 13 -------------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  2 ++
 4 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index f4288232d06c..83fd7f93d9f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2089,7 +2089,6 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	 * 2. We are using a unified image but had an error while exiting D3
 	 */
 	set_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status);
-	set_bit(IWL_MVM_STATUS_D3_RECONFIG, &mvm->status);
 	/*
 	 * When switching images we return 1, which causes mac80211
 	 * to do a reconfig with IEEE80211_RECONFIG_TYPE_RESTART.
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index dc4bff74c89c..1cad9238e45a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1198,15 +1198,6 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 
 static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 {
-	/* clear the D3 reconfig, we only need it to avoid dumping a
-	 * firmware coredump on reconfiguration, we shouldn't do that
-	 * on D3->D0 transition
-	 */
-	if (!test_and_clear_bit(IWL_MVM_STATUS_D3_RECONFIG, &mvm->status)) {
-		mvm->fwrt.dump.desc = &iwl_dump_desc_assert;
-		iwl_fw_error_dump(&mvm->fwrt);
-	}
-
 	/* cleanup all stale references (scan, roc), but keep the
 	 * ucode_down ref until reconfig is complete
 	 */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 4e179e69fd32..61b6dbc83600 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1203,7 +1203,6 @@ struct iwl_mvm {
  * @IWL_MVM_STATUS_IN_HW_RESTART: HW restart is active
  * @IWL_MVM_STATUS_IN_D0I3: NIC is in D0i3
  * @IWL_MVM_STATUS_ROC_AUX_RUNNING: AUX remain-on-channel is running
- * @IWL_MVM_STATUS_D3_RECONFIG: D3 reconfiguration is being done
  * @IWL_MVM_STATUS_FIRMWARE_RUNNING: firmware is running
  * @IWL_MVM_STATUS_NEED_FLUSH_P2P: need to flush P2P bcast STA
  */
@@ -1215,7 +1214,6 @@ enum iwl_mvm_status {
 	IWL_MVM_STATUS_IN_HW_RESTART,
 	IWL_MVM_STATUS_IN_D0I3,
 	IWL_MVM_STATUS_ROC_AUX_RUNNING,
-	IWL_MVM_STATUS_D3_RECONFIG,
 	IWL_MVM_STATUS_FIRMWARE_RUNNING,
 	IWL_MVM_STATUS_NEED_FLUSH_P2P,
 };
@@ -2027,17 +2025,6 @@ static inline u32 iwl_mvm_flushable_queues(struct iwl_mvm *mvm)
 static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 {
 	lockdep_assert_held(&mvm->mutex);
-	/* If IWL_MVM_STATUS_HW_RESTART_REQUESTED bit is set then we received
-	 * an assert. Since we failed to bring the interface up, mac80211
-	 * will not attempt to reconfig the device,
-	 * which handles the dump collection in assert flow,
-	 * so trigger dump collection here.
-	 */
-	if (test_and_clear_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED,
-			       &mvm->status))
-		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
-					false, 0);
-
 	iwl_fw_cancel_timestamp(&mvm->fwrt);
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
 	iwl_fwrt_stop_device(&mvm->fwrt);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ad8dea01c638..3cc6048d6a10 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1340,6 +1340,8 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 			}
 		}
 
+		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
+					false, 0);
 		if (fw_error && mvm->fw_restart > 0)
 			mvm->fw_restart--;
 		set_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status);
-- 
2.20.1

