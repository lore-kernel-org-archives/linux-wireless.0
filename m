Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB96FC282D8
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5D9B20855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbfA3L4a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:56:30 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52870 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730308AbfA3L4a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:56:30 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooTH-0003x8-Ej; Wed, 30 Jan 2019 13:56:00 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:28 +0200
Message-Id: <20190130115528.19922-18-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 17/17] iwlwifi: mvm: fix AP mode in WEP
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Recently we started to send the WEP keys to the firmware so
that we could use hardware Tx encryption also on newer
devices that require the keys to be installed in the firmware
for encryption (as opposed to older devices that can get
the key in the Tx command for each Tx).

When we implemented that, we forgot to remove the key when
we remove a station leading to a situation where a station
that connects and disconnects a lot of times exhausts the
key database inside the firmware.

A fix was made for that, but we always removed the same
key: mvmvif->ap_wep_key which means that we removed the
same key entry in the firmware. This can make sense since
in WEP, the key is the same for all the stations, but the
internal implementation of iwl_mvm_set_sta_key and
iwl_mvm_remove_sta_key assumes that each station uses a
different key in the firmware's key database.

So now we got to the situation where we have a single
ieee80211_key_conf instance that means, a single
ieee80211_key_conf.hw_key_idx index for several stations
and hence for several keys.
ieee80211_key_conf.hw_key_idx is set to 0 when the first
station associates, and then it is overwritten to 1 when
the second station associates which is a buggy of course.
This led to the following message upon the removal of the
second station:

iwlwifi 0000:00:03.0: offset 1 not used in fw key table.
WARNING: CPU: 2 PID: 27883 at net/mac80211/sta_info.c:1122 __sta_info_destroy_part2+0x16b/0x180 [mac80211]
RIP: 0010:__sta_info_destroy_part2+0x16b/0x180 [mac80211]
 Call Trace:
  __sta_info_destroy+0x2a/0x40 [mac80211]
  sta_info_destroy_addr_bss+0x38/0x60 [mac80211]
  ieee80211_del_station+0x1d/0x30 [mac80211]
  nl80211_del_station+0xe0/0x1f0 [cfg80211]

Fix this by copying the ieee80211_key_conf structure for
each and every station. This is the easiest way to properly
remove the keys with the right index. Another solution
would have been to allow several stations to use the same
key offset in the firmware. That would require to change
the way we track keys in iwlmvm and not really worth it.

Also, maintain correctly fw_key_table when we add a key
for the multicast station.
Remove the key when we remove the multicast station.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Fixes: 337bfc9881a2 ("iwlwifi: mvm: set wep key for all stations in soft ap mode")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  30 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 132 +++++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |   3 +
 3 files changed, 102 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 4e676a6936c1..92605aaca937 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3078,6 +3078,24 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		ret = iwl_mvm_update_sta(mvm, vif, sta);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTHORIZED) {
+		/* if wep is used, need to set the key for the station now */
+		if (vif->type == NL80211_IFTYPE_AP && mvmvif->ap_wep_key) {
+			mvm_sta->wep_key =
+				kmemdup(mvmvif->ap_wep_key,
+					sizeof(*mvmvif->ap_wep_key) +
+					mvmvif->ap_wep_key->keylen,
+					GFP_KERNEL);
+			if (!mvm_sta->wep_key) {
+				ret = -ENOMEM;
+				goto out_unlock;
+			}
+
+			ret = iwl_mvm_set_sta_key(mvm, vif, sta,
+						  mvm_sta->wep_key,
+						  STA_KEY_IDX_INVALID);
+		} else {
+			ret = 0;
+		}
 
 		/* we don't support TDLS during DCM */
 		if (iwl_mvm_phy_ctx_count(mvm) > 1)
@@ -3092,14 +3110,6 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 
 		iwl_mvm_rs_rate_init(mvm, sta, mvmvif->phy_ctxt->channel->band,
 				     true);
-
-		/* if wep is used, need to set the key for the station now */
-		if (vif->type == NL80211_IFTYPE_AP && mvmvif->ap_wep_key)
-			ret = iwl_mvm_set_sta_key(mvm, vif, sta,
-						  mvmvif->ap_wep_key,
-						  STA_KEY_IDX_INVALID);
-		else
-			ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
 		   new_state == IEEE80211_STA_ASSOC) {
 		/* disable beacon filtering */
@@ -3127,10 +3137,12 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		/* Remove STA key if this is an AP using WEP */
 		if (vif->type == NL80211_IFTYPE_AP && mvmvif->ap_wep_key) {
 			int rm_ret = iwl_mvm_remove_sta_key(mvm, vif, sta,
-							    mvmvif->ap_wep_key);
+							    mvm_sta->wep_key);
 
 			if (!ret)
 				ret = rm_ret;
+			kfree(mvm_sta->wep_key);
+			mvm_sta->wep_key = NULL;
 		}
 
 	} else {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index a102a16a15f6..3ea39bb533e8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2337,11 +2337,13 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (mvmvif->ap_wep_key) {
 		u8 key_offset = iwl_mvm_set_fw_key_idx(mvm);
 
+		__set_bit(key_offset, mvm->fw_key_table);
+
 		if (key_offset == STA_KEY_IDX_INVALID)
 			return -ENOSPC;
 
 		ret = iwl_mvm_send_sta_key(mvm, mvmvif->mcast_sta.sta_id,
-					   mvmvif->ap_wep_key, 1, 0, NULL, 0,
+					   mvmvif->ap_wep_key, true, 0, NULL, 0,
 					   key_offset, 0);
 		if (ret)
 			return ret;
@@ -2350,6 +2352,59 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	return 0;
 }
 
+static int __iwl_mvm_remove_sta_key(struct iwl_mvm *mvm, u8 sta_id,
+				    struct ieee80211_key_conf *keyconf,
+				    bool mcast)
+{
+	union {
+		struct iwl_mvm_add_sta_key_cmd_v1 cmd_v1;
+		struct iwl_mvm_add_sta_key_cmd cmd;
+	} u = {};
+	bool new_api = fw_has_api(&mvm->fw->ucode_capa,
+				  IWL_UCODE_TLV_API_TKIP_MIC_KEYS);
+	__le16 key_flags;
+	int ret, size;
+	u32 status;
+
+	/* This is a valid situation for GTK removal */
+	if (sta_id == IWL_MVM_INVALID_STA)
+		return 0;
+
+	key_flags = cpu_to_le16((keyconf->keyidx << STA_KEY_FLG_KEYID_POS) &
+				 STA_KEY_FLG_KEYID_MSK);
+	key_flags |= cpu_to_le16(STA_KEY_FLG_NO_ENC | STA_KEY_FLG_WEP_KEY_MAP);
+	key_flags |= cpu_to_le16(STA_KEY_NOT_VALID);
+
+	if (mcast)
+		key_flags |= cpu_to_le16(STA_KEY_MULTICAST);
+
+	/*
+	 * The fields assigned here are in the same location at the start
+	 * of the command, so we can do this union trick.
+	 */
+	u.cmd.common.key_flags = key_flags;
+	u.cmd.common.key_offset = keyconf->hw_key_idx;
+	u.cmd.common.sta_id = sta_id;
+
+	size = new_api ? sizeof(u.cmd) : sizeof(u.cmd_v1);
+
+	status = ADD_STA_SUCCESS;
+	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, size, &u.cmd,
+					  &status);
+
+	switch (status) {
+	case ADD_STA_SUCCESS:
+		IWL_DEBUG_WEP(mvm, "MODIFY_STA: remove sta key passed\n");
+		break;
+	default:
+		ret = -EIO;
+		IWL_ERR(mvm, "MODIFY_STA: remove sta key failed\n");
+		break;
+	}
+
+	return ret;
+}
+
 /*
  * Send the FW a request to remove the station from it's internal data
  * structures, and in addition remove it from the local data structure.
@@ -2365,6 +2420,28 @@ int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	iwl_mvm_disable_txq(mvm, NULL, mvmvif->cab_queue, 0, 0);
 
+	if (mvmvif->ap_wep_key) {
+		int i;
+
+		if (!__test_and_clear_bit(mvmvif->ap_wep_key->hw_key_idx,
+					  mvm->fw_key_table)) {
+			IWL_ERR(mvm, "offset %d not used in fw key table.\n",
+				mvmvif->ap_wep_key->hw_key_idx);
+			return -ENOENT;
+		}
+
+		/* track which key was deleted last */
+		for (i = 0; i < STA_KEY_MAX_NUM; i++) {
+			if (mvm->fw_key_deleted[i] < U8_MAX)
+				mvm->fw_key_deleted[i]++;
+		}
+		mvm->fw_key_deleted[mvmvif->ap_wep_key->hw_key_idx] = 0;
+		ret = __iwl_mvm_remove_sta_key(mvm, mvmvif->mcast_sta.sta_id,
+					       mvmvif->ap_wep_key, true);
+		if (ret)
+			return ret;
+	}
+
 	ret = iwl_mvm_rm_sta_common(mvm, mvmvif->mcast_sta.sta_id);
 	if (ret)
 		IWL_WARN(mvm, "Failed sending remove station\n");
@@ -3396,59 +3473,6 @@ static int __iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	return ret;
 }
 
-static int __iwl_mvm_remove_sta_key(struct iwl_mvm *mvm, u8 sta_id,
-				    struct ieee80211_key_conf *keyconf,
-				    bool mcast)
-{
-	union {
-		struct iwl_mvm_add_sta_key_cmd_v1 cmd_v1;
-		struct iwl_mvm_add_sta_key_cmd cmd;
-	} u = {};
-	bool new_api = fw_has_api(&mvm->fw->ucode_capa,
-				  IWL_UCODE_TLV_API_TKIP_MIC_KEYS);
-	__le16 key_flags;
-	int ret, size;
-	u32 status;
-
-	/* This is a valid situation for GTK removal */
-	if (sta_id == IWL_MVM_INVALID_STA)
-		return 0;
-
-	key_flags = cpu_to_le16((keyconf->keyidx << STA_KEY_FLG_KEYID_POS) &
-				 STA_KEY_FLG_KEYID_MSK);
-	key_flags |= cpu_to_le16(STA_KEY_FLG_NO_ENC | STA_KEY_FLG_WEP_KEY_MAP);
-	key_flags |= cpu_to_le16(STA_KEY_NOT_VALID);
-
-	if (mcast)
-		key_flags |= cpu_to_le16(STA_KEY_MULTICAST);
-
-	/*
-	 * The fields assigned here are in the same location at the start
-	 * of the command, so we can do this union trick.
-	 */
-	u.cmd.common.key_flags = key_flags;
-	u.cmd.common.key_offset = keyconf->hw_key_idx;
-	u.cmd.common.sta_id = sta_id;
-
-	size = new_api ? sizeof(u.cmd) : sizeof(u.cmd_v1);
-
-	status = ADD_STA_SUCCESS;
-	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA_KEY, size, &u.cmd,
-					  &status);
-
-	switch (status) {
-	case ADD_STA_SUCCESS:
-		IWL_DEBUG_WEP(mvm, "MODIFY_STA: remove sta key passed\n");
-		break;
-	default:
-		ret = -EIO;
-		IWL_ERR(mvm, "MODIFY_STA: remove sta key failed\n");
-		break;
-	}
-
-	return ret;
-}
-
 int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 			struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 0614296244b3..79700c7310a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -394,6 +394,7 @@ struct iwl_mvm_rxq_dup_data {
  *	the BA window. To be used for UAPSD only.
  * @ptk_pn: per-queue PTK PN data structures
  * @dup_data: per queue duplicate packet detection data
+ * @wep_key: used in AP mode. Is a duplicate of the WEP key.
  * @deferred_traffic_tid_map: indication bitmap of deferred traffic per-TID
  * @tx_ant: the index of the antenna to use for data tx to this station. Only
  *	used during connection establishment (e.g. for the 4 way handshake
@@ -425,6 +426,8 @@ struct iwl_mvm_sta {
 	struct iwl_mvm_key_pn __rcu *ptk_pn[4];
 	struct iwl_mvm_rxq_dup_data *dup_data;
 
+	struct ieee80211_key_conf *wep_key;
+
 	u8 reserved_queue;
 
 	/* Temporary, until the new TLC will control the Tx protection */
-- 
2.20.1

