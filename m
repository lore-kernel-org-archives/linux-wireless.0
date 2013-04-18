Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:38685 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413Ab3DRTXg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 15:23:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>
Date: Thu, 18 Apr 2013 12:20:03 -0700
Subject: RE: mwifiex frequent "not allowed while suspended" crash on resume
Message-ID: <477F20668A386D41ADCC57781B1F70430D9E057145@SC-VEXCH1.marvell.com> (sfid-20130418_212340_562075_AF375AD1)
References: <CAMLZHHRpPghm0tWTksFiD-zxUUM1dSbgPbj6doMck1jqv-yokw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD431B@SC-VEXCH1.marvell.com>
	<CAMLZHHRcTgQ66fucR09SEyjCCRiZixigM=cDwnfKB5yWYk4PQw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DDAB9CC@SC-VEXCH1.marvell.com>
 <CAMLZHHTe+9D_XwYHFMbu8bRAD7OHNgf8_0+44ZhM+AwSnwLZBw@mail.gmail.com>
In-Reply-To: <CAMLZHHTe+9D_XwYHFMbu8bRAD7OHNgf8_0+44ZhM+AwSnwLZBw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> > Normally TX is blocked until resume handler is called and host sleep handshake between driver and
> firmware is done.
> 
> Where is the code that makes such synchronization happen?

If a data packet is received unexpectedly during suspended, driver blocks it and displays a message "not allowed while suspended".

Earlier you mentioned that doing netif attach/detach in suspend/resume would work around this problem.
It reminders me that previously we set carrier off in suspend so that kernel won't send data packets to driver. That carrier-off code was removed in recent commit 1499d9f to fix a missing ping response issue right after resume. Perhaps it's worth a revisit to this change.

> 
> > Does the TX happen before "hs_deactivated" event?
> 
> hard_start_xmit is called approximately 1ms after hs_deactivated arrives.

When hs_deactivated event arrives, 'is_suspended' flag must have been cleared already. The tx packets should be allowed to send freely. I don't know why the message "not allowed while suspended" is fired in this case.
There could be a race condition somewhere though. Could you please send a complete dynamic_debug enabled log showing all the sequence?

> 
> > I'm thinking of releasing IRQ in driver suspend handler and re-claim the IRQ in resume. Of course
> it needs some changes in sdio_release_irq to skip SDIO_CCCR_IENx disabling, otherwise host may not be
> woken up by SDIO DAT1.
> >
> > Attached is the sample code, not tested.
> 
> That patch breaks wake-on-LAN, the suspended system simply doesn't
> respond to incoming packets.

Could you confirm that you saw this message on suspend?

"SDIO: KEEP IRQ ON for ..."

Thanks,
Bing

> 
> Daniel
