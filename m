Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:19182 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbZAPWGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 17:06:49 -0500
Received: by fg-out-1718.google.com with SMTP id 19so915571fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 14:06:46 -0800 (PST)
Message-ID: <3ace41890901161406r591eb519o44b41efa3d36295c@mail.gmail.com> (sfid-20090116_230653_270339_2DEB2D5C)
Date: Fri, 16 Jan 2009 22:06:46 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: garbaged AP mac address in dmesg in wireless-testing?
Cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	"Kalle Valo" <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090116192046.GD10037@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <3ace41890901160907w2d04da91r61744477ac64e018@mail.gmail.com>
	 <20090116183826.GC10037@tuxdriver.com> <87ocy7xejp.fsf@litku.valot.fi>
	 <4970DC58.3000507@hauke-m.de> <20090116192046.GD10037@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 7:20 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Jan 16, 2009 at 08:13:28PM +0100, Hauke Mehrtens wrote:
>> Kalle Valo wrote:
>> > "John W. Linville" <linville@tuxdriver.com> writes:
>> >
>> >> On Fri, Jan 16, 2009 at 05:07:50PM +0000, Hin-Tak Leung wrote:
>> >>> Since a few days ago, my dmesg is looking like this - instead of the
>> >>> older AA:BB:CC:DD:EE:FF form
>> >>> with the mac address of the AP.
>> >>> That ffff88* looks like a pointer/address to me? Is this change intentional?
>> >>>
>> >>> --------------
>> >>> wlan2 direct probe responded
>> >>> wlan2: authenticate with AP ffff880070995aa0
>> >>> wlan2: authenticated
>> >>> wlan2: associate with AP ffff880070995aa0
>> >>> wlan2: RX ReassocResp from ffff88001431f01a (capab=0x431 status=0 aid=1)
>> >>> wlan2: associated
>> >
>> > Works for me:
>> >
>> > [37125.111672] wlan0: authenticate with AP 00:12:17:e7:98:de
>> > [37125.113509] wlan0: authenticated
>> > [37125.113514] wlan0: associate with AP 00:12:17:e7:98:de
>> > [37125.115875] wlan0: RX AssocResp from 00:12:17:e7:98:de (capab=0x11 status=0 aid=1)
>> > [37125.115881] wlan0: associated
>> >
>> > This is on x86 32bit with iwl3945 and latest wireless-testing.
>> >
>> >> Odd...some problem with the "%pM" printk conversion?  What kernel
>> >> are you running?
>> >
>> > And on what architecture?
>> >
>>
>> I have got the same problem on x86_64 with rtl8187, kernel 2.6.27 and
>> compat-wireless-2008-01-16.
>>
>> [ 3064.480766] wlan0: authenticate with AP ffff8801291dfa20
>> [ 3064.482271] wlan0: authenticated
>> [ 3064.482275] wlan0: associate with AP ffff8801291dfa20
>> [ 3064.485021] wlan0: RX AssocResp from ffff88011128c01a (capab=0x411
>> status=0 aid=1)
>> [ 3064.485025] wlan0: associated
>
> compat-wireless users are probably using kernels that have printk
> implementations that do not understand "%pM".  QED. :-)
>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>

2.6.28.1-9.rc2.fc10.x86_64 and yes, I am using compat-wireless ...
what puzzles me is
that the as-shipped modules have the mac addresses correctly.

Okay, sorry for the noise. I did look at git blame and, when I saw the
date of the lines with the
%pM commits was two months ago, I didn't bother to look further, since
the problem is very recent...
I was looking in the right direction but just didn't look far enough.

commit 0c68ae2605dbcf67414d8d1f19af93be44b355fb
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Mon Oct 27 15:56:10 2008 -0700

    mac80211: convert to %pM away from print_mac

    Also remove a few stray DECLARE_MAC_BUF that were no longer
    used at all.

    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

--------------------------------
commit dd45c9cf687682c9ce256ab14bd8914db77410bb
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Mon Oct 27 15:47:12 2008 -0700

    printk: add %pM format specifier for MAC addresses
--------------

and it is in lib/vsprintf.c ...

But I guess ideally compat-wireless should patch this in to somewhere
under net/mac80211? (that's the whole point
of compat-wireless, to run with older kernels?)
