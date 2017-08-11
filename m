Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36373 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752972AbdHKNqg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 09:46:36 -0400
Received: by mail-pg0-f65.google.com with SMTP id y129so3184651pgy.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Aug 2017 06:46:36 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 10/11] rsi: aggregation parameters frame for AP mode
Date: Fri, 11 Aug 2017 19:11:28 +0530
Message-Id: <1502458889-9690-11-git-send-email-amitkarwar@gmail.com> (sfid-20170811_154649_840596_30019591)
In-Reply-To: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

TX command frame ampdu aggregation parameters is updated to
include sta_id for AP mode.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 43 +++++++++++++++++++++++------
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  6 ++--
 drivers/net/wireless/rsi/rsi_mgmt.h         |  3 +-
 3 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 6eb93ad..5e94445 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -866,9 +866,11 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 	int status = -EOPNOTSUPP;
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
-	u16 seq_no = 0;
+	struct rsi_sta *rsta = NULL;
+	u16 seq_no = 0, seq_start = 0;
 	u8 ii = 0;
 	struct ieee80211_sta *sta = params->sta;
+	u8 sta_id = 0;
 	enum ieee80211_ampdu_mlme_action action = params->action;
 	u16 tid = params->tid;
 	u16 *ssn = &params->ssn;
@@ -880,17 +882,31 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 	}
 
 	mutex_lock(&common->mutex);
-	rsi_dbg(INFO_ZONE, "%s: AMPDU action %d called\n", __func__, action);
+
 	if (ssn != NULL)
 		seq_no = *ssn;
 
+	if (vif->type == NL80211_IFTYPE_AP) {
+		rsta = rsi_find_sta(common, sta->addr);
+		if (!rsta) {
+			rsi_dbg(ERR_ZONE, "No station mapped\n");
+			return 0;
+		}
+		sta_id = rsta->sta_id;
+	}
+
+	rsi_dbg(INFO_ZONE,
+		"%s: AMPDU action tid=%d ssn=0x%x, buf_size=%d sta_id=%d\n",
+		__func__, tid, seq_no, buf_size, sta_id);
+
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		status = rsi_send_aggregation_params_frame(common,
 							   tid,
 							   seq_no,
 							   buf_size,
-							   STA_RX_ADDBA_DONE);
+							   STA_RX_ADDBA_DONE,
+							   sta_id);
 		break;
 
 	case IEEE80211_AMPDU_RX_STOP:
@@ -898,11 +914,15 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 							   tid,
 							   0,
 							   buf_size,
-							   STA_RX_DELBA);
+							   STA_RX_DELBA,
+							   sta_id);
 		break;
 
 	case IEEE80211_AMPDU_TX_START:
-		common->vif_info[ii].seq_start = seq_no;
+		if (vif->type == NL80211_IFTYPE_STATION)
+			common->vif_info[ii].seq_start = seq_no;
+		else if (vif->type == NL80211_IFTYPE_AP)
+			rsta->seq_start[tid] = seq_no;
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		status = 0;
 		break;
@@ -914,18 +934,23 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 							   tid,
 							   seq_no,
 							   buf_size,
-							   STA_TX_DELBA);
+							   STA_TX_DELBA,
+							   sta_id);
 		if (!status)
 			ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		if (vif->type == NL80211_IFTYPE_STATION)
+			seq_start = common->vif_info[ii].seq_start;
+		else if (vif->type == NL80211_IFTYPE_AP)
+			seq_start = rsta->seq_start[tid];
 		status = rsi_send_aggregation_params_frame(common,
 							   tid,
-							   common->vif_info[ii]
-								.seq_start,
+							   seq_start,
 							   buf_size,
-							   STA_TX_ADDBA_DONE);
+							   STA_TX_ADDBA_DONE,
+							   sta_id);
 		break;
 
 	default:
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 8762d13..2d3cae5 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -537,11 +537,11 @@ int rsi_send_aggregation_params_frame(struct rsi_common *common,
 				      u16 tid,
 				      u16 ssn,
 				      u8 buf_size,
-				      u8 event)
+				      u8 event,
+				      u8 sta_id)
 {
 	struct sk_buff *skb = NULL;
 	struct rsi_aggr_params *aggr_params;
-	u8 peer_id = 0;
 	u16 frame_len = sizeof(struct rsi_aggr_params);
 
 	skb = dev_alloc_skb(frame_len);
@@ -561,7 +561,7 @@ int rsi_send_aggregation_params_frame(struct rsi_common *common,
 	aggr_params->desc_dword0.frame_type = AMPDU_IND;
 
 	aggr_params->aggr_params = tid & RSI_AGGR_PARAMS_TID_MASK;
-	aggr_params->peer_id = peer_id;
+	aggr_params->peer_id = sta_id;
 	if (event == STA_TX_ADDBA_DONE) {
 		aggr_params->seq_start = cpu_to_le16(ssn);
 		aggr_params->baw_size = cpu_to_le16(buf_size);
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index c50153d..2d82733 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -609,7 +609,8 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg);
 int rsi_set_vap_capabilities(struct rsi_common *common, enum opmode mode,
 			     u8 *mac_addr, u8 vap_id, u8 vap_status);
 int rsi_send_aggregation_params_frame(struct rsi_common *common, u16 tid,
-				      u16 ssn, u8 buf_size, u8 event);
+				      u16 ssn, u8 buf_size, u8 event,
+				      u8 sta_id);
 int rsi_hal_load_key(struct rsi_common *common, u8 *data, u16 key_len,
 		     u8 key_type, u8 key_id, u32 cipher);
 int rsi_set_channel(struct rsi_common *common,
-- 
2.7.4
