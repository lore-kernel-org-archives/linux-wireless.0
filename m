Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([204.127.217.105]:34402 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbZG2Pld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 11:41:33 -0400
Message-ID: <4A706DCA.3060805@lwfinger.net>
Date: Wed, 29 Jul 2009 10:42:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Work around mac80211 race condition that may 	transmit
 one packet after queue is stopped
References: <4a6fa3fe.kYeW+HADItDIXTLm%Larry.Finger@lwfinger.net> <69e28c910907290543t7532bd07g2ffdc2a04973a6f8@mail.gmail.com>
In-Reply-To: <69e28c910907290543t7532bd07g2ffdc2a04973a6f8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> On Wed, Jul 29, 2009 at 3:21 AM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
>> As shown in http://thread.gmane.org/gmane.linux.kernel.wireless.general/36497,
>> mac80211 has a bug that allows a call to the TX routine after the queues have
>> been stopped. This situation will only occur under extreme stress. Although
>> b43 does not crash when this condition occurs, it does generate a WARN_ON and
>> also logs a queue overrun message. This patch recognizes b43 is not at fault
>> and logs a message only when the most verbose debugging mode is enabled. In
>> the unlikely event that the queue is not stopped when the DMA queue becomes
>> full, then a warning is issued.
>>
>> During testing of this patch with one output stream running repeated tcpperf
>> writes and a second running a flood ping, this routine was entered with
>> the DMA ring stopped about once per hour. The condition where the DMA queue is
>> full but the ring has not been stopped has never been seen by me.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> John,
>>
>> This patch is 2.6.32 material.
>>
>> Larry
>> ---
>>
>> Index: wireless-testing/drivers/net/wireless/b43/dma.c
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/b43/dma.c
>> +++ wireless-testing/drivers/net/wireless/b43/dma.c
>> @@ -1334,13 +1334,23 @@ int b43_dma_tx(struct b43_wldev *dev, st
>>        spin_lock_irqsave(&ring->lock, flags);
>>
>>        B43_WARN_ON(!ring->tx);
>> -       /* Check if the queue was stopped in mac80211,
>> -        * but we got called nevertheless.
>> -        * That would be a mac80211 bug. */
>> -       B43_WARN_ON(ring->stopped);
>> +
>> +       if (unlikely(ring->stopped)) {
>> +               /* We get here only because of a bug in mac80211.
>> +                * Because of a race, one packet may be queued after
>> +                * the queue is stopped, thus we got called when we shouldn't.
>> +                * For now, just refuse the transmit. */
>> +               if (b43_debug(dev, B43_DBG_DMAVERBOSE))
>> +                       b43err(dev->wl, "Packet after queue stopped\n");
>> +               err = -ENOSPC;
>> +               goto out_unlock;
>> +       }
>>
>>        if (unlikely(free_slots(ring) < TX_SLOTS_PER_FRAME)) {
>> -               b43warn(dev->wl, "DMA queue overflow\n");
>> +               /* If we get here, we have a real error with the queue
>> +                * full, but queues not stopped. */
>> +               b43err(dev->wl, "DMA queue overflow\n");
>> +               WARN_ON(1);
> 
> Is this really the best way to do this? Any reason why not have the
> WARN_ON in the if-condition?

I did it this way because my preference is to see the text saying why
there was a warning before the traceback part of the warning; however,
as I do not expect to ever see this warning, I will resubmit. The
argument for putting the WARN_ON in the if statement is that the size
of the object code is decreased by 7 bytes and one line is removed
from the source. The important thing is that the x86_64 code for the
expected branch is exactly the same for the two cases.

One interesting thing is that gcc 4.3.2 for x86_64 does not seem to
pay any attention to the "unlikely" hint. The compiled code is the
same for "if(cond)" and "if(unlikely(cond))".

Larry
