Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:21958 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbYHUW3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:29:34 -0400
Received: by ug-out-1314.google.com with SMTP id c2so104668ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:29:33 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 18/19] orinoco: Process bulk of receive interrupt in a tasklet
Date: Thu, 21 Aug 2008 23:28:04 +0100
Message-Id: <85860f83f169137df12056c9bf248828db299e09.1219352676.git.kilroyd@gmail.com> (sfid-20080822_005041_098131_18B98822)
In-Reply-To: <e7263ec9b482c0e15ad3dff6e4284c514fbb19f6.1219352676.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
 <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
 <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com>
 <ac0da2799e97f5256019ad669f5a6c461bd0d82a.1219352674.git.kilroyd@gmail.com>
 <d792f6b1d5853becf1b1488e6572a4c3244eb769.1219352674.git.kilroyd@gmail.com>
 <6c4f63d9cc1bec763719e18ea8282919b6604503.1219352674.git.kilroyd@gmail.com>
 <9a54acb1147a2c0a7c1cf9b07b9ac756366d0877.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <347f1ce011aaeeb9b4d8f805fdfb6eb58fc467ca.1219352675.git.kilroyd@gmail.com>
 <5e42f22bf794bbefae50fa2a3e5b4ff6e36c7096.1219352675.git.kilroyd@gmail.com>
 <dc5df8328be19728aec203304d9c265368c2b876.1219352675.git.kilroyd@gmail.com>
 <09ee16c27766ca779c63a0e82df7e4aa723f4fdf.1219352676.git.kilroyd@gmail.com>
 <bbb15e90927ee20492ec6d76000ee6b95ce69bd9.1219352676.git.kilroyd@gmail.com>
 <50585fbee314ce11734e09b9c342c94d2f84c8bc.1219352676.git.kilroyd@gmail.com>
 <bba898fea5b82aaa4ccc7464d05c946bbff263ec.1219352676.git.kilroyd@gmail.com>
 <e7263ec9b482c0e15ad3dff6e4284c514fbb19f6.1219352676.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Read the packet data off the hardware and straight into an skb in the
interrupt. We have to do this in case we don't process the tasklet in
time.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/orinoco.c |  105 ++++++++++++++++++++++++++++++++-------
 drivers/net/wireless/orinoco.h |   14 +++++
 2 files changed, 100 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 5e6f90b..768b394 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -1178,15 +1178,23 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 	struct net_device_stats *stats = &priv->stats;
 	struct iw_statistics *wstats = &priv->wstats;
 	struct sk_buff *skb = NULL;
-	u16 rxfid, status, fc;
+	u16 rxfid, status;
 	int length;
-	struct hermes_rx_descriptor desc;
-	struct ethhdr *hdr;
+	struct hermes_rx_descriptor *desc;
+	struct orinoco_rx_data *rx_data;
 	int err;
 
+	desc = kmalloc(sizeof(*desc), GFP_ATOMIC);
+	if (!desc) {
+		printk(KERN_WARNING
+		       "%s: Can't allocate space for RX descriptor\n",
+		       dev->name);
+		goto update_stats;
+	}
+
 	rxfid = hermes_read_regn(hw, RXFID);
 
-	err = hermes_bap_pread(hw, IRQ_BAP, &desc, sizeof(desc),
+	err = hermes_bap_pread(hw, IRQ_BAP, desc, sizeof(*desc),
 			       rxfid, 0);
 	if (err) {
 		printk(KERN_ERR "%s: error %d reading Rx descriptor. "
@@ -1194,7 +1202,7 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 		goto update_stats;
 	}
 
-	status = le16_to_cpu(desc.status);
+	status = le16_to_cpu(desc->status);
 
 	if (status & HERMES_RXSTAT_BADCRC) {
 		DEBUG(1, "%s: Bad CRC on Rx. Frame dropped.\n",
@@ -1205,8 +1213,8 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 
 	/* Handle frames in monitor mode */
 	if (priv->iw_mode == IW_MODE_MONITOR) {
-		orinoco_rx_monitor(dev, rxfid, &desc);
-		return;
+		orinoco_rx_monitor(dev, rxfid, desc);
+		goto out;
 	}
 
 	if (status & HERMES_RXSTAT_UNDECRYPTABLE) {
@@ -1216,15 +1224,14 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 		goto update_stats;
 	}
 
-	length = le16_to_cpu(desc.data_len);
-	fc = le16_to_cpu(desc.frame_ctl);
+	length = le16_to_cpu(desc->data_len);
 
 	/* Sanity checks */
 	if (length < 3) { /* No for even an 802.2 LLC header */
 		/* At least on Symbol firmware with PCF we get quite a
                    lot of these legitimately - Poll frames with no
                    data. */
-		return;
+		goto out;
 	}
 	if (length > IEEE80211_DATA_LEN) {
 		printk(KERN_WARNING "%s: Oversized frame received (%d bytes)\n",
@@ -1259,6 +1266,43 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 		goto drop;
 	}
 
+	/* Add desc and skb to rx queue */
+	rx_data = kzalloc(sizeof(*rx_data), GFP_ATOMIC);
+	if (!rx_data) {
+		printk(KERN_WARNING "%s: Can't allocate RX packet\n",
+			dev->name);
+		goto drop;
+	}
+	rx_data->desc = desc;
+	rx_data->skb = skb;
+	list_add_tail(&rx_data->list, &priv->rx_list);
+	tasklet_schedule(&priv->rx_tasklet);
+
+	return;
+
+drop:
+	dev_kfree_skb_irq(skb);
+update_stats:
+	stats->rx_errors++;
+	stats->rx_dropped++;
+out:
+	kfree(desc);
+}
+
+static void orinoco_rx(struct net_device *dev,
+		       struct hermes_rx_descriptor *desc,
+		       struct sk_buff *skb)
+{
+	struct orinoco_private *priv = netdev_priv(dev);
+	struct net_device_stats *stats = &priv->stats;
+	u16 status, fc;
+	int length;
+	struct ethhdr *hdr;
+
+	status = le16_to_cpu(desc->status);
+	length = le16_to_cpu(desc->data_len);
+	fc = le16_to_cpu(desc->frame_ctl);
+
 	/* Handle decapsulation
 	 * In most cases, the firmware tell us about SNAP frames.
 	 * For some reason, the SNAP frames sent by LinkSys APs
@@ -1277,11 +1321,11 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 		hdr = (struct ethhdr *)skb_push(skb, ETH_HLEN);
 		hdr->h_proto = htons(length);
 	}
-	memcpy(hdr->h_dest, desc.addr1, ETH_ALEN);
+	memcpy(hdr->h_dest, desc->addr1, ETH_ALEN);
 	if (fc & IEEE80211_FCTL_FROMDS)
-		memcpy(hdr->h_source, desc.addr3, ETH_ALEN);
+		memcpy(hdr->h_source, desc->addr3, ETH_ALEN);
 	else
-		memcpy(hdr->h_source, desc.addr2, ETH_ALEN);
+		memcpy(hdr->h_source, desc->addr2, ETH_ALEN);
 
 	dev->last_rx = jiffies;
 	skb->protocol = eth_type_trans(skb, dev);
@@ -1290,7 +1334,7 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 		skb->pkt_type = PACKET_OTHERHOST;
 	
 	/* Process the wireless stats if needed */
-	orinoco_stat_gather(dev, skb, &desc);
+	orinoco_stat_gather(dev, skb, desc);
 
 	/* Pass the packet to the networking stack */
 	netif_rx(skb);
@@ -1298,12 +1342,27 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 	stats->rx_bytes += length;
 
 	return;
+}
 
- drop:	
-	dev_kfree_skb_irq(skb);
- update_stats:
-	stats->rx_errors++;
-	stats->rx_dropped++;
+static void orinoco_rx_isr_tasklet(unsigned long data)
+{
+	struct net_device *dev = (struct net_device *) data;
+	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_rx_data *rx_data, *temp;
+	struct hermes_rx_descriptor *desc;
+	struct sk_buff *skb;
+
+	/* extract desc and skb from queue */
+	list_for_each_entry_safe(rx_data, temp, &priv->rx_list, list) {
+		desc = rx_data->desc;
+		skb = rx_data->skb;
+		list_del(&rx_data->list);
+		kfree(rx_data);
+
+		orinoco_rx(dev, desc, skb);
+
+		kfree(desc);
+	}
 }
 
 /********************************************************************/
@@ -3248,6 +3307,10 @@ struct net_device
 	INIT_WORK(&priv->join_work, orinoco_join_ap);
 	INIT_WORK(&priv->wevent_work, orinoco_send_wevents);
 
+	INIT_LIST_HEAD(&priv->rx_list);
+	tasklet_init(&priv->rx_tasklet, orinoco_rx_isr_tasklet,
+		     (unsigned long) dev);
+
 	netif_carrier_off(dev);
 	priv->last_linkstatus = 0xffff;
 
@@ -3258,6 +3321,10 @@ void free_orinocodev(struct net_device *dev)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
 
+	/* No need to empty priv->rx_list: if the tasklet is scheduled
+	 * when we call tasklet_kill it will run one final time,
+	 * emptying the list */
+	tasklet_kill(&priv->rx_tasklet);
 	priv->wpa_ie_len = 0;
 	kfree(priv->wpa_ie);
 	orinoco_bss_data_free(priv);
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index bfab88f..e0c9be3 100644
--- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -9,6 +9,7 @@
 
 #define DRIVER_VERSION "0.15"
 
+#include <linux/interrupt.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
@@ -57,6 +58,14 @@ struct xbss_element {
 	struct list_head list;
 };
 
+struct hermes_rx_descriptor;
+
+struct orinoco_rx_data {
+	struct hermes_rx_descriptor *desc;
+	struct sk_buff *skb;
+	struct list_head list;
+};
+
 struct orinoco_private {
 	void *card;	/* Pointer to card dependent structure */
 	struct device *dev;
@@ -68,6 +77,11 @@ struct orinoco_private {
 	int hw_unavailable;
 	struct work_struct reset_work;
 
+	/* Interrupt tasklets */
+	struct tasklet_struct rx_tasklet;
+	struct list_head rx_list;
+	struct orinoco_rx_data *rx_data;
+
 	/* driver state */
 	int open;
 	u16 last_linkstatus;
-- 
1.5.6.4

