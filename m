Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7B5C5ACCA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69D0E2098A
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:43:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="anvBbN8y";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RWjH62Ry"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69D0E2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbeJQCez (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 22:34:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51988 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbeJQCez (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 22:34:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6B94361327; Tue, 16 Oct 2018 18:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715387;
        bh=aqvMJJAZTsxuImCpcfdG+ohEtAHpCsmXdGsyESGiXts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anvBbN8yqcuwA0Quh4n/7pwG6n889Yhq3kWrWS++1z5X7VzBa+L+iNd/HDWFJqvkQ
         IDJC2HuR7hBvXsGmzB/c4J2u7e3zQKuq3lZ8Anq3MoCS87huoURCp0kwcSuMJhI8Nh
         45yZY3xFrTJ//aCCcvY86K4SQfRdpehm0tBhXBO4=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 63BE46021C;
        Tue, 16 Oct 2018 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715384;
        bh=aqvMJJAZTsxuImCpcfdG+ohEtAHpCsmXdGsyESGiXts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWjH62Ry2tuehYklFI/1aYPdRzUlkX4ACh9v5Wh35nEm3rCh78LG4kRxMpRp3zYCU
         yxya4Z0hKLL6JhEGhX+b9mkq52/UvtkacJ25tVFbmpAbaVJWyYat+UzqcfKROoQB/B
         ZjS1nHUBkp5ERnPUNMFfKQmPO2J0GhR9IYY6AzXs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 63BE46021C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 6/6] ath10k: Add support for station specific noack TID policy
Date:   Wed, 17 Oct 2018 00:11:11 +0530
Message-Id: <1539715271-14325-7-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
References: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch add ops for set_noack_tid_bitmap to support
station specific noack policy functionality for a TID.
TID will be parsed from noack_map parameter and pass to target
with station's mac address and the ack policy, and the value
is stored in arsta.

Suppose if the station entry is not mentioned in the command, the configuration
will be applied for all the connected stations in the vif which have default
value(-1) in the arsta structure. And this will be applied for newly connecting
station as well.

ATH10K_SKB_F_NOACK_TID skb cb flag introduced to avoid
setting IEEE80211_TX_STAT_ACK flag in the tx completion.

WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT flag is added to
advertise this command support

Testing:
       * Tested HW: QCA9888
       * Tested FW: 10.4-3.5.1-00052

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h |  11 +++
 drivers/net/wireless/ath/ath10k/mac.c  | 172 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/txrx.c |  12 ++-
 3 files changed, 188 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 0424180..418eb19 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -90,6 +90,9 @@
 /* The magic used by QCA spec */
 #define ATH10K_SMBIOS_BDF_EXT_MAGIC "BDF_"
 
+/* Number of TID target accepts from host */
+#define ATH10K_MAX_TIDS	0x8
+
 struct ath10k;
 
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
@@ -116,6 +119,7 @@ enum ath10k_skb_flags {
 	ATH10K_SKB_F_DELIVER_CAB = BIT(2),
 	ATH10K_SKB_F_MGMT = BIT(3),
 	ATH10K_SKB_F_QOS = BIT(4),
+	ATH10K_SKB_F_NOACK_TID = BIT(5),
 };
 
 struct ath10k_skb_cb {
@@ -498,6 +502,10 @@ struct ath10k_sta {
 	u64 rx_duration;
 	struct ath10k_htt_tx_stats *tx_stats;
 
+	/* TID bitmap for station's NoAck policy, protected by conf_mutex */
+	int noack_map;
+	struct work_struct noack_map_wk;
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* protected by conf_mutex */
 	bool aggr_mode;
@@ -573,6 +581,9 @@ struct ath10k_vif {
 	struct work_struct ap_csa_work;
 	struct delayed_work connection_loss_work;
 	struct cfg80211_bitrate_mask bitrate_mask;
+
+	/* TID bitmap for station's NoAck policy, protected by conf_mutex */
+	int noack_map;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a1c2801..54ec919 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2940,6 +2940,39 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 	cancel_delayed_work_sync(&arvif->connection_loss_work);
 }
 
+static int
+ath10k_mac_set_noack_tid_bitmap(struct ath10k *ar,
+				struct wmi_per_peer_per_tid_cfg_arg *arg,
+				int noack_map)
+{
+	int tid, ret;
+
+	for (tid = 0; tid < ATH10K_MAX_TIDS; tid++) {
+		if (noack_map & BIT(tid)) {
+			arg->ack_policy = WMI_PEER_TID_CONFIG_NOACK;
+			/* It is preferred to transmit the noack policy frames
+			 * in basic rate. for 5G -> 6Mbps 2G -> 1Mbps
+			 */
+			arg->rate_ctrl =
+				WMI_TID_CONFIG_RATE_CONTROL_DEFAULT_LOWEST_RATE;
+			arg->aggr_control = WMI_TID_CONFIG_AGGR_CONTROL_DISABLE;
+		} else {
+			arg->ack_policy = WMI_PEER_TID_CONFIG_ACK;
+			arg->rate_ctrl = WMI_TID_CONFIG_RATE_CONTROL_AUTO;
+			arg->aggr_control = WMI_TID_CONFIG_AGGR_CONTROL_ENABLE;
+		}
+
+		arg->tid = tid;
+		ret = ath10k_wmi_set_per_peer_per_tid_cfg(ar, arg);
+		if (ret) {
+			ath10k_warn(ar, "failed to set noack map for STA %pM for vdev %i: %d\n",
+				    arg->peer_macaddr.addr, arg->vdev_id, ret);
+			break;
+		}
+	}
+	return ret;
+}
+
 static int ath10k_station_assoc(struct ath10k *ar,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta,
@@ -2947,6 +2980,7 @@ static int ath10k_station_assoc(struct ath10k *ar,
 {
 	struct ath10k_vif *arvif = (void *)vif->drv_priv;
 	struct wmi_peer_assoc_complete_arg peer_arg;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
 	int ret = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
@@ -3005,6 +3039,23 @@ static int ath10k_station_assoc(struct ath10k *ar,
 		}
 	}
 
+	if (arvif->noack_map) {
+		struct wmi_per_peer_per_tid_cfg_arg arg = {};
+
+		arg.vdev_id = arvif->vdev_id;
+		ether_addr_copy(arg.peer_macaddr.addr, sta->addr);
+
+		ret = ath10k_mac_set_noack_tid_bitmap(ar, &arg,
+						      arvif->noack_map);
+		if (ret)
+			return ret;
+	}
+
+	/* Assign default noack_map value (-1) to newly connecting station.
+	 * This default value used to identify the station configured with
+	 * vif specific noack configuration rather than station specific.
+	 */
+	arsta->noack_map = -1;
 	return ret;
 }
 
@@ -3543,10 +3594,15 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
 static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_txq *txq,
+				    struct ieee80211_sta *sta,
 				    struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
+	struct ath10k_vif *arvif = (void *)vif->drv_priv;
+	int noack_map = arvif->noack_map;
+	struct ath10k_sta *arsta;
+	u8 tid, *p;
 
 	cb->flags = 0;
 	if (!ath10k_tx_h_use_hwcrypto(vif, skb))
@@ -3555,8 +3611,20 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 	if (ieee80211_is_mgmt(hdr->frame_control))
 		cb->flags |= ATH10K_SKB_F_MGMT;
 
-	if (ieee80211_is_data_qos(hdr->frame_control))
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		cb->flags |= ATH10K_SKB_F_QOS;
+		p = ieee80211_get_qos_ctl(hdr);
+		tid = (*p) & IEEE80211_QOS_CTL_TID_MASK;
+
+		if (sta) {
+			arsta = (struct ath10k_sta *)sta->drv_priv;
+			if (arsta->noack_map != -1)
+				noack_map = arsta->noack_map;
+		}
+
+		if (noack_map & BIT(tid))
+			cb->flags |= ATH10K_SKB_F_NOACK_TID;
+	}
 
 	cb->vif = vif;
 	cb->txq = txq;
@@ -3987,7 +4055,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		return -ENOENT;
 	}
 
-	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
+	ath10k_mac_tx_h_fill_cb(ar, vif, txq, sta, skb);
 
 	skb_len = skb->len;
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
@@ -4258,7 +4326,7 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 	bool is_presp;
 	int ret;
 
-	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
+	ath10k_mac_tx_h_fill_cb(ar, vif, txq, sta, skb);
 
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
@@ -6247,6 +6315,42 @@ static void ath10k_mac_dec_num_stations(struct ath10k_vif *arvif,
 	ar->num_stations--;
 }
 
+struct ath10k_mac_iter_noack_map_data {
+	struct ieee80211_vif *curr_vif;
+	struct ath10k *ar;
+};
+
+static void ath10k_sta_set_noack_tid_bitmap(struct work_struct *wk)
+{
+	struct wmi_per_peer_per_tid_cfg_arg arg = {};
+	struct ieee80211_sta *sta;
+	struct ath10k_sta *arsta;
+	struct ath10k_vif *arvif;
+	struct ath10k *ar;
+
+	arsta = container_of(wk, struct ath10k_sta, noack_map_wk);
+	sta = container_of((void *)arsta, struct ieee80211_sta, drv_priv);
+	arvif = arsta->arvif;
+	ar = arvif->ar;
+
+	arg.vdev_id = arvif->vdev_id;
+	ether_addr_copy(arg.peer_macaddr.addr, sta->addr);
+	ath10k_mac_set_noack_tid_bitmap(ar, &arg, arvif->noack_map);
+}
+
+static void ath10k_mac_vif_stations_noack_map(void *data,
+					      struct ieee80211_sta *sta)
+{
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k_mac_iter_noack_map_data *iter_data = data;
+	struct ieee80211_vif *sta_vif = arsta->arvif->vif;
+
+	if (sta_vif != iter_data->curr_vif || arsta->noack_map != -1)
+		return;
+
+	ieee80211_queue_work(iter_data->ar->hw, &arsta->noack_map_wk);
+}
+
 static int ath10k_sta_state(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta,
@@ -6266,6 +6370,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		arsta->arvif = arvif;
 		arsta->peer_ps_state = WMI_PEER_PS_STATE_DISABLED;
 		INIT_WORK(&arsta->update_wk, ath10k_sta_rc_update_wk);
+		INIT_WORK(&arsta->noack_map_wk,
+			  ath10k_sta_set_noack_tid_bitmap);
 
 		for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 			ath10k_mac_txq_init(sta->txq[i]);
@@ -6273,8 +6379,10 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 	/* cancel must be done outside the mutex to avoid deadlock */
 	if ((old_state == IEEE80211_STA_NONE &&
-	     new_state == IEEE80211_STA_NOTEXIST))
+	     new_state == IEEE80211_STA_NOTEXIST)) {
 		cancel_work_sync(&arsta->update_wk);
+		cancel_work_sync(&arsta->noack_map_wk);
+	}
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -7882,6 +7990,55 @@ static void ath10k_sta_statistics(struct ieee80211_hw *hw,
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 }
 
+static int ath10k_mac_op_set_noack_tid_bitmap(struct ieee80211_hw *hw,
+					      struct ieee80211_vif *vif,
+					      struct ieee80211_sta *sta,
+					      int noack_map)
+{
+	struct ath10k_vif *arvif = (void *)vif->drv_priv;
+	struct ath10k_mac_iter_noack_map_data data = {};
+	struct wmi_per_peer_per_tid_cfg_arg arg = {};
+	struct ath10k *ar = hw->priv;
+	struct ath10k_sta *arsta;
+	int ret;
+
+	mutex_lock(&ar->conf_mutex);
+
+	arg.vdev_id = arvif->vdev_id;
+	if (sta) {
+		arsta = (struct ath10k_sta *)sta->drv_priv;
+		ether_addr_copy(arg.peer_macaddr.addr, sta->addr);
+		if (arsta->noack_map == noack_map)
+			goto exit;
+
+		if (noack_map == -1)
+			ret = ath10k_mac_set_noack_tid_bitmap(ar, &arg,
+							      arvif->noack_map);
+		else
+			ret = ath10k_mac_set_noack_tid_bitmap(ar, &arg,
+							      noack_map);
+		if (!ret)
+			arsta->noack_map = noack_map;
+
+		goto exit;
+	}
+
+	if (arvif->noack_map == noack_map)
+		goto exit;
+
+	data.curr_vif = vif;
+	data.ar = ar;
+	arvif->noack_map = noack_map;
+	ieee80211_iterate_stations_atomic(hw,
+					  ath10k_mac_vif_stations_noack_map,
+					  &data);
+	arvif->noack_map = noack_map;
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_mac_op_tx,
 	.wake_tx_queue			= ath10k_mac_op_wake_tx_queue,
@@ -7924,6 +8081,7 @@ static void ath10k_sta_statistics(struct ieee80211_hw *hw,
 	.switch_vif_chanctx		= ath10k_mac_op_switch_vif_chanctx,
 	.sta_pre_rcu_remove		= ath10k_mac_op_sta_pre_rcu_remove,
 	.sta_statistics			= ath10k_sta_statistics,
+	.set_noack_tid_bitmap           = ath10k_mac_op_set_noack_tid_bitmap,
 
 	CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
 
@@ -8578,6 +8736,12 @@ int ath10k_mac_register(struct ath10k *ar)
 		wiphy_ext_feature_set(ar->hw->wiphy,
 				      NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT);
 
+	if (test_bit(WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT, ar->wmi.svc_map))
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_PER_STA_NOACK_MAP);
+	else
+		ar->ops->set_noack_tid_bitmap = NULL;
+
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 23606b6..3b385d4 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -61,6 +61,7 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	struct ath10k_skb_cb *skb_cb;
 	struct ath10k_txq *artxq;
 	struct sk_buff *msdu;
+	u8 flags;
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt tx completion msdu_id %u status %d\n",
@@ -89,6 +90,8 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		artxq->num_fw_queued--;
 	}
 
+	flags = skb_cb->flags;
+
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
 	ath10k_htt_tx_dec_pending(htt);
 	if (htt->num_pending_tx == 0)
@@ -104,18 +107,21 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	memset(&info->status, 0, sizeof(info->status));
 	trace_ath10k_txrx_tx_unref(ar, tx_done->msdu_id);
 
-	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+	    !(flags & ATH10K_SKB_F_NOACK_TID))
 		info->flags |= IEEE80211_TX_STAT_ACK;
 
 	if (tx_done->status == HTT_TX_COMPL_STATE_NOACK)
 		info->flags &= ~IEEE80211_TX_STAT_ACK;
 
 	if ((tx_done->status == HTT_TX_COMPL_STATE_ACK) &&
-	    (info->flags & IEEE80211_TX_CTL_NO_ACK))
+	    ((info->flags & IEEE80211_TX_CTL_NO_ACK) ||
+	    (flags & ATH10K_SKB_F_NOACK_TID)))
 		info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
 
 	if (tx_done->status == HTT_TX_COMPL_STATE_DISCARD) {
-		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+		if ((info->flags & IEEE80211_TX_CTL_NO_ACK) ||
+		    (flags & ATH10K_SKB_F_NOACK_TID))
 			info->flags &= ~IEEE80211_TX_STAT_NOACK_TRANSMITTED;
 		else
 			info->flags &= ~IEEE80211_TX_STAT_ACK;
-- 
1.9.1

