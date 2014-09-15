Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54839 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaIOFNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:45 -0400
Received: by mail-wi0-f180.google.com with SMTP id ex7so3431762wid.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:44 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/28] iwlwifi: mvm: move IWL_MVM_UAPSD_QUEUES to constants.h
Date: Mon, 15 Sep 2014 08:12:59 +0300
Message-Id: <1410757980-2138-27-git-send-email-egrumbach@gmail.com> (sfid-20140915_073114_994141_D6D350F7)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h | 6 ++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  | 2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h       | 4 ----
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 1181089..a355788 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -65,12 +65,18 @@
 #ifndef __MVM_CONSTANTS_H
 #define __MVM_CONSTANTS_H
 
+#include <linux/ieee80211.h>
+
 #define IWL_MVM_DEFAULT_PS_TX_DATA_TIMEOUT	(100 * USEC_PER_MSEC)
 #define IWL_MVM_DEFAULT_PS_RX_DATA_TIMEOUT	(100 * USEC_PER_MSEC)
 #define IWL_MVM_WOWLAN_PS_TX_DATA_TIMEOUT	(10 * USEC_PER_MSEC)
 #define IWL_MVM_WOWLAN_PS_RX_DATA_TIMEOUT	(10 * USEC_PER_MSEC)
 #define IWL_MVM_UAPSD_RX_DATA_TIMEOUT		(50 * USEC_PER_MSEC)
 #define IWL_MVM_UAPSD_TX_DATA_TIMEOUT		(50 * USEC_PER_MSEC)
+#define IWL_MVM_UAPSD_QUEUES		(IEEE80211_WMM_IE_STA_QOSINFO_AC_VO |\
+					 IEEE80211_WMM_IE_STA_QOSINFO_AC_VI |\
+					 IEEE80211_WMM_IE_STA_QOSINFO_AC_BK |\
+					 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
 #define IWL_MVM_PS_HEAVY_TX_THLD_PACKETS	20
 #define IWL_MVM_PS_HEAVY_RX_THLD_PACKETS	8
 #define IWL_MVM_PS_SNOOZE_HEAVY_TX_THLD_PACKETS	30
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index a3bb4a0..2517f87 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -327,7 +327,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	    IWL_UCODE_API(mvm->fw->ucode_ver) >= 9 &&
 	    !iwlwifi_mod_params.uapsd_disable) {
 		hw->flags |= IEEE80211_HW_SUPPORTS_UAPSD;
-		hw->uapsd_queues = IWL_UAPSD_AC_INFO;
+		hw->uapsd_queues = IWL_MVM_UAPSD_QUEUES;
 		hw->uapsd_max_sp_len = IWL_UAPSD_MAX_SP;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 6eb1f85..efdafa1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -180,10 +180,6 @@ enum iwl_power_scheme {
 };
 
 #define IWL_CONN_MAX_LISTEN_INTERVAL	10
-#define IWL_UAPSD_AC_INFO		(IEEE80211_WMM_IE_STA_QOSINFO_AC_VO |\
-					 IEEE80211_WMM_IE_STA_QOSINFO_AC_VI |\
-					 IEEE80211_WMM_IE_STA_QOSINFO_AC_BK |\
-					 IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
 #define IWL_UAPSD_MAX_SP		IEEE80211_WMM_IE_STA_QOSINFO_SP_2
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
1.9.1

