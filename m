Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:59903 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943AbZGPSDw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 14:03:52 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] p54: fix beaconing related firmware crash
Date: Thu, 16 Jul 2009 20:03:47 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry.Finger@lwfinger.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907162003.48028.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a firmware crash which can be provoked by changing
operation mode.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
---
diff --git a/drivers/net/wireless/p54/lmac.h b/drivers/net/wireless/p54/lmac.h
index af35cfc..04b63ec 100644
--- a/drivers/net/wireless/p54/lmac.h
+++ b/drivers/net/wireless/p54/lmac.h
@@ -98,6 +98,10 @@ struct p54_hdr {
 	(!((((struct p54_hdr *) ((struct sk_buff *) skb)->data)->	\
 	flags) & cpu_to_le16(P54_HDR_FLAG_CONTROL)))
 
+#define GET_HW_QUEUE(skb)						\
+	(((struct p54_tx_data *)((struct p54_hdr *)			\
+	skb->data)->data)->hw_queue)
+
 /*
  * shared interface ID definitions
  * The interface ID is a unique identification of a specific interface.
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index f19add2..955f6d7 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -130,7 +130,6 @@ static int p54_beacon_update(struct p54_common *priv,
 			struct ieee80211_vif *vif)
 {
 	struct sk_buff *beacon;
-	__le32 old_beacon_req_id;
 	int ret;
 
 	beacon = ieee80211_beacon_get(priv->hw, vif);
@@ -140,15 +139,16 @@ static int p54_beacon_update(struct p54_common *priv,
 	if (ret)
 		return ret;
 
-	old_beacon_req_id = priv->beacon_req_id;
-	priv->beacon_req_id = GET_REQ_ID(beacon);
-
-	ret = p54_tx_80211(priv->hw, beacon);
-	if (ret) {
-		priv->beacon_req_id = old_beacon_req_id;
-		return -ENOSPC;
-	}
-
+	/*
+	 * During operation, the firmware takes care of beaconing.
+	 * The driver only needs to upload a new beacon template, once
+	 * the template was changed by the stack or userspace.
+	 *
+	 * LMAC API 3.2.2 also specifies that the driver does not need
+	 * to cancel the old beacon template by hand, instead the firmware
+	 * will release the previous one through the feedback mechanism.
+	 */
+	WARN_ON(p54_tx_80211(priv->hw, beacon));
 	priv->tsf_high32 = 0;
 	priv->tsf_low32 = 0;
 
@@ -253,9 +253,14 @@ static void p54_remove_interface(struct ieee80211_hw *dev,
 
 	mutex_lock(&priv->conf_mutex);
 	priv->vif = NULL;
-	if (priv->beacon_req_id) {
+
+	/*
+	 * LMAC API 3.2.2 states that any active beacon template must be
+	 * canceled by the driver before attempting a mode transition.
+	 */
+	if (le32_to_cpu(priv->beacon_req_id) != 0) {
 		p54_tx_cancel(priv, priv->beacon_req_id);
-		priv->beacon_req_id = cpu_to_le32(0);
+		wait_for_completion_interruptible_timeout(&priv->beacon_comp, HZ);
 	}
 	priv->mode = NL80211_IFTYPE_MONITOR;
 	memset(priv->mac_addr, 0, ETH_ALEN);
@@ -544,6 +549,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 				      BIT(NL80211_IFTYPE_MESH_POINT);
 
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
+	priv->beacon_req_id = cpu_to_le32(0);
 	priv->tx_stats[P54_QUEUE_BEACON].limit = 1;
 	priv->tx_stats[P54_QUEUE_FWSCAN].limit = 1;
 	priv->tx_stats[P54_QUEUE_MGMT].limit = 3;
@@ -567,6 +573,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	mutex_init(&priv->conf_mutex);
 	mutex_init(&priv->eeprom_mutex);
 	init_completion(&priv->eeprom_comp);
+	init_completion(&priv->beacon_comp);
 	INIT_DELAYED_WORK(&priv->work, p54_work);
 
 	return dev;
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 584b156..1afc394 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -211,6 +211,7 @@ struct p54_common {
 	u16 aid;
 	bool powersave_override;
 	__le32 beacon_req_id;
+	struct completion beacon_comp;
 
 	/* cryptographic engine information */
 	u8 privacy_caps;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 416400c..0d589d6 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -134,9 +134,13 @@ static int p54_assign_address(struct p54_common *priv, struct sk_buff *skb)
 	range = (void *) info->rate_driver_data;
 	range->start_addr = target_addr;
 	range->end_addr = target_addr + len;
+	data->req_id = cpu_to_le32(target_addr + priv->headroom);
+	if (IS_DATA_FRAME(skb) &&
+	    unlikely(GET_HW_QUEUE(skb) == P54_QUEUE_BEACON))
+		priv->beacon_req_id = data->req_id;
+
 	__skb_queue_after(&priv->tx_queue, target_skb, skb);
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
-	data->req_id = cpu_to_le32(target_addr + priv->headroom);
 	return 0;
 }
 
@@ -209,13 +213,19 @@ static void p54_tx_qos_accounting_free(struct p54_common *priv,
 				       struct sk_buff *skb)
 {
 	if (IS_DATA_FRAME(skb)) {
-		struct p54_hdr *hdr = (void *) skb->data;
-		struct p54_tx_data *data = (void *) hdr->data;
 		unsigned long flags;
 
 		spin_lock_irqsave(&priv->tx_stats_lock, flags);
-		priv->tx_stats[data->hw_queue].len--;
+		priv->tx_stats[GET_HW_QUEUE(skb)].len--;
 		spin_unlock_irqrestore(&priv->tx_stats_lock, flags);
+
+		if (unlikely(GET_HW_QUEUE(skb) == P54_QUEUE_BEACON)) {
+			if (priv->beacon_req_id == GET_REQ_ID(skb)) {
+				/* this is the  active beacon set anymore */
+				priv->beacon_req_id = 0;
+			}
+			complete(&priv->beacon_comp);
+		}
 	}
 	p54_wake_queues(priv);
 }
@@ -403,10 +413,6 @@ static void p54_rx_frame_sent(struct p54_common *priv, struct sk_buff *skb)
 	 * and we don't want to confuse the mac80211 stack.
 	 */
 	if (unlikely(entry_data->hw_queue < P54_QUEUE_FWSCAN)) {
-		if (entry_data->hw_queue == P54_QUEUE_BEACON &&
-		    hdr->req_id == priv->beacon_req_id)
-			priv->beacon_req_id = cpu_to_le32(0);
-
 		dev_kfree_skb_any(entry);
 		return ;
 	}
