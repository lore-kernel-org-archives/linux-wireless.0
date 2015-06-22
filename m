Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36031 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933083AbbFVIIC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:08:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M7xr3g032680
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:08:01 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1v57pduf3x-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:08:01 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 13/17] mwifiex: extend tx_data pause to AP interface as well
Date: Mon, 22 Jun 2015 19:06:19 +0530
Message-ID: <1434980183-2901-14-git-send-email-patila@marvell.com> (sfid-20150622_103355_614237_1664E151)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to extend TX Data pause for AP intefaces.
Also for station role, support for pausing/unpausing all traffic
when mac address parameter is BSSID is added.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h      |   2 +
 drivers/net/wireless/mwifiex/sta_event.c | 121 ++++++++++++++++++++++---------
 drivers/net/wireless/mwifiex/uap_event.c |   4 +
 3 files changed, 93 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 6f98d7e..6e82058 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1554,6 +1554,8 @@ void mwifiex_queue_main_work(struct mwifiex_adapter *adapter);
 void mwifiex_coex_ampdu_rxwinsize(struct mwifiex_adapter *adapter);
 void mwifiex_11n_delba(struct mwifiex_private *priv, int tid);
 int mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy);
+void mwifiex_process_tx_pause_event(struct mwifiex_private *priv,
+				    struct sk_buff *event);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 72be16e..a2777d1 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -237,58 +237,110 @@ static int mwifiex_parse_tdls_event(struct mwifiex_private *priv,
 	return ret;
 }
 
-static void
-mwifiex_process_sta_tx_pause_event(struct mwifiex_private *priv,
-				   struct sk_buff *event_skb)
+static void mwifiex_process_uap_tx_pause(struct mwifiex_private *priv,
+					 struct mwifiex_ie_types_header *tlv)
 {
-	struct mwifiex_ie_types_header *tlv;
-	struct mwifiex_tx_pause_tlv *tp_tlv;
+	struct mwifiex_tx_pause_tlv *tp;
 	struct mwifiex_sta_node *sta_ptr;
 	unsigned long flags;
-	u16 tlv_type, tlv_len;
-	int tlv_buf_left, status;
 
-	if (!ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info))
-		return;
+	tp = (void *)tlv;
+	mwifiex_dbg(priv->adapter, EVENT,
+		    "uap tx_pause: %pM pause=%d, pkts=%d\n",
+		    tp->peermac, tp->tx_pause,
+		    tp->pkt_cnt);
+
+	if (ether_addr_equal(tp->peermac, priv->netdev->dev_addr)) {
+		if (tp->tx_pause)
+			priv->port_open = false;
+		else
+			priv->port_open = true;
+	} else if (is_multicast_ether_addr(tp->peermac)) {
+		mwifiex_update_ralist_tx_pause(priv, tp->peermac, tp->tx_pause);
+	} else {
+		spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+		sta_ptr = mwifiex_get_sta_entry(priv, tp->peermac);
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+
+		if (sta_ptr && sta_ptr->tx_pause != tp->tx_pause) {
+			sta_ptr->tx_pause = tp->tx_pause;
+			mwifiex_update_ralist_tx_pause(priv, tp->peermac,
+						       tp->tx_pause);
+		}
+	}
+}
+
+static void mwifiex_process_sta_tx_pause(struct mwifiex_private *priv,
+					 struct mwifiex_ie_types_header *tlv)
+{
+	struct mwifiex_tx_pause_tlv *tp;
+	struct mwifiex_sta_node *sta_ptr;
+	int status;
+	unsigned long flags;
+
+	tp = (void *)tlv;
+	mwifiex_dbg(priv->adapter, EVENT,
+		    "sta tx_pause: %pM pause=%d, pkts=%d\n",
+		    tp->peermac, tp->tx_pause,
+		    tp->pkt_cnt);
+
+	if (ether_addr_equal(tp->peermac, priv->cfg_bssid)) {
+		if (tp->tx_pause)
+			priv->port_open = false;
+		else
+			priv->port_open = true;
+	} else {
+		if (!ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info))
+			return;
+
+		status = mwifiex_get_tdls_link_status(priv, tp->peermac);
+		if (mwifiex_is_tdls_link_setup(status)) {
+			spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+			sta_ptr = mwifiex_get_sta_entry(priv, tp->peermac);
+			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+
+			if (sta_ptr && sta_ptr->tx_pause != tp->tx_pause) {
+				sta_ptr->tx_pause = tp->tx_pause;
+				mwifiex_update_ralist_tx_pause(priv,
+							       tp->peermac,
+							       tp->tx_pause);
+			}
+		}
+	}
+}
+
+void mwifiex_process_tx_pause_event(struct mwifiex_private *priv,
+				    struct sk_buff *event_skb)
+{
+	struct mwifiex_ie_types_header *tlv;
+	u16 tlv_type, tlv_len;
+	int tlv_buf_left;
 
-	if (!(priv->bss_type == MWIFIEX_BSS_TYPE_STA && priv->media_connected))
+	if (!priv->media_connected) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "tx_pause event while disconnected; bss_role=%d\n",
+			    priv->bss_role);
 		return;
+	}
 
 	tlv_buf_left = event_skb->len - sizeof(u32);
 	tlv = (void *)event_skb->data + sizeof(u32);
+
 	while (tlv_buf_left >= (int)sizeof(struct mwifiex_ie_types_header)) {
 		tlv_type = le16_to_cpu(tlv->type);
 		tlv_len  = le16_to_cpu(tlv->len);
 		if ((sizeof(struct mwifiex_ie_types_header) + tlv_len) >
-		   tlv_buf_left) {
+		    tlv_buf_left) {
 			mwifiex_dbg(priv->adapter, ERROR,
 				    "wrong tlv: tlvLen=%d, tlvBufLeft=%d\n",
 				    tlv_len, tlv_buf_left);
 			break;
 		}
 		if (tlv_type == TLV_TYPE_TX_PAUSE) {
-			tp_tlv = (void *)tlv;
-			mwifiex_dbg(priv->adapter, ERROR,
-				    "TxPause: %pM pause=%d, pkts=%d\n",
-				    tp_tlv->peermac, tp_tlv->tx_pause,
-				    tp_tlv->pkt_cnt);
-			status = mwifiex_get_tdls_link_status
-					(priv,	tp_tlv->peermac);
-			if (mwifiex_is_tdls_link_setup(status)) {
-				spin_lock_irqsave(&priv->sta_list_spinlock,
-						  flags);
-				sta_ptr = mwifiex_get_sta_entry
-						(priv, tp_tlv->peermac);
-				spin_unlock_irqrestore(&priv->sta_list_spinlock,
-						       flags);
-				if (sta_ptr && sta_ptr->tx_pause !=
-							     tp_tlv->tx_pause) {
-					sta_ptr->tx_pause = tp_tlv->tx_pause;
-					mwifiex_update_ralist_tx_pause
-						(priv, tp_tlv->peermac,
-						 tp_tlv->tx_pause);
-				}
-			}
+			if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
+				mwifiex_process_sta_tx_pause(priv, tlv);
+			else
+				mwifiex_process_uap_tx_pause(priv, tlv);
 		}
 
 		tlv_buf_left -= sizeof(struct mwifiex_ie_types_header) +
@@ -296,6 +348,7 @@ mwifiex_process_sta_tx_pause_event(struct mwifiex_private *priv,
 		tlv = (void *)((u8 *)tlv + tlv_len +
 			       sizeof(struct mwifiex_ie_types_header));
 	}
+
 }
 
 /*
@@ -691,8 +744,8 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		break;
 
 	case EVENT_TX_DATA_PAUSE:
-		mwifiex_process_sta_tx_pause_event(priv, adapter->event_skb);
 		mwifiex_dbg(adapter, EVENT, "event: TX DATA PAUSE\n");
+		mwifiex_process_tx_pause_event(priv, adapter->event_skb);
 		break;
 
 	case EVENT_TX_STATUS_REPORT:
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index a412c3d..a9d34c6 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -300,6 +300,10 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		mwifiex_bt_coex_wlan_param_update_event(priv,
 							adapter->event_skb);
 		break;
+	case EVENT_TX_DATA_PAUSE:
+		mwifiex_dbg(adapter, EVENT, "event: TX DATA PAUSE\n");
+		mwifiex_process_tx_pause_event(priv, adapter->event_skb);
+		break;
 	default:
 		mwifiex_dbg(adapter, EVENT,
 			    "event: unknown event id: %#x\n", eventcause);
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
