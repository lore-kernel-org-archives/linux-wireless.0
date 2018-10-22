Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655E5C67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3589220652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:56:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FgK+e7qA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UF1Cmzea"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3589220652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbeJWCQA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 22:16:00 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38288 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728658AbeJWCQA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 22:16:00 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 874726130A; Mon, 22 Oct 2018 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540230988;
        bh=xescxlBWn0yw1GwXf9PFwekLre4fHJsY8h1ZMjOaMfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgK+e7qA6EpWSSvJntd61ZcBHrCByuZQnDhAZEkQ/xcXhWnc9B21BoIvi2G0ce15q
         RJwjdgiHM4r+pKNTD49kj5dKZiO8MJByri1dJHudYqBGEzfo9APkLMN09mNwBwLjxy
         yl/M/Pxgno0PuBG5k7WWldng4vaRRCeYUzX0tLqc=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5494B60CEB;
        Mon, 22 Oct 2018 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540230986;
        bh=xescxlBWn0yw1GwXf9PFwekLre4fHJsY8h1ZMjOaMfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UF1Cmzeaatqvg17cj/Mm8zumfCo15b8WsJjlXJsm4Qqbc1LayJqexXIlD+M+E+eOM
         4FtdVdY8cf9noYz1X//IXFTtj/fcm9D6L/nt9GLSz93kqtvec4g5mIde33S0VhRT8Z
         GfBKkYgl0EsCcOzVkNW0XMNxXiS7s05//P2EEZ0g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5494B60CEB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 4/4] ath10k: Add support to configure TID specific configuration
Date:   Mon, 22 Oct 2018 23:25:18 +0530
Message-Id: <1540230918-27712-5-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch add ops for set_tid_conf to support
station specific retry and aggregation configuration for a TID.
station and configuration parameter(TID, configuration changed
parameter through ieee80211_tid_conf) information will be passed
as an argument for this ops.
Since target accepts one parameter as a retry count, ath10k
pass retry_long along with TID and station's mac address to target
in the command and store this if TID_RETRY_CONF_CHANGED.
And pass enable/disable aggregation for the TID
if TID_AGGR_CONF_CHANGED is passed. Depends on the changed
parameter the respective value stored in arsta struct.

Suppose if the station entry is not mentioned in the command,
the configuration will be applied for all the connected stations
in the vif.

And this configuration will be stored in arvif to apply this
configuration for newly connecting station.

Testing:
        * Tested HW: QCA9888
        * Tested FW: 10.4-3.5.1-00052

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h |  23 ++++
 drivers/net/wireless/ath/ath10k/mac.c  | 240 +++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi.c  |   6 +-
 drivers/net/wireless/ath/ath10k/wmi.h  |   1 +
 4 files changed, 245 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 418eb19..1ce46f4 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -93,6 +93,9 @@
 /* Number of TID target accepts from host */
 #define ATH10K_MAX_TIDS	0x8
 
+/* Upper limit/default retry count for a ppdu */
+#define	ATH10K_MAX_RETRY_COUNT 30
+
 struct ath10k;
 
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
@@ -506,6 +509,16 @@ struct ath10k_sta {
 	int noack_map;
 	struct work_struct noack_map_wk;
 
+	/* TID retry count for a station and by default
+	 * this will have -1 for all the TIDs until user changes
+	 * the retry count by specifying station's MAC address
+	 */
+	int retry_count[ATH10K_MAX_TIDS];
+
+	/* TID aggregation control value for the station */
+	u8 aggr_ctrl[ATH10K_MAX_TIDS];
+	struct work_struct tid_cfg_wk;
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/* protected by conf_mutex */
 	bool aggr_mode;
@@ -584,6 +597,16 @@ struct ath10k_vif {
 
 	/* TID bitmap for station's NoAck policy, protected by conf_mutex */
 	int noack_map;
+
+	/* TID retry count for all the stations in the vif */
+	int retry_count[ATH10K_MAX_TIDS];
+
+	/* TID aggregation control parameter fo all the connected
+	 * stations in the vif
+	 */
+	u8 aggr_ctrl[ATH10K_MAX_TIDS];
+	u8 tid_conf_changed;
+	u8 tid;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 54ec919..258473e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2973,6 +2973,57 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static int ath10k_new_peer_tid_config(struct ath10k *ar,
+				      struct ieee80211_sta *sta,
+				      struct ath10k_vif *arvif)
+{
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct wmi_per_peer_per_tid_cfg_arg arg = {};
+	int i, ret;
+
+	if (arvif->noack_map) {
+		arg.vdev_id = arvif->vdev_id;
+		ether_addr_copy(arg.peer_macaddr.addr, sta->addr);
+
+		ret = ath10k_mac_set_noack_tid_bitmap(ar, &arg,
+						      arvif->noack_map);
+		if (ret) {
+			ath10k_warn(ar, "failed to set peer tid noack policy for sta %pM: %d\n",
+				    sta->addr, ret);
+			return ret;
+		}
+	}
+
+	/* Assign default noack_map value (-1) to newly connecting station.
+	 * This default value used to identify the station configured with
+	 * vif specific noack configuration rather than station specific.
+	 */
+	arsta->noack_map = -1;
+	memset(&arg, 0, sizeof(arg));
+
+	for (i = 0; i < ATH10K_MAX_TIDS; i++) {
+		if (arvif->retry_count[i] || arvif->aggr_ctrl[i]) {
+			arg.tid = i;
+			arg.vdev_id = arvif->vdev_id;
+			arg.retry_count = arvif->retry_count[i];
+			arg.aggr_control = arvif->aggr_ctrl[i];
+			ether_addr_copy(arg.peer_macaddr.addr, sta->addr);
+			ret = ath10k_wmi_set_per_peer_per_tid_cfg(ar, &arg);
+			if (ret) {
+				ath10k_warn(ar, "failed to set per tid retry/aggr config for sta %pM: %d\n",
+					    sta->addr, ret);
+				return ret;
+			}
+		}
+		/* Assign default retry count(-1) to newly connected station.
+		 * This is to identify station specific tid retry count not
+		 * configured for the station.
+		 */
+		arsta->retry_count[i] = -1;
+	}
+	return 0;
+}
+
 static int ath10k_station_assoc(struct ath10k *ar,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta,
@@ -2980,7 +3031,6 @@ static int ath10k_station_assoc(struct ath10k *ar,
 {
 	struct ath10k_vif *arvif = (void *)vif->drv_priv;
 	struct wmi_peer_assoc_complete_arg peer_arg;
-	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
 	int ret = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
@@ -3039,24 +3089,10 @@ static int ath10k_station_assoc(struct ath10k *ar,
 		}
 	}
 
-	if (arvif->noack_map) {
-		struct wmi_per_peer_per_tid_cfg_arg arg = {};
-
-		arg.vdev_id = arvif->vdev_id;
-		ether_addr_copy(arg.peer_macaddr.addr, sta->addr);
-
-		ret = ath10k_mac_set_noack_tid_bitmap(ar, &arg,
-						      arvif->noack_map);
-		if (ret)
-			return ret;
-	}
+	if (!test_bit(WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT, ar->wmi.svc_map))
+		return 0;
 
-	/* Assign default noack_map value (-1) to newly connecting station.
-	 * This default value used to identify the station configured with
-	 * vif specific noack configuration rather than station specific.
-	 */
-	arsta->noack_map = -1;
-	return ret;
+	return ath10k_new_peer_tid_config(ar, sta, arvif);
 }
 
 static int ath10k_station_disassoc(struct ath10k *ar,
@@ -6315,7 +6351,7 @@ static void ath10k_mac_dec_num_stations(struct ath10k_vif *arvif,
 	ar->num_stations--;
 }
 
-struct ath10k_mac_iter_noack_map_data {
+struct ath10k_mac_iter_tid_config {
 	struct ieee80211_vif *curr_vif;
 	struct ath10k *ar;
 };
@@ -6342,7 +6378,7 @@ static void ath10k_mac_vif_stations_noack_map(void *data,
 					      struct ieee80211_sta *sta)
 {
 	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
-	struct ath10k_mac_iter_noack_map_data *iter_data = data;
+	struct ath10k_mac_iter_tid_config *iter_data = data;
 	struct ieee80211_vif *sta_vif = arsta->arvif->vif;
 
 	if (sta_vif != iter_data->curr_vif || arsta->noack_map != -1)
@@ -6351,6 +6387,56 @@ static void ath10k_mac_vif_stations_noack_map(void *data,
 	ieee80211_queue_work(iter_data->ar->hw, &arsta->noack_map_wk);
 }
 
+static void ath10k_sta_tid_cfg_wk(struct work_struct *wk)
+{
+	struct wmi_per_peer_per_tid_cfg_arg arg = {};
+	struct ieee80211_sta *sta;
+	struct ath10k_sta *arsta;
+	struct ath10k_vif *arvif;
+	struct ath10k *ar;
+	int ret;
+
+	arsta = container_of(wk, struct ath10k_sta, noack_map_wk);
+	sta = container_of((void *)arsta, struct ieee80211_sta, drv_priv);
+	arvif = arsta->arvif;
+	ar = arvif->ar;
+	arg.vdev_id = arvif->vdev_id;
+	arg.tid = arvif->tid;
+	ether_addr_copy(arg.peer_macaddr.addr, sta->addr);
+
+	if (arvif->tid_conf_changed & TID_RETRY_CONF_CHANGED) {
+		if (arsta->retry_count[arvif->tid] != -1)
+			return;
+
+		arg.retry_count = arvif->retry_count[arvif->tid];
+	}
+
+	if (arvif->tid_conf_changed & TID_AGGR_CONF_CHANGED) {
+		if (arsta->aggr_ctrl[arvif->tid])
+			return;
+
+		arg.aggr_control = arvif->aggr_ctrl[arvif->tid];
+	}
+
+	ret = ath10k_wmi_set_per_peer_per_tid_cfg(ar, &arg);
+	if (ret)
+		ath10k_warn(ar, "failed to set per tid retry/aggr config for sta %pM: %d\n",
+			    sta->addr, ret);
+}
+
+static void ath10k_mac_vif_stations_tid_conf(void *data,
+					     struct ieee80211_sta *sta)
+{
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k_mac_iter_tid_config *iter_data = data;
+	struct ieee80211_vif *sta_vif = arsta->arvif->vif;
+
+	if (sta_vif != iter_data->curr_vif)
+		return;
+
+	ieee80211_queue_work(iter_data->ar->hw, &arsta->tid_cfg_wk);
+}
+
 static int ath10k_sta_state(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta,
@@ -6372,6 +6458,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		INIT_WORK(&arsta->update_wk, ath10k_sta_rc_update_wk);
 		INIT_WORK(&arsta->noack_map_wk,
 			  ath10k_sta_set_noack_tid_bitmap);
+		INIT_WORK(&arsta->tid_cfg_wk, ath10k_sta_tid_cfg_wk);
 
 		for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 			ath10k_mac_txq_init(sta->txq[i]);
@@ -6382,6 +6469,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 	     new_state == IEEE80211_STA_NOTEXIST)) {
 		cancel_work_sync(&arsta->update_wk);
 		cancel_work_sync(&arsta->noack_map_wk);
+		cancel_work_sync(&arsta->tid_cfg_wk);
 	}
 
 	mutex_lock(&ar->conf_mutex);
@@ -7996,7 +8084,7 @@ static int ath10k_mac_op_set_noack_tid_bitmap(struct ieee80211_hw *hw,
 					      int noack_map)
 {
 	struct ath10k_vif *arvif = (void *)vif->drv_priv;
-	struct ath10k_mac_iter_noack_map_data data = {};
+	struct ath10k_mac_iter_tid_config data = {};
 	struct wmi_per_peer_per_tid_cfg_arg arg = {};
 	struct ath10k *ar = hw->priv;
 	struct ath10k_sta *arsta;
@@ -8039,6 +8127,98 @@ static int ath10k_mac_op_set_noack_tid_bitmap(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static int ath10k_mac_op_set_tid_conf(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_sta *sta,
+				      struct ieee80211_tid_conf *tid_conf,
+				      u8 changed)
+{
+	int ret;
+	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif = (void *)vif->drv_priv;
+	struct ath10k_mac_iter_tid_config data = {};
+	struct wmi_per_peer_per_tid_cfg_arg arg = {};
+	struct ath10k_sta *arsta;
+
+	if (!(changed & TID_RETRY_CONF_CHANGED) &&
+	    !(changed & TID_AGGR_CONF_CHANGED))
+		return 0;
+
+	mutex_lock(&ar->conf_mutex);
+	arg.vdev_id = arvif->vdev_id;
+	arg.tid = tid_conf->tid;
+
+	if (sta) {
+		arsta = (struct ath10k_sta *)sta->drv_priv;
+		ether_addr_copy(arg.peer_macaddr.addr, sta->addr);
+
+		if (changed & TID_RETRY_CONF_CHANGED) {
+			if (tid_conf->retry_long ==
+			    arsta->retry_count[arg.tid]) {
+				ret = 0;
+				goto exit;
+			}
+
+			if (tid_conf->retry_long == -1) {
+				if (arvif->retry_count[arg.tid])
+					arg.retry_count =
+						arvif->retry_count[arg.tid];
+				else
+					arg.retry_count =
+						ATH10K_MAX_RETRY_COUNT;
+			} else {
+				arg.retry_count = tid_conf->retry_long;
+			}
+		}
+		if (changed & TID_AGGR_CONF_CHANGED) {
+			if (tid_conf->aggr)
+				arg.aggr_control =
+					WMI_TID_CONFIG_AGGR_CONTROL_ENABLE;
+			else
+				arg.aggr_control =
+					WMI_TID_CONFIG_AGGR_CONTROL_DISABLE;
+		}
+
+		ret = ath10k_wmi_set_per_peer_per_tid_cfg(ar, &arg);
+		if (!ret) {
+			/* Store the configured parameters in success case */
+			if (changed & TID_RETRY_CONF_CHANGED)
+				arsta->retry_count[arg.tid] =
+							tid_conf->retry_long;
+			if (changed & TID_AGGR_CONF_CHANGED)
+				arsta->aggr_ctrl[arg.tid] = arg.aggr_control;
+		}
+
+		goto exit;
+	}
+
+	ret = 0;
+
+	if (changed & TID_RETRY_CONF_CHANGED)
+		arvif->retry_count[tid_conf->tid] = tid_conf->retry_long;
+
+	if (changed & TID_AGGR_CONF_CHANGED) {
+		if (tid_conf->aggr)
+			arvif->aggr_ctrl[tid_conf->tid] =
+				WMI_TID_CONFIG_AGGR_CONTROL_ENABLE;
+		else
+			arvif->aggr_ctrl[tid_conf->tid] =
+				WMI_TID_CONFIG_AGGR_CONTROL_DISABLE;
+	}
+
+	data.curr_vif = vif;
+	data.ar = ar;
+	arvif->tid_conf_changed = changed;
+	arvif->tid = tid_conf->tid;
+	ieee80211_iterate_stations_atomic(hw,
+					  ath10k_mac_vif_stations_tid_conf,
+					  &data);
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_mac_op_tx,
 	.wake_tx_queue			= ath10k_mac_op_wake_tx_queue,
@@ -8082,6 +8262,7 @@ static int ath10k_mac_op_set_noack_tid_bitmap(struct ieee80211_hw *hw,
 	.sta_pre_rcu_remove		= ath10k_mac_op_sta_pre_rcu_remove,
 	.sta_statistics			= ath10k_sta_statistics,
 	.set_noack_tid_bitmap           = ath10k_mac_op_set_noack_tid_bitmap,
+	.set_tid_conf			= ath10k_mac_op_set_tid_conf,
 
 	CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
 
@@ -8736,11 +8917,24 @@ int ath10k_mac_register(struct ath10k *ar)
 		wiphy_ext_feature_set(ar->hw->wiphy,
 				      NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT);
 
-	if (test_bit(WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT, ar->wmi.svc_map))
+	if (test_bit(WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT, ar->wmi.svc_map)) {
 		wiphy_ext_feature_set(ar->hw->wiphy,
 				      NL80211_EXT_FEATURE_PER_STA_NOACK_MAP);
-	else
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG);
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG);
+		wiphy_ext_feature_set(ar->hw->wiphy,
+			      NL80211_EXT_FEATURE_PER_TID_AMPDU_AGGR_CTRL);
+		wiphy_ext_feature_set(ar->hw->wiphy,
+			      NL80211_EXT_FEATURE_PER_STA_AMPDU_AGGR_CTRL);
+		ar->hw->wiphy->max_data_retry_count = ATH10K_MAX_RETRY_COUNT;
+		ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_MAX_DATA_RETRY_COUNT;
+	} else {
 		ar->ops->set_noack_tid_bitmap = NULL;
+		ar->ops->set_tid_conf = NULL;
+		ar->hw->wiphy->flags &= ~WIPHY_FLAG_HAS_MAX_DATA_RETRY_COUNT;
+	}
 
 	/*
 	 * on LL hardware queues are managed entirely by the FW
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 14fdc94..5666232 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -8764,10 +8764,12 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	cmd->ack_policy = cpu_to_le32(arg->ack_policy);
 	cmd->aggr_control = cpu_to_le32(arg->aggr_control);
 	cmd->rate_control = cpu_to_le32(arg->rate_ctrl);
+	cmd->sw_retry_threshold = cpu_to_le32(arg->retry_count);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi noack tid %d vdev id %d ack_policy %d aggr %u rate %u mac_addr %pM\n",
-		   arg->tid, arg->vdev_id, arg->ack_policy, arg->aggr_control, arg->rate_ctrl, arg->peer_macaddr.addr);
+		   "wmi noack tid %d vdev id %d ack_policy %d aggr %u rate %u retry_count %d mac_addr %pM\n",
+		   arg->tid, arg->vdev_id, arg->ack_policy, arg->aggr_control, arg->rate_ctrl, arg->retry_count,
+		   arg->peer_macaddr.addr);
 	return skb;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index d3571b6..0f1826d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -7086,6 +7086,7 @@ struct wmi_per_peer_per_tid_cfg_arg {
 	enum wmi_noack_tid_conf ack_policy;
 	enum wmi_tid_aggr_control_conf aggr_control;
 	enum wmi_tid_rate_ctrl_conf rate_ctrl;
+	u8 retry_count;
 };
 
 struct wmi_peer_per_tid_cfg_cmd {
-- 
1.9.1

