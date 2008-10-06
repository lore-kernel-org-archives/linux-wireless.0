Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:63650 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbYJFClW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 22:41:22 -0400
Message-ID: <48E97ACE.8060207@lwfinger.net> (sfid-20081006_044135_060940_EAF19AFB)
Date: Sun, 05 Oct 2008 19:41:18 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [RFC][PATCH 4/5] p54: fix memory management
References: <200810050239.29822.chunkeey@web.de>
In-Reply-To: <200810050239.29822.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> We have to be careful if multiple "control frames" are passed in a very short intervals to
> the device's firmware. As p54_assign_address always put them into same memory location.
> To guarantee that this won't happen anymore, we have to treat control frames like normal
> data frames in the devices own memory management.
> 
> Larry? If this update doesn't fix the crash in p54_set_vdcf. Can you please remove the
> #if 0/#endif around p54_dump_txqueue and put one p54_dump_txqueue(dev)
> right before the p54_assign_address in p54_set_vdcf and another one after p54_assign_.... 

Christian,

Thus far, the new set of patches have not oopsed.

I was able to discover that the previous version crashed because
"target_skb" was NULL in the call to __skb_queue_after(). I avoided
the crash by the equivalent of the patch below. It may not be needed,
but adding it to the current patch set won't hurt, and will provide
extra safety just in case my testing has not found all the conditions
that trigger this condition.

Larry


Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -829,7 +829,7 @@ static void p54_assign_address(struct ie
        } else
                largest_hole = max(largest_hole, priv->rx_end -
last_addr);

-       if (skb) {
+       if (skb && target_skb) {
                struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
                struct memrecord *range = (void *)info->driver_data;
                range->start_addr = target_addr;




