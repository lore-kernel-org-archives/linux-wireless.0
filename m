Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38705 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932256AbbFVIHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:07:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M80NBF000563
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:06 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1v57pduf10-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:06 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 05/17] mwifiex: process tdls channel switch event
Date: Mon, 22 Jun 2015 19:06:11 +0530
Message-ID: <1434980183-2901-6-git-send-email-patila@marvell.com> (sfid-20150622_100711_285131_6CEBBC47)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add support for tdls channel switch event process.
We block TX queues for particular RA list depending upon channel
switch state. If channel switch state is moving to base channel,
we unblock RA lists for AP. If channel switch state is moving to off
channel, we unblock TDLS peer RA lists.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h        | 17 +++++++++-
 drivers/net/wireless/mwifiex/sta_event.c | 54 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.c       | 45 ++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.h       |  2 ++
 4 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 8ab0d81..0785e64 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -547,7 +547,14 @@ enum P2P_MODES {
 #define ACT_TDLS_DELETE            0x00
 #define ACT_TDLS_CREATE            0x01
 #define ACT_TDLS_CONFIG            0x02
-#define TDLS_EVENT_LINK_TEAR_DOWN  3
+
+#define TDLS_EVENT_LINK_TEAR_DOWN      3
+#define TDLS_EVENT_CHAN_SWITCH_RESULT  7
+#define TDLS_EVENT_START_CHAN_SWITCH   8
+#define TDLS_EVENT_CHAN_SWITCH_STOPPED 9
+
+#define TDLS_BASE_CHANNEL	       0
+#define TDLS_OFF_CHANNEL	       1
 
 #define MWIFIEX_FW_V15		   15
 
@@ -1936,10 +1943,18 @@ struct host_cmd_ds_802_11_subsc_evt {
 	__le16 events;
 } __packed;
 
+struct chan_switch_result {
+	u8 cur_chan;
+	u8 status;
+	u8 reason;
+} __packed;
+
 struct mwifiex_tdls_generic_event {
 	__le16 type;
 	u8 peer_mac[ETH_ALEN];
 	union {
+		struct chan_switch_result switch_result;
+		u8 cs_stop_reason;
 		__le16 reason_code;
 		__le16 reserved;
 	} u;
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 0a80814..0529b9a 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -153,6 +153,7 @@ static int mwifiex_parse_tdls_event(struct mwifiex_private *priv,
 	struct mwifiex_sta_node *sta_ptr;
 	struct mwifiex_tdls_generic_event *tdls_evt =
 			(void *)event_skb->data + sizeof(adapter->event_cause);
+	u8 *mac = tdls_evt->peer_mac;
 
 	/* reserved 2 bytes are not mandatory in tdls event */
 	if (event_skb->len < (sizeof(struct mwifiex_tdls_generic_event) -
@@ -175,6 +176,59 @@ static int mwifiex_parse_tdls_event(struct mwifiex_private *priv,
 					   le16_to_cpu(tdls_evt->u.reason_code),
 					   GFP_KERNEL);
 		break;
+	case TDLS_EVENT_CHAN_SWITCH_RESULT:
+		mwifiex_dbg(adapter, EVENT, "tdls channel switch result :\n");
+		mwifiex_dbg(adapter, EVENT,
+			    "status=0x%x, reason=0x%x cur_chan=%d\n",
+			    tdls_evt->u.switch_result.status,
+			    tdls_evt->u.switch_result.reason,
+			    tdls_evt->u.switch_result.cur_chan);
+
+		/* tdls channel switch failed */
+		if (tdls_evt->u.switch_result.status != 0) {
+			switch (tdls_evt->u.switch_result.cur_chan) {
+			case TDLS_BASE_CHANNEL:
+				sta_ptr->tdls_status = TDLS_IN_BASE_CHAN;
+				break;
+			case TDLS_OFF_CHANNEL:
+				sta_ptr->tdls_status = TDLS_IN_OFF_CHAN;
+				break;
+			default:
+				break;
+			}
+			return ret;
+		}
+
+		/* tdls channel switch success */
+		switch (tdls_evt->u.switch_result.cur_chan) {
+		case TDLS_BASE_CHANNEL:
+			if (sta_ptr->tdls_status == TDLS_IN_BASE_CHAN)
+				break;
+			mwifiex_update_ralist_tx_pause_in_tdls_cs(priv, mac,
+								  false);
+			sta_ptr->tdls_status = TDLS_IN_BASE_CHAN;
+			break;
+		case TDLS_OFF_CHANNEL:
+			if (sta_ptr->tdls_status == TDLS_IN_OFF_CHAN)
+				break;
+			mwifiex_update_ralist_tx_pause_in_tdls_cs(priv, mac,
+								  true);
+			sta_ptr->tdls_status = TDLS_IN_OFF_CHAN;
+			break;
+		default:
+			break;
+		}
+
+		break;
+	case TDLS_EVENT_START_CHAN_SWITCH:
+		mwifiex_dbg(adapter, EVENT, "tdls start channel switch...\n");
+		sta_ptr->tdls_status = TDLS_CHAN_SWITCHING;
+		break;
+	case TDLS_EVENT_CHAN_SWITCH_STOPPED:
+		mwifiex_dbg(adapter, EVENT,
+			    "tdls chan switch stopped, reason=%d\n",
+			    tdls_evt->u.cs_stop_reason);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 8e343b3..21712cd 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -641,6 +641,51 @@ void mwifiex_update_ralist_tx_pause(struct mwifiex_private *priv, u8 *mac,
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 }
 
+/* This function update non-tdls peer ralist tx_pause while
+ * tdls channel swithing
+ */
+void mwifiex_update_ralist_tx_pause_in_tdls_cs(struct mwifiex_private *priv,
+					       u8 *mac, u8 tx_pause)
+{
+	struct mwifiex_ra_list_tbl *ra_list;
+	u32 pkt_cnt = 0, tx_pkts_queued;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+
+	for (i = 0; i < MAX_NUM_TID; ++i) {
+		list_for_each_entry(ra_list, &priv->wmm.tid_tbl_ptr[i].ra_list,
+				    list) {
+			if (!memcmp(ra_list->ra, mac, ETH_ALEN))
+				continue;
+
+			if (ra_list && ra_list->tx_paused != tx_pause) {
+				pkt_cnt += ra_list->total_pkt_count;
+				ra_list->tx_paused = tx_pause;
+				if (tx_pause)
+					priv->wmm.pkts_paused[i] +=
+						ra_list->total_pkt_count;
+				else
+					priv->wmm.pkts_paused[i] -=
+						ra_list->total_pkt_count;
+			}
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
index 90edb8f..c12dd0e 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -128,6 +128,8 @@ mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid,
 u8 mwifiex_wmm_downgrade_tid(struct mwifiex_private *priv, u32 tid);
 void mwifiex_update_ralist_tx_pause(struct mwifiex_private *priv, u8 *mac,
 				    u8 tx_pause);
+void mwifiex_update_ralist_tx_pause_in_tdls_cs(struct mwifiex_private *priv,
+					       u8 *mac, u8 tx_pause);
 
 struct mwifiex_ra_list_tbl *mwifiex_wmm_get_ralist_node(struct mwifiex_private
 					*priv, u8 tid, const u8 *ra_addr);
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
