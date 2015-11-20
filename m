Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51933 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161907AbbKTMF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 07:05:29 -0500
Message-ID: <1448021125.3141.37.camel@sipsolutions.net> (sfid-20151120_130533_219053_A1BF1F1B)
Subject: Re: Configurable scan dwell time?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 20 Nov 2015 13:05:25 +0100
In-Reply-To: <563B8713.6000401@candelatech.com>
References: <563A9B8C.3060503@candelatech.com>
	 <CA+BoTQnYrFSLkdBgcMgnuJPvPeSjuu9oB68KkU7jRMEH5iFE2A@mail.gmail.com>
	 <1446710205.2540.1.camel@sipsolutions.net>
	 <563B7D63.1010203@candelatech.com>
	 <1446739615.2540.6.camel@sipsolutions.net>
	 <563B8206.1040807@candelatech.com>
	 <1446740733.2540.9.camel@sipsolutions.net>
	 <563B8713.6000401@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-05 at 08:42 -0800, Ben Greear wrote:

> Grep for 'dwell_time' in ath10k driver dir...it is already using
> different values (active 50, passive 150) than what mac80211 does, so
> anyone assuming scan time is exactly some duration is already
> confused.

Sure, you can even grep more carefully and notice that in certain cases
iwlwifi/mvm doesn't even have control over the dwell times as they're
handled entirely in firmware, and the firmware might do stranger things
still.

In the future, with FILS, scanning is going to get more complicated and
will likely have to jump around channels, hitting each one two or more
times.

But that's kinda my point - we have lots of different ways to do
scanning today. Assuming anything about it, other than that'll
eventually return scan results, is pointless.

You're arguing though that dwell time should be controllable. This can
be a problem:

> It wouldn't break clients if the value is known to just be a hint
> from the beginning..ie clients cannot ever expect that this value
> is guaranteed to be used.

Then I fail to see the use-case for this. If there's an actual
requirement to do scanning with a changed dwell time, then you really
will need to know that it is going to work/has worked. If you don't
really care, why would you specify a hint?

This isn't really an optimisation that you can safely ignore. It has
massive impact on the scan scheduling/timing.

> But, if it would help this feature get upstream, then I will work on
> adding a driver flag.  Would that make it acceptable for upstream?

I think you really should more clearly define the use case for this
first. If it's just a debug (or similar) thing, why even bother, we can
just put it into ath10k debugfs?

I'll agree that many of the software implementation are pretty simple
today and could implement this fairly easily, but I don't want us to
cut off the path towards other things like FILS in the future by using
something like this. Especially without a well-defined use-case.

Jouni mentioned once to me that there is actually a spec use case for
something like that, but I'm not sure if it's really scanning or
measurement? In any case, even if that's scanning, it should really be
understood to apply to those use cases only, and not be used
indiscriminately, since using it will cut off the ability of using
current and future optimisations.

johannes
