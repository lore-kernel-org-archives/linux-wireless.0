Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:49541 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYIFAxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 20:53:10 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] p54: add lots of useful rx/tx statistics
Date: Sat, 6 Sep 2008 02:56:23 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809060256.23944.chunkeey@web.de> (sfid-20080906_025315_870942_884C6825)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware can provide lots of useful statistics about noise floor, 
mac time and lots of numbers about successful transfers and dropped
frames.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-09-06 01:57:59.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-09-06 02:44:35.000000000 +0200
@@ -424,6 +424,12 @@ int p54_parse_eeprom(struct ieee80211_hw
 }
 EXPORT_SYMBOL_GPL(p54_parse_eeprom);
 
+static int p54_rssi_to_dbm(struct ieee80211_hw *dev, int rssi)
+{
+	/* TODO: get the rssi_add & rssi_mul data from the eeprom */
+	return ((rssi * 0x83) / 64 - 400) / 4;
+}
+
 static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
@@ -440,7 +446,8 @@ static int p54_rx_data(struct ieee80211_
 			return 0;
 	}
 
-	rx_status.signal = hdr->rssi;
+	rx_status.signal = p54_rssi_to_dbm(dev, hdr->rssi);
+	rx_status.noise = priv->noise;
 	/* XX correct? */
 	rx_status.qual = (100 * hdr->rssi) / 127;
 	rx_status.rate_idx = hdr->rate & 0xf;
@@ -526,7 +533,8 @@ static void p54_rx_frame_sent(struct iee
 					info->status.excessive_retries = 1;
 			}
 			info->status.retry_count = payload->retries - 1;
-			info->status.ack_signal = le16_to_cpu(payload->ack_rssi);
+			info->status.ack_signal = p54_rssi_to_dbm(dev,
+					le16_to_cpu(payload->ack_rssi));
 			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
 			ieee80211_tx_status_irqsafe(dev, entry);
 			goto out;
@@ -557,6 +565,27 @@ static void p54_rx_eeprom_readback(struc
 	complete(&priv->eeprom_comp);
 }
 
+static void p54_rx_stats(struct ieee80211_hw *dev, struct sk_buff *skb)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
+	struct p54_statistics *stats = (struct p54_statistics *) hdr->data;
+	u32 tsf32 = le32_to_cpu(stats->tsf32);
+
+	if (tsf32 < priv->tsf_low32)
+		priv->tsf_high32++;
+	priv->tsf_low32 = tsf32;
+
+	priv->stats.dot11RTSFailureCount = le32_to_cpu(stats->rts_fail);
+	priv->stats.dot11RTSSuccessCount = le32_to_cpu(stats->rts_success);
+	priv->stats.dot11FCSErrorCount = le32_to_cpu(stats->rx_bad_fcs);
+
+	priv->noise = p54_rssi_to_dbm(dev, le32_to_cpu(stats->noise));
+	complete(&priv->stats_comp);
+
+	mod_timer(&priv->stats_timer, jiffies + 5 * HZ);
+}
+
 static int p54_rx_control(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
@@ -567,6 +596,9 @@ static int p54_rx_control(struct ieee802
 		break;
 	case P54_CONTROL_TYPE_BBP:
 		break;
+	case P54_CONTROL_TYPE_STAT_READBACK:
+		p54_rx_stats(dev, skb);
+		break;
 	case P54_CONTROL_TYPE_EEPROM_READBACK:
 		p54_rx_eeprom_readback(dev, skb);
 		break;
@@ -1036,12 +1068,25 @@ static int p54_start(struct ieee80211_hw
 			return -ENOMEM;
 	}
 
+	if (!priv->cached_stats) {
+		priv->cached_stats = kzalloc(sizeof(struct p54_statistics) +
+			priv->tx_hdr_len + sizeof(struct p54_control_hdr),
+			GFP_KERNEL);
+
+		if (!priv->cached_stats) {
+			kfree(priv->cached_vdcf);
+			priv->cached_vdcf = NULL;
+			return -ENOMEM;
+		}
+	}
+
 	err = priv->open(dev);
 	if (!err)
 		priv->mode = IEEE80211_IF_TYPE_MNTR;
 
 	p54_init_vdcf(dev);
 
+	mod_timer(&priv->stats_timer, jiffies + HZ);
 	return err;
 }
 
@@ -1049,6 +1094,8 @@ static void p54_stop(struct ieee80211_hw
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
+
+	del_timer(&priv->stats_timer);
 	while ((skb = skb_dequeue(&priv->tx_queue)))
 		kfree_skb(skb);
 	priv->stop(dev);
@@ -1177,10 +1224,40 @@ static int p54_conf_tx(struct ieee80211_
 	return 0;
 }
 
+static void p54_statistics_timer(unsigned long data)
+{
+	struct ieee80211_hw *dev = (struct ieee80211_hw *) data;
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr;
+	struct p54_statistics *stats;
+
+	BUG_ON(!priv->cached_stats);
+
+	hdr = (void *)priv->cached_stats + priv->tx_hdr_len;
+	hdr->magic1 = cpu_to_le16(0x8000);
+	hdr->len = cpu_to_le16(sizeof(*stats));
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_STAT_READBACK);
+	p54_assign_address(dev, NULL, hdr, sizeof(*hdr) + sizeof(*stats));
+
+	priv->tx(dev, hdr, sizeof(*hdr) + sizeof(*stats), 0);
+}
+
 static int p54_get_stats(struct ieee80211_hw *dev,
 			 struct ieee80211_low_level_stats *stats)
 {
-	/* TODO */
+	struct p54_common *priv = dev->priv;
+
+	del_timer(&priv->stats_timer);
+	p54_statistics_timer((unsigned long)dev);
+
+	if (!wait_for_completion_interruptible_timeout(&priv->stats_comp, HZ)) {
+		printk(KERN_ERR "%s: device does not respond!\n",
+			wiphy_name(dev->wiphy));
+		return -EBUSY;
+	}
+
+	memcpy(stats, &priv->stats, sizeof(*stats));
+
 	return 0;
 }
 
@@ -1222,9 +1299,9 @@ struct ieee80211_hw *p54_init_common(siz
 	skb_queue_head_init(&priv->tx_queue);
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
 		     IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_SIGNAL_UNSPEC;
+		     IEEE80211_HW_SIGNAL_DBM |
+		     IEEE80211_HW_NOISE_DBM;
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
-	dev->max_signal = 127;
 
 	priv->tx_stats[0].limit = 1;
 	priv->tx_stats[1].limit = 1;
@@ -1232,11 +1309,15 @@ struct ieee80211_hw *p54_init_common(siz
 	priv->tx_stats[3].limit = 1;
 	priv->tx_stats[4].limit = 5;
 	dev->queues = 1;
+	priv->noise = -94;
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
 				 sizeof(struct p54_tx_control_allocdata);
 
 	mutex_init(&priv->conf_mutex);
 	init_completion(&priv->eeprom_comp);
+	init_completion(&priv->stats_comp);
+	setup_timer(&priv->stats_timer, p54_statistics_timer,
+		(unsigned long)dev);
 
 	return dev;
 }
@@ -1245,6 +1326,7 @@ EXPORT_SYMBOL_GPL(p54_init_common);
 void p54_free_common(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
+	kfree(priv->cached_stats);
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-09-04 14:56:25.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-09-06 02:04:25.000000000 +0200
@@ -301,4 +301,17 @@ struct p54_tx_control_vdcf {
 	__le16 frameburst;
 } __attribute__ ((packed));
 
+struct p54_statistics {
+	__le32 rx_success;
+	__le32 rx_bad_fcs;
+	__le32 rx_abort;
+	__le32 rx_abort_phy;
+	__le32 rts_success;
+	__le32 rts_fail;
+	__le32 tsf32;
+	__le32 airtime;
+	__le32 noise;
+	__le32 unkn[10]; /* CCE / CCA / RADAR */
+} __attribute__ ((packed));
+
 #endif /* P54COMMON_H */
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-09-04 14:56:25.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-09-05 21:11:06.000000000 +0200
@@ -91,6 +91,11 @@ struct p54_common {
 	u32 tsf_low32;
 	u32 tsf_high32;
 	struct ieee80211_tx_queue_stats tx_stats[8];
+	struct ieee80211_low_level_stats stats;
+	struct timer_list stats_timer;
+	struct completion stats_comp;
+	void *cached_stats;
+	int noise;
 	void *eeprom;
 	struct completion eeprom_comp;
 };


