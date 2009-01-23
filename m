Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbZAWRqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 12:46:42 -0500
Date: Fri, 23 Jan 2009 11:46:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Add termination packet to prevent stall
Message-ID: <497a0278.fRVcNq75DBBbCg4K%Larry.Finger@lwfinger.net> (sfid-20090123_184700_224005_429B8AC1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RTL8187 and RTL8187B devices can stall unless an explicit termination
packet is sent.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

With this patch my RTL8187L was able to perform a major git pull for a
tree mounted on an NFS volume, and do a multi-job kernel compilation. Without
the patch, the wireless would hang. I think this is 2.6.29 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -281,6 +281,7 @@ static int rtl8187_tx(struct ieee80211_h
 
 	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, ep),
 			  buf, skb->len, rtl8187_tx_cb, skb);
+	urb->transfer_flags |= URB_ZERO_PACKET;
 	usb_anchor_urb(urb, &priv->anchored);
 	rc = usb_submit_urb(urb, GFP_ATOMIC);
 	if (rc < 0) {

---
