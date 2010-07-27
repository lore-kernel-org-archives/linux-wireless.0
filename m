Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39858 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab0G0QpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 12:45:11 -0400
Date: Tue, 27 Jul 2010 12:31:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Confused - bisecting wireless-testing
Message-ID: <20100727163141.GC31694@tuxdriver.com>
References: <AANLkTim-0qoS7o+fcQ6uA18AC_gQSiiDe4Tv_L1FT1Ae@mail.gmail.com>
 <20100727140139.GA31694@tuxdriver.com>
 <AANLkTimS2d0jZnu-44+cbFQXvitj_3Rq3egttgOzEiRh@mail.gmail.com>
 <20100727160434.GB31694@tuxdriver.com>
 <AANLkTi=x7FzdRoC6DxeahvSm+2teN__TsoKjxphOMiPP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=x7FzdRoC6DxeahvSm+2teN__TsoKjxphOMiPP@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 09:21:40AM -0700, Luis R. Rodriguez wrote:
> On Tue, Jul 27, 2010 at 9:04 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Tue, Jul 27, 2010 at 08:56:54AM -0700, Luis R. Rodriguez wrote:
> >> On Tue, Jul 27, 2010 at 7:01 AM, John W. Linville
> >> <linville@tuxdriver.com> wrote:

> >> > As for right now, it sounds like you should just use wireless-next-2.6
> >> > instead?
> >>
> >> Oh OK, didn't realize that was bisectable, thanks. Also was unsure if
> >> I'd get other subsystems's -next components. Is wireless-next.git just
> >> the -next bits for 802.11 or does it also suck up net-next?
> >
> > Usually just the wireless bits, but I did just pull the bluetooth stuff
> > (which included some net-next stuff).
> 
> Oh neat. OK so which net-next.git release was wireless-next.git based
> on and what net-next.git release was bluetooth-next.git based on? Did
> it bump your next-next.git or do you routinely pull next-next.git into
> your own wireless-next.git?

I don't have those exact commit IDs.  How badly do you need them?

I don't normally pull net-next into wireless-next, but this release
not doing that has been a source of pain due to the __packed patch
in net-next and the addition of __attribute__ ((packed)) in various
places in wireless-next.  Since Marcel had already based on a net-next
that had that patch and since it is close to the end of the release
I decided it would be acceptable to pull it this time.

I have been considering making regular net-next pulls a standard
practice.  That would make my life easier, but would add some
non-wireless instability into wireless-testing (which pulls from
wireless-next).  I don't think that would be a big problem _most_
of the time, but I'm sure there would be some occasional pain from
doing that.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
