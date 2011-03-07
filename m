Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62495 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab1CGCPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:15:17 -0500
Received: by mail-yw0-f46.google.com with SMTP id 3so1451423ywj.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:15:17 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16301.27050.686467@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:45:09 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 23/34] ath9k_htc: Introduce new HTC API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

A new routine that takes an endpoint explicitly is
introduced. The normal htc_send() now retrieves the endpoint
from the packet's private data. This would be useful
in TX completion when the endpoint ID would be required.
While at it, use a helper function to map the queue to endpoint.

Data/mgmt/beacon packets use htc_send(), while WMI comamnds
pass the endpoint to HTC.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   56 +++++++++++++----------
 drivers/net/wireless/ath/ath9k/htc_hst.c        |   12 ++++-
 drivers/net/wireless/ath/ath9k/htc_hst.h        |    5 +-
 drivers/net/wireless/ath/ath9k/wmi.c            |    2 +-
 6 files changed, 49 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index a5d791e..af747de 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -273,6 +273,7 @@ struct ath9k_htc_tx {
 
 struct ath9k_htc_tx_ctl {
 	u8 type; /* ATH9K_HTC_* */
+	u8 epid;
 };
 
 static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 778f999..a048720 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -391,12 +391,13 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	memset(tx_ctl, 0, sizeof(*tx_ctl));
 
 	tx_ctl->type = ATH9K_HTC_BEACON;
+	tx_ctl->epid = priv->beacon_ep;
 
 	beacon_hdr.vif_index = avp->index;
 	tx_fhdr = skb_push(beacon, sizeof(beacon_hdr));
 	memcpy(tx_fhdr, (u8 *) &beacon_hdr, sizeof(beacon_hdr));
 
-	ret = htc_send(priv->htc, beacon, priv->beacon_ep);
+	ret = htc_send(priv->htc, beacon);
 	if (ret != 0) {
 		if (ret == -ENOMEM) {
 			ath_dbg(common, ATH_DBG_BSTUCK,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 1cbe194..d17662f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -76,6 +76,34 @@ void ath9k_htc_check_wake_queues(struct ath9k_htc_priv *priv)
 	spin_unlock_bh(&priv->tx.tx_lock);
 }
 
+static enum htc_endpoint_id get_htc_epid(struct ath9k_htc_priv *priv,
+					 u16 qnum)
+{
+	enum htc_endpoint_id epid;
+
+	switch (qnum) {
+	case 0:
+		TX_QSTAT_INC(WME_AC_VO);
+		epid = priv->data_vo_ep;
+		break;
+	case 1:
+		TX_QSTAT_INC(WME_AC_VI);
+		epid = priv->data_vi_ep;
+		break;
+	case 2:
+		TX_QSTAT_INC(WME_AC_BE);
+		epid = priv->data_be_ep;
+		break;
+	case 3:
+	default:
+		TX_QSTAT_INC(WME_AC_BK);
+		epid = priv->data_bk_ep;
+		break;
+	}
+
+	return epid;
+}
+
 int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
 		       struct ath9k_tx_queue_info *qinfo)
 {
@@ -113,7 +141,6 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 	struct ath9k_htc_sta *ista;
 	struct ath9k_htc_vif *avp = NULL;
 	struct ath9k_htc_tx_ctl *tx_ctl;
-	enum htc_endpoint_id epid;
 	u16 qnum;
 	__le16 fc;
 	u8 *tx_fhdr;
@@ -197,31 +224,12 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 
 		if (is_cab) {
 			CAB_STAT_INC;
-			epid = priv->cab_ep;
+			tx_ctl->epid = priv->cab_ep;
 			goto send;
 		}
 
 		qnum = skb_get_queue_mapping(skb);
-
-		switch (qnum) {
-		case 0:
-			TX_QSTAT_INC(WME_AC_VO);
-			epid = priv->data_vo_ep;
-			break;
-		case 1:
-			TX_QSTAT_INC(WME_AC_VI);
-			epid = priv->data_vi_ep;
-			break;
-		case 2:
-			TX_QSTAT_INC(WME_AC_BE);
-			epid = priv->data_be_ep;
-			break;
-		case 3:
-		default:
-			TX_QSTAT_INC(WME_AC_BK);
-			epid = priv->data_bk_ep;
-			break;
-		}
+		tx_ctl->epid = get_htc_epid(priv, qnum);
 	} else {
 		struct tx_mgmt_hdr mgmt_hdr;
 
@@ -251,10 +259,10 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 
 		tx_fhdr = skb_push(skb, sizeof(mgmt_hdr));
 		memcpy(tx_fhdr, (u8 *) &mgmt_hdr, sizeof(mgmt_hdr));
-		epid = priv->mgmt_ep;
+		tx_ctl->epid = priv->mgmt_ep;
 	}
 send:
-	return htc_send(priv->htc, skb, epid);
+	return htc_send(priv->htc, skb);
 }
 
 static bool ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 6ee53de..be87f47 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -286,8 +286,16 @@ err:
 	return ret;
 }
 
-int htc_send(struct htc_target *target, struct sk_buff *skb,
-	     enum htc_endpoint_id epid)
+int htc_send(struct htc_target *target, struct sk_buff *skb)
+{
+	struct ath9k_htc_tx_ctl *tx_ctl;
+
+	tx_ctl = HTC_SKB_CB(skb);
+	return htc_issue_send(target, skb, skb->len, 0, tx_ctl->epid);
+}
+
+int htc_send_epid(struct htc_target *target, struct sk_buff *skb,
+		  enum htc_endpoint_id epid)
 {
 	return htc_issue_send(target, skb, skb->len, 0, epid);
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index 3531552..064a324 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -204,8 +204,9 @@ int htc_init(struct htc_target *target);
 int htc_connect_service(struct htc_target *target,
 			  struct htc_service_connreq *service_connreq,
 			  enum htc_endpoint_id *conn_rsp_eid);
-int htc_send(struct htc_target *target, struct sk_buff *skb,
-	     enum htc_endpoint_id eid);
+int htc_send(struct htc_target *target, struct sk_buff *skb);
+int htc_send_epid(struct htc_target *target, struct sk_buff *skb,
+		  enum htc_endpoint_id epid);
 void htc_stop(struct htc_target *target);
 void htc_start(struct htc_target *target);
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index a916c92..9d03069 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -265,7 +265,7 @@ static int ath9k_wmi_cmd_issue(struct wmi *wmi,
 	hdr->command_id = cpu_to_be16(cmd);
 	hdr->seq_no = cpu_to_be16(++wmi->tx_seq_id);
 
-	return htc_send(wmi->htc, skb, wmi->ctrl_epid);
+	return htc_send_epid(wmi->htc, skb, wmi->ctrl_epid);
 }
 
 int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
-- 
1.7.4.1

