Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZAEVXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 16:23:36 -0500
Subject: Re: Problem with rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4962775B.2040205@lwfinger.net>
References: <496273D4.6020600@lwfinger.net>
	 <1231189302.3697.25.camel@johannes>  <4962775B.2040205@lwfinger.net>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 22:23:54 +0100
Message-Id: <1231190634.3697.32.camel@johannes> (sfid-20090105_222349_817912_47030B59)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-01-05 at 15:10 -0600, Larry Finger wrote:
> Johannes Berg wrote:
> > 
> > Does the backtrace continue beyond what you pasted?
> 
> Yes, here is the whole thing.

Thanks.


>  [<ffffffff8023afce>] warn_on_slowpath+0x58/0x7d
>  [<ffffffffa029e98b>] ieee80211_master_start_xmit+0x41c/0x50d [mac80211]
>  [<ffffffff803cf0a4>] dev_hard_start_xmit+0x214/0x28f
>  [<ffffffff803cf584>] dev_queue_xmit+0x357/0x48f
>  [<ffffffffa029fa0e>] ieee80211_tx_skb+0x60/0x62 [mac80211]
>  [<ffffffffa0293c61>] ieee80211_send_probe_req+0x1d2/0x1e1 [mac80211]
>  [<ffffffffa0290c1b>] ieee80211_scan_work+0x155/0x17a [mac80211]
>  [<ffffffff8024ac68>] run_workqueue+0x103/0x20a
>  [<ffffffff8024ae4f>] worker_thread+0xe0/0xf1
>  [<ffffffff8024e664>] kthread+0x49/0x76
>  [<ffffffff8020d0c9>] child_rip+0xa/0x11

That's rather strange, I see no way for this path to attempt sending an
SKB that has since been freed. Unless... yes, here's a problem:
rtl8187_tx is not supposed to return error codes, it's supposed to
return NETDEV_TX_{OK,BUSY}.

This should fix it:

--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c	2009-01-05 22:22:04.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c	2009-01-05 22:22:59.000000000 +0100
@@ -213,7 +213,7 @@ static int rtl8187_tx(struct ieee80211_h
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
 		kfree_skb(skb);
-		return -ENOMEM;
+		return NETDEV_TX_OK;
 	}
 
 	flags = skb->len;
@@ -281,7 +281,7 @@ static int rtl8187_tx(struct ieee80211_h
 	}
 	usb_free_urb(urb);
 
-	return rc;
+	return NETDEV_TX_OK;
 }
 
 static void rtl8187_rx_cb(struct urb *urb)


johannes

