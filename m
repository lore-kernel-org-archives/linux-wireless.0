Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50983 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbZAPTap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 14:30:45 -0500
Date: Fri, 16 Jan 2009 14:20:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: garbaged AP mac address in dmesg in wireless-testing?
Message-ID: <20090116192046.GD10037@tuxdriver.com> (sfid-20090116_203052_961189_17EB10C1)
References: <3ace41890901160907w2d04da91r61744477ac64e018@mail.gmail.com> <20090116183826.GC10037@tuxdriver.com> <87ocy7xejp.fsf@litku.valot.fi> <4970DC58.3000507@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4970DC58.3000507@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 08:13:28PM +0100, Hauke Mehrtens wrote:
> Kalle Valo wrote:
> > "John W. Linville" <linville@tuxdriver.com> writes:
> > 
> >> On Fri, Jan 16, 2009 at 05:07:50PM +0000, Hin-Tak Leung wrote:
> >>> Since a few days ago, my dmesg is looking like this - instead of the
> >>> older AA:BB:CC:DD:EE:FF form
> >>> with the mac address of the AP.
> >>> That ffff88* looks like a pointer/address to me? Is this change intentional?
> >>>
> >>> --------------
> >>> wlan2 direct probe responded
> >>> wlan2: authenticate with AP ffff880070995aa0
> >>> wlan2: authenticated
> >>> wlan2: associate with AP ffff880070995aa0
> >>> wlan2: RX ReassocResp from ffff88001431f01a (capab=0x431 status=0 aid=1)
> >>> wlan2: associated
> > 
> > Works for me:
> > 
> > [37125.111672] wlan0: authenticate with AP 00:12:17:e7:98:de
> > [37125.113509] wlan0: authenticated
> > [37125.113514] wlan0: associate with AP 00:12:17:e7:98:de
> > [37125.115875] wlan0: RX AssocResp from 00:12:17:e7:98:de (capab=0x11 status=0 aid=1)
> > [37125.115881] wlan0: associated
> > 
> > This is on x86 32bit with iwl3945 and latest wireless-testing.
> > 
> >> Odd...some problem with the "%pM" printk conversion?  What kernel
> >> are you running?
> > 
> > And on what architecture?
> > 
> 
> I have got the same problem on x86_64 with rtl8187, kernel 2.6.27 and
> compat-wireless-2008-01-16.
> 
> [ 3064.480766] wlan0: authenticate with AP ffff8801291dfa20
> [ 3064.482271] wlan0: authenticated
> [ 3064.482275] wlan0: associate with AP ffff8801291dfa20
> [ 3064.485021] wlan0: RX AssocResp from ffff88011128c01a (capab=0x411
> status=0 aid=1)
> [ 3064.485025] wlan0: associated

compat-wireless users are probably using kernels that have printk
implementations that do not understand "%pM".  QED. :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
