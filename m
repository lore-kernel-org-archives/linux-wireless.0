Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46744 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbaICT5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:03 -0400
Received: by mail-wg0-f47.google.com with SMTP id z12so8910788wgg.18
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:01 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/36] iwlwifi: mvm: add some debugging to quota allocation
Date: Wed,  3 Sep 2014 22:56:10 +0300
Message-Id: <1409774184-24665-22-git-send-email-egrumbach@gmail.com> (sfid-20140903_220115_099746_E3217849)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to follow more easily what's going on, add some
debug statements to the quota allocation algorithm.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |  2 ++
 drivers/net/wireless/iwlwifi/mvm/quota.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 2950835..0a70bcd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -145,6 +145,7 @@ do {                                            			\
 #define IWL_DL_HCMD		0x00000004
 #define IWL_DL_STATE		0x00000008
 /* 0x000000F0 - 0x00000010 */
+#define IWL_DL_QUOTA		0x00000010
 #define IWL_DL_TE		0x00000020
 #define IWL_DL_EEPROM		0x00000040
 #define IWL_DL_RADIO		0x00000080
@@ -189,6 +190,7 @@ do {                                            			\
 #define IWL_DEBUG_LED(p, f, a...)	IWL_DEBUG(p, IWL_DL_LED, f, ## a)
 #define IWL_DEBUG_WEP(p, f, a...)	IWL_DEBUG(p, IWL_DL_WEP, f, ## a)
 #define IWL_DEBUG_HC(p, f, a...)	IWL_DEBUG(p, IWL_DL_HCMD, f, ## a)
+#define IWL_DEBUG_QUOTA(p, f, a...)	IWL_DEBUG(p, IWL_DL_QUOTA, f, ## a)
 #define IWL_DEBUG_TE(p, f, a...)	IWL_DEBUG(p, IWL_DL_TE, f, ## a)
 #define IWL_DEBUG_EEPROM(d, f, a...)	IWL_DEBUG_DEV(d, IWL_DL_EEPROM, f, ## a)
 #define IWL_DEBUG_CALIB(p, f, a...)	IWL_DEBUG(p, IWL_DL_CALIB, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 4e20b3c..300639c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -161,6 +161,9 @@ static void iwl_mvm_adjust_quota_for_noa(struct iwl_mvm *mvm,
 		quota *= (beacon_int - mvm->noa_duration);
 		quota /= beacon_int;
 
+		IWL_DEBUG_QUOTA(mvm, "quota: adjust for NoA from %d to %d\n",
+				le32_to_cpu(cmd->quotas[i].quota), quota);
+
 		cmd->quotas[i].quota = cpu_to_le32(quota);
 	}
 #endif
@@ -222,6 +225,9 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
 		quota = (QUOTA_100 - QUOTA_LOWLAT_MIN) / n_non_lowlat;
 		quota_rem = QUOTA_100 - n_non_lowlat * quota -
 			    QUOTA_LOWLAT_MIN;
+		IWL_DEBUG_QUOTA(mvm,
+				"quota: low-latency binding active, remaining quota per other binding: %d\n",
+				quota);
 	} else if (num_active_macs) {
 		/*
 		 * There are 0 or more than 1 low latency bindings, or all the
@@ -230,6 +236,9 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
 		 */
 		quota = QUOTA_100 / num_active_macs;
 		quota_rem = QUOTA_100 % num_active_macs;
+		IWL_DEBUG_QUOTA(mvm,
+				"quota: splitting evenly per binding: %d\n",
+				quota);
 	} else {
 		/* values don't really matter - won't be used */
 		quota = 0;
@@ -271,6 +280,9 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
 	for (i = 0; i < MAX_BINDINGS; i++) {
 		if (le32_to_cpu(cmd.quotas[i].quota) != 0) {
 			le32_add_cpu(&cmd.quotas[i].quota, quota_rem);
+			IWL_DEBUG_QUOTA(mvm,
+					"quota: giving remainder of %d to binding %d\n",
+					quota_rem, i);
 			break;
 		}
 	}
-- 
1.9.1

