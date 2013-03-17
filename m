Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:48177 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3CQJ7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 05:59:16 -0400
Subject: [PATCH 1/4] rtlwifi: usb: use usb_alloc_coherent for RX buffers
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 17 Mar 2013 11:59:13 +0200
Message-ID: <20130317095913.24983.60974.stgit@localhost6.localdomain6> (sfid-20130317_105925_020713_A4D930D5)
In-Reply-To: <20130317095831.24983.97107.stgit@localhost6.localdomain6>
References: <20130317095831.24983.97107.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use dedicated DMA coherent buffers for RX urbs, to avoid allocation of large
skbuffs in hard-irq context and improve performance.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 drivers/net/wireless/rtlwifi/usb.c |  114 +++++++++++++++++++++---------------
 drivers/net/wireless/rtlwifi/usb.h |    1 
 2 files changed, 68 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 41dce83..146d2b4 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -324,6 +324,7 @@ static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
 	pr_info("rx_max_size %d, rx_urb_num %d, in_ep %d\n",
 		rtlusb->rx_max_size, rtlusb->rx_urb_num, rtlusb->in_ep);
 	init_usb_anchor(&rtlusb->rx_submitted);
+	init_usb_anchor(&rtlusb->rx_cleanup_urbs);
 	return 0;
 }
 
@@ -405,40 +406,30 @@ static void rtl_usb_init_sw(struct ieee80211_hw *hw)
 	rtlusb->disableHWSM =  true;
 }
 
-#define __RADIO_TAP_SIZE_RSV	32
-
 static void _rtl_rx_completed(struct urb *urb);
 
-static struct sk_buff *_rtl_prep_rx_urb(struct ieee80211_hw *hw,
-					struct rtl_usb *rtlusb,
-					struct urb *urb,
-					gfp_t gfp_mask)
+static int _rtl_prep_rx_urb(struct ieee80211_hw *hw, struct rtl_usb *rtlusb,
+			      struct urb *urb, gfp_t gfp_mask)
 {
-	struct sk_buff *skb;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	void *buf;
 
-	skb = __dev_alloc_skb((rtlusb->rx_max_size + __RADIO_TAP_SIZE_RSV),
-			       gfp_mask);
-	if (!skb) {
+	buf = usb_alloc_coherent(rtlusb->udev, rtlusb->rx_max_size, gfp_mask,
+				 &urb->transfer_dma);
+	if (!buf) {
 		RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
-			 "Failed to __dev_alloc_skb!!\n");
-		return ERR_PTR(-ENOMEM);
+			 "Failed to usb_alloc_coherent!!\n");
+		return -ENOMEM;
 	}
 
-	/* reserve some space for mac80211's radiotap */
-	skb_reserve(skb, __RADIO_TAP_SIZE_RSV);
 	usb_fill_bulk_urb(urb, rtlusb->udev,
 			  usb_rcvbulkpipe(rtlusb->udev, rtlusb->in_ep),
-			  skb->data, min(skb_tailroom(skb),
-			  (int)rtlusb->rx_max_size),
-			  _rtl_rx_completed, skb);
+			  buf, rtlusb->rx_max_size, _rtl_rx_completed, rtlusb);
+	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
-	_rtl_install_trx_info(rtlusb, skb, rtlusb->in_ep);
-	return skb;
+	return 0;
 }
 
-#undef __RADIO_TAP_SIZE_RSV
-
 static void _rtl_usb_rx_process_agg(struct ieee80211_hw *hw,
 				    struct sk_buff *skb)
 {
@@ -558,11 +549,11 @@ static void _rtl_rx_pre_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 }
 
+#define __RADIO_TAP_SIZE_RSV	32
+
 static void _rtl_rx_completed(struct urb *_urb)
 {
-	struct sk_buff *skb = (struct sk_buff *)_urb->context;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct rtl_usb *rtlusb = (struct rtl_usb *)info->rate_driver_data[0];
+	struct rtl_usb *rtlusb = (struct rtl_usb *)_urb->context;
 	struct ieee80211_hw *hw = usb_get_intfdata(rtlusb->intf);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int err = 0;
@@ -571,28 +562,42 @@ static void _rtl_rx_completed(struct urb *_urb)
 		goto free;
 
 	if (likely(0 == _urb->status)) {
-		/* If this code were moved to work queue, would CPU
-		 * utilization be improved?  NOTE: We shall allocate another skb
-		 * and reuse the original one.
+		struct sk_buff *skb;
+		unsigned int size = _urb->actual_length;
+
+		if (size < RTL_RX_DESC_SIZE + sizeof(struct ieee80211_hdr)) {
+			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
+				 "Too short packet from bulk IN! (len: %d)\n",
+				 size);
+			goto resubmit;
+		}
+
+		skb = dev_alloc_skb(size + __RADIO_TAP_SIZE_RSV);
+		if (!skb) {
+			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
+				 "Can't allocate skb for bulk IN!\n");
+			goto resubmit;
+		}
+
+		_rtl_install_trx_info(rtlusb, skb, rtlusb->in_ep);
+
+		/* reserve some space for mac80211's radiotap */
+		skb_reserve(skb, __RADIO_TAP_SIZE_RSV);
+
+		memcpy(skb_put(skb, size), _urb->transfer_buffer, size);
+
+		/* TODO: Do further processing in tasklet (queue skbs,
+		 * schedule tasklet)
 		 */
-		skb_put(skb, _urb->actual_length);
 
 		if (likely(!rtlusb->usb_rx_segregate_hdl)) {
-			struct sk_buff *_skb;
 			_rtl_usb_rx_process_noagg(hw, skb);
-			_skb = _rtl_prep_rx_urb(hw, rtlusb, _urb, GFP_ATOMIC);
-			if (IS_ERR(_skb)) {
-				err = PTR_ERR(_skb);
-				RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
-					 "Can't allocate skb for bulk IN!\n");
-				return;
-			}
-			skb = _skb;
-		} else{
+		} else {
 			/* TO DO */
 			_rtl_rx_pre_process(hw, skb);
 			pr_err("rx agg not supported\n");
 		}
+
 		goto resubmit;
 	}
 
@@ -608,9 +613,6 @@ static void _rtl_rx_completed(struct urb *_urb)
 	}
 
 resubmit:
-	skb_reset_tail_pointer(skb);
-	skb_trim(skb, 0);
-
 	usb_anchor_urb(_urb, &rtlusb->rx_submitted);
 	err = usb_submit_urb(_urb, GFP_ATOMIC);
 	if (unlikely(err)) {
@@ -620,13 +622,31 @@ resubmit:
 	return;
 
 free:
-	dev_kfree_skb_irq(skb);
+	/* On some architectures, usb_free_coherent must not be called from
+	 * hardirq context. Queue urb to cleanup list.
+	 */
+	usb_anchor_urb(_urb, &rtlusb->rx_cleanup_urbs);
+}
+
+#undef __RADIO_TAP_SIZE_RSV
+
+static void _rtl_usb_cleanup_rx(struct ieee80211_hw *hw)
+{
+	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
+	struct urb *urb;
+
+	usb_kill_anchored_urbs(&rtlusb->rx_submitted);
+
+	while ((urb = usb_get_from_anchor(&rtlusb->rx_cleanup_urbs))) {
+		usb_free_coherent(urb->dev, urb->transfer_buffer_length,
+				urb->transfer_buffer, urb->transfer_dma);
+		usb_free_urb(urb);
+	}
 }
 
 static int _rtl_usb_receive(struct ieee80211_hw *hw)
 {
 	struct urb *urb;
-	struct sk_buff *skb;
 	int err;
 	int i;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -645,11 +665,10 @@ static int _rtl_usb_receive(struct ieee80211_hw *hw)
 			goto err_out;
 		}
 
-		skb = _rtl_prep_rx_urb(hw, rtlusb, urb, GFP_KERNEL);
-		if (IS_ERR(skb)) {
+		err = _rtl_prep_rx_urb(hw, rtlusb, urb, GFP_KERNEL);
+		if (err < 0) {
 			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
 				 "Failed to prep_rx_urb!!\n");
-			err = PTR_ERR(skb);
 			usb_free_urb(urb);
 			goto err_out;
 		}
@@ -664,6 +683,7 @@ static int _rtl_usb_receive(struct ieee80211_hw *hw)
 
 err_out:
 	usb_kill_anchored_urbs(&rtlusb->rx_submitted);
+	_rtl_usb_cleanup_rx(hw);
 	return err;
 }
 
@@ -705,7 +725,7 @@ static void rtl_usb_cleanup(struct ieee80211_hw *hw)
 	SET_USB_STOP(rtlusb);
 
 	/* clean up rx stuff. */
-	usb_kill_anchored_urbs(&rtlusb->rx_submitted);
+	_rtl_usb_cleanup_rx(hw);
 
 	/* clean up tx stuff */
 	for (i = 0; i < RTL_USB_MAX_EP_NUM; i++) {
diff --git a/drivers/net/wireless/rtlwifi/usb.h b/drivers/net/wireless/rtlwifi/usb.h
index fb986f9..22d7c68 100644
--- a/drivers/net/wireless/rtlwifi/usb.h
+++ b/drivers/net/wireless/rtlwifi/usb.h
@@ -141,6 +141,7 @@ struct rtl_usb {
 	u32 rx_max_size;	/* Bulk IN max buffer size */
 	u32 rx_urb_num;		/* How many Bulk INs are submitted to host. */
 	struct usb_anchor	rx_submitted;
+	struct usb_anchor	rx_cleanup_urbs;
 	void (*usb_rx_segregate_hdl)(struct ieee80211_hw *, struct sk_buff *,
 				     struct sk_buff_head *);
 	void (*usb_rx_hdl)(struct ieee80211_hw *, struct sk_buff *);

