Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:30575 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759372AbYEUBYy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 21:24:54 -0400
Subject: Re: newbie rtl8187 question
From: Pavel Roskin <proski@gnu.org>
To: Paul Thomas <pthomas8589@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c785bba30805172315q42066fct39e20b35629faa51@mail.gmail.com>
References: <c785bba30805132014y56aafa7bi8788503f67a7c809@mail.gmail.com>
	 <1210736718.2721.4.camel@rd>
	 <c785bba30805132050y51cc3031uae718bc74ade96@mail.gmail.com>
	 <1210737929.2721.19.camel@rd>
	 <c785bba30805132141l62bef2d7n4d78a95510ed6a3d@mail.gmail.com>
	 <1210740748.2721.62.camel@rd>
	 <c785bba30805172315q42066fct39e20b35629faa51@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 May 2008 21:24:52 -0400
Message-Id: <1211333092.11738.18.camel@dv> (sfid-20080521_032500_183351_1BC73CAC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-17 at 23:15 -0700, Paul Thomas wrote:

> I was finally able to test the driver with an ARM9 (AT91RM9200)
> processor, but I wasn't able to make it work. Here is the error I get:
> 
> kernel BUG at net/core/skbuff.c:149!

There should be a message starting with "skb_under_panic:" immediately
before this.  It prints information about the skb.

> Backtrace:
> [<c0025588>] (__bug+0x0/0x2c) from [<c020ee54>] (skb_under_panic+0x5c/0x68)
> [<c020edf8>] (skb_under_panic+0x0/0x68) from [<c020fce4>] (skb_push+0x3c/0x44)
>  r7:c1d4be40 r6:023a0000 r5:c1d4be40 r4:00000020
> [<c020fca8>] (skb_push+0x0/0x44) from [<c01ae2b8>] (rtl8187_tx+0x200/0x324)
>  r5:00000001 r4:00000001

So, we got there from skb_push().

> [<c01ae0b8>] (rtl8187_tx+0x0/0x324) from [<c02a9d74>]
> (__ieee80211_tx+0x60/0x168)

rtl8187_tx() doesn't call skb_push() directly, but I think that
rtl8187b_tx_buf() got inlined.

Perhaps there is too little headroom space in the skb.  I would check if
dev->extra_tx_headroom is correct in rtl8187_probe().

Try checking the available headroom in rtl8187b_tx_buf() by
skb_headroom().  If it's not enough, use skb_realloc_headroom() and
print how much is missing.

I know there were conflicts between the patch and the latest changes on
linux-wireless.  Maybe you didn't resolve them correctly.

Here's the patch for debugging the panic.

And by the way, please provide the kernel log part from the device
initialization time all the way to the panic.

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index 88e4d4b..8005651 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -185,6 +185,13 @@ static void *rtl8187b_tx_buf(struct sk_buff *skb, __le32 flags,
 			     __le16 tx_dur)
 {
 	struct rtl8187b_tx_hdr *hdr;
+	int need_headroom;
+
+	need_headroom = sizeof(*hdr) - skb_headroom(skb);
+	printk("rtl8187: need headroom: %zd, have %d\n", sizeof(*hdr),
+	       skb_headroom(skb));
+	if (need_headroom)
+		skb = skb_realloc_headroom(skb, need_headroom);
 
 	hdr = (struct rtl8187b_tx_hdr *)skb_push(skb, sizeof(*hdr));
 	memset(hdr, 0, sizeof(*hdr));
@@ -1057,6 +1064,8 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	dev->extra_tx_headroom = (!priv->is_rtl8187b) ?
 				  sizeof(struct rtl8187_tx_hdr) :
 				  sizeof(struct rtl8187b_tx_hdr);
+	printk("rtl8187: need headroom: %d, priv->is_rtl8187b = %d\n",
+	       dev->extra_tx_headroom, priv->is_rtl8187b);
 	if (!priv->is_rtl8187b)
 		dev->queues = 1;
 	else


-- 
Regards,
Pavel Roskin
