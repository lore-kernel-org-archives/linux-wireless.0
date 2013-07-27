Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:59225 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab3G0Fly (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jul 2013 01:41:54 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] beacon measurement (beacon filtering disable)
References: <1373971517-315-1-git-send-email-johannes@sipsolutions.net>
	<87oba1yggl.fsf@purkki.adurom.net>
	<1374825838.8248.6.camel@jlt4.sipsolutions.net>
Date: Sat, 27 Jul 2013 08:41:52 +0300
In-Reply-To: <1374825838.8248.6.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Fri, 26 Jul 2013 10:03:58 +0200")
Message-ID: <87wqocwodb.fsf@purkki.adurom.net> (sfid-20130727_074216_686590_9F05E164)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2013-07-17 at 07:10 +0300, Kalle Valo wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> 
>> > We have beacon filtering (to reduce host wakeups) in our device,
>> > but for some measurement/debug purposes we need to turn it off.
>> 
>> TBH I'm not really fond of this. I'm not really sure what's the use
>> case but first this sounded a like a factory test for me, not something
>> which a regular user would want to do.

Sure, that's good to do. I'm just worried that if we add a new command
to enable/disable each small feature we will have a lot of commands in
nl80211. But I guess that's not a problem as you are the maintainer
anyway :)

But I do see benefits from this, so I guess in the end this is good to
have. It would be nice if someone would add a similar command for BT
coexistance as well, that always seems to be a common source of
problems.

> Yeah, in a way that's true. FWIW, we could also connect it to testmode
> and not worry about it for upstream, but it seemed that others might
> want/need similar functionality.
>
>> Can't we connect this to power save? When disabling power save we could
>> also disable beacon filtering and would not need a separate command.
>
> I'm not so sure that's a good idea. While superficially beacon filtering
> is related to saving power, it's really a different thing - it's about
> CPU/host power while powersave is about device power (RX chains etc.)
> Connecting them, in particular where disabling beacon filtering isn't
> even supported by all devices, doesn't really seem like a good idea,
> particularly not for any tool that would require such functionality.

Makes sense.

-- 
Kalle Valo
