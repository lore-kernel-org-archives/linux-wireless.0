Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33876 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752988AbdHKNqY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 09:46:24 -0400
Received: by mail-pf0-f193.google.com with SMTP id t86so3539734pfe.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Aug 2017 06:46:24 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 07/11] rsi: data and managemet path changes for AP mode
Date: Fri, 11 Aug 2017 19:11:25 +0530
Message-Id: <1502458889-9690-8-git-send-email-amitkarwar@gmail.com> (sfid-20170811_154636_672671_4261F8BB)
In-Reply-To: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Station id needs to be get for data and management frames
to fill in the descruptor for AP mode. Few other changes
related to AP mode are covered here.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 55 ++++++++++++++++++++++------
 drivers/net/wireless/rsi/rsi_91x_hal.c  | 64 ++++++++++++++++++++++++---------
 drivers/net/wireless/rsi/rsi_common.h   |  1 +
 drivers/net/wireless/rsi/rsi_hal.h      |  2 +-
 drivers/net/wireless/rsi/rsi_mgmt.h     |  1 +
 5 files changed, 96 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 6cfda86..2b0516d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -320,6 +320,20 @@ void rsi_core_qos_processor(struct rsi_common *common)
 	}
 }
 
+struct rsi_sta *rsi_find_sta(struct rsi_common *common, u8 *mac_addr)
+{
+	int i;
+
+	for (i = 0; i < common->max_stations; i++) {
+		if (!common->stations[i].sta)
+			continue;
+		if (!(memcmp(common->stations[i].sta->addr,
+			     mac_addr, ETH_ALEN)))
+			return &common->stations[i];
+	}
+	return NULL;
+}
+
 /**
  * rsi_core_xmit() - This function transmits the packets received from mac80211
  * @common: Pointer to the driver private structure.
@@ -332,39 +346,60 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_tx_info *info;
 	struct skb_info *tx_params;
-	struct ieee80211_hdr *tmp_hdr = NULL;
+	struct ieee80211_hdr *wh;
+	struct ieee80211_vif *vif = adapter->vifs[0];
 	u8 q_num, tid = 0;
+	struct rsi_sta *rsta = NULL;
 
 	if ((!skb) || (!skb->len)) {
 		rsi_dbg(ERR_ZONE, "%s: Null skb/zero Length packet\n",
 			__func__);
 		goto xmit_fail;
 	}
-	info = IEEE80211_SKB_CB(skb);
-	tx_params = (struct skb_info *)info->driver_data;
-	tmp_hdr = (struct ieee80211_hdr *)&skb->data[0];
-
 	if (common->fsm_state != FSM_MAC_INIT_DONE) {
 		rsi_dbg(ERR_ZONE, "%s: FSM state not open\n", __func__);
 		goto xmit_fail;
 	}
 
-	if ((ieee80211_is_mgmt(tmp_hdr->frame_control)) ||
-	    (ieee80211_is_ctl(tmp_hdr->frame_control)) ||
-	    (ieee80211_is_qos_nullfunc(tmp_hdr->frame_control))) {
+	info = IEEE80211_SKB_CB(skb);
+	tx_params = (struct skb_info *)info->driver_data;
+	wh = (struct ieee80211_hdr *)&skb->data[0];
+	tx_params->sta_id = 0;
+
+	if ((ieee80211_is_mgmt(wh->frame_control)) ||
+	    (ieee80211_is_ctl(wh->frame_control)) ||
+	    (ieee80211_is_qos_nullfunc(wh->frame_control))) {
 		q_num = MGMT_SOFT_Q;
 		skb->priority = q_num;
 	} else {
-		if (ieee80211_is_data_qos(tmp_hdr->frame_control)) {
+		if (ieee80211_is_data_qos(wh->frame_control)) {
 			tid = (skb->data[24] & IEEE80211_QOS_TID);
 			skb->priority = TID_TO_WME_AC(tid);
 		} else {
 			tid = IEEE80211_NONQOS_TID;
 			skb->priority = BE_Q;
 		}
+
 		q_num = skb->priority;
 		tx_params->tid = tid;
-		tx_params->sta_id = 0;
+
+		if ((vif->type == NL80211_IFTYPE_AP) &&
+		    (!is_broadcast_ether_addr(wh->addr1)) &&
+		    (!is_multicast_ether_addr(wh->addr1))) {
+			rsta = rsi_find_sta(common, wh->addr1);
+			if (!rsta)
+				goto xmit_fail;
+			tx_params->sta_id = rsta->sta_id;
+		}
+
+		if (rsta) {
+			/* Start aggregation if not done for this tid */
+			if (!rsta->start_tx_aggr[tid]) {
+				rsta->start_tx_aggr[tid] = true;
+				ieee80211_start_tx_ba_session(rsta->sta,
+							      tid, 0);
+			}
+		}
 	}
 
 	if ((q_num < MGMT_SOFT_Q) &&
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 1ed7332..070dfd6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -18,6 +18,7 @@
 #include "rsi_mgmt.h"
 #include "rsi_hal.h"
 #include "rsi_sdio.h"
+#include "rsi_common.h"
 
 /* FLASH Firmware */
 static struct ta_metadata metadata_flash_content[] = {
@@ -41,7 +42,7 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 	struct ieee80211_hdr *wh = NULL;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_conf *conf = &adapter->hw->conf;
-	struct ieee80211_vif *vif = NULL;
+	struct ieee80211_vif *vif = adapter->vifs[0];
 	struct rsi_mgmt_desc *mgmt_desc;
 	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss = NULL;
@@ -49,6 +50,11 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 	u8 header_size;
 	u32 dword_align_bytes = 0;
 
+	if (skb->len > MAX_MGMT_PKT_SIZE) {
+		rsi_dbg(INFO_ZONE, "%s: Dropping mgmt pkt > 512\n", __func__);
+		return -EINVAL;
+	}
+
 	info = IEEE80211_SKB_CB(skb);
 	tx_params = (struct skb_info *)info->driver_data;
 
@@ -74,15 +80,10 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 	memset(&skb->data[0], 0, header_size);
 	bss = &info->control.vif->bss_conf;
 	wh = (struct ieee80211_hdr *)&skb->data[header_size];
-	vif = adapter->vifs[0];
 
 	mgmt_desc = (struct rsi_mgmt_desc *)skb->data;
 	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
 
-	if (skb->len > MAX_MGMT_PKT_SIZE) {
-		rsi_dbg(INFO_ZONE, "%s: Dropping mgmt pkt > 512\n", __func__);
-		return -EINVAL;
-	}
 	rsi_set_len_qno(&mgmt_desc->len_qno, (skb->len - FRAME_DESC_SZ),
 			RSI_WIFI_MGMT_Q);
 	mgmt_desc->frame_type = TX_DOT11_MGMT;
@@ -113,6 +114,22 @@ static int rsi_prepare_mgmt_desc(struct rsi_common *common, struct sk_buff *skb)
 		}
 	}
 
+	if (ieee80211_is_probe_resp(wh->frame_control)) {
+		mgmt_desc->misc_flags |= (RSI_ADD_DELTA_TSF_VAP_ID |
+					  RSI_FETCH_RETRY_CNT_FRM_HST);
+#define PROBE_RESP_RETRY_CNT	3
+		xtend_desc->retry_cnt = PROBE_RESP_RETRY_CNT;
+	}
+
+	if ((vif->type == NL80211_IFTYPE_AP) &&
+	    (ieee80211_is_action(wh->frame_control))) {
+		struct rsi_sta *rsta = rsi_find_sta(common, wh->addr1);
+
+		if (rsta)
+			mgmt_desc->sta_id = tx_params->sta_id;
+		else
+			return -EINVAL;
+	}
 	return 0;
 }
 
@@ -157,7 +174,7 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 
 	xtend_desc = (struct xtended_desc *)&skb->data[FRAME_DESC_SZ];
 	wh = (struct ieee80211_hdr *)&skb->data[header_size];
-	seq_num = (le16_to_cpu(wh->seq_ctrl) >> 4);
+	seq_num = IEEE80211_SEQ_TO_SN(le16_to_cpu(wh->seq_ctrl));
 	vif = adapter->vifs[0];
 
 	data_desc->xtend_desc_size = header_size - FRAME_DESC_SZ;
@@ -191,12 +208,11 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		if (conf_is_ht40(&common->priv->hw->conf))
 			data_desc->bbp_info = cpu_to_le16(FULL40M_ENABLE);
 
-		if (common->vif_info[0].sgi) {
-			if (common->min_rate & 0x100) /* Only MCS rates */
-				data_desc->rate_info |=
-					cpu_to_le16(ENABLE_SHORTGI_RATE);
+		if ((common->vif_info[0].sgi) && (common->min_rate & 0x100)) {
+		       /* Only MCS rates */
+			data_desc->rate_info |=
+				cpu_to_le16(ENABLE_SHORTGI_RATE);
 		}
-
 	}
 
 	if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
@@ -223,7 +239,17 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		data_desc->frame_info = cpu_to_le16(RATE_INFO_ENABLE);
 		data_desc->frame_info |= cpu_to_le16(RSI_BROADCAST_PKT);
 		data_desc->sta_id = vap_id;
+
+		if (vif->type == NL80211_IFTYPE_AP) {
+			if (common->band == NL80211_BAND_5GHZ)
+				data_desc->rate_info = cpu_to_le16(RSI_RATE_6);
+			else
+				data_desc->rate_info = cpu_to_le16(RSI_RATE_1);
+		}
 	}
+	if ((vif->type == NL80211_IFTYPE_AP) &&
+	    (ieee80211_has_moredata(wh->frame_control)))
+		data_desc->frame_info |= cpu_to_le16(MORE_DATA_PRESENT);
 
 	return 0;
 }
@@ -232,17 +258,23 @@ static int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_vif *vif = adapter->vifs[0];
 	struct ieee80211_tx_info *info;
 	struct ieee80211_bss_conf *bss;
-	int status = -EIO;
+	int status = -EINVAL;
+
+	if (!skb)
+		return 0;
+	if (common->iface_down)
+		goto err;
 
 	info = IEEE80211_SKB_CB(skb);
+	if (!info->control.vif)
+		goto err;
 	bss = &info->control.vif->bss_conf;
 
-	if (!bss->assoc) {
-		status = -EINVAL;
+	if ((vif->type == NL80211_IFTYPE_STATION) && (!bss->assoc))
 		goto err;
-	}
 
 	status = rsi_prepare_data_desc(common, skb);
 	if (status)
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index 4434969..e579d69 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -83,4 +83,5 @@ u16 rsi_get_connected_channel(struct rsi_hw *adapter);
 struct rsi_hw *rsi_91x_init(void);
 void rsi_91x_deinit(struct rsi_hw *adapter);
 int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len);
+struct rsi_sta *rsi_find_sta(struct rsi_common *common, u8 *mac_addr);
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index 297f4ce..7c14505 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -126,7 +126,7 @@ struct rsi_mgmt_desc {
 	__le16 bbp_info;
 	__le16 seq_ctrl;
 	u8 reserved2;
-	u8 vap_info;
+	u8 sta_id;
 } __packed;
 
 struct rsi_data_desc {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index a2e377f..9c59250 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -63,6 +63,7 @@
 #define BBP_REG_WRITE                   0
 #define RF_RESET_ENABLE                 BIT(3)
 #define RATE_INFO_ENABLE                BIT(0)
+#define MORE_DATA_PRESENT		BIT(1)
 #define RSI_BROADCAST_PKT               BIT(9)
 #define RSI_DESC_REQUIRE_CFM_TO_HOST	BIT(2)
 #define RSI_ADD_DELTA_TSF_VAP_ID	BIT(3)
-- 
2.7.4
