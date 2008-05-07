Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbYEGXop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 19:44:45 -0400
Subject: [PATCH] zd1211rw: fix potential use-after-free bug
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Daniel Drake <dsd@gentoo.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Thu, 08 May 2008 01:43:59 +0200
Message-Id: <1210203839.3547.15.camel@johannes.berg> (sfid-20080508_014352_653550_6012C694)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd_mac_tx_to_dev() could potentially free the skb, or hand it off
to mac80211 which might free it. Hence, this code needs to get the
usb pointer out of skb->cb before handing it off to that function.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
-stable material?

 drivers/net/wireless/zd1211rw/zd_usb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- everything.orig/drivers/net/wireless/zd1211rw/zd_usb.c	2008-05-08 01:36:06.000000000 +0200
+++ everything/drivers/net/wireless/zd1211rw/zd_usb.c	2008-05-08 01:37:03.000000000 +0200
@@ -889,9 +889,13 @@ static void tx_urb_complete(struct urb *
 	}
 free_urb:
 	skb = (struct sk_buff *)urb->context;
-	zd_mac_tx_to_dev(skb, urb->status);
+	/*
+	 * grab 'usb' pointer before handing off the skb (since
+	 * it might be freed by zd_mac_tx_to_dev or mac80211)
+	 */
 	cb = (struct zd_tx_skb_control_block *)skb->cb;
 	usb = &zd_hw_mac(cb->hw)->chip.usb;
+	zd_mac_tx_to_dev(skb, urb->status);
 	free_tx_urb(usb, urb);
 	tx_dec_submitted_urbs(usb);
 	return;


