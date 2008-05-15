Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:41209 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbYEOORl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 10:17:41 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-usb@vger.kernel.org, Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andreamrl@tiscali.it>
Subject: [patch] resource leak in error case in rtl8187
Date: Thu, 15 May 2008 16:17:36 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805151617.37968.oliver@neukum.org> (sfid-20080515_161752_956805_4B075B04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this fixes a resource leak in the error case of the write code path.

	Regards
		Oliver

Signed-off-by: Oliver Neukum <oneukum@suse.de>

---

--- linux-2.6.26-rc1/drivers/net/wireless/rtl8187_dev.c.alt	2008-05-15 15:53:58.000000000 +0200
+++ linux-2.6.26-rc1/drivers/net/wireless/rtl8187_dev.c	2008-05-15 15:57:35.000000000 +0200
@@ -169,6 +169,7 @@ static int rtl8187_tx(struct ieee80211_h
 	struct urb *urb;
 	__le16 rts_dur = 0;
 	u32 flags;
+	int rv;
 
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
@@ -208,7 +209,11 @@ static int rtl8187_tx(struct ieee80211_h
 	info->dev = dev;
 	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, 2),
 			  hdr, skb->len, rtl8187_tx_cb, skb);
-	usb_submit_urb(urb, GFP_ATOMIC);
+	rv = usb_submit_urb(urb, GFP_ATOMIC);
+	if (rv < 0) {
+		usb_free_urb(urb);
+		kfree_skb(skb);
+	}
 
 	return 0;
 }
