Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54057 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYKQPId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 10:08:33 -0500
Date: Mon, 17 Nov 2008 09:08:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Fix transmission count sent to mac80211
Message-ID: <492188e5.bIuOh01ilT9fPRTO%Larry.Finger@lwfinger.net> (sfid-20081117_160837_465627_A7658EE7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the commit entitled "mac80211/drivers: rewrite the rate control API"
(commit 9ea2c74de0ec971e8ec9fc5aaea9cd5b4fec95b6), the meaning of the packet
transmit count was changed from the number of retries to the total number.
In driver rtl8187, this change was missed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -488,7 +488,7 @@ static void rtl8187b_status_cb(struct ur
 			__skb_unlink(skb, &priv->b_tx_status.queue);
 			if (tok)
 				info->flags |= IEEE80211_TX_STAT_ACK;
-			info->status.rates[0].count = pkt_rc;
+			info->status.rates[0].count = pkt_rc + 1;
 
 			ieee80211_tx_status_irqsafe(hw, skb);
 		}
