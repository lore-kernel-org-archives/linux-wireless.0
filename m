Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38656 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751343AbZCTUHk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 16:07:40 -0400
Cc: otus-devel@lists.madwifi-project.org, greg@kroah.com,
	linville@tuxdriver.com, johannes@sipsolutions.net
Content-Type: multipart/mixed; boundary="========GMX261051237579656865998"
Date: Fri, 20 Mar 2009 21:07:36 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <200903202036.09255.chunkeey@web.de>
Message-ID: <20090320200736.261050@gmx.net> (sfid-20090320_210743_770874_D432A094)
MIME-Version: 1.0
References: <200903170408.12626.chunkeey@web.de>
 <200903202036.09255.chunkeey@web.de>
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's
 otus)
To: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX261051237579656865998
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hello Christian!

> Based on the number of mails I got, this driver should be ready for
> inclusion.

ACK

> So, this is probably the last RFC and the official patches will follow on
> sunday (only if no one finds a bug that needs to be fixed ASAP.)

This is not same driver. Its much different, and I couldn't follow the changes in Johannes' git repository.

Today, if have implement rate control (the needed ieee80211_tx_status_irqsafe() calls) for the original code. Now after one hour this code already outdated. :/

In your code the implementation of it is not yet complete?

Regards
Alina

-- 
Aufgepasst: Sind Ihre Daten beim Online-Banking auch optimal geschützt?
Jetzt absichern: https://homebanking.gmx.net/?mc=mail@footer.hb

--========GMX261051237579656865998
Content-Type: text/x-patch; charset="iso-8859-15"; name="rate_control.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="rate_control.patch"

diff --git a/ar9170.h b/ar9170.h
index 4ad272c..b65da25 100644
--- a/ar9170.h
+++ b/ar9170.h
@@ -70,6 +70,8 @@ enum ar9170_rf_init_mode {
 #define AR9170_MAX_RX_BUFFER_SIZE		8192
 #define AR9170_NUM_RX_URBS			16
 
+#define AR9170_MAX_TX_STATUS			10
+
 struct ar9170;
 
 struct ar9170_led {
@@ -102,9 +104,8 @@ struct ar9170 {
 	int readlen;
 	u8 *readbuf;
 
-	struct sk_buff *tx_status_queue_head;
-	struct sk_buff *tx_status_queue_tail;
 	spinlock_t tx_status_lock;
+	struct sk_buff_head tx_status_queue;
 
 	/* power calibration data */
 	u8 power_5G_leg[4];
diff --git a/hw.h b/hw.h
index 7eae0ea..4d6c69c 100644
--- a/hw.h
+++ b/hw.h
@@ -149,7 +149,7 @@ enum ar9170_cmd {
 #define AR9170_MAC_REG_FTF_ACK			BIT(29)
 #define AR9170_MAC_REG_FTF_CFE			BIT(30)
 #define AR9170_MAC_REG_FTF_CFE_ACK		BIT(31)
-#define AR9170_MAC_REG_FTF_DEFAULTS		0x0500ffff
+#define AR9170_MAC_REG_FTF_DEFAULTS		0x2500ffff
 
 #define AR9170_MAC_REG_RX_TOTAL			(AR9170_MAC_REG_BASE + 0x6A0)
 #define AR9170_MAC_REG_RX_CRC32			(AR9170_MAC_REG_BASE + 0x6A4)
diff --git a/main.c b/main.c
index 8a9ddf7..7319c20 100644
--- a/main.c
+++ b/main.c
@@ -220,6 +220,7 @@ static int ar9170_op_start(struct ieee80211_hw *hw)
 static void ar9170_op_stop(struct ieee80211_hw *hw)
 {
 	struct ar9170 *ar = hw->priv;
+	struct sk_buff *skb;
 
 	mutex_lock(&ar->mutex);
 
@@ -228,54 +229,53 @@ static void ar9170_op_stop(struct ieee80211_hw *hw)
 
 	ar->started = false;
 
-	mutex_unlock(&ar->mutex);
-}
+	while ((skb = skb_dequeue(&ar->tx_status_queue)))
+		dev_kfree_skb_any(skb);
 
-#if 0
-static inline void ar9170_add_tx_status_skb(struct ar9170 *ar,
-					    struct sk_buff *skb)
-{
-	skb->next = NULL;
-
-	if (ar->tx_status_queue_tail) {
-		ar->tx_status_queue_tail->next = skb;
-		ar->tx_status_queue_tail = skb;
-	} else {
-		ar->tx_status_queue_tail = skb;
-		ar->tx_status_queue_head = skb;
-	}
+	mutex_unlock(&ar->mutex);
 }
 
-static inline struct sk_buff *ar9170_get_tx_status_skb(struct ar9170 *ar)
+static void ar9170_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
+                             int ack_signal, bool success)
 {
-	struct sk_buff *skb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	skb = ar->tx_status_queue_head;
+	ieee80211_tx_info_clear_status(info);
 
-	if (skb) {
-		ar->tx_status_queue_head = skb->next;
-		if (ar->tx_status_queue_tail == skb)
-			ar->tx_status_queue_tail = NULL;
-	}
+	if (success)
+		info->flags |= IEEE80211_TX_STAT_ACK;
+	info->status.ack_signal = ack_signal;
 
-	return skb;
+	ieee80211_tx_status_irqsafe(hw, skb);
 }
-#endif
 
 static void tx_urb_complete(struct urb *urb)
 {
-	struct sk_buff *skb = (void *)urb->context;
-/*
+	struct sk_buff *skb = (struct sk_buff *)urb->context;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ar9170 *ar = info->rate_driver_data[0];
- */
+	struct ieee80211_hw *hw = info->rate_driver_data[0];
+	struct ar9170 *ar = hw->priv;
+	struct sk_buff *outdated_skb;
 
 	/*
 	 * For proper rate control we really need to provide
-	 * TX status callbacks. For now, don't.
+	 * TX status callbacks.
 	 */
+
+	skb_pull(skb, sizeof(struct ar9170_tx_control));
+	if (urb->status || (info->flags & IEEE80211_TX_CTL_NO_ACK))
+		ar9170_tx_status(hw, skb, 0, !urb->status);
+	else {
+		skb_queue_tail(&ar->tx_status_queue, skb);
+
+		while (skb_queue_len(&ar->tx_status_queue) > AR9170_MAX_TX_STATUS) {
+			outdated_skb = skb_dequeue(&ar->tx_status_queue);
+			if (outdated_skb)
+				ar9170_tx_status(hw, outdated_skb, 0, 0);
+		}
+	}
+
 	usb_free_urb(urb);
-	dev_kfree_skb_irq(skb);
 }
 
 int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
@@ -419,7 +419,7 @@ int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (!urb)
 		goto free;
 
-	info->rate_driver_data[0] = ar;
+	info->rate_driver_data[0] = hw;
 
 	usb_fill_bulk_urb(urb, ar->udev,
 			  usb_sndbulkpipe(ar->udev, AR9170_EP_TX),
@@ -881,6 +881,7 @@ static struct ar9170 *ar9170_alloc(struct usb_interface *intf)
 	mutex_init(&ar->mutex);
 	spin_lock_init(&ar->cmdlock);
 	spin_lock_init(&ar->tx_status_lock);
+	skb_queue_head_init(&ar->tx_status_queue);
 	INIT_WORK(&ar->filter_config_work, ar9170_set_filters);
 	INIT_WORK(&ar->led_work, ar9170_update_leds);
 	INIT_WORK(&ar->beacon_work, ar9170_new_beacon);
@@ -1107,6 +1108,10 @@ static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	struct ieee80211_rx_status status;
 	int mpdu_len, i;
 	u8 error, antennas = 0, decrypt;
+	struct ieee80211_hdr *rx_hdr;
+	unsigned long flags;
+	struct sk_buff *tx_skb;
+	struct ieee80211_hdr *tx_hdr;
 	__le16 fc;
 	int reserved;
 
@@ -1239,8 +1244,30 @@ static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 	}
 
 	buf += sizeof(struct ar9170_rx_head);
-	fc = *(__le16 *)buf;
 
+	/*
+	 * For proper rate control we really need to provide
+	 * TX status callbacks.
+	 */
+
+	rx_hdr = (struct ieee80211_hdr *)buf;
+	if (ieee80211_is_ack(rx_hdr->frame_control)) {
+		spin_lock_irqsave(&ar->tx_status_queue.lock, flags);
+
+		skb_queue_walk(&ar->tx_status_queue, tx_skb) {
+			tx_hdr = (struct ieee80211_hdr *)tx_skb->data;
+			if (memcmp(tx_hdr->addr2, rx_hdr->addr1, ETH_ALEN) == 0) {
+				__skb_unlink(tx_skb, &ar->tx_status_queue);
+				printk("!!!\n");
+				ar9170_tx_status(ar->hw, tx_skb, status.signal, 1);
+				break;
+			}
+		}
+
+		spin_unlock_irqrestore(&ar->tx_status_queue.lock, flags);
+	}
+
+	fc = *(__le16 *)buf;
 	if (ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc))
 		reserved=32+2;
 	else

--========GMX261051237579656865998--
