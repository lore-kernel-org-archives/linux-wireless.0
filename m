Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58968 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbbHSTlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 15:41:05 -0400
Message-ID: <1440013262.2089.13.camel@sipsolutions.net> (sfid-20150819_214221_373154_F464D062)
Subject: Re: set channel from radiotap headers during injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Allan Matthew <allanm84@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Aug 2015 21:41:02 +0200
In-Reply-To: <CAEnVuW0m5jPMcQnC4inVF+8xubZbuyM-faP6Lebz26jvb4s-XA@mail.gmail.com> (sfid-20150819_210044_577870_EE440EEF)
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
	 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com>
	 <1439983495.2089.7.camel@sipsolutions.net>
	 <CAEnVuW18e15hOjoMYRstjgu2cr5BFAtVHThAyZGqpMAdFUQrpQ@mail.gmail.com>
	 <1440007745.2089.11.camel@sipsolutions.net>
	 <CAEnVuW0m5jPMcQnC4inVF+8xubZbuyM-faP6Lebz26jvb4s-XA@mail.gmail.com>
	 (sfid-20150819_210044_577870_EE440EEF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-19 at 12:00 -0700, Allan Matthew wrote:
> 
> I operate an AP on one channel that talks to some set of devices.
> 
> On another "channel" (maybe just different BW) I use packet injection
> to send data to and from a separate device.
> 
> The bitrate to the 2nd device (on the 2nd channel) is much lower than
> that of the AP, and I'd like to get longer range out of it.  The idea
> is that I use narrower bandwidth and fixed, low bitrates with control
> over the retries to get really tight control over that link.
> 

It might be somewhat feasible to set up the second one as a regular
client/AP link as well, with a different channel context...

However, the clients on the original AP might not be amused - their AP
would mysteriously disappear every once a while, something they're not
expecting (unless you restrict it to P2P GO/client operation)

johannes
