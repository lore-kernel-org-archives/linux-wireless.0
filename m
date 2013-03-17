Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:48271 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3CQJ7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 05:59:31 -0400
Subject: [PATCH 4/4] rtlwifi: usb: add NET_IP_ALIGN padding to RX skb when
 needed
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 17 Mar 2013 11:59:29 +0200
Message-ID: <20130317095929.24983.14535.stgit@localhost6.localdomain6> (sfid-20130317_105934_044772_35692FBD)
In-Reply-To: <20130317095831.24983.97107.stgit@localhost6.localdomain6>
References: <20130317095831.24983.97107.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add proper alignment at first packet copy, to avoid extra copies made later
in networking stack.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 drivers/net/wireless/rtlwifi/usb.c |   41 +++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 6cb2940..83915dc 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -569,6 +569,37 @@ static void _rtl_rx_work(unsigned long param)
 	}
 }
 
+static unsigned int _rtl_rx_get_padding(struct ieee80211_hdr *hdr,
+					unsigned int len)
+{
+	unsigned int padding = 0;
+
+	/* make function no-op when possible */
+	if (NET_IP_ALIGN == 0 || len < sizeof(*hdr))
+		return 0;
+
+	/* alignment calculation as in lbtf_rx() / carl9170_rx_copy_data() */
+	/* TODO: deduplicate common code, define helper function instead? */
+
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
+
+		padding ^= NET_IP_ALIGN;
+
+		/* Input might be invalid, avoid accessing memory outside
+		 * the buffer.
+		 */
+		if ((unsigned long)qc - (unsigned long)hdr < len &&
+		    *qc & IEEE80211_QOS_CTL_A_MSDU_PRESENT)
+			padding ^= NET_IP_ALIGN;
+	}
+
+	if (ieee80211_has_a4(hdr->frame_control))
+		padding ^= NET_IP_ALIGN;
+
+	return padding;
+}
+
 #define __RADIO_TAP_SIZE_RSV	32
 
 static void _rtl_rx_completed(struct urb *_urb)
@@ -582,9 +613,11 @@ static void _rtl_rx_completed(struct urb *_urb)
 		goto free;
 
 	if (likely(0 == _urb->status)) {
+		unsigned int padding;
 		struct sk_buff *skb;
 		unsigned int qlen;
 		unsigned int size = _urb->actual_length;
+		struct ieee80211_hdr *hdr;
 
 		if (size < RTL_RX_DESC_SIZE + sizeof(struct ieee80211_hdr)) {
 			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
@@ -601,7 +634,10 @@ static void _rtl_rx_completed(struct urb *_urb)
 			goto resubmit;
 		}
 
-		skb = dev_alloc_skb(size + __RADIO_TAP_SIZE_RSV);
+		hdr = (void *)(_urb->transfer_buffer + RTL_RX_DESC_SIZE);
+		padding = _rtl_rx_get_padding(hdr, size - RTL_RX_DESC_SIZE);
+
+		skb = dev_alloc_skb(size + __RADIO_TAP_SIZE_RSV + padding);
 		if (!skb) {
 			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
 				 "Can't allocate skb for bulk IN!\n");
@@ -610,6 +646,9 @@ static void _rtl_rx_completed(struct urb *_urb)
 
 		_rtl_install_trx_info(rtlusb, skb, rtlusb->in_ep);
 
+		/* Make sure the payload data is 4 byte aligned. */
+		skb_reserve(skb, padding);
+
 		/* reserve some space for mac80211's radiotap */
 		skb_reserve(skb, __RADIO_TAP_SIZE_RSV);
 

