Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56667 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0G0Qys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 12:54:48 -0400
Received: by pvc7 with SMTP id 7so538906pvc.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 09:54:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100727163141.GC31694@tuxdriver.com>
References: <AANLkTim-0qoS7o+fcQ6uA18AC_gQSiiDe4Tv_L1FT1Ae@mail.gmail.com>
	<20100727140139.GA31694@tuxdriver.com> <AANLkTimS2d0jZnu-44+cbFQXvitj_3Rq3egttgOzEiRh@mail.gmail.com>
	<20100727160434.GB31694@tuxdriver.com> <AANLkTi=x7FzdRoC6DxeahvSm+2teN__TsoKjxphOMiPP@mail.gmail.com>
	<20100727163141.GC31694@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Jul 2010 09:54:20 -0700
Message-ID: <AANLkTi=Yan5f7hcGm-GTDL=aJ_Oc-U8JExZXMZdr+MPZ@mail.gmail.com>
Subject: Re: Confused - bisecting wireless-testing
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 9:31 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Jul 27, 2010 at 09:21:40AM -0700, Luis R. Rodriguez wrote:
>> On Tue, Jul 27, 2010 at 9:04 AM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > On Tue, Jul 27, 2010 at 08:56:54AM -0700, Luis R. Rodriguez wrote:
>> >> On Tue, Jul 27, 2010 at 7:01 AM, John W. Linville
>> >> <linville@tuxdriver.com> wrote:
>
>> >> > As for right now, it sounds like you should just use wireless-next-2.6
>> >> > instead?
>> >>
>> >> Oh OK, didn't realize that was bisectable, thanks. Also was unsure if
>> >> I'd get other subsystems's -next components. Is wireless-next.git just
>> >> the -next bits for 802.11 or does it also suck up net-next?
>> >
>> > Usually just the wireless bits, but I did just pull the bluetooth stuff
>> > (which included some net-next stuff).
>>
>> Oh neat. OK so which net-next.git release was wireless-next.git based
>> on and what net-next.git release was bluetooth-next.git based on? Did
>> it bump your next-next.git or do you routinely pull next-next.git into
>> your own wireless-next.git?
>
> I don't have those exact commit IDs.  How badly do you need them?

I don't at all, was just interested to know if they were indeed
different and how each differ in terms of pulling new net-next.git
bits from future next-(date -I) releases.

> I don't normally pull net-next into wireless-next, but this release
> not doing that has been a source of pain due to the __packed patch
> in net-next and the addition of __attribute__ ((packed)) in various
> places in wireless-next.  Since Marcel had already based on a net-next
> that had that patch and since it is close to the end of the release
> I decided it would be acceptable to pull it this time.

Ah I see.

> I have been considering making regular net-next pulls a standard
> practice.  That would make my life easier, but would add some
> non-wireless instability into wireless-testing (which pulls from
> wireless-next).  I don't think that would be a big problem _most_
> of the time, but I'm sure there would be some occasional pain from
> doing that.

Thanks for the details. Yeah indeed my concern over bisecting
wireless-next.git would have been testing other bleeding edge
non-802.11 / BT subsystem stuff, things in net core, but relying on
the master-(date -I) tags sufficed for me to bisect an issue down to
early June. Think I'll stick to that for now but I suppose we should
not fear using next-next.git as much given that we now have both
802.11 and BT

So I guess the next question is where does David base his net-next.git
off from? Will it only include 802.11 / Ethernet / Wimax / netcore /
etc next bits or is there more? I ask to know what I'm in for in case
I want to bisect from it or derivatives (wireless-next.git).

  Luis
