Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41659 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab0DMIbz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 04:31:55 -0400
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: ext Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ylalehto Janne \(Nokia-D\/Tampere\)" <janne.ylalehto@nokia.com>
Subject: Re: [RFC PATCH] nl80211: Add support for dynamic ps timeout configuration
References: <1271059902-27788-1-git-send-email-juuso.oikarinen@nokia.com>
	<1271061120.3877.6.camel@jlt3.sipsolutions.net>
	<1271062589.10120.1169.camel@wimaxnb.nmp.nokia.com>
	<1271063175.3877.13.camel@jlt3.sipsolutions.net>
	<1271065535.10120.1191.camel@wimaxnb.nmp.nokia.com>
	<871vekpexo.fsf@purkki.valot.fi>
	<1271143746.10120.1232.camel@wimaxnb.nmp.nokia.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 13 Apr 2010 11:31:52 +0300
In-Reply-To: <1271143746.10120.1232.camel@wimaxnb.nmp.nokia.com> (Juuso Oikarinen's message of "Tue\, 13 Apr 2010 10\:29\:06 +0300")
Message-ID: <87wrwboirr.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:

>> But we do not want to tie our hands to a simple timeout value because
>> that only applies to the very crude dynamic ps implementation we have
>> currently. What if, next year, we have an uber cool new power save
>> implementation in mac80211 which doesn't use the timeout value at all,
>> what do we do with the nl80211 timeout parameter then? Deprecate it?
>
> I agree that letting user-space configure a raw timeout is rather crude.
> But in my view the problem really is that we don't have that uber-cool
> power save feature of the future yet, and hence cannot fully take its
> needs into account. So apparently, until we do, we have to live without
> even the crude one?
>
> Or is it better to deprecate a semi-complex interface instead of a crude
> one, if even that does not meet all requirements of whats to come?

But nl80211 is a user space interface and there are special rules for
that. Basically we need to support it a long time to avoid breaking
existing user space applications. If we add new features to nl80211
which we will deprecate later on, it will soon become a mess and
difficult to maintain. That would create more work for the wireless
community and I would like to minimise the extra work, naturally :)

If this would affect only a kernel internal API (like mac80211 driver
API), I would have no objections at all. That's always easy to change.

>> I think power save control should happen outside nl80211. The problem
>> here is that we want to inform kernel about events (or states) in user
>> space (display turned off, user activity, voip call etc.). We need a
>> different interface for that, nl80211 is not suitable for this. Also
>> other subsystems than wireless would definitely benefit from this kind
>> of information. The interface might already exist (pm qos?) or we have
>> to create a new one, I haven't studied this that much.
>
> I looked into this slightly. I can see, that the mac80211 has support
> for a latency-wish from user-space, using pm_qos. This seems to affect
> only the dtim-period somehow (by the way, at least the wl1251 driver has
> an obvious bug about this - if the AP dtim is > 1 and user-space
> configures the latency properly, you can make the wl1251 miss broadcast
> traffic in PSM.)

Thanks, I wrote down that wl1251 issue and I'll take a look at it
later on.

>> I would recommend to see if the pm qos interface can be used to hint
>> mac80211 dynamic ps enough so that you would get similar end result as
>> with the WE power timeout value. It should be possible, but I haven't
>> checked the code myself.
>
> The problem here is that the latency at least cannot be used in any
> simple and/or general way I can think of to control the dynamic PS
> timeout.

Can't you do something like this:

pm_qos >= 1000 -> timeout 0 ms (aka. full power save)
pm_qos <= 100 -> timeout 100 ms
pm_qos <= 50 -> timeout 300 ms

That is, just some arbitrary numbers but which affect dynamic ps
timeout. I haven't thought about the numbers at all, but they actually
don't matter because it's easy to change them inside mac80211.

> So we would still need to add some crude PS level stuff anyway,
> unless someone comes up with that uber-cool solution of tomorrow
> already today.
>
> I see there is fierce resistance, so I'll drop looking into this here.
> As far as I can see, the result of this is that anyone using linux
> wireless in their hand-held devices either cannot switch to nl80211
> today or have to use nl80211 and wext simultaneously.

If yoy need this right now, using wext for setting the timeout is the
fastest way. But it's ugly :/

-- 
Kalle Valo
