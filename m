Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:59975 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1AUDEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:04:45 -0500
Received: by mail-px0-f174.google.com with SMTP id 15so217956pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:04:45 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63391.745854.390923@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:33:59 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 32/33] ath9k_htc: Use SKB's private area for TX parameters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

For all packets sent through the USB_WLAN_TX_PIPE endpoint,
the private area of the SKB's tx_info can be used to store
driver-specific information. For packets sent through USB_REG_OUT_PIPE,
this will not make a difference since they are routed through a
separate routine that doesn't access the private region.

This would help in situations where TX information is required
in the URB callback.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c        |   17 +++++++++--------
 drivers/net/wireless/ath/ath9k/htc.h            |   14 +++++++++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   11 +++++++----
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   15 ++++++++-------
 drivers/net/wireless/ath/ath9k/htc_hst.c        |   18 +++++++++---------
 drivers/net/wireless/ath/ath9k/htc_hst.h        |    5 ++---
 drivers/net/wireless/ath/ath9k/wmi.c            |    2 +-
 7 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 5ab3084..2c96960 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -282,9 +282,9 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 	return ret;
 }
 
-static int hif_usb_send_tx(struct hif_device_usb *hif_dev, struct sk_buff *skb,
-			   struct ath9k_htc_tx_ctl *tx_ctl)
+static int hif_usb_send_tx(struct hif_device_usb *hif_dev, struct sk_buff *skb)
 {
+	struct ath9k_htc_tx_ctl *tx_ctl;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hif_dev->tx.tx_lock, flags);
@@ -303,12 +303,14 @@ static int hif_usb_send_tx(struct hif_device_usb *hif_dev, struct sk_buff *skb,
 	__skb_queue_tail(&hif_dev->tx.tx_skb_queue, skb);
 	hif_dev->tx.tx_skb_cnt++;
 
-	/* Send normal frames immediately */
-	if (!tx_ctl || (tx_ctl && (tx_ctl->type == ATH9K_HTC_NORMAL)))
+	tx_ctl = HTC_SKB_CB(skb);
+
+	/* Send normal/mgmt/beacon frames immediately */
+	if (tx_ctl->type != ATH9K_HTC_AMPDU)
 		__hif_usb_tx(hif_dev);
 
 	/* Check if AMPDUs have to be sent immediately */
-	if (tx_ctl && (tx_ctl->type == ATH9K_HTC_AMPDU) &&
+	if ((tx_ctl->type == ATH9K_HTC_AMPDU) &&
 	    (hif_dev->tx.tx_buf_cnt == MAX_TX_URB_NUM) &&
 	    (hif_dev->tx.tx_skb_cnt < 2)) {
 		__hif_usb_tx(hif_dev);
@@ -350,15 +352,14 @@ static void hif_usb_stop(void *hif_handle, u8 pipe_id)
 	}
 }
 
-static int hif_usb_send(void *hif_handle, u8 pipe_id, struct sk_buff *skb,
-			struct ath9k_htc_tx_ctl *tx_ctl)
+static int hif_usb_send(void *hif_handle, u8 pipe_id, struct sk_buff *skb)
 {
 	struct hif_device_usb *hif_dev = (struct hif_device_usb *)hif_handle;
 	int ret = 0;
 
 	switch (pipe_id) {
 	case USB_WLAN_TX_PIPE:
-		ret = hif_usb_send_tx(hif_dev, skb, tx_ctl);
+		ret = hif_usb_send_tx(hif_dev, skb);
 		break;
 	case USB_REG_OUT_PIPE:
 		ret = hif_usb_send_regout(hif_dev, skb);
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ed82bba..ec3511d 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -67,8 +67,11 @@ enum htc_opmode {
 };
 
 #define ATH9K_HTC_HDRSPACE sizeof(struct htc_frame_hdr)
-#define ATH9K_HTC_AMPDU	1
+
+#define ATH9K_HTC_AMPDU  1
 #define ATH9K_HTC_NORMAL 2
+#define ATH9K_HTC_BEACON 3
+#define ATH9K_HTC_MGMT   4
 
 #define ATH9K_HTC_TX_CTSONLY      0x1
 #define ATH9K_HTC_TX_RTSCTS       0x2
@@ -287,6 +290,15 @@ struct ath9k_htc_tx_ctl {
 	u8 type; /* ATH9K_HTC_* */
 };
 
+static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+
+	BUILD_BUG_ON(sizeof(struct ath9k_htc_tx_ctl) >
+		     IEEE80211_TX_INFO_DRIVER_DATA_SIZE);
+	return (struct ath9k_htc_tx_ctl *) &tx_info->driver_data;
+}
+
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 
 #define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 15b149e..d23426f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -345,7 +345,7 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	struct ieee80211_vif *vif;
 	struct ath9k_htc_vif *avp;
 	struct tx_beacon_header beacon_hdr;
-	struct ath9k_htc_tx_ctl tx_ctl;
+	struct ath9k_htc_tx_ctl *tx_ctl;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_mgmt *mgmt;
 	struct sk_buff *beacon;
@@ -353,7 +353,6 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	int ret;
 
 	memset(&beacon_hdr, 0, sizeof(struct tx_beacon_header));
-	memset(&tx_ctl, 0, sizeof(struct ath9k_htc_tx_ctl));
 
 	spin_lock_bh(&priv->beacon_lock);
 
@@ -388,12 +387,16 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 		hdr->seq_ctrl |= cpu_to_le16(avp->seq_no);
 	}
 
-	tx_ctl.type = ATH9K_HTC_NORMAL;
+	tx_ctl = HTC_SKB_CB(beacon);
+	memset(tx_ctl, 0, sizeof(*tx_ctl));
+
+	tx_ctl->type = ATH9K_HTC_BEACON;
+
 	beacon_hdr.vif_index = avp->index;
 	tx_fhdr = skb_push(beacon, sizeof(beacon_hdr));
 	memcpy(tx_fhdr, (u8 *) &beacon_hdr, sizeof(beacon_hdr));
 
-	ret = htc_send(priv->htc, beacon, priv->beacon_ep, &tx_ctl);
+	ret = htc_send(priv->htc, beacon, priv->beacon_ep);
 	if (ret != 0) {
 		if (ret == -ENOMEM) {
 			ath_dbg(common, ATH_DBG_BSTUCK,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 458164f..7357e70 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -89,13 +89,16 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 	struct ieee80211_vif *vif = tx_info->control.vif;
 	struct ath9k_htc_sta *ista;
 	struct ath9k_htc_vif *avp = NULL;
-	struct ath9k_htc_tx_ctl tx_ctl;
+	struct ath9k_htc_tx_ctl *tx_ctl;
 	enum htc_endpoint_id epid;
 	u16 qnum;
 	__le16 fc;
 	u8 *tx_fhdr;
 	u8 sta_idx, vif_idx;
 
+	tx_ctl = HTC_SKB_CB(skb);
+	memset(tx_ctl, 0, sizeof(*tx_ctl));
+
 	hdr = (struct ieee80211_hdr *) skb->data;
 	fc = hdr->frame_control;
 
@@ -126,8 +129,6 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 		sta_idx = priv->vif_sta_pos[vif_idx];
 	}
 
-	memset(&tx_ctl, 0, sizeof(struct ath9k_htc_tx_ctl));
-
 	if (ieee80211_is_data(fc)) {
 		struct tx_frame_hdr tx_hdr;
 		u32 flags = 0;
@@ -139,10 +140,10 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 		tx_hdr.vif_idx = vif_idx;
 
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-			tx_ctl.type = ATH9K_HTC_AMPDU;
+			tx_ctl->type = ATH9K_HTC_AMPDU;
 			tx_hdr.data_type = ATH9K_HTC_AMPDU;
 		} else {
-			tx_ctl.type = ATH9K_HTC_NORMAL;
+			tx_ctl->type = ATH9K_HTC_NORMAL;
 			tx_hdr.data_type = ATH9K_HTC_NORMAL;
 		}
 
@@ -212,7 +213,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 			mgmt->u.probe_resp.timestamp = avp->tsfadjust;
 		}
 
-		tx_ctl.type = ATH9K_HTC_NORMAL;
+		tx_ctl->type = ATH9K_HTC_MGMT;
 
 		mgmt_hdr.node_idx = sta_idx;
 		mgmt_hdr.vif_idx = vif_idx;
@@ -230,7 +231,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 		epid = priv->mgmt_ep;
 	}
 send:
-	return htc_send(priv->htc, skb, epid, &tx_ctl);
+	return htc_send(priv->htc, skb, epid);
 }
 
 static bool ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index c41ab8c..6ee53de 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -17,8 +17,8 @@
 #include "htc.h"
 
 static int htc_issue_send(struct htc_target *target, struct sk_buff* skb,
-			  u16 len, u8 flags, u8 epid,
-			  struct ath9k_htc_tx_ctl *tx_ctl)
+			  u16 len, u8 flags, u8 epid)
+
 {
 	struct htc_frame_hdr *hdr;
 	struct htc_endpoint *endpoint = &target->endpoint[epid];
@@ -30,8 +30,8 @@ static int htc_issue_send(struct htc_target *target, struct sk_buff* skb,
 	hdr->flags = flags;
 	hdr->payload_len = cpu_to_be16(len);
 
-	status = target->hif->send(target->hif_dev, endpoint->ul_pipeid, skb,
-				   tx_ctl);
+	status = target->hif->send(target->hif_dev, endpoint->ul_pipeid, skb);
+
 	return status;
 }
 
@@ -162,7 +162,7 @@ static int htc_config_pipe_credits(struct htc_target *target)
 
 	target->htc_flags |= HTC_OP_CONFIG_PIPE_CREDITS;
 
-	ret = htc_issue_send(target, skb, skb->len, 0, ENDPOINT0, NULL);
+	ret = htc_issue_send(target, skb, skb->len, 0, ENDPOINT0);
 	if (ret)
 		goto err;
 
@@ -197,7 +197,7 @@ static int htc_setup_complete(struct htc_target *target)
 
 	target->htc_flags |= HTC_OP_START_WAIT;
 
-	ret = htc_issue_send(target, skb, skb->len, 0, ENDPOINT0, NULL);
+	ret = htc_issue_send(target, skb, skb->len, 0, ENDPOINT0);
 	if (ret)
 		goto err;
 
@@ -268,7 +268,7 @@ int htc_connect_service(struct htc_target *target,
 	conn_msg->dl_pipeid = endpoint->dl_pipeid;
 	conn_msg->ul_pipeid = endpoint->ul_pipeid;
 
-	ret = htc_issue_send(target, skb, skb->len, 0, ENDPOINT0, NULL);
+	ret = htc_issue_send(target, skb, skb->len, 0, ENDPOINT0);
 	if (ret)
 		goto err;
 
@@ -287,9 +287,9 @@ err:
 }
 
 int htc_send(struct htc_target *target, struct sk_buff *skb,
-	     enum htc_endpoint_id epid, struct ath9k_htc_tx_ctl *tx_ctl)
+	     enum htc_endpoint_id epid)
 {
-	return htc_issue_send(target, skb, skb->len, 0, epid, tx_ctl);
+	return htc_issue_send(target, skb, skb->len, 0, epid);
 }
 
 void htc_stop(struct htc_target *target)
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index ecd0187..3531552 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -35,8 +35,7 @@ struct ath9k_htc_hif {
 
 	void (*start) (void *hif_handle, u8 pipe);
 	void (*stop) (void *hif_handle, u8 pipe);
-	int (*send) (void *hif_handle, u8 pipe, struct sk_buff *buf,
-		     struct ath9k_htc_tx_ctl *tx_ctl);
+	int (*send) (void *hif_handle, u8 pipe, struct sk_buff *buf);
 };
 
 enum htc_endpoint_id {
@@ -206,7 +205,7 @@ int htc_connect_service(struct htc_target *target,
 			  struct htc_service_connreq *service_connreq,
 			  enum htc_endpoint_id *conn_rsp_eid);
 int htc_send(struct htc_target *target, struct sk_buff *skb,
-	     enum htc_endpoint_id eid, struct ath9k_htc_tx_ctl *tx_ctl);
+	     enum htc_endpoint_id eid);
 void htc_stop(struct htc_target *target);
 void htc_start(struct htc_target *target);
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index a5f8f6b..5cac5d0 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -244,7 +244,7 @@ static int ath9k_wmi_cmd_issue(struct wmi *wmi,
 	hdr->command_id = cpu_to_be16(cmd);
 	hdr->seq_no = cpu_to_be16(++wmi->tx_seq_id);
 
-	return htc_send(wmi->htc, skb, wmi->ctrl_epid, NULL);
+	return htc_send(wmi->htc, skb, wmi->ctrl_epid);
 }
 
 int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
-- 
1.7.3.5

