Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48365 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYLNAJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Dec 2008 19:09:59 -0500
Date: Sat, 13 Dec 2008 18:09:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] rtl8187: Fix error returns
Message-ID: <49444ed4.RHT0goRgzQT9Xfeg%Larry.Finger@lwfinger.net> (sfid-20081214_011013_624267_865A1963)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two places in the rtl8187 code where a routine was returning zero
(OK) when it should have been returning an error.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.29 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -213,7 +213,7 @@ static int rtl8187_tx(struct ieee80211_h
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
 		kfree_skb(skb);
-		return 0;
+		return -ENOMEM;
 	}
 
 	flags = skb->len;
@@ -281,7 +281,7 @@ static int rtl8187_tx(struct ieee80211_h
 	}
 	usb_free_urb(urb);
 
-	return 0;
+	return rc;
 }
 
 static void rtl8187_rx_cb(struct urb *urb)


