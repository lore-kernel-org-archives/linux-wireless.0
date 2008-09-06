Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:62766 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYIFTgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 15:36:46 -0400
Message-ID: <48C2DBCB.1030706@lwfinger.net> (sfid-20080906_213654_895284_2E08BCF9)
Date: Sat, 06 Sep 2008 14:36:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	bcm43xx-dev@lists.berlios.de,
	John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix failure in rate-adjustment mechanism
References: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net> <200809062055.51797.mb@bu3sch.de> <1220727470.10102.9.camel@johannes.berg> <200809062104.15274.mb@bu3sch.de>
In-Reply-To: <200809062104.15274.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Saturday 06 September 2008 20:57:50 Johannes Berg wrote:
>> It is, this isn't really a difference between the two but a result of
>> you shifting it up/down due to the tx status via dma queue vs. tx status
>> via registers thing.
> 
> Yeah, that's the point. larry's patch modified both the register and dmaqueue
> mechanism. I think the register mechanism might be correct as-is (Or is it even
> dead code and it's not used by any legacy device?)
> 

I modified the patch to add printouts in both paths as shown below:

Index: linux-2.6/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/xmit.c
+++ linux-2.6/drivers/net/wireless/b43legacy/xmit.c
@@ -631,7 +631,8 @@ void b43legacy_handle_hwtxstatus(struct
         status.pm_indicated = !!(tmp & 0x80);
         status.intermediate = !!(tmp & 0x40);
         status.for_ampdu = !!(tmp & 0x20);
-       status.acked = !!(tmp & 0x02);
+       status.acked = tmp & 0x01;
+       printk(KERN_INFO "b43legacy: In b43legacy_handle_hwtxstatus, 
hw->flags = 0x%X\n", hw->flags);

         b43legacy_handle_txstatus(dev, &status);
  }
Index: linux-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ linux-2.6/drivers/net/wireless/b43legacy/main.c
@@ -744,7 +744,7 @@ static void handle_irq_transmit_status(s

         while (1) {
                 v0 = b43legacy_read32(dev, B43legacy_MMIO_XMITSTAT_0);
-               if (!(v0 & 0x00000001))
+               if (!v0)
                         break;
                 v1 = b43legacy_read32(dev, B43legacy_MMIO_XMITSTAT_1);

@@ -752,13 +752,14 @@ static void handle_irq_transmit_status(s
                 stat.seq = (v1 & 0x0000FFFF);
                 stat.phy_stat = ((v1 & 0x00FF0000) >> 16);
                 tmp = (v0 & 0x0000FFFF);
+               printk(KERN_INFO "b43legacy: In 
handle_irq_transmit_status, tmp 0x%X\n", tmp);
                 stat.frame_count = ((tmp & 0xF000) >> 12);
                 stat.rts_count = ((tmp & 0x0F00) >> 8);
                 stat.supp_reason = ((tmp & 0x001C) >> 2);
                 stat.pm_indicated = !!(tmp & 0x0080);
                 stat.intermediate = !!(tmp & 0x0040);
                 stat.for_ampdu = !!(tmp & 0x0020);
-               stat.acked = !!(tmp & 0x0002);
+               stat.acked = tmp & 0x0001;

                 b43legacy_handle_txstatus(dev, &stat);
         }


What I see are lots of

b43legacy: In b43legacy_handle_hwtxstatus, hw->flags = 0x1

and this is the only one that ever triggered. ATM, I'm not sure why 
handle_irq_transmit_status() is not called.

Larry


