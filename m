Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2b.orange.fr ([80.12.242.146]:55945 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbZJVKEr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 06:04:47 -0400
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
To: zd1211-devs@lists.sourceforge.net
Cc: linux-wireless@vger.kernel.org,
	Benoit PAPILLAULT <benoit.papillault@free.fr>
Subject: [PATCH] zd1211rw: Fix TX status reporting in order to have proper rate control
Date: Thu, 22 Oct 2009 12:04:52 +0200
Message-Id: <1256205892-6951-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, we reduce the number of hardware retries to 0 (ie 2 real retries
for each rate). Next, when we report the retries to mac80211, we always
report a retry count of 1 (it seems to be 2 in fact, but using 2 seems
to lead to wrong performance for some reason). We use a state machine to
determine the real fate of a packet based on the 802.11 ACK and what the
Zydas hardware is saying when a real retry occurs. The real retry rates
are encoded in a static array. It has been tested with both zd1211 and
zd1211b hardware. Of course, since the Zydas hardware is not reporting
retries accurately, we are just doing our best in order to get the best
performance (ie higher throughput).

Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |    4 +-
 drivers/net/wireless/zd1211rw/zd_chip.h |   18 +++-
 drivers/net/wireless/zd1211rw/zd_mac.c  |  204 +++++++++++++++++++++++++++---
 drivers/net/wireless/zd1211rw/zd_mac.h  |   25 ++++-
 drivers/net/wireless/zd1211rw/zd_usb.c  |    4 +-
 5 files changed, 228 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 5e110a2..43b476d 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -755,7 +755,7 @@ static int hw_reset_phy(struct zd_chip *chip)
 static int zd1211_hw_init_hmac(struct zd_chip *chip)
 {
 	static const struct zd_ioreq32 ioreqs[] = {
-		{ CR_ZD1211_RETRY_MAX,		0x2 },
+		{ CR_ZD1211_RETRY_MAX,		ZD1211_RETRY_COUNT },
 		{ CR_RX_THRESHOLD,		0x000c0640 },
 	};
 
@@ -767,7 +767,7 @@ static int zd1211_hw_init_hmac(struct zd_chip *chip)
 static int zd1211b_hw_init_hmac(struct zd_chip *chip)
 {
 	static const struct zd_ioreq32 ioreqs[] = {
-		{ CR_ZD1211B_RETRY_MAX,		0x02020202 },
+		{ CR_ZD1211B_RETRY_MAX,		ZD1211B_RETRY_COUNT },
 		{ CR_ZD1211B_CWIN_MAX_MIN_AC0,	0x007f003f },
 		{ CR_ZD1211B_CWIN_MAX_MIN_AC1,	0x007f003f },
 		{ CR_ZD1211B_CWIN_MAX_MIN_AC2,  0x003f001f },
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index 678c139..9fd8f35 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -642,13 +642,29 @@ enum {
 #define CR_ZD1211B_TXOP			CTL_REG(0x0b20)
 #define CR_ZD1211B_RETRY_MAX		CTL_REG(0x0b28)
 
+/* Value for CR_ZD1211_RETRY_MAX & CR_ZD1211B_RETRY_MAX. Vendor driver uses 2,
+ * we use 0. The first rate is tried (count+2), then all next rates are tried
+ * twice, until 1 Mbits is tried. */
+#define	ZD1211_RETRY_COUNT		0
+#define	ZD1211B_RETRY_COUNT	\
+	(ZD1211_RETRY_COUNT <<  0)|	\
+	(ZD1211_RETRY_COUNT <<  8)|	\
+	(ZD1211_RETRY_COUNT << 16)|	\
+	(ZD1211_RETRY_COUNT << 24)
+
 /* Used to detect PLL lock */
 #define UW2453_INTR_REG			((zd_addr_t)0x85c1)
 
 #define CWIN_SIZE			0x007f043f
 
 
-#define HWINT_ENABLED			0x004f0000
+#define HWINT_ENABLED			\
+	(INT_TX_COMPLETE_EN|		\
+	 INT_RX_COMPLETE_EN|		\
+	 INT_RETRY_FAIL_EN|		\
+	 INT_WAKEUP_EN|			\
+	 INT_CFG_NEXT_BCN_EN)
+
 #define HWINT_DISABLED			0
 
 #define E2P_PWR_INT_GUARD		8
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 6d66635..8ca85d8 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -88,6 +88,34 @@ static const struct ieee80211_rate zd_rates[] = {
 	  .flags = 0 },
 };
 
+/*
+ * Zydas retry rates table. Each line is listed in the same order as
+ * in zd_rates[] and contains all the rate used when a packet is sent
+ * starting with a given rates. Let's consider an example :
+ *
+ * "11 Mbits : 4, 3, 2, 1, 0" means :
+ * - packet is sent using 4 different rates
+ * - 1st rate is index 3 (ie 11 Mbits)
+ * - 2nd rate is index 2 (ie 5.5 Mbits)
+ * - 3rd rate is index 1 (ie 2 Mbits)
+ * - 4th rate is index 0 (ie 1 Mbits)
+ */
+
+static const struct tx_retry_rate zd_retry_rates[] = {
+	{ /*  1 Mbits */	1, { 0 }},
+	{ /*  2 Mbits */	2, { 1,  0 }},
+	{ /*  5.5 Mbits */	3, { 2,  1, 0 }},
+	{ /* 11 Mbits */	4, { 3,  2, 1, 0 }},
+	{ /*  6 Mbits */	5, { 4,  3, 2, 1, 0 }},
+	{ /*  9 Mbits */	6, { 5,  4, 3, 2, 1, 0}},
+	{ /* 12 Mbits */	5, { 6,  3, 2, 1, 0 }},
+	{ /* 18 Mbits */	6, { 7,  6, 3, 2, 1, 0 }},
+	{ /* 24 Mbits */	6, { 8,  6, 3, 2, 1, 0 }},
+	{ /* 36 Mbits */	7, { 9,  8, 6, 3, 2, 1, 0 }},
+	{ /* 48 Mbits */	8, {10,  9, 8, 6, 3, 2, 1, 0 }},
+	{ /* 54 Mbits */	9, {11, 10, 9, 8, 6, 3, 2, 1, 0 }}
+};
+
 static const struct ieee80211_channel zd_channels[] = {
 	{ .center_freq = 2412, .hw_value = 1 },
 	{ .center_freq = 2417, .hw_value = 2 },
@@ -282,7 +310,7 @@ static void zd_op_stop(struct ieee80211_hw *hw)
 }
 
 /**
- * tx_status - reports tx status of a packet if required
+ * zd_mac_tx_status - reports tx status of a packet if required
  * @hw - a &struct ieee80211_hw pointer
  * @skb - a sk-buffer
  * @flags: extra flags to set in the TX status info
@@ -295,15 +323,49 @@ static void zd_op_stop(struct ieee80211_hw *hw)
  *
  * If no status information has been requested, the skb is freed.
  */
-static void tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
-		      int ackssi, bool success)
+static void zd_mac_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
+		      int ackssi, struct tx_status *tx_status)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
+	int i;
+	int success = 1, retry = 1;
+	int first_idx;
+	const struct tx_retry_rate *retries;
+	
 	ieee80211_tx_info_clear_status(info);
 
-	if (success)
+	if (tx_status) {
+		success = !tx_status->failure;
+		retry = tx_status->retry + success;
+	}
+
+	if (success) {
+		/* success */
 		info->flags |= IEEE80211_TX_STAT_ACK;
+	} else {
+		/* failure */
+		info->flags &= ~IEEE80211_TX_STAT_ACK;
+	}
+
+	first_idx = info->status.rates[0].idx;
+	ZD_ASSERT(0<=first_idx && first_idx<ARRAY_SIZE(zd_retry_rates));
+	retries = &zd_retry_rates[first_idx];
+	ZD_ASSERT(0<=retry && retry<=retries->count);
+	
+	info->status.rates[0].idx = retries->rate[0];
+	info->status.rates[0].count = 1; // (retry > 1 ? 2 : 1);
+
+	for (i=1; i<IEEE80211_TX_MAX_RATES-1 && i<retry; i++) {
+		info->status.rates[i].idx = retries->rate[i];
+		info->status.rates[i].count = 1; // ((i==retry-1) && success ? 1:2);
+	}
+	for (; i<IEEE80211_TX_MAX_RATES && i<retry; i++) {
+		info->status.rates[i].idx = retries->rate[retry-1];
+		info->status.rates[i].count = 1; // (success ? 1:2);
+	}
+	if (i<IEEE80211_TX_MAX_RATES)
+		info->status.rates[i].idx = -1; /* terminate */
+
 	info->status.ack_signal = ackssi;
 	ieee80211_tx_status_irqsafe(hw, skb);
 }
@@ -316,16 +378,79 @@ static void tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
  * transferred. The first frame from the tx queue, will be selected and
  * reported as error to the upper layers.
  */
-void zd_mac_tx_failed(struct ieee80211_hw *hw)
+void zd_mac_tx_failed(struct urb *urb)
 {
-	struct sk_buff_head *q = &zd_hw_mac(hw)->ack_wait_queue;
+	struct ieee80211_hw * hw = zd_usb_to_hw(urb->context);
+	struct zd_mac *mac = zd_hw_mac(hw);
+	struct sk_buff_head *q = &mac->ack_wait_queue;
 	struct sk_buff *skb;
+	struct tx_status *tx_status = (struct tx_status *)urb->transfer_buffer;
+	unsigned long flags;
+	int success = !tx_status->failure;
+	int retry = tx_status->retry + success;
+	int found = 0;
+	int i, position = 0;
 
-	skb = skb_dequeue(q);
-	if (skb == NULL)
-		return;
+	q = &mac->ack_wait_queue;
+	spin_lock_irqsave(&q->lock, flags);
 
-	tx_status(hw, skb, 0, 0);
+	skb_queue_walk(q, skb) {
+		struct ieee80211_hdr *tx_hdr;
+		struct ieee80211_tx_info *info;
+		int first_idx, final_idx;
+		const struct tx_retry_rate *retries;
+		u8 final_rate;
+
+		position ++;
+	
+		/* if the hardware reports a failure and we had a 802.11 ACK
+		 * pending, then we skip the first skb when searching for a
+		 * matching frame */
+		if (tx_status->failure && mac->ack_pending &&
+		    skb_queue_is_first(q, skb)) {
+			continue;
+		}
+
+		tx_hdr = (struct ieee80211_hdr *)skb->data;
+
+		/* we skip all frames not matching the reported destination */
+		if (unlikely(memcmp(tx_hdr->addr1, tx_status->mac, ETH_ALEN))) {
+			continue;
+		}
+
+		/* we skip all frames not matching the reported final rate */
+
+		info = IEEE80211_SKB_CB(skb);
+		first_idx = info->status.rates[0].idx;
+		ZD_ASSERT(0<=first_idx && first_idx<ARRAY_SIZE(zd_retry_rates));
+		retries = &zd_retry_rates[first_idx];
+		if (retry < 0 || retry > retries->count) {
+			continue;
+		}
+
+		ZD_ASSERT(0<=retry && retry<=retries->count);
+		final_idx = retries->rate[retry-1];
+		final_rate = zd_rates[final_idx].hw_value;
+
+		if (final_rate != tx_status->rate) {
+			continue;
+		}
+
+		found = 1;
+		break;
+	}
+
+	if (found) {
+		for (i=1; i<=position; i++) {
+			skb = __skb_dequeue(q);
+			zd_mac_tx_status(hw, skb,
+					 mac->ack_pending ? mac->ack_signal : 0,
+					 i == position ? tx_status : NULL);
+			mac->ack_pending = 0;
+		}
+	}
+
+	spin_unlock_irqrestore(&q->lock, flags);
 }
 
 /**
@@ -342,18 +467,27 @@ void zd_mac_tx_to_dev(struct sk_buff *skb, int error)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hw *hw = info->rate_driver_data[0];
+	struct zd_mac *mac = zd_hw_mac(hw);
+
+	ieee80211_tx_info_clear_status(info);
 
 	skb_pull(skb, sizeof(struct zd_ctrlset));
 	if (unlikely(error ||
 	    (info->flags & IEEE80211_TX_CTL_NO_ACK))) {
-		tx_status(hw, skb, 0, !error);
+		/*
+		 * FIXME : do we need to fill in anything ?
+		 */
+		ieee80211_tx_status_irqsafe(hw, skb);
 	} else {
-		struct sk_buff_head *q =
-			&zd_hw_mac(hw)->ack_wait_queue;
+		struct sk_buff_head *q = &mac->ack_wait_queue;
 
 		skb_queue_tail(q, skb);
-		while (skb_queue_len(q) > ZD_MAC_MAX_ACK_WAITERS)
-			zd_mac_tx_failed(hw);
+		while (skb_queue_len(q) > ZD_MAC_MAX_ACK_WAITERS) {
+			zd_mac_tx_status(hw, skb_dequeue(q),
+					 mac->ack_pending ? mac->ack_signal : 0,
+					 NULL);
+			mac->ack_pending = 0;
+		}
 	}
 }
 
@@ -606,27 +740,47 @@ fail:
 static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
 		      struct ieee80211_rx_status *stats)
 {
+	struct zd_mac *mac = zd_hw_mac(hw);
 	struct sk_buff *skb;
 	struct sk_buff_head *q;
 	unsigned long flags;
+	int found = 0;
+	int i, position = 0;
 
 	if (!ieee80211_is_ack(rx_hdr->frame_control))
 		return 0;
 
-	q = &zd_hw_mac(hw)->ack_wait_queue;
+	q = &mac->ack_wait_queue;
 	spin_lock_irqsave(&q->lock, flags);
 	skb_queue_walk(q, skb) {
 		struct ieee80211_hdr *tx_hdr;
 
+		position ++;
+
+		if (mac->ack_pending && skb_queue_is_first(q, skb))
+		    continue;
+
 		tx_hdr = (struct ieee80211_hdr *)skb->data;
 		if (likely(!memcmp(tx_hdr->addr2, rx_hdr->addr1, ETH_ALEN)))
 		{
-			__skb_unlink(skb, q);
-			tx_status(hw, skb, stats->signal, 1);
-			goto out;
+			found = 1;
+			break;
 		}
 	}
-out:
+
+	if (found) {
+		for (i=1; i<position; i++) {
+			skb = __skb_dequeue(q);
+			zd_mac_tx_status(hw, skb,
+					 mac->ack_pending ? mac->ack_signal : 0,
+					 NULL);
+			mac->ack_pending = 0;
+		}
+
+		mac->ack_pending = 1;
+		mac->ack_signal = stats->signal;
+	}
+
 	spin_unlock_irqrestore(&q->lock, flags);
 	return 1;
 }
@@ -709,6 +863,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 		skb_reserve(skb, 2);
 	}
 
+	/* FIXME : could we avoid this big memcpy ? */
 	memcpy(skb_put(skb, length), buffer, length);
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &stats, sizeof(stats));
@@ -999,7 +1154,14 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	hw->queues = 1;
 	hw->extra_tx_headroom = sizeof(struct zd_ctrlset);
 
+	/*
+	 * Tell mac80211 that we support multi rate retries
+	 */
+	hw->max_rates = IEEE80211_TX_MAX_RATES;
+	hw->max_rate_tries = 18;	/* 9 rates * 2 retries/rate */
+
 	skb_queue_head_init(&mac->ack_wait_queue);
+	mac->ack_pending = 0;
 
 	zd_chip_init(&mac->chip, hw, intf);
 	housekeeping_init(mac);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index 7c27591..630c298 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -140,6 +140,21 @@ struct rx_status {
 #define ZD_RX_CRC16_ERROR		0x40
 #define ZD_RX_ERROR			0x80
 
+struct tx_retry_rate {
+	int count;	/* number of valid element in rate[] array */
+	int rate[10];	/* retry rates, described by an index in zd_rates[] */
+};
+
+struct tx_status {
+	u8 type;	/* must always be 0x01 : USB_INT_TYPE */
+	u8 id;		/* must always be 0xa0 : USB_INT_ID_RETRY_FAILED */
+	u8 rate;
+	u8 pad;
+	u8 mac[ETH_ALEN];
+	u8 retry;
+	u8 failure;
+} __attribute__((packed));
+
 enum mac_flags {
 	MAC_FIXED_CHANNEL = 0x01,
 };
@@ -150,7 +165,7 @@ struct housekeeping {
 
 #define ZD_MAC_STATS_BUFFER_SIZE 16
 
-#define ZD_MAC_MAX_ACK_WAITERS 10
+#define ZD_MAC_MAX_ACK_WAITERS 50
 
 struct zd_mac {
 	struct zd_chip chip;
@@ -184,6 +199,12 @@ struct zd_mac {
 
 	/* whether to pass control frames to stack */
 	unsigned int pass_ctrl:1;
+
+	/* whether we have received a 802.11 ACK that is pending */
+	unsigned int ack_pending:1;
+
+	/* signal strength of the last 802.11 ACK received */
+	int ack_signal;
 };
 
 #define ZD_REGDOMAIN_FCC	0x10
@@ -279,7 +300,7 @@ int zd_mac_preinit_hw(struct ieee80211_hw *hw);
 int zd_mac_init_hw(struct ieee80211_hw *hw);
 
 int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length);
-void zd_mac_tx_failed(struct ieee80211_hw *hw);
+void zd_mac_tx_failed(struct urb *urb);
 void zd_mac_tx_to_dev(struct sk_buff *skb, int error);
 
 #ifdef DEBUG
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 3868884..ddfaa73 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -419,7 +419,7 @@ static void int_urb_complete(struct urb *urb)
 		handle_regs_int(urb);
 		break;
 	case USB_INT_ID_RETRY_FAILED:
-		zd_mac_tx_failed(zd_usb_to_hw(urb->context));
+		zd_mac_tx_failed(urb);
 		break;
 	default:
 		dev_dbg_f(urb_dev(urb), "error: urb %p unknown id %x\n", urb,
@@ -553,6 +553,8 @@ static void handle_rx_packet(struct zd_usb *usb, const u8 *buffer,
 
 	if (length < sizeof(struct rx_length_info)) {
 		/* It's not a complete packet anyhow. */
+		printk("%s: invalid, small RX packet : %d\n",
+		       __func__, length);
 		return;
 	}
 	length_info = (struct rx_length_info *)
-- 
1.6.2.4



