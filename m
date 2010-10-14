Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19014 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab0JNWyk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 18:54:40 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 15:54:31 -0700
Date: Thu, 14 Oct 2010 15:54:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ben Greear <greearb@candelatech.com>, <g@tux>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
Message-ID: <20101014225438.GC15740@tux>
References: <4CB4AA89.1070009@candelatech.com>
 <20101013053141.GA15798@vasanth-laptop>
 <4CB5E0A8.5020502@candelatech.com>
 <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com>
 <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com>
 <4CB77EA0.1000005@candelatech.com>
 <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com>
 <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com>
 <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com>
 <4CB787E1.9000201@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CB787E1.9000201@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 03:44:49PM -0700, Ben Greear wrote:
> On 10/14/2010 03:35 PM, Luis R. Rodriguez wrote:
> > On Thu, Oct 14, 2010 at 3:29 PM, Luis R. Rodriguez<mcgrof@gmail.com>  wrote:
> >> Fun enough if I just create one monitor interface and loop quickly
> >> over some 2 GHz channels where I know I have traffic nearby I don't
> >> see the poison. So channel changes don't seem to do much because this
> >> is changing channels as fast as possible from userspace. I also can
> >> confirm that I see frames from the different channels as I move along.
> >
> > Even forcing a band change doesn't help trigger it with just one mon0
> > and one regular device scanning in a loop;
> >
> > while true; do for i in 2412 5745 2417 5745 2422 5745 2427 5745 2432
> > 5745 2442; do echo $i iw dev mon0 set freq $i; done; done
> > while true; do iw dev wlan0 scan; done
> 
> What if you just make a bunch of skb copies in ath9k before it
> sends them up the stack, and then delete them?  (That's basically
> what a bunch of monitor devices would be doing, eh?)
 
Sure, as you can see from my patch I at least do it all the time
now on RX and TX. The TX poison never shows though so currently I'm
more suspicious about RX. The other idea I had was to just run
check_bytes_and_report() often around the code, but haven't tried that
yet.

I'm also poking harware folks about some of the registers we use
to better understand how DMA works here.

  Luis
