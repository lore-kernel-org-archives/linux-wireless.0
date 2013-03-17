Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:48239 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3CQJ70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 05:59:26 -0400
Subject: [PATCH 3/4] rtlwifi: usb: defer rx processing to tasklet
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 17 Mar 2013 11:59:24 +0200
Message-ID: <20130317095923.24983.51403.stgit@localhost6.localdomain6> (sfid-20130317_105929_758458_23996FD5)
In-Reply-To: <20130317095831.24983.97107.stgit@localhost6.localdomain6>
References: <20130317095831.24983.97107.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move processing of received packets to tasklet from hard-irq context.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    2 -
 drivers/net/wireless/rtlwifi/usb.c           |   60 ++++++++++++++++++++------
 drivers/net/wireless/rtlwifi/usb.h           |    4 +-
 3 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index b6222ee..710f790 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -434,7 +434,7 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 		 (u32)hdr->addr1[2], (u32)hdr->addr1[3],
 		 (u32)hdr->addr1[4], (u32)hdr->addr1[5]);
 	memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
-	ieee80211_rx_irqsafe(hw, skb);
+	ieee80211_rx(hw, skb);
 }
 
 void  rtl8192cu_rx_hdl(struct ieee80211_hw *hw, struct sk_buff * skb)
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 8563818..6cb2940 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -308,6 +308,8 @@ static int _rtl_usb_init_tx(struct ieee80211_hw *hw)
 	return 0;
 }
 
+static void _rtl_rx_work(unsigned long param);
+
 static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -325,6 +327,11 @@ static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
 		rtlusb->rx_max_size, rtlusb->rx_urb_num, rtlusb->in_ep);
 	init_usb_anchor(&rtlusb->rx_submitted);
 	init_usb_anchor(&rtlusb->rx_cleanup_urbs);
+
+	skb_queue_head_init(&rtlusb->rx_queue);
+	rtlusb->rx_work_tasklet.func = _rtl_rx_work;
+	rtlusb->rx_work_tasklet.data = (unsigned long)rtlusb;
+
 	return 0;
 }
 
@@ -515,7 +522,7 @@ static void _rtl_usb_rx_process_noagg(struct ieee80211_hw *hw,
 		}
 
 		if (likely(rtl_action_proc(hw, skb, false)))
-			ieee80211_rx_irqsafe(hw, skb);
+			ieee80211_rx(hw, skb);
 		else
 			dev_kfree_skb_any(skb);
 	}
@@ -534,7 +541,31 @@ static void _rtl_rx_pre_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	while (!skb_queue_empty(&rx_queue)) {
 		_skb = skb_dequeue(&rx_queue);
 		_rtl_usb_rx_process_agg(hw, _skb);
-		ieee80211_rx_irqsafe(hw, _skb);
+		ieee80211_rx(hw, _skb);
+	}
+}
+
+#define __RX_SKB_MAX_QUEUED	32
+
+static void _rtl_rx_work(unsigned long param)
+{
+	struct rtl_usb *rtlusb = (struct rtl_usb *)param;
+	struct ieee80211_hw *hw = usb_get_intfdata(rtlusb->intf);
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&rtlusb->rx_queue))) {
+		if (unlikely(IS_USB_STOP(rtlusb))) {
+			dev_kfree_skb_any(skb);
+			continue;
+		}
+
+		if (likely(!rtlusb->usb_rx_segregate_hdl)) {
+			_rtl_usb_rx_process_noagg(hw, skb);
+		} else {
+			/* TO DO */
+			_rtl_rx_pre_process(hw, skb);
+			pr_err("rx agg not supported\n");
+		}
 	}
 }
 
@@ -552,6 +583,7 @@ static void _rtl_rx_completed(struct urb *_urb)
 
 	if (likely(0 == _urb->status)) {
 		struct sk_buff *skb;
+		unsigned int qlen;
 		unsigned int size = _urb->actual_length;
 
 		if (size < RTL_RX_DESC_SIZE + sizeof(struct ieee80211_hdr)) {
@@ -561,6 +593,14 @@ static void _rtl_rx_completed(struct urb *_urb)
 			goto resubmit;
 		}
 
+		qlen = skb_queue_len(&rtlusb->rx_queue);
+		if (qlen >= __RX_SKB_MAX_QUEUED) {
+			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
+				 "Pending RX skbuff queue full! (qlen: %d)\n",
+				 qlen);
+			goto resubmit;
+		}
+
 		skb = dev_alloc_skb(size + __RADIO_TAP_SIZE_RSV);
 		if (!skb) {
 			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
@@ -575,17 +615,8 @@ static void _rtl_rx_completed(struct urb *_urb)
 
 		memcpy(skb_put(skb, size), _urb->transfer_buffer, size);
 
-		/* TODO: Do further processing in tasklet (queue skbs,
-		 * schedule tasklet)
-		 */
-
-		if (likely(!rtlusb->usb_rx_segregate_hdl)) {
-			_rtl_usb_rx_process_noagg(hw, skb);
-		} else {
-			/* TO DO */
-			_rtl_rx_pre_process(hw, skb);
-			pr_err("rx agg not supported\n");
-		}
+		skb_queue_tail(&rtlusb->rx_queue, skb);
+		tasklet_schedule(&rtlusb->rx_work_tasklet);
 
 		goto resubmit;
 	}
@@ -626,6 +657,9 @@ static void _rtl_usb_cleanup_rx(struct ieee80211_hw *hw)
 
 	usb_kill_anchored_urbs(&rtlusb->rx_submitted);
 
+	tasklet_kill(&rtlusb->rx_work_tasklet);
+	skb_queue_purge(&rtlusb->rx_queue);
+
 	while ((urb = usb_get_from_anchor(&rtlusb->rx_cleanup_urbs))) {
 		usb_free_coherent(urb->dev, urb->transfer_buffer_length,
 				urb->transfer_buffer, urb->transfer_dma);
diff --git a/drivers/net/wireless/rtlwifi/usb.h b/drivers/net/wireless/rtlwifi/usb.h
index 22d7c68..685273c 100644
--- a/drivers/net/wireless/rtlwifi/usb.h
+++ b/drivers/net/wireless/rtlwifi/usb.h
@@ -136,12 +136,14 @@ struct rtl_usb {
 	void (*usb_tx_cleanup)(struct ieee80211_hw *, struct sk_buff *);
 
 	/* Rx */
-	u8 in_ep_nums ;
+	u8 in_ep_nums;
 	u32 in_ep;		/* Bulk IN endpoint number */
 	u32 rx_max_size;	/* Bulk IN max buffer size */
 	u32 rx_urb_num;		/* How many Bulk INs are submitted to host. */
 	struct usb_anchor	rx_submitted;
 	struct usb_anchor	rx_cleanup_urbs;
+	struct tasklet_struct   rx_work_tasklet;
+	struct sk_buff_head	rx_queue;
 	void (*usb_rx_segregate_hdl)(struct ieee80211_hw *, struct sk_buff *,
 				     struct sk_buff_head *);
 	void (*usb_rx_hdl)(struct ieee80211_hw *, struct sk_buff *);

