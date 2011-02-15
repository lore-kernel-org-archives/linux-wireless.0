Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56550 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1BOBKK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 20:10:10 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Pp9Qb-0002MK-CJ
	for linux-wireless@vger.kernel.org; Tue, 15 Feb 2011 02:10:05 +0100
Received: from 75-145-127-229-colorado.hfc.comcastbusiness.net ([75.145.127.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 02:10:05 +0100
Received: from d by 75-145-127-229-colorado.hfc.comcastbusiness.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 02:10:05 +0100
To: linux-wireless@vger.kernel.org
From: d@taht.net (Dave =?utf-8?Q?T=C3=A4ht?=)
Subject: Re: [PATCH 1/5] iwlwifi: Simplify tx queue management
Date: Mon, 14 Feb 2011 17:15:12 -0700
Message-ID: <87r5baf90v.fsf@cruithne.co.teklibre.org>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	<1297619803-2832-2-git-send-email-njs@pobox.com>
	<1297677453.3785.4.camel@jlt3.sipsolutions.net>
	<AANLkTinA0yoF_dU+2B6+rHcE_DvS7yjqu+TqYzhprvZj@mail.gmail.com>
	<1297723541.4723.22.camel@wwguy-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wwguy <wey-yi.w.guy@intel.com> writes:

> On Mon, 2011-02-14 at 14:17 -0800, Nathaniel Smith wrote:
>> On Mon, Feb 14, 2011 at 1:57 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Sun, 2011-02-13 at 09:56 -0800, Nathaniel J. Smith wrote:
>> >> Previously, the iwlwifi driver filled its transmit queue until it
>> >> reached a high-water mark, and then stopped until it had fallen to
>> >> a low-water mark. This basic logic makes sense for interrupt
>> >> mitigation -- you might not want to wake up the CPU after every
>> >> packet, but instead wait until a batch of packets has been sent --
>> >> except the iwlwifi driver doesn't actually do any interrupt
>> >> mitigation; the CPU wakes up after every packet transmitted
>> >> anyway. So we simplify the code to maintain only a single limit on
>> >> total queue length, and whenever we drop below that limit we allow
>> >> more packets in.
>> >>
>> >> This patch should have no user-visible effect.
>> >
>> > I'm pretty sure the devices (but maybe not 3945) implement
>> > interrupt mitigation at least in some cases. How did you arrive at
>> > the conclusion that "the driver doesn't actually do any interrupt
>> > mitigation"?
>> 
>> Two reasons: -- I searched the code and couldn't find any evidence
>> for it -- If I'm wrong then the quickest way to find out is to make
>> loud and confident claims in front of people who know better ;-) I
>> might be wrong.
>> 
>> If so, then it'd be pretty straightforward to extend this approach to
>> handle interrupt mitigation -- you set the low mark to N ms, and the
>> high mark to N+M ms, where N is the amount of time you think you need
>> to refill the queue after it drops, and 1/M is the maximum interrupt
>> rate you're willing to tolerate.
>> 
>> On Mon, Feb 14, 2011 at 7:33 AM, wwguy <wey-yi.w.guy@intel.com> wrote:
>> > Hi Nathaniel,
>> [...]
>> > what device you test this with? I will like to see this changes
>> > with newer device, especially with aggregation.
>> 
>> Hi Wey,
>> 
>> 03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
>> [Golan] Network Connection (rev 02)
>> 
>> Sadly, I don't have access to any newer hardware. I'd be happy to
>> take donations ;-), but probably someone else will need to do the
>> testing?
>> 
>> I wouldn't be surprised if it needed some tweaks to properly handle
>> aggregation (in particular, I'd want to start by clamping the minimum
>> queue size to match our best guess at the number of packets we can
>> currently combine into a single transmission), but I'm not enough of
>> an 802.11 expert to be confident about how to do that either. That
>> number varies with the rate, yes? So we'd need some way to ask the
>> rate control algorithm what rate it plans to use next?

Concur there may be issues with aggregation. 

However, I'll take two orders of magnitude latency improvement over
extreme bandwidth, ANY DAY.

>> 
>
> right, I will really like to see those changes being test with agn
> device first.

Is this modern enough?

03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN [Kedron] Network Connection (rev 61)

If so, I'll apply Nathans patch series (could you email the latest cut to me?)


-- 
Dave Taht
http://nex-6.taht.net

