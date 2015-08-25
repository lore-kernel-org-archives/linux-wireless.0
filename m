Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38080 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbbHYJgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 05:36:52 -0400
Message-ID: <1440495409.2192.16.camel@sipsolutions.net> (sfid-20150825_113659_245569_6956B4F3)
Subject: Re: set channel from radiotap headers during injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Allan Matthew <allanm84@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Aug 2015 11:36:49 +0200
In-Reply-To: <CAEnVuW28F2g_x65UzvH-RGpLON+YR2KoJ7dM=3j7gP11VJ8WEg@mail.gmail.com> (sfid-20150825_024629_360431_CBDD71CD)
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
	 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com>
	 <1439983495.2089.7.camel@sipsolutions.net>
	 <CAEnVuW18e15hOjoMYRstjgu2cr5BFAtVHThAyZGqpMAdFUQrpQ@mail.gmail.com>
	 <1440007745.2089.11.camel@sipsolutions.net>
	 <CAEnVuW0m5jPMcQnC4inVF+8xubZbuyM-faP6Lebz26jvb4s-XA@mail.gmail.com>
	 <1440013262.2089.13.camel@sipsolutions.net>
	 <CAEnVuW21Ocie0RUGv-UZU1U=n=mTinJ_nJa2uHQqVZz-11AbWA@mail.gmail.com>
	 <1440014031.2089.14.camel@sipsolutions.net>
	 <CAEnVuW3LHHDUpJzaKoDAcYkBoT8B5ddQM2Va33xtxA-ORgLH3w@mail.gmail.com>
	 <CAEnVuW28F2g_x65UzvH-RGpLON+YR2KoJ7dM=3j7gP11VJ8WEg@mail.gmail.com>
	 (sfid-20150825_024629_360431_CBDD71CD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-08-24 at 17:46 -0700, Allan Matthew wrote:
> 
> Johannes- What about txpower?  Should this be configurable through 
> the radiotap headers?

It's ... complicated. First of all, it's currently not supported I
believe, in general, since there's no parsing code. Obviously, parsing
code can be changed, and I think there might even be patches floating
around for that.

However, not all hardware supports per-frame TX power control. Some
might, most will not. Until fairly recently, there was also no API with
drivers to allow setting TX power per frame. This changed with the
addition of TX power control to rate control, of course.

So I think similar to rate control the situation is that it could be
done, but there are many corner cases where it won't work reliably. I'd
apply clean patches that add the functionality while documenting the
issues.

johannes
