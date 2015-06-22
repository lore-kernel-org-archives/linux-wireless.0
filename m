Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63128 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932730AbbFVIGk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:06:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M80NBC000563
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:06:40 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1v57pduf03-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:06:40 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 01/17] mwifiex: add tx data pause support
Date: Mon, 22 Jun 2015 19:06:07 +0530
Message-ID: <1434980183-2901-2-git-send-email-patila@marvell.com> (sfid-20150622_100645_307133_033B9C54)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to enable TX data pause feature for mwifiex.
Whenever FW TX buffers reach threshold, FW would send TX pause event
to driver. Driver in turn would block data traffic to that particular
receiver address.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h        |  9 +++++
 drivers/net/wireless/mwifiex/main.h      |  3 ++
 drivers/net/wireless/mwifiex/sta_event.c | 66 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.c       | 38 ++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.h       |  2 +
 5 files changed, 118 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index cd09051..8ab0d81 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -169,6 +169,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_UAP_PS_AO_TIMER    (PROPRIETARY_TLV_BASE_ID + 123)
 #define TLV_TYPE_PWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 145)
 #define TLV_TYPE_GWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 146)
+#define TLV_TYPE_TX_PAUSE           (PROPRIETARY_TLV_BASE_ID + 148)
 #define TLV_TYPE_COALESCE_RULE      (PROPRIETARY_TLV_BASE_ID + 154)
 #define TLV_TYPE_KEY_PARAM_V2       (PROPRIETARY_TLV_BASE_ID + 156)
 #define TLV_TYPE_TDLS_IDLE_TIMEOUT  (PROPRIETARY_TLV_BASE_ID + 194)
@@ -509,6 +510,7 @@ enum P2P_MODES {
 #define EVENT_TDLS_GENERIC_EVENT        0x00000052
 #define EVENT_RADAR_DETECTED		0x00000053
 #define EVENT_CHANNEL_REPORT_RDY        0x00000054
+#define EVENT_TX_DATA_PAUSE             0x00000055
 #define EVENT_EXT_SCAN_REPORT           0x00000058
 #define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
 #define EVENT_TX_STATUS_REPORT		0x00000074
@@ -1131,6 +1133,13 @@ struct host_cmd_ds_tx_rate_query {
 	u8 ht_info;
 } __packed;
 
+struct mwifiex_tx_pause_tlv {
+	struct mwifiex_ie_types_header header;
+	u8 peermac[ETH_ALEN];
+	u8 tx_pause;
+	u8 pkt_cnt;
+} __packed;
+
 enum Host_Sleep_Action {
 	HS_CONFIGURE = 0x0001,
 	HS_ACTIVATE  = 0x0002,
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ae98b5b..2106a5c 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -281,6 +281,7 @@ struct mwifiex_ra_list_tbl {
 	u8 amsdu_in_ampdu;
 	u16 total_pkt_count;
 	bool tdls_link;
+	bool tx_paused;
 };
 
 struct mwifiex_tid_tbl {
@@ -294,6 +295,7 @@ struct mwifiex_tid_tbl {
 struct mwifiex_wmm_desc {
 	struct mwifiex_tid_tbl tid_tbl_ptr[MAX_NUM_TID];
 	u32 packets_out[MAX_NUM_TID];
+	u32 pkts_paused[MAX_NUM_TID];
 	/* spin lock to protect ra_list */
 	spinlock_t ra_list_spinlock;
 	struct mwifiex_wmm_ac_status ac_status[IEEE80211_NUM_ACS];
@@ -768,6 +770,7 @@ struct mwifiex_sta_node {
 	u8 tdls_status;
 	struct mwifiex_tdls_capab tdls_cap;
 	struct mwifiex_station_stats stats;
+	u8 tx_pause;
 };
 
 struct mwifiex_auto_tdls_peer {
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 848de26..0a80814 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -182,6 +182,67 @@ static int mwifiex_parse_tdls_event(struct mwifiex_private *priv,
 	return ret;
 }
 
+static void
+mwifiex_process_sta_tx_pause_event(struct mwifiex_private *priv,
+				   struct sk_buff *event_skb)
+{
+	struct mwifiex_ie_types_header *tlv;
+	struct mwifiex_tx_pause_tlv *tp_tlv;
+	struct mwifiex_sta_node *sta_ptr;
+	unsigned long flags;
+	u16 tlv_type, tlv_len;
+	int tlv_buf_left, status;
+
+	if (!ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info))
+		return;
+
+	if (!(priv->bss_type == MWIFIEX_BSS_TYPE_STA && priv->media_connected))
+		return;
+
+	tlv_buf_left = event_skb->len - sizeof(u32);
+	tlv = (void *)event_skb->data + sizeof(u32);
+	while (tlv_buf_left >= (int)sizeof(struct mwifiex_ie_types_header)) {
+		tlv_type = le16_to_cpu(tlv->type);
+		tlv_len  = le16_to_cpu(tlv->len);
+		if ((sizeof(struct mwifiex_ie_types_header) + tlv_len) >
+		   tlv_buf_left) {
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "wrong tlv: tlvLen=%d, tlvBufLeft=%d\n",
+				    tlv_len, tlv_buf_left);
+			break;
+		}
+		if (tlv_type == TLV_TYPE_TX_PAUSE) {
+			tp_tlv = (void *)tlv;
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "TxPause: %pM pause=%d, pkts=%d\n",
+				    tp_tlv->peermac, tp_tlv->tx_pause,
+				    tp_tlv->pkt_cnt);
+			status = mwifiex_get_tdls_link_status
+					(priv,	tp_tlv->peermac);
+			if (status == TDLS_SETUP_COMPLETE) {
+				spin_lock_irqsave(&priv->sta_list_spinlock,
+						  flags);
+				sta_ptr = mwifiex_get_sta_entry
+						(priv, tp_tlv->peermac);
+				spin_unlock_irqrestore(&priv->sta_list_spinlock,
+						       flags);
+				if (sta_ptr && sta_ptr->tx_pause !=
+							     tp_tlv->tx_pause) {
+					sta_ptr->tx_pause = tp_tlv->tx_pause;
+					mwifiex_update_ralist_tx_pause
+						(priv, tp_tlv->peermac,
+						 tp_tlv->tx_pause);
+				}
+			}
+		}
+
+		tlv_buf_left -= sizeof(struct mwifiex_ie_types_header) +
+				tlv_len;
+		tlv = (void *)((u8 *)tlv + tlv_len +
+			       sizeof(struct mwifiex_ie_types_header));
+	}
+}
+
 /*
 * This function handles coex events generated by firmware
 */
@@ -573,6 +634,11 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		ret = mwifiex_parse_tdls_event(priv, adapter->event_skb);
 		break;
 
+	case EVENT_TX_DATA_PAUSE:
+		mwifiex_process_sta_tx_pause_event(priv, adapter->event_skb);
+		mwifiex_dbg(adapter, EVENT, "event: TX DATA PAUSE\n");
+		break;
+
 	case EVENT_TX_STATUS_REPORT:
 		mwifiex_dbg(adapter, EVENT, "event: TX_STATUS Report\n");
 		mwifiex_parse_tx_status_event(priv, adapter->event_body);
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index a8ea21c..bc920a5 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -160,6 +160,7 @@ void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra)
 		ra_list->tdls_link = false;
 		ra_list->ba_status = BA_SETUP_NONE;
 		ra_list->amsdu_in_ampdu = false;
+		ra_list->tx_paused = false;
 		if (!mwifiex_queuing_ra_based(priv)) {
 			if (mwifiex_get_tdls_link_status(priv, ra) ==
 			    TDLS_SETUP_COMPLETE) {
@@ -603,6 +604,43 @@ mwifiex_wmm_get_ralist_node(struct mwifiex_private *priv, u8 tid,
 	return NULL;
 }
 
+void mwifiex_update_ralist_tx_pause(struct mwifiex_private *priv, u8 *mac,
+				    u8 tx_pause)
+{
+	struct mwifiex_ra_list_tbl *ra_list;
+	u32 pkt_cnt = 0, tx_pkts_queued;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+
+	for (i = 0; i < MAX_NUM_TID; ++i) {
+		ra_list = mwifiex_wmm_get_ralist_node(priv, i, mac);
+		if (ra_list && ra_list->tx_paused != tx_pause) {
+			pkt_cnt += ra_list->total_pkt_count;
+			ra_list->tx_paused = tx_pause;
+			if (tx_pause)
+				priv->wmm.pkts_paused[i] +=
+					ra_list->total_pkt_count;
+			else
+				priv->wmm.pkts_paused[i] -=
+					ra_list->total_pkt_count;
+		}
+	}
+
+	if (pkt_cnt) {
+		tx_pkts_queued = atomic_read(&priv->wmm.tx_pkts_queued);
+		if (tx_pause)
+			tx_pkts_queued -= pkt_cnt;
+		else
+			tx_pkts_queued += pkt_cnt;
+
+		atomic_set(&priv->wmm.tx_pkts_queued, tx_pkts_queued);
+		atomic_set(&priv->wmm.highest_queued_prio, HIGH_PRIO_TID);
+	}
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+}
+
 /*
  * This function retrieves an RA list node for a given TID and
  * RA address pair.
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index 48ece0b..90edb8f 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -126,6 +126,8 @@ struct mwifiex_ra_list_tbl *
 mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid,
 			    const u8 *ra_addr);
 u8 mwifiex_wmm_downgrade_tid(struct mwifiex_private *priv, u32 tid);
+void mwifiex_update_ralist_tx_pause(struct mwifiex_private *priv, u8 *mac,
+				    u8 tx_pause);
 
 struct mwifiex_ra_list_tbl *mwifiex_wmm_get_ralist_node(struct mwifiex_private
 					*priv, u8 tid, const u8 *ra_addr);
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
