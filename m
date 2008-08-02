Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:8775 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbYHBKQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 06:16:05 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1578395ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 03:16:05 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH 18/19] orinoco: Process bulk of receive interrupt in a tasklet
Date: Sat,  2 Aug 2008 11:14:32 +0100
Message-Id: <1217672073-7094-19-git-send-email-kilroyd@gmail.com> (sfid-20080802_124547_328733_F3D4F114)
In-Reply-To: <1217672073-7094-18-git-send-email-kilroyd@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-3-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-4-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-5-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-6-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-7-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-8-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-9-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-10-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-11-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-12-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-13-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-14-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-15-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-16-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-17-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-18-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Read the packet data off the hardware and straight into an skb in the
interrupt. We have to do this in case we don't process the tasklet in
time.

Signed-off by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/orinoco.c |  105 ++++++++++++++++++++++++++++++++-------
 drivers/net/wireless/orinoco.h |   14 +++++
 2 files changed, 100 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 300920e..5d1955f 100644
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
@@ -3255,6 +3314,10 @@ struct net_device
 	INIT_WORK(&priv->join_work, orinoco_join_ap);
 	INIT_WORK(&priv->wevent_work, orinoco_send_wevents);
 
+	INIT_LIST_HEAD(&priv->rx_list);
+	tasklet_init(&priv->rx_tasklet, orinoco_rx_isr_tasklet,
+		     (unsigned long) dev);
+
 	netif_carrier_off(dev);
 	priv->last_linkstatus = 0xffff;
 
@@ -3265,6 +3328,10 @@ void free_orinocodev(struct net_device *dev)
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
1.5.4.5

