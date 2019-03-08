Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F653C4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22A5020854
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbfCHKJC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:09:02 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41390 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726249AbfCHKJB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 05:09:01 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2CR1-0006tZ-7z; Fri, 08 Mar 2019 12:09:00 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Mar 2019 12:08:42 +0200
Message-Id: <20190308100848.13188-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308100848.13188-1-luca@coelho.fi>
References: <20190308100848.13188-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 1/7] iwlwifi: mvm: fix TX crypto on 22560+ devices
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In the old days, we could transmit with HW crypto with an arbitrary
key by filling it into TX_CMD. This was broken first with the advent
of CCMP/GCMP-256 keys which don't fit there.

This was broken *again* with the newer TX_CMD format on 22560+,
where we simply cannot pass key material anymore. However, we forgot
to update all the cases when we get a key from mac80211 and don't
program it into the hardware but still return 0 for HW crypto on TX.

In AP mode with WEP, we tried to fix this by programming the keys
separately for each station later, but this ultimately turns out to
be buggy, for example now it leaks memory when we have more than one
WEP key.

Fix this by simply using only SW crypto for WEP in newer devices by
returning -EOPNOTSUPP instead of trying to program WEP keys later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 64 +++++--------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 41 +-----------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |  7 +-
 4 files changed, 19 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 3a92c09d4692..eeaeb8475666 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2714,9 +2714,6 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
-	kfree(mvmvif->ap_wep_key);
-	mvmvif->ap_wep_key = NULL;
-
 	mutex_unlock(&mvm->mutex);
 }
 
@@ -3183,24 +3180,7 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		ret = iwl_mvm_update_sta(mvm, vif, sta);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTHORIZED) {
-		/* if wep is used, need to set the key for the station now */
-		if (vif->type == NL80211_IFTYPE_AP && mvmvif->ap_wep_key) {
-			mvm_sta->wep_key =
-				kmemdup(mvmvif->ap_wep_key,
-					sizeof(*mvmvif->ap_wep_key) +
-					mvmvif->ap_wep_key->keylen,
-					GFP_KERNEL);
-			if (!mvm_sta->wep_key) {
-				ret = -ENOMEM;
-				goto out_unlock;
-			}
-
-			ret = iwl_mvm_set_sta_key(mvm, vif, sta,
-						  mvm_sta->wep_key,
-						  STA_KEY_IDX_INVALID);
-		} else {
-			ret = 0;
-		}
+		ret = 0;
 
 		/* we don't support TDLS during DCM */
 		if (iwl_mvm_phy_ctx_count(mvm) > 1)
@@ -3242,17 +3222,6 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 						   NL80211_TDLS_DISABLE_LINK);
 		}
 
-		/* Remove STA key if this is an AP using WEP */
-		if (vif->type == NL80211_IFTYPE_AP && mvmvif->ap_wep_key) {
-			int rm_ret = iwl_mvm_remove_sta_key(mvm, vif, sta,
-							    mvm_sta->wep_key);
-
-			if (!ret)
-				ret = rm_ret;
-			kfree(mvm_sta->wep_key);
-			mvm_sta->wep_key = NULL;
-		}
-
 		if (unlikely(ret &&
 			     test_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED,
 				      &mvm->status)))
@@ -3439,20 +3408,12 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 		break;
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-		if (vif->type == NL80211_IFTYPE_AP) {
-			struct iwl_mvm_vif *mvmvif =
-				iwl_mvm_vif_from_mac80211(vif);
-
-			mvmvif->ap_wep_key = kmemdup(key,
-						     sizeof(*key) + key->keylen,
-						     GFP_KERNEL);
-			if (!mvmvif->ap_wep_key)
-				return -ENOMEM;
-		}
-
-		if (vif->type != NL80211_IFTYPE_STATION)
-			return 0;
-		break;
+		if (vif->type == NL80211_IFTYPE_STATION)
+			break;
+		if (iwl_mvm_has_new_tx_api(mvm))
+			return -EOPNOTSUPP;
+		/* support HW crypto on TX */
+		return 0;
 	default:
 		/* currently FW supports only one optional cipher scheme */
 		if (hw->n_cipher_schemes &&
@@ -3540,12 +3501,17 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 		ret = iwl_mvm_set_sta_key(mvm, vif, sta, key, key_offset);
 		if (ret) {
 			IWL_WARN(mvm, "set key failed\n");
+			key->hw_key_idx = STA_KEY_IDX_INVALID;
 			/*
 			 * can't add key for RX, but we don't need it
-			 * in the device for TX so still return 0
+			 * in the device for TX so still return 0,
+			 * unless we have new TX API where we cannot
+			 * put key material into the TX_CMD
 			 */
-			key->hw_key_idx = STA_KEY_IDX_INVALID;
-			ret = 0;
+			if (iwl_mvm_has_new_tx_api(mvm))
+				ret = -EOPNOTSUPP;
+			else
+				ret = 0;
 		}
 
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index bca6f6b536d9..a50dc53df086 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -498,7 +498,6 @@ struct iwl_mvm_vif {
 	netdev_features_t features;
 
 	struct iwl_probe_resp_data __rcu *probe_resp_data;
-	struct ieee80211_key_conf *ap_wep_key;
 };
 
 static inline struct iwl_mvm_vif *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 498c315291cf..db26f0041a81 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -2333,21 +2333,6 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		iwl_mvm_enable_txq(mvm, NULL, mvmvif->cab_queue, 0, &cfg,
 				   timeout);
 
-	if (mvmvif->ap_wep_key) {
-		u8 key_offset = iwl_mvm_set_fw_key_idx(mvm);
-
-		__set_bit(key_offset, mvm->fw_key_table);
-
-		if (key_offset == STA_KEY_IDX_INVALID)
-			return -ENOSPC;
-
-		ret = iwl_mvm_send_sta_key(mvm, mvmvif->mcast_sta.sta_id,
-					   mvmvif->ap_wep_key, true, 0, NULL, 0,
-					   key_offset, 0);
-		if (ret)
-			return ret;
-	}
-
 	return 0;
 }
 
@@ -2419,28 +2404,6 @@ int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	iwl_mvm_disable_txq(mvm, NULL, mvmvif->cab_queue, 0, 0);
 
-	if (mvmvif->ap_wep_key) {
-		int i;
-
-		if (!__test_and_clear_bit(mvmvif->ap_wep_key->hw_key_idx,
-					  mvm->fw_key_table)) {
-			IWL_ERR(mvm, "offset %d not used in fw key table.\n",
-				mvmvif->ap_wep_key->hw_key_idx);
-			return -ENOENT;
-		}
-
-		/* track which key was deleted last */
-		for (i = 0; i < STA_KEY_MAX_NUM; i++) {
-			if (mvm->fw_key_deleted[i] < U8_MAX)
-				mvm->fw_key_deleted[i]++;
-		}
-		mvm->fw_key_deleted[mvmvif->ap_wep_key->hw_key_idx] = 0;
-		ret = __iwl_mvm_remove_sta_key(mvm, mvmvif->mcast_sta.sta_id,
-					       mvmvif->ap_wep_key, true);
-		if (ret)
-			return ret;
-	}
-
 	ret = iwl_mvm_rm_sta_common(mvm, mvmvif->mcast_sta.sta_id);
 	if (ret)
 		IWL_WARN(mvm, "Failed sending remove station\n");
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 79700c7310a1..b4d4071b865d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -394,7 +394,6 @@ struct iwl_mvm_rxq_dup_data {
  *	the BA window. To be used for UAPSD only.
  * @ptk_pn: per-queue PTK PN data structures
  * @dup_data: per queue duplicate packet detection data
- * @wep_key: used in AP mode. Is a duplicate of the WEP key.
  * @deferred_traffic_tid_map: indication bitmap of deferred traffic per-TID
  * @tx_ant: the index of the antenna to use for data tx to this station. Only
  *	used during connection establishment (e.g. for the 4 way handshake
@@ -426,8 +425,6 @@ struct iwl_mvm_sta {
 	struct iwl_mvm_key_pn __rcu *ptk_pn[4];
 	struct iwl_mvm_rxq_dup_data *dup_data;
 
-	struct ieee80211_key_conf *wep_key;
-
 	u8 reserved_queue;
 
 	/* Temporary, until the new TLC will control the Tx protection */
-- 
2.20.1

