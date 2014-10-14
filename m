Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:34519 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaJNUox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 16:44:53 -0400
Date: Wed, 15 Oct 2014 07:44:35 +1100
From: James Cameron <quozl@laptop.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to
 5GHz
Message-ID: <20141014204435.GA29124@us.netrek.org> (sfid-20141014_224457_313635_68A13D90)
References: <5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
 <CAAfyv35E2HUReFpnpdsebPETKk9VPA_hfQHUEJmoJfQt6Q-Puw@mail.gmail.com>
 <5FF020A1CFFEEC49BD1E09530C4FF5951821936285@SC-VEXCH1.marvell.com>
 <CAAfyv34UXMNwHf+kYCWEn+bcfGda_gA7uroLRLvhTEGGC5R57w@mail.gmail.com>
 <5FF020A1CFFEEC49BD1E09530C4FF5951821936BBC@SC-VEXCH1.marvell.com>
 <CAAfyv36s+stSKU7Oi372EjsvUi+S6PSbg1wVTD1dJrMrerBPXg@mail.gmail.com>
 <5FF020A1CFFEEC49BD1E09530C4FF5951821936F03@SC-VEXCH1.marvell.com>
 <CAAfyv34ivLF-B0ip+uhCah0PsiRsP1QOD0qW8F73n7KERqgM2w@mail.gmail.com>
 <20141014102051.GB16934@us.netrek.org>
 <CAAfyv34btPrqW5Z=wzdFi7e+tOYF6XPdxY6sKcMy0CBzBsVFqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAfyv34btPrqW5Z=wzdFi7e+tOYF6XPdxY6sKcMy0CBzBsVFqA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 14, 2014 at 12:48:07PM +0200, Belisko Marek wrote:
> Dear James Cameron,
> 
> On Tue, Oct 14, 2014 at 12:20 PM, James Cameron <quozl@laptop.org> wrote:
> > On Tue, Oct 14, 2014 at 10:25:01AM +0200, Belisko Marek wrote:
> >> Hi Amitkumar,
> >>
> >> On Tue, Oct 14, 2014 at 9:08 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> >> > Hi Marek,
> >> >
> >> > > I tried both (slightly modified as we're in 3.9 kernel) but
> >> > > issue is still reproducible. My patch against 3.9 sources:
> >> >
> >> > Thanks a lot for the tests.
> >> >
> >> > > One thing which is not yet still clear to me why kernel console
> >> > > is completely unresponsive when receiving packets in high
> >> > > rates. When use iperf (on client) with -b40m it is OK but when
> >> > > increase to -b100m then console is completely unresponsive until
> >> > > iperf finish.
> >> >
> >> > Does the system recover when "-b100M" iperf is finished? Can we
> >> > run iperf with "-b40M" later?  Do you see "dev_alloc_skb failed"
> >> > messages in dmesg when console is unresponsive?
> >> When we get "dev_alloc_skb failed" then interface is dead (cannot
> >> ping ...) so no recovery is possible only system reboot.
> >
> > This symptom was familiar to me, but on sdio.c, which is very
> > different code.
> >
> > I've had a brief look at usb.c and offer the following comments:
> >
> > - a list of six data endpoint urb is allocated in mwifiex_usb_rx_init,
> >   because MWIFIEX_RX_DATA_URB is 6,
> >
> > - when data endpoint urb is submitted, a new skb is allocated, in
> >   mwifiex_usb_submit_rx_urb, and this is the only source of
> >   "dev_alloc_skb failed" message,
> >
> > - in normal situation, when data endpoint urb is complete, skb is
> >   either freed or handed up to mwifiex_usb_recv, and the urb is
> >   resubmitted, which causes a new skb to be allocated.
> >
> > - if "dev_alloc_skb failed" message appears, one data endpoint urb has
> >   been lost and is not re-used,
> >
> > - if six "dev_alloc_skb failed" messages appear, the interface should
> >   be dead for data receive only.
> >
> > Amitkumar mentioned this on 9th October; "corresponding URB won't get
> > submitted".  I think this should be fixed; dev_alloc_skb should be
> > harmless failure, please retry.
> >
> > I don't see why interface is dead with only one "dev_alloc_skb
> > failed" message.
> Maybe my description wasn't  not correct. I see 6 "dev_alloc_skb
> failed" messages and then interface is dead
> as you wrote.

Thanks.  That is what I expected.

> >> I don't see  dev_alloc_skb failed when console is unresponsive.
> >> >
> >> > > Any other ideas
> >> > > what to change to check? Thanks.
> >> >
> >> > Could you please share dmesg log with dynamic debug enabled (using
> >> > attached script) captured when the problem occurs?
> >> I tried to capture logs but when enable DYNAMIC_DEBUG I cannot
> >> reproduce issue (running test > 30 minutes without allocation
> >> failure).
> >
> > Yes, I've seen similar; turn on debugging, and timing critical bug
> > goes away.
> >
> > Serial console?  If so, try turning it off, and logging to dmesg
> > buffer only.
> When turning off serial console how then I get kernel messages from
> dmesg buffer?

I use three techniques depending on how usable the system is afterwards:

0.  capture kernel messages to disk, using rsyslog or other user space
assistance; often there is enough information saved before the system
is unresponsive,

1.  type dmesg at a console shell prompt,

2.  watchdog trigger system reset, and in firmware locate the dmesg
buffer structures in memory, and dump them to serial.

http://lists.laptop.org/pipermail/devel/2012-January/034253.html

-- 
James Cameron
http://quozl.linux.org.au/
