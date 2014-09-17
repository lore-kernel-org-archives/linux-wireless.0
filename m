Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:49010 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbaIQV5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 17:57:31 -0400
Date: Thu, 18 Sep 2014 07:57:19 +1000
From: James Cameron <quozl@laptop.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Belisko Marek <marek.belisko@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to
 5GHz
Message-ID: <20140917215719.GB17696@us.netrek.org> (sfid-20140917_235735_395451_195F39A0)
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
 <5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
 <CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
 <5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 17, 2014 at 03:52:52AM -0700, Amitkumar Karwar wrote:
> Hi BR,
> 
> > Dear Amitkumar Karwar,
> > 
> > some additional info.
> > 
> > On Thu, Sep 11, 2014 at 5:09 PM, Amitkumar Karwar <akarwar@marvell.com>
> > wrote:
> > > Hi BR,
> > >
> > >>
> > >> I'm using 3.9 mainline mwifiex driver for wireless usb card. Doing
> > >> some throughput testing (with iperf) in 5GHz I got following
> > failures:
> > >> [ 221.521799] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb
> > >> failed
> > >
> > > This is skb allocation failure returned by kernel. 4k buffer is
> > always allocated for Rx packets. This issue doesn't seem to be specific
> > to 5Ghz.
> > Yes you're right. I can reproduce issue also with 2.4GHz (doing iperf
> > testing as mentioned in other email) by pinging device with card.
> > >
> > >>
> > >> I checked which which size fails to allocate and it's 4096 bytes. I
> > >> was looking to changes in never kernel releases but I cannot find
> > >> anything obvious. When connected to 2.4GHz I cannot reproduce issue
> > >> though. I'm using FW version mwifiex 1.0 (14.68.29.p26).
> > >>
> > >
> > > Could you please provide the platform details?
> > > How often the problem occurs during throughput testing? Are there any
> > specific steps?
> > One more observation is that when problem occurred complete system is
> > unresponsive (console is almost completely dead).
> 
> Thanks for the more information.
> Skb alloc failure should be gracefully handled. We will look into
> this issue.

If you get time, I'd also appreciate a look into the issue on sdio.c
during data receive.

When dev_alloc_skb fails the interrupt handler does not rewind
the driver state in preparation for a retry.  This is not graceful.

http://dev.laptop.org/ticket/12694 has details, and an adequate
solution we are using in 3.5 to rewind the driver state:

http://dev.laptop.org/git/olpc-kernel/commit/?h=arm-3.5&id=59fcaf10cce5bbdc370ec1c262b12aeb66ed1dca

We're using 8787.

> 
> > I can workaround issue by decreasing iperf bandwidth to ~40m. I think
> > in this situation we're running out of memory by exhaustive skb
> > allocations.
> 
> Actually 6 4K size buffers are being allocated for Rx and Tx data during traffic.
> Probably your platform runs out of memory after these allocations.
> 
> Could you please try changing this number(MWIFIEX_TX_DATA_URB/MWIFIEX_RX_DATA_URB macros) to 3?
> 
> Regards,
> Amitkumar Karwar
> N?????r??y????b?X??ǧv?^?)޺{.n?+????{??*ޕ?,?{ay?ʇڙ?,j??f???h???z??w??????j:+v???w?j?m????????zZ+?????ݢj"??!

-- 
James Cameron
http://quozl.linux.org.au/
