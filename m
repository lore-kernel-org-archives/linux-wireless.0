Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:40346 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYJaPlu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 11:41:50 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [RFC/RFT PATCH 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
Date: Fri, 31 Oct 2008 11:42:02 -0400
Message-Id: <1225467722-31684-3-git-send-email-herton@mandriva.com.br> (sfid-20081031_164159_061791_2C2214DE)
In-Reply-To: <1225467722-31684-1-git-send-email-herton@mandriva.com.br>
References: <1225467722-31684-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Realtek 8187B has a receive command queue to feedback beacon interrupt
and transmitted packet status. Use it to feedback mac80211 about status
of transmitted packets. Unfortunately in the course of testing I found
that the sequence number reported by hardware includes entire sequence
control in a 12 bit only field, so a workaround is done to check only
lowest bits.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl8187.h     |    5 ++
 drivers/net/wireless/rtl8187_dev.c |  127 +++++++++++++++++++++++++++++++++++-
 2 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl8187.h b/drivers/net/wireless/rtl8187.h
index f09872e..c385407 100644
--- a/drivers/net/wireless/rtl8187.h
+++ b/drivers/net/wireless/rtl8187.h
@@ -113,6 +113,11 @@ struct rtl8187_priv {
 	u8 noise;
 	u8 slot_time;
 	u8 aifsn[4];
+	struct {
+		__le64 buf;
+		struct urb *urb;
+		struct sk_buff_head queue;
+	} b_tx_status;
 };
 
 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index 537ad64..71eade1 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -167,8 +167,27 @@ static void rtl8187_tx_cb(struct urb *urb)
 	skb_pull(skb, priv->is_rtl8187b ? sizeof(struct rtl8187b_tx_hdr) :
 					  sizeof(struct rtl8187_tx_hdr));
 	ieee80211_tx_info_clear_status(info);
-	info->flags |= IEEE80211_TX_STAT_ACK;
-	ieee80211_tx_status_irqsafe(hw, skb);
+
+	if (!urb->status &&
+	    !(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+	    priv->is_rtl8187b) {
+		skb_queue_tail(&priv->b_tx_status.queue, skb);
+
+		/* queue is "full", discard last items */
+		while (skb_queue_len(&priv->b_tx_status.queue) > 5) {
+			struct sk_buff *old_skb;
+
+			dev_dbg(&priv->udev->dev,
+				"transmit status queue full\n");
+
+			old_skb = skb_dequeue(&priv->b_tx_status.queue);
+			ieee80211_tx_status_irqsafe(hw, old_skb);
+		}
+	} else {
+		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) && !urb->status)
+			info->flags |= IEEE80211_TX_STAT_ACK;
+		ieee80211_tx_status_irqsafe(hw, skb);
+	}
 }
 
 static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
@@ -394,6 +413,105 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
 	return 0;
 }
 
+static void rtl8187b_status_cb(struct urb *urb)
+{
+	struct ieee80211_hw *hw = (struct ieee80211_hw *)urb->context;
+	struct rtl8187_priv *priv = hw->priv;
+	u64 val;
+	unsigned int cmd_type;
+
+	if (unlikely(urb->status)) {
+		usb_free_urb(urb);
+		return;
+	}
+
+	/*
+	 * Read from status buffer:
+	 *
+	 * bits [30:31] = cmd type:
+	 * - 0 indicates tx beacon interrupt
+	 * - 1 indicates tx close descriptor
+	 *
+	 * In the case of tx beacon interrupt:
+	 * [0:9] = Last Beacon CW
+	 * [10:29] = reserved
+	 * [30:31] = 00b
+	 * [32:63] = Last Beacon TSF
+	 * 
+	 * If it's tx close descriptor:
+	 * [0:7] = Packet Retry Count
+	 * [8:14] = RTS Retry Count
+	 * [15] = TOK
+	 * [16:27] = Sequence No
+	 * [28] = LS
+	 * [29] = FS
+	 * [30:31] = 01b
+	 * [32:47] = unused (reserved?)
+	 * [48:63] = MAC Used Time
+	 */
+	val = le64_to_cpu(priv->b_tx_status.buf);
+
+	cmd_type = (val >> 30) & 0x3;
+	if (cmd_type == 1) {
+		unsigned int pkt_rc, seq_no;
+		bool tok;
+		struct sk_buff *skb;
+		struct ieee80211_hdr *ieee80211hdr;
+		unsigned long flags;
+
+		pkt_rc = val & 0xFF;
+		tok = val & (1 << 15);
+		seq_no = (val >> 16) & 0xFFF;
+
+		spin_lock_irqsave(&priv->b_tx_status.queue.lock, flags);
+		skb_queue_reverse_walk(&priv->b_tx_status.queue, skb) {
+			ieee80211hdr = (struct ieee80211_hdr *)skb->data;
+
+			/* 
+			 * Instead of returning just the 12 bits of sequence
+			 * number, hardware is returning entire sequence
+			 * control, overflowing after some time. As a
+			 * workaround, just consider the lower bits, and expect
+			 * it's unlikely we wrongly ack some sent data
+			 */
+			if ((le16_to_cpu(ieee80211hdr->seq_ctrl) & 0xFFF) == seq_no)
+				break;
+		}
+		if (skb != (struct sk_buff *) &priv->b_tx_status.queue) {
+			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+			__skb_unlink(skb, &priv->b_tx_status.queue);
+			if (tok)
+				info->flags |= IEEE80211_TX_STAT_ACK;
+			info->status.rates[0].count = pkt_rc + 1;
+
+			ieee80211_tx_status_irqsafe(hw, skb);
+		}
+		spin_unlock_irqrestore(&priv->b_tx_status.queue.lock, flags);
+	}
+
+	usb_submit_urb(urb, GFP_ATOMIC);
+}
+
+static int rtl8187b_init_status_urb(struct ieee80211_hw *dev)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	struct urb *entry;
+
+	entry = usb_alloc_urb(0, GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+	priv->b_tx_status.urb = entry;
+
+	usb_fill_bulk_urb(entry, priv->udev, usb_rcvbulkpipe(priv->udev, 9),
+			  &priv->b_tx_status.buf, sizeof(priv->b_tx_status.buf),
+			  rtl8187b_status_cb, dev);
+
+	usb_submit_urb(entry, GFP_KERNEL);
+
+	return 0;
+}
+
 static int rtl8187_cmd_reset(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
@@ -746,6 +864,7 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 				  (7 << 0  /* long retry limit */) |
 				  (7 << 21 /* MAX TX DMA */));
 		rtl8187_init_urbs(dev);
+		rtl8187b_init_status_urb(dev);
 		mutex_unlock(&priv->conf_mutex);
 		return 0;
 	}
@@ -822,6 +941,9 @@ static void rtl8187_stop(struct ieee80211_hw *dev)
 		usb_kill_urb(info->urb);
 		kfree_skb(skb);
 	}
+	while ((skb = skb_dequeue(&priv->b_tx_status.queue)))
+		dev_kfree_skb_any(skb);
+	usb_kill_urb(priv->b_tx_status.urb);
 	mutex_unlock(&priv->conf_mutex);
 }
 
@@ -1310,6 +1432,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 		goto err_free_dev;
 	}
 	mutex_init(&priv->conf_mutex);
+	skb_queue_head_init(&priv->b_tx_status.queue);
 
 	printk(KERN_INFO "%s: hwaddr %s, %s V%d + %s\n",
 	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
-- 
1.6.0.2

