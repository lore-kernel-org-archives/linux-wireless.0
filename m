Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42374 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab0INHgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 03:36:16 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 00:36:10 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Fix memory leak on WMI event handler
Date: Tue, 14 Sep 2010 13:07:28 +0530
Message-ID: <1284449848-7870-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_wmi_ctrl_rx is racy with ath9k_wmi_tasklet on event notification
due to which the wmi_skb may be overwritten which leads to memory leak.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c |   72 ++++++++++-----------------------
 drivers/net/wireless/ath/ath9k/wmi.h |    6 +--
 2 files changed, 23 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 45fe9ca..93a8bda 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -124,55 +124,11 @@ void ath9k_wmi_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
-	struct wmi_cmd_hdr *hdr;
-	struct wmi_swba *swba_hdr;
-	enum wmi_event_id event;
-	struct sk_buff *skb;
-	void *wmi_event;
-	unsigned long flags;
-#ifdef CONFIG_ATH9K_HTC_DEBUGFS
-	__be32 txrate;
-#endif
 
-	spin_lock_irqsave(&priv->wmi->wmi_lock, flags);
-	skb = priv->wmi->wmi_skb;
-	spin_unlock_irqrestore(&priv->wmi->wmi_lock, flags);
+	ath_print(common, ATH_DBG_WMI, "SWBA Event received\n");
 
-	hdr = (struct wmi_cmd_hdr *) skb->data;
-	event = be16_to_cpu(hdr->command_id);
-	wmi_event = skb_pull(skb, sizeof(struct wmi_cmd_hdr));
+	ath9k_htc_swba(priv, priv->wmi->beacon_pending);
 
-	ath_print(common, ATH_DBG_WMI,
-		  "WMI Event: 0x%x\n", event);
-
-	switch (event) {
-	case WMI_TGT_RDY_EVENTID:
-		break;
-	case WMI_SWBA_EVENTID:
-		swba_hdr = (struct wmi_swba *) wmi_event;
-		ath9k_htc_swba(priv, swba_hdr->beacon_pending);
-		break;
-	case WMI_FATAL_EVENTID:
-		break;
-	case WMI_TXTO_EVENTID:
-		break;
-	case WMI_BMISS_EVENTID:
-		break;
-	case WMI_WLAN_TXCOMP_EVENTID:
-		break;
-	case WMI_DELBA_EVENTID:
-		break;
-	case WMI_TXRATE_EVENTID:
-#ifdef CONFIG_ATH9K_HTC_DEBUGFS
-		txrate = ((struct wmi_event_txrate *)wmi_event)->txrate;
-		priv->debug.txrate = be32_to_cpu(txrate);
-#endif
-		break;
-	default:
-		break;
-	}
-
-	kfree_skb(skb);
 }
 
 static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
@@ -191,6 +147,10 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 	struct wmi *wmi = (struct wmi *) priv;
 	struct wmi_cmd_hdr *hdr;
 	u16 cmd_id;
+	void *wmi_event;
+#ifdef CONFIG_ATH9K_HTC_DEBUGFS
+	__be32 txrate;
+#endif
 
 	if (unlikely(wmi->stopped))
 		goto free_skb;
@@ -199,10 +159,22 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 	cmd_id = be16_to_cpu(hdr->command_id);
 
 	if (cmd_id & 0x1000) {
-		spin_lock(&wmi->wmi_lock);
-		wmi->wmi_skb = skb;
-		spin_unlock(&wmi->wmi_lock);
-		tasklet_schedule(&wmi->drv_priv->wmi_tasklet);
+		wmi_event = skb_pull(skb, sizeof(struct wmi_cmd_hdr));
+		switch (cmd_id) {
+		case WMI_SWBA_EVENTID:
+			wmi->beacon_pending = *(u8 *)wmi_event;
+			tasklet_schedule(&wmi->drv_priv->wmi_tasklet);
+			break;
+		case WMI_TXRATE_EVENTID:
+#ifdef CONFIG_ATH9K_HTC_DEBUGFS
+			txrate = ((struct wmi_event_txrate *)wmi_event)->txrate;
+			wmi->drv_priv->debug.txrate = be32_to_cpu(txrate);
+#endif
+			break;
+		default:
+			break;
+		}
+		kfree_skb(skb);
 		return;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index a0bf857..ac61074 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -31,10 +31,6 @@ struct wmi_cmd_hdr {
 	__be16 seq_no;
 } __packed;
 
-struct wmi_swba {
-	u8 beacon_pending;
-} __packed;
-
 enum wmi_cmd_id {
 	WMI_ECHO_CMDID = 0x0001,
 	WMI_ACCESS_MEMORY_CMDID,
@@ -104,7 +100,7 @@ struct wmi {
 	u32 cmd_rsp_len;
 	bool stopped;
 
-	struct sk_buff *wmi_skb;
+	u8 beacon_pending;
 	spinlock_t wmi_lock;
 
 	atomic_t mwrite_cnt;
-- 
1.7.2.3

