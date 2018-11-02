Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA78FC6786F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EA412082E
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EA412082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbeKBUPD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:15:03 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:34024 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726700AbeKBUPA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:15:00 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIXJD-0007MW-TD; Fri, 02 Nov 2018 13:08:12 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  2 Nov 2018 13:07:52 +0200
Message-Id: <20181102110800.29817-8-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102110800.29817-1-luca@coelho.fi>
References: <20181102110800.29817-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/15] iwlwifi: mvm: toggle tx antenna if tx fails during connection establishment
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

If tx fails during connection establishment, try another antenna for
the next tx. This will increase the chance to establish connection if
one of the antennas is blocked.  Note that the antenna is toggled even
when failing to tx data frames since connection establishment may use
EAPOLs for 802.1X authentication/ 4 way handshake.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c  | 65 +++++++++++++++-----
 3 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 79ccc698ad83..e82194836f03 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1768,6 +1768,8 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	if (iwl_mvm_has_tlc_offload(mvm))
 		iwl_mvm_rs_add_sta(mvm, mvm_sta);
 
+	iwl_mvm_toggle_tx_ant(mvm, &mvm_sta->tx_ant);
+
 update_fw:
 	ret = iwl_mvm_sta_send_to_fw(mvm, sta, sta_update, sta_flags);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index de1a0a2d8723..d52cd888f77d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -397,6 +397,9 @@ struct iwl_mvm_rxq_dup_data {
  * @ptk_pn: per-queue PTK PN data structures
  * @dup_data: per queue duplicate packet detection data
  * @deferred_traffic_tid_map: indication bitmap of deferred traffic per-TID
+ * @tx_ant: the index of the antenna to use for data tx to this station. Only
+ *	used during connection establishment (e.g. for the 4 way handshake
+ *	exchange).
  *
  * When mac80211 creates a station it reserves some space (hw->sta_data_size)
  * in the structure for use by driver. This structure is placed in that
@@ -439,6 +442,7 @@ struct iwl_mvm_sta {
 	u8 agg_tids;
 	u8 sleep_tx_count;
 	u8 avg_energy;
+	u8 tx_ant;
 };
 
 u16 iwl_mvm_tid_queued(struct iwl_mvm *mvm, struct iwl_mvm_tid_data *tid_data);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ac4fa0363942..09cabf336310 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -302,13 +302,30 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 					    offload_assist));
 }
 
+static u32 iwl_mvm_get_tx_ant(struct iwl_mvm *mvm,
+			      struct ieee80211_tx_info *info,
+			      struct ieee80211_sta *sta, __le16 fc)
+{
+	if (info->band == NL80211_BAND_2GHZ &&
+	    !iwl_mvm_bt_coex_is_shared_ant_avail(mvm))
+		return mvm->cfg->non_shared_ant << RATE_MCS_ANT_POS;
+
+	if (sta && ieee80211_is_data(fc)) {
+		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+		return BIT(mvmsta->tx_ant) << RATE_MCS_ANT_POS;
+	}
+
+	return BIT(mvm->mgmt_last_antenna_idx) << RATE_MCS_ANT_POS;
+}
+
 static u32 iwl_mvm_get_tx_rate(struct iwl_mvm *mvm,
 			       struct ieee80211_tx_info *info,
 			       struct ieee80211_sta *sta)
 {
 	int rate_idx;
 	u8 rate_plcp;
-	u32 rate_flags;
+	u32 rate_flags = 0;
 
 	/* HT rate doesn't make sense for a non data frame */
 	WARN_ONCE(info->control.rates[0].flags & IEEE80211_TX_RC_MCS,
@@ -332,13 +349,6 @@ static u32 iwl_mvm_get_tx_rate(struct iwl_mvm *mvm,
 	/* Get PLCP rate for tx_cmd->rate_n_flags */
 	rate_plcp = iwl_mvm_mac80211_idx_to_hwrate(rate_idx);
 
-	if (info->band == NL80211_BAND_2GHZ &&
-	    !iwl_mvm_bt_coex_is_shared_ant_avail(mvm))
-		rate_flags = mvm->cfg->non_shared_ant << RATE_MCS_ANT_POS;
-	else
-		rate_flags =
-			BIT(mvm->mgmt_last_antenna_idx) << RATE_MCS_ANT_POS;
-
 	/* Set CCK flag as needed */
 	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
 		rate_flags |= RATE_MCS_CCK_MSK;
@@ -346,6 +356,14 @@ static u32 iwl_mvm_get_tx_rate(struct iwl_mvm *mvm,
 	return (u32)rate_plcp | rate_flags;
 }
 
+static u32 iwl_mvm_get_tx_rate_n_flags(struct iwl_mvm *mvm,
+				       struct ieee80211_tx_info *info,
+				       struct ieee80211_sta *sta, __le16 fc)
+{
+	return iwl_mvm_get_tx_rate(mvm, info, sta) |
+		iwl_mvm_get_tx_ant(mvm, info, sta, fc);
+}
+
 /*
  * Sets the fields in the Tx cmd that are rate related
  */
@@ -373,16 +391,21 @@ void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm, struct iwl_tx_cmd *tx_cmd,
 	 */
 
 	if (ieee80211_is_data(fc) && sta) {
-		tx_cmd->initial_rate_index = 0;
-		tx_cmd->tx_flags |= cpu_to_le32(TX_CMD_FLG_STA_RATE);
-		return;
+		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+		if (mvmsta->sta_state >= IEEE80211_STA_AUTHORIZED) {
+			tx_cmd->initial_rate_index = 0;
+			tx_cmd->tx_flags |= cpu_to_le32(TX_CMD_FLG_STA_RATE);
+			return;
+		}
 	} else if (ieee80211_is_back_req(fc)) {
 		tx_cmd->tx_flags |=
 			cpu_to_le32(TX_CMD_FLG_ACK | TX_CMD_FLG_BAR);
 	}
 
 	/* Set the rate in the TX cmd */
-	tx_cmd->rate_n_flags = cpu_to_le32(iwl_mvm_get_tx_rate(mvm, info, sta));
+	tx_cmd->rate_n_flags =
+		cpu_to_le32(iwl_mvm_get_tx_rate_n_flags(mvm, info, sta, fc));
 }
 
 static inline void iwl_mvm_set_tx_cmd_pn(struct ieee80211_tx_info *info,
@@ -487,6 +510,8 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 		u16 offload_assist = 0;
 		u32 rate_n_flags = 0;
 		u16 flags = 0;
+		struct iwl_mvm_sta *mvmsta = sta ?
+			iwl_mvm_sta_from_mac80211(sta) : NULL;
 
 		if (ieee80211_is_data_qos(hdr->frame_control)) {
 			u8 *qc = ieee80211_get_qos_ctl(hdr);
@@ -506,10 +531,16 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 		if (!info->control.hw_key)
 			flags |= IWL_TX_FLAGS_ENCRYPT_DIS;
 
-		/* For data packets rate info comes from the fw */
-		if (!(ieee80211_is_data(hdr->frame_control) && sta)) {
+		/*
+		 * For data packets rate info comes from the fw. Only
+		 * set rate/antenna during connection establishment.
+		 */
+		if (sta && (!ieee80211_is_data(hdr->frame_control) ||
+			    mvmsta->sta_state < IEEE80211_STA_AUTHORIZED)) {
 			flags |= IWL_TX_FLAGS_CMD_RATE;
-			rate_n_flags = iwl_mvm_get_tx_rate(mvm, info, sta);
+			rate_n_flags =
+				iwl_mvm_get_tx_rate_n_flags(mvm, info, sta,
+							    hdr->frame_control);
 		}
 
 		if (mvm->trans->cfg->device_family >=
@@ -1600,6 +1631,10 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		iwl_mvm_tx_airtime(mvm, mvmsta,
 				   le16_to_cpu(tx_resp->wireless_media_time));
 
+		if ((status & TX_STATUS_MSK) != TX_STATUS_SUCCESS &&
+		    mvmsta->sta_state < IEEE80211_STA_AUTHORIZED)
+			iwl_mvm_toggle_tx_ant(mvm, &mvmsta->tx_ant);
+
 		if (sta->wme && tid != IWL_MGMT_TID) {
 			struct iwl_mvm_tid_data *tid_data =
 				&mvmsta->tid_data[tid];
-- 
2.19.1

