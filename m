Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63131 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaDMTUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:17 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so3126117wiv.15
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:16 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/47] iwlwifi: mvm: add lq_cmd/tx_resp reduced_tpc field
Date: Sun, 13 Apr 2014 22:19:19 +0300
Message-Id: <1397416802-32403-4-git-send-email-egrumbach@gmail.com> (sfid-20140413_212224_109517_D5E06420)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The fw recently added an option to set tx power reduction
per station (in the lq_cmd command), and get the tx power
reduction used (in the tx_resp struct).

Use them and propogate this value up to mac80211's tx
response (in order to use it later in the rate-scaling
algorithm).

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h | 2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h | 3 ++-
 drivers/net/wireless/iwlwifi/mvm/sta.h       | 3 +++
 drivers/net/wireless/iwlwifi/mvm/tx.c        | 7 +++++++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
index 39148b5..8bb5b94 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
@@ -334,7 +334,7 @@ enum {
  */
 struct iwl_lq_cmd {
 	u8 sta_id;
-	u8 reserved1;
+	u8 reduced_tpc;
 	u16 control;
 	/* LINK_QUAL_GENERAL_PARAMS_API_S_VER_1 */
 	u8 flags;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
index 8e122f3..6cc5f52 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -482,7 +482,8 @@ struct iwl_mvm_tx_resp {
 	u8 pa_integ_res_b[3];
 	u8 pa_integ_res_c[3];
 	__le16 measurement_req_id;
-	__le16 reserved;
+	u8 reduced_tpc;
+	u8 reserved;
 
 	__le32 tfd_info;
 	__le16 seq_ctl;
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index 2ed84c4..e5e3071 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -253,6 +253,8 @@ enum iwl_mvm_agg_state {
  *	This is basically (last acked packet++).
  * @rate_n_flags: Rate at which Tx was attempted. Holds the data between the
  *	Tx response (TX_CMD), and the block ack notification (COMPRESSED_BA).
+ * @reduced_tpc: Reduced tx power. Holds the data between the
+ *	Tx response (TX_CMD), and the block ack notification (COMPRESSED_BA).
  * @state: state of the BA agreement establishment / tear down.
  * @txq_id: Tx queue used by the BA session
  * @ssn: the first packet to be sent in AGG HW queue in Tx AGG start flow, or
@@ -265,6 +267,7 @@ struct iwl_mvm_tid_data {
 	u16 next_reclaimed;
 	/* The rest is Tx AGG related */
 	u32 rate_n_flags;
+	u8 reduced_tpc;
 	enum iwl_mvm_agg_state state;
 	u16 txq_id;
 	u16 ssn;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 879aeac..0a4ad45 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -636,6 +636,10 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			seq_ctl = le16_to_cpu(hdr->seq_ctrl);
 		}
 
+		BUILD_BUG_ON(ARRAY_SIZE(info->status.status_driver_data) < 1);
+		info->status.status_driver_data[0] =
+				(void *)(uintptr_t)tx_resp->reduced_tpc;
+
 		ieee80211_tx_status_ni(mvm->hw, skb);
 	}
 
@@ -815,6 +819,7 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 		mvmsta->tid_data[tid].rate_n_flags =
 			le32_to_cpu(tx_resp->initial_rate);
+		mvmsta->tid_data[tid].reduced_tpc = tx_resp->reduced_tpc;
 	}
 
 	rcu_read_unlock();
@@ -928,6 +933,8 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			info->status.ampdu_len = ba_notif->txed;
 			iwl_mvm_hwrate_to_tx_status(tid_data->rate_n_flags,
 						    info);
+			info->status.status_driver_data[0] =
+				(void *)(uintptr_t)tid_data->reduced_tpc;
 		}
 	}
 
-- 
1.8.3.2

