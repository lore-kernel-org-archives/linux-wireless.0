Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47439 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbZCPTrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 15:47:45 -0400
Date: Mon, 16 Mar 2009 21:47:33 +0200
From: Jouni Malinen <j@w1.fi>
To: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] zd1211rw: Do not panic on device eject when associated
Message-ID: <20090316194733.GA23062@jm.kir.nu> (sfid-20090316_204748_435020_3BB72D18)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd_op_tx() must not return an arbitrary error value since that can
leave mac80211 trying to retransmit the frame and with the extra data
pushed into the beginning of the skb on every attempt, this will end up
causing a kernel panic (skb_under_panic from skb_push call). This can
happen, e.g., when ejecting the device when associated.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 drivers/net/wireless/zd1211rw/zd_mac.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2009-02-28 00:24:24.000000000 +0200
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2009-03-16 21:44:07.000000000 +0200
@@ -575,13 +575,17 @@ static int zd_op_tx(struct ieee80211_hw 
 
 	r = fill_ctrlset(mac, skb);
 	if (r)
-		return r;
+		goto fail;
 
 	info->rate_driver_data[0] = hw;
 
 	r = zd_usb_tx(&mac->chip.usb, skb);
 	if (r)
-		return r;
+		goto fail;
+	return 0;
+
+fail:
+	dev_kfree_skb(skb);
 	return 0;
 }
 

-- 
Jouni Malinen                                            PGP id EFC895FA
