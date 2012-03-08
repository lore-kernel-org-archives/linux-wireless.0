Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54545 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab2CHWa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 17:30:26 -0500
Date: Thu, 8 Mar 2012 16:30:22 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: "Quan, David" <dquan@qca.qualcomm.com>,
	"Green, Michael" <green@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Problems with regulatory domain support and BCM43224
Message-ID: <20120308223021.GF13667@ubuntu-macmini> (sfid-20120308_233029_669483_9517CC00)
References: <20120307194001.GA2506@ubuntu-macmini>
 <20120308174101.GB28133@ubuntu-macmini>
 <CAB=NE6VapPfLjAh5Y+sCA4qA82s9HrQk_Mxr8FpKoCfjudMDig@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BB72@nasanexd02d.na.qualcomm.com>
 <CAB=NE6U04a0XNrvt6HLCwqbHMtGL8CWh8No_=Bx0mwQZYEgGxQ@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BC94@nasanexd02d.na.qualcomm.com>
 <CAB=NE6X9c1m63xayNsEf9XZ3AgPZDV2SiRivg3SV2Day83fPQA@mail.gmail.com>
 <20120308215913.GC13667@ubuntu-macmini>
 <CAB=NE6VziFZRTuyZx6unuaOY9=AYrSJ8DD2SFtWxSz5FcdHRQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6VziFZRTuyZx6unuaOY9=AYrSJ8DD2SFtWxSz5FcdHRQg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 08, 2012 at 02:12:46PM -0800, Luis R. Rodriguez wrote:
> On Thu, Mar 8, 2012 at 1:59 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> > On Thu, Mar 08, 2012 at 11:51:03AM -0800, Luis R. Rodriguez wrote:
> >> On Thu, Mar 8, 2012 at 11:45 AM, Quan, David <dquan@qca.qualcomm.com> wrote:
> >> > I think there is to it more than SW.
> >> > Where ever you get this card, is the card tested and regulatory approved for those countries, DFS or not?
> >>
> >> Seth, what driver are you using? I know you are using a BCM43224 card.
> >>
> >> > It is possible that this card is only regulatory tested for non DFS channels, but now you enable them for passive.
> >>
> >> That's a good point.
> >>
> >> > This means that yes, you are save and not violate DFS rules because you are in passive mode. However, you are in complete violation if the STA finds an AP on that DFS channel and then connects and transmits as this STA is not allow to transmit on that channel since it is not approved.
> >
> > I was thinking about this some more. I still don't understand why it
> > makes sense to omit these frequencies from the world domain. Isn't the
> > point of geographic domains to communicate the rules for wherever the
> > user happens to be at the time?
> 
> Yes
> 
> > Does the core regulatory support really
> > ever know which frequencies the hardware has ben approved for, even
> > among those it already allows?
> 
> It depends, some drivers are hacks, some drivers are vendor supported.
> For those driver with vendor support yes, you do know what the
> hardware should have been approved for. For reversed engineers
> drivers, no.
> 
> Problem with using frequencies a card was not properly tested with is
> that those frequencies may not have calibrated data for it on the
> actual card, this may take the card out of compliance.
> 
> > It seems to me that it's the job of the driver to communicate
> > hardware-specific regulatory hints.
> 
> It is!
> 
> > So _if_ passive scanning of the DFS
> > frequencies is allowed worldwide (I emphasize the if because I don't
> > know whether or not that's true), why should the world domain not allow
> > this?
> 
> This is what I am in agreement with but you are missing that some
> cards do not have programmed certain frequencies on them certain
> calibration information. For DFS -- its a pain, and DFS is one of the
> areas where regulatory bodies tend to be more proactive on enforcing
> so the better thing to do is to avoid these at all costs -- unless the
> driver knows it can certainly use them.
> 
> Fortunately today we get proper vendor support for all 802.11 drivers
> now on Linux so moving forward this is not an issue and I rather have
> safer and cautious code in place than not, specially for DFS.

Okay, taking all that information into account it does seem pragmatic to
leave the DFS channels out of the world domain. Thanks for taking the
time to explain it all to me!

Seth

> 
>   Luis
