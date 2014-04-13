Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45625 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbaDMTVM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:12 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so7266581wgh.4
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:11 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 42/47] iwlwifi: mvm: Add support for Energy based scan (EBS)
Date: Sun, 13 Apr 2014 22:19:57 +0300
Message-Id: <1397416802-32403-42-git-send-email-egrumbach@gmail.com> (sfid-20140413_213516_755432_6B9DA943)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

This patch enables Energy Based Scan (EBS) - intended to detect energy
on 5 GHz band channels. Passive scan on this band takes up to 2.64 sec
assuming 110mSec per-channel * 24 channels. EBS is designed to detect
energy on channels with intensive Wifi activity as well as those where
only beacons are transmitted. EBS completes sampling all channels within
shortest beacon frame transmission time. Total EBS duration is about 100
msec (typical beacon interval).
Detecting Wifi activity on 5 GHz band channels can significantly reduce
scan duration thus saving time and power. EBS failure reported by FW
disables EBS for current connection. It is re-enabled upon new
connection attempt on any WLAN interface.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h          |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 18 ++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/fw-api.h      |  1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |  5 +++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  2 ++
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 15 +++++++++++++--
 6 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 265d6f1..f5927d0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -91,6 +91,7 @@
  * @IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD: P2P client supports uAPSD power save
  * @IWL_UCODE_TLV_FLAGS_BCAST_FILTERING: uCode supports broadcast filtering.
  * @IWL_UCODE_TLV_FLAGS_GO_UAPSD: AP/GO interfaces support uAPSD clients
+ * @IWL_UCODE_TLV_FLAGS_EBS_SUPPORT: this uCode image supports EBS.
  */
 enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_PAN			= BIT(0),
@@ -106,6 +107,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_P2P_PM		= BIT(21),
 	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM	= BIT(22),
 	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_SCM	= BIT(23),
+	IWL_UCODE_TLV_FLAGS_EBS_SUPPORT		= BIT(25),
 	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
 	IWL_UCODE_TLV_FLAGS_BCAST_FILTERING	= BIT(29),
 	IWL_UCODE_TLV_FLAGS_GO_UAPSD		= BIT(30),
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 0373f44..6959fda 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -538,13 +538,16 @@ struct iwl_scan_offload_schedule {
  *
  * IWL_SCAN_OFFLOAD_FLAG_PASS_ALL: pass all results - no filtering.
  * IWL_SCAN_OFFLOAD_FLAG_CACHED_CHANNEL: add cached channels to partial scan.
- * IWL_SCAN_OFFLOAD_FLAG_ENERGY_SCAN: use energy based scan before partial scan
- *	on A band.
+ * IWL_SCAN_OFFLOAD_FLAG_EBS_QUICK_MODE: EBS duration is 100mSec - typical
+ *	beacon period. Finding channel activity in this mode is not guaranteed.
+ * IWL_SCAN_OFFLOAD_FLAG_EBS_ACCURATE_MODE: EBS duration is 200mSec.
+ *	Assuming beacon period is 100ms finding channel activity is guaranteed.
  */
 enum iwl_scan_offload_flags {
 	IWL_SCAN_OFFLOAD_FLAG_PASS_ALL		= BIT(0),
 	IWL_SCAN_OFFLOAD_FLAG_CACHED_CHANNEL	= BIT(2),
-	IWL_SCAN_OFFLOAD_FLAG_ENERGY_SCAN	= BIT(3),
+	IWL_SCAN_OFFLOAD_FLAG_EBS_QUICK_MODE	= BIT(5),
+	IWL_SCAN_OFFLOAD_FLAG_EBS_ACCURATE_MODE	= BIT(6),
 };
 
 /**
@@ -567,17 +570,24 @@ enum iwl_scan_offload_compleate_status {
 	IWL_SCAN_OFFLOAD_ABORTED	= 2,
 };
 
+enum iwl_scan_ebs_status {
+	IWL_SCAN_EBS_SUCCESS,
+	IWL_SCAN_EBS_FAILED,
+	IWL_SCAN_EBS_CHAN_NOT_FOUND,
+};
+
 /**
  * iwl_scan_offload_complete - SCAN_OFFLOAD_COMPLETE_NTF_API_S_VER_1
  * @last_schedule_line:		last schedule line executed (fast or regular)
  * @last_schedule_iteration:	last scan iteration executed before scan abort
  * @status:			enum iwl_scan_offload_compleate_status
+ * @ebs_status: last EBS status, see IWL_SCAN_EBS_*
  */
 struct iwl_scan_offload_complete {
 	u8 last_schedule_line;
 	u8 last_schedule_iteration;
 	u8 status;
-	u8 reserved;
+	u8 ebs_status;
 } __packed;
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 48554da..309a9b9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -71,6 +71,7 @@
 #include "fw-api-power.h"
 #include "fw-api-d3.h"
 #include "fw-api-coex.h"
+#include "fw-api-scan.h"
 
 /* maximal number of Tx queues in any platform */
 #define IWL_MVM_MAX_QUEUES	20
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index dc9069b..374ecd4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1694,6 +1694,11 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		ret = iwl_mvm_add_sta(mvm, vif, sta);
 	} else if (old_state == IEEE80211_STA_NONE &&
 		   new_state == IEEE80211_STA_AUTH) {
+		/*
+		 * EBS may be disabled due to previous failures reported by FW.
+		 * Reset EBS status here assuming environment has been changed.
+		 */
+		mvm->last_ebs_successful = true;
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index ed22201..41184a4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -535,6 +535,8 @@ struct iwl_mvm {
 	/* Internal station */
 	struct iwl_mvm_int_sta aux_sta;
 
+	bool last_ebs_successful;
+
 	u8 scan_last_antenna_idx; /* to toggle TX between antennas */
 	u8 mgmt_last_antenna_idx;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index ea17745..84e7c66 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -575,9 +575,13 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 	/* scan status must be locked for proper checking */
 	lockdep_assert_held(&mvm->mutex);
 
-	IWL_DEBUG_SCAN(mvm, "Scheduled scan completed, status %s\n",
+	IWL_DEBUG_SCAN(mvm,
+		       "Scheduled scan completed, status %s EBS status %s:%d\n",
 		       scan_notif->status == IWL_SCAN_OFFLOAD_COMPLETED ?
-		       "completed" : "aborted");
+		       "completed" : "aborted", scan_notif->ebs_status ==
+		       IWL_SCAN_EBS_SUCCESS ? "success" : "failed",
+		       scan_notif->ebs_status);
+
 
 	/* only call mac80211 completion if the stop was initiated by FW */
 	if (mvm->scan_status == IWL_MVM_SCAN_SCHED) {
@@ -585,6 +589,8 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 		ieee80211_sched_scan_stopped(mvm->hw);
 	}
 
+	mvm->last_ebs_successful = !scan_notif->ebs_status;
+
 	return 0;
 }
 
@@ -921,6 +927,11 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		scan_req.flags |= cpu_to_le16(IWL_SCAN_OFFLOAD_FLAG_PASS_ALL);
 	}
 
+	if (mvm->last_ebs_successful &&
+	    mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT)
+		scan_req.flags |=
+			cpu_to_le16(IWL_SCAN_OFFLOAD_FLAG_EBS_ACCURATE_MODE);
+
 	return iwl_mvm_send_cmd_pdu(mvm, SCAN_OFFLOAD_REQUEST_CMD, CMD_SYNC,
 				    sizeof(scan_req), &scan_req);
 }
-- 
1.8.3.2

