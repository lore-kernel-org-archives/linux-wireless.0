Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:6993 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728151AbeGVIqO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Jul 2018 04:46:14 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 11/20] wil6210: send L2UF on behalf of newly associated station
Date: Sun, 22 Jul 2018 10:47:36 +0300
Message-Id: <1532245665-15249-12-git-send-email-merez@codeaurora.org> (sfid-20180722_095029_900823_BD03869E)
In-Reply-To: <1532245665-15249-1-git-send-email-merez@codeaurora.org>
References: <1532245665-15249-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ahmad Masri <amasri@codeaurora.org>

Send L2UF (Level 2 Update Frame) to update forwarding tables in layer 2
in AP mode. Wil6210 driver creates and sends this frame once a new
station connects to the AP.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c    | 48 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h |  2 ++
 drivers/net/wireless/ath/wil6210/wmi.c     |  2 ++
 3 files changed, 52 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 6a7943e..08d61a5 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -43,6 +43,15 @@
 module_param(rx_large_buf, bool, 0444);
 MODULE_PARM_DESC(rx_large_buf, " allocate 8KB RX buffers, default - no");
 
+/* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */
+struct l2_update_frame {
+	struct ethhdr eh;
+	u8 dsap;
+	u8 ssap;
+	u8 control;
+	u8 xid_info[3];
+} __packed;
+
 static inline uint wil_rx_snaplen(void)
 {
 	return rx_align_2 ? 6 : 0;
@@ -72,6 +81,45 @@ static inline int wil_ring_avail_high(struct wil_ring *ring)
 	return wil_ring_avail_tx(ring) > wil_ring_wmark_high(ring);
 }
 
+/**
+ * Send Level 2 Update Frame to update forwarding tables in
+ * layer 2 bridge devices
+ */
+void wil_indicate_layer2_update(struct wil6210_vif *vif,
+				struct wil_sta_info *sta)
+{
+	struct l2_update_frame *msg;
+	struct sk_buff *skb;
+	struct net_device *ndev = vif_to_ndev(vif);
+
+	skb = dev_alloc_skb(sizeof(*msg));
+	if (!skb)
+		return;
+
+	msg = (struct l2_update_frame *)skb_put(skb, sizeof(*msg));
+
+	/* 802.2 Type 1 Logical Link Control (LLC) Exchange Identifier (XID)
+	 * Update response frame; IEEE Std 802.2-1998, 5.4.1.2.1
+	 */
+	eth_broadcast_addr(msg->eh.h_dest);
+	ether_addr_copy(msg->eh.h_source, sta->addr);
+	msg->eh.h_proto = htons(skb->len - sizeof(struct ethhdr));
+	msg->dsap = 0;
+	msg->ssap = 0; /* NULL LSAP, CR Bit: Response */
+
+	/* XID response lsb.1111F101.
+	 * F=0 (no poll command; unsolicited frame)
+	 */
+	msg->control = 0xaf;
+	msg->xid_info[0] = 0x81; /* XID format identifier */
+	msg->xid_info[1] = 1; /* LLC types/classes: Type 1 LLC */
+	msg->xid_info[2] = 0; /* XID sender's receive window size (RW) */
+
+	skb->dev = ndev;
+	skb->protocol = eth_type_trans(skb, ndev);
+	netif_rx_ni(skb);
+}
+
 /* returns true when all tx vrings are empty */
 bool wil_is_tx_idle(struct wil6210_priv *wil)
 {
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index e87c889..1857fb2 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1308,6 +1308,8 @@ void wil_update_net_queues_bh(struct wil6210_priv *wil, struct wil6210_vif *vif,
 void wil_rx_handle(struct wil6210_priv *wil, int *quota);
 void wil6210_unmask_irq_rx(struct wil6210_priv *wil);
 void wil6210_unmask_irq_rx_edma(struct wil6210_priv *wil);
+void wil_indicate_layer2_update(struct wil6210_vif *vif,
+				struct wil_sta_info *sta);
 
 int wil_iftype_nl2wmi(enum nl80211_iftype type);
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 45a71fd..7fee674 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1047,6 +1047,8 @@ static void wmi_evt_connect(struct wil6210_vif *vif, int id, void *d, int len)
 		}
 
 		cfg80211_new_sta(ndev, evt->bssid, sinfo, GFP_KERNEL);
+		if (wdev->iftype == NL80211_IFTYPE_AP)
+			wil_indicate_layer2_update(vif, &wil->sta[evt->cid]);
 
 		kfree(sinfo);
 	} else {
-- 
1.9.1
