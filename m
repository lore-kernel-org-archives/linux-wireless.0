Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16332 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab1BNWrr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 17:47:47 -0500
Subject: Re: [PATCH 1/5] iwlwifi: Simplify tx queue management
From: wwguy <wey-yi.w.guy@intel.com>
To: Nathaniel Smith <njs@pobox.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
In-Reply-To: <AANLkTinA0yoF_dU+2B6+rHcE_DvS7yjqu+TqYzhprvZj@mail.gmail.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <1297619803-2832-2-git-send-email-njs@pobox.com>
	 <1297677453.3785.4.camel@jlt3.sipsolutions.net>
	 <AANLkTinA0yoF_dU+2B6+rHcE_DvS7yjqu+TqYzhprvZj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 14:45:41 -0800
Message-ID: <1297723541.4723.22.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-14 at 14:17 -0800, Nathaniel Smith wrote:
> On Mon, Feb 14, 2011 at 1:57 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2011-02-13 at 09:56 -0800, Nathaniel J. Smith wrote:
> >> Previously, the iwlwifi driver filled its transmit queue until it
> >> reached a high-water mark, and then stopped until it had fallen to a
> >> low-water mark. This basic logic makes sense for interrupt mitigation
> >> -- you might not want to wake up the CPU after every packet, but
> >> instead wait until a batch of packets has been sent -- except the
> >> iwlwifi driver doesn't actually do any interrupt mitigation; the CPU
> >> wakes up after every packet transmitted anyway. So we simplify the
> >> code to maintain only a single limit on total queue length, and
> >> whenever we drop below that limit we allow more packets in.
> >>
> >> This patch should have no user-visible effect.
> >
> > I'm pretty sure the devices (but maybe not 3945) implement interrupt
> > mitigation at least in some cases. How did you arrive at the conclusion
> > that "the driver doesn't actually do any interrupt mitigation"?
> 
> Two reasons:
>   -- I searched the code and couldn't find any evidence for it
>   -- If I'm wrong then the quickest way to find out is to make loud
> and confident claims in front of people who know better ;-)
> I might be wrong.
> 
> If so, then it'd be pretty straightforward to extend this approach to
> handle interrupt mitigation -- you set the low mark to N ms, and the
> high mark to N+M ms, where N is the amount of time you think you need
> to refill the queue after it drops, and 1/M is the maximum interrupt
> rate you're willing to tolerate.
> 
> On Mon, Feb 14, 2011 at 7:33 AM, wwguy <wey-yi.w.guy@intel.com> wrote:
> > Hi Nathaniel,
> [...]
> > what device you test this with? I will like to see this changes with
> > newer device, especially with aggregation.
> 
> Hi Wey,
> 
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
> [Golan] Network Connection (rev 02)
> 
> Sadly, I don't have access to any newer hardware. I'd be happy to take
> donations ;-), but probably someone else will need to do the testing?
> 
> I wouldn't be surprised if it needed some tweaks to properly handle
> aggregation (in particular, I'd want to start by clamping the minimum
> queue size to match our best guess at the number of packets we can
> currently combine into a single transmission), but I'm not enough of
> an 802.11 expert to be confident about how to do that either. That
> number varies with the rate, yes? So we'd need some way to ask the
> rate control algorithm what rate it plans to use next?
> 

right, I will really like to see those changes being test with agn
device first.

btw, we are in the process of splitting 3945/4965 out of iwlwifi into it
own directory (iwlwifilegacy). The work should be done and upstream in
the next few days. I will really prefer you wait for us done the split
works first, then consider those changes.

Thanks
Wey


