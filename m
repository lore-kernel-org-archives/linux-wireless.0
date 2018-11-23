Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC9AC04EBA
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2D70206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2D70206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405218AbeKWWKe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:34 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38256 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388238AbeKWWKd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:33 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bb-0008GU-Qr; Fri, 23 Nov 2018 13:26:40 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:20 +0200
Message-Id: <20181123112631.29360-5-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/15] iwlwifi: mvm: activate apply points
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Call the previously introduced apply points entry
point when reaching an apply point.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       | 4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     | 2 ++
 4 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index c55abc186a2e..dcb739fb7c35 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1006,10 +1006,14 @@ static int iwl_mvm_load_rt_fw(struct iwl_mvm *mvm)
 	if (ret)
 		return ret;
 
+	iwl_fw_dbg_apply_point(&mvm->fwrt, IWL_FW_INI_APPLY_EARLY);
+
 	ret = iwl_mvm_load_ucode_wait_alive(mvm, IWL_UCODE_REGULAR);
 	if (ret)
 		return ret;
 
+	iwl_fw_dbg_apply_point(&mvm->fwrt, IWL_FW_INI_APPLY_AFTER_ALIVE);
+
 	return iwl_init_paging(&mvm->fwrt, mvm->fwrt.cur_fw_img);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index e049d34a3553..7779951a9533 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1532,6 +1532,8 @@ void iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
 						   IEEE80211_IFACE_ITER_NORMAL,
 						   iwl_mvm_beacon_loss_iterator,
 						   mb);
+
+	iwl_fw_dbg_apply_point(&mvm->fwrt, IWL_FW_INI_APPLY_MISSED_BEACONS);
 }
 
 void iwl_mvm_rx_stored_beacon_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 6fe48cc31071..3523c8ce5491 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1125,6 +1125,8 @@ int __iwl_mvm_mac_start(struct iwl_mvm *mvm)
 	}
 	ret = iwl_mvm_up(mvm);
 
+	iwl_fw_dbg_apply_point(&mvm->fwrt, IWL_FW_INI_APPLY_POST_INIT);
+
 	if (ret && test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		/* Something went wrong - we need to finish some cleanup
 		 * that normally iwl_mvm_mac_restart_complete() below
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index cb376e869144..86d598d5b68f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1893,6 +1893,8 @@ void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 		mvm->last_ebs_successful = false;
 
 	mvm->scan_uid_status[uid] = 0;
+
+	iwl_fw_dbg_apply_point(&mvm->fwrt, IWL_FW_INI_APPLY_SCAN_COMPLETE);
 }
 
 void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
-- 
2.19.1

