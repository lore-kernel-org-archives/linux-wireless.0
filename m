Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61476 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1BNWRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 17:17:19 -0500
Received: by bwz15 with SMTP id 15so5974231bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 14:17:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297677453.3785.4.camel@jlt3.sipsolutions.net>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	<1297619803-2832-2-git-send-email-njs@pobox.com>
	<1297677453.3785.4.camel@jlt3.sipsolutions.net>
Date: Mon, 14 Feb 2011 14:17:17 -0800
Message-ID: <AANLkTinA0yoF_dU+2B6+rHcE_DvS7yjqu+TqYzhprvZj@mail.gmail.com>
Subject: Re: [PATCH 1/5] iwlwifi: Simplify tx queue management
From: Nathaniel Smith <njs@pobox.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 1:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2011-02-13 at 09:56 -0800, Nathaniel J. Smith wrote:
>> Previously, the iwlwifi driver filled its transmit queue until it
>> reached a high-water mark, and then stopped until it had fallen to a
>> low-water mark. This basic logic makes sense for interrupt mitigation
>> -- you might not want to wake up the CPU after every packet, but
>> instead wait until a batch of packets has been sent -- except the
>> iwlwifi driver doesn't actually do any interrupt mitigation; the CPU
>> wakes up after every packet transmitted anyway. So we simplify the
>> code to maintain only a single limit on total queue length, and
>> whenever we drop below that limit we allow more packets in.
>>
>> This patch should have no user-visible effect.
>
> I'm pretty sure the devices (but maybe not 3945) implement interrupt
> mitigation at least in some cases. How did you arrive at the conclusion
> that "the driver doesn't actually do any interrupt mitigation"?

Two reasons:
  -- I searched the code and couldn't find any evidence for it
  -- If I'm wrong then the quickest way to find out is to make loud
and confident claims in front of people who know better ;-)
I might be wrong.

If so, then it'd be pretty straightforward to extend this approach to
handle interrupt mitigation -- you set the low mark to N ms, and the
high mark to N+M ms, where N is the amount of time you think you need
to refill the queue after it drops, and 1/M is the maximum interrupt
rate you're willing to tolerate.

On Mon, Feb 14, 2011 at 7:33 AM, wwguy <wey-yi.w.guy@intel.com> wrote:
> Hi Nathaniel,
[...]
> what device you test this with? I will like to see this changes with
> newer device, especially with aggregation.

Hi Wey,

03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
[Golan] Network Connection (rev 02)

Sadly, I don't have access to any newer hardware. I'd be happy to take
donations ;-), but probably someone else will need to do the testing?

I wouldn't be surprised if it needed some tweaks to properly handle
aggregation (in particular, I'd want to start by clamping the minimum
queue size to match our best guess at the number of packets we can
currently combine into a single transmission), but I'm not enough of
an 802.11 expert to be confident about how to do that either. That
number varies with the rate, yes? So we'd need some way to ask the
rate control algorithm what rate it plans to use next?

-- Nathaniel
