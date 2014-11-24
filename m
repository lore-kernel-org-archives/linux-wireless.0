Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:46091 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaKXOf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:29 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so12191245wgh.26
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:28 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 19/75] iwlwifi: mvm: add support for WMM Access Control
Date: Mon, 24 Nov 2014 16:33:55 +0200
Message-Id: <1416839691-28533-19-git-send-email-egrumbach@gmail.com> (sfid-20141124_154434_382069_ADA51228)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

After the corresponding mac80211 patch, we can now report the airtime
used for each transmitted packet and mac80211 will be able to implement
WMM-AC with that information.

To support WMM-AC in the driver then, report the airtime and advertise
support.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  3 ++-
 drivers/net/wireless/iwlwifi/mvm/sta.h      |  2 ++
 drivers/net/wireless/iwlwifi/mvm/tx.c       | 10 ++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 92e1810..19aff50 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -423,7 +423,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 			       NL80211_FEATURE_LOW_PRIORITY_SCAN |
 			       NL80211_FEATURE_P2P_GO_OPPPS |
 			       NL80211_FEATURE_DYNAMIC_SMPS |
-			       NL80211_FEATURE_STATIC_SMPS;
+			       NL80211_FEATURE_STATIC_SMPS |
+			       NL80211_FEATURE_SUPPORTS_WMM_ADMISSION;
 
 	if (mvm->fw->ucode_capa.capa[0] &
 	    IWL_UCODE_TLV_CAPA_TXPOWER_INSERTION_SUPPORT)
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index d9c0d7b..84f37ca 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -264,6 +264,7 @@ enum iwl_mvm_agg_state {
  *	the first packet to be sent in legacy HW queue in Tx AGG stop flow.
  *	Basically when next_reclaimed reaches ssn, we can tell mac80211 that
  *	we are ready to finish the Tx AGG stop / start flow.
+ * @tx_time: medium time consumed by this A-MPDU
  */
 struct iwl_mvm_tid_data {
 	u16 seq_number;
@@ -274,6 +275,7 @@ struct iwl_mvm_tid_data {
 	enum iwl_mvm_agg_state state;
 	u16 txq_id;
 	u16 ssn;
+	u16 tx_time;
 };
 
 static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 4789c77..b54708e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -658,6 +658,12 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			seq_ctl = le16_to_cpu(hdr->seq_ctrl);
 		}
 
+		/*
+		 * TODO: this is not accurate if we are freeing more than one
+		 * packet.
+		 */
+		info->status.tx_time =
+			le16_to_cpu(tx_resp->wireless_media_time);
 		BUILD_BUG_ON(ARRAY_SIZE(info->status.status_driver_data) < 1);
 		info->status.status_driver_data[0] =
 				(void *)(uintptr_t)tx_resp->reduced_tpc;
@@ -850,6 +856,8 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 		mvmsta->tid_data[tid].rate_n_flags =
 			le32_to_cpu(tx_resp->initial_rate);
 		mvmsta->tid_data[tid].reduced_tpc = tx_resp->reduced_tpc;
+		mvmsta->tid_data[tid].tx_time =
+			le16_to_cpu(tx_resp->wireless_media_time);
 	}
 
 	rcu_read_unlock();
@@ -878,6 +886,8 @@ static void iwl_mvm_tx_info_from_ba_notif(struct ieee80211_tx_info *info,
 	info->status.ampdu_len = ba_notif->txed;
 	iwl_mvm_hwrate_to_tx_status(tid_data->rate_n_flags,
 				    info);
+	/* TODO: not accounted if the whole A-MPDU failed */
+	info->status.tx_time = tid_data->tx_time;
 	info->status.status_driver_data[0] =
 		(void *)(uintptr_t)tid_data->reduced_tpc;
 }
-- 
1.9.1

