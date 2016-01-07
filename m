Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbcAGMru (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/21] iwlwifi: mvm: reset mvm->scan_type when firmware is started
Date: Thu,  7 Jan 2016 14:47:25 +0200
Message-Id: <1452170861-10060-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134907_958741_709D0E4E)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we don't reset the scan type when the firmware is
started, we will think the firmware is still configured
after the interface has been brought down. When we will
bring it up again, we will not configure the scan type
in firmware and it will crash with the following assert:

0x0000100A | ADVANCED_SYSASSERT

Fixes: 355346ba3050 ("iwlwifi: mvm: configure scheduled scan according to traffic conditions")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index e6e8088..4ed5180 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -943,6 +943,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	}
 
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
+		mvm->scan_type = IWL_SCAN_TYPE_NOT_SET;
 		ret = iwl_mvm_config_scan(mvm);
 		if (ret)
 			goto error;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 296b9c5..2d65040 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1002,7 +1002,6 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	mvm->vif_count = 0;
 	mvm->rx_ba_sessions = 0;
 	mvm->fw_dbg_conf = FW_DBG_INVALID;
-	mvm->scan_type = IWL_SCAN_TYPE_NOT_SET;
 
 	/* keep statistics ticking */
 	iwl_mvm_accu_radio_stats(mvm);
-- 
2.5.0

