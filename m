Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45372 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab1ISPlN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 11:41:13 -0400
To: Luciano Coelho <coelho@ti.com>
Cc: Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	<1316408970.2157.9.camel@cumari>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 19 Sep 2011 18:41:10 +0300
In-Reply-To: <1316408970.2157.9.camel@cumari> (Luciano Coelho's message of "Mon\, 19 Sep 2011 08\:09\:30 +0300")
Message-ID: <87aaa0k0a1.fsf@purkki.adurom.net> (sfid-20110919_174116_436354_EEBE6333)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <coelho@ti.com> writes:

> On Sun, 2011-09-18 at 15:03 +0300, Eliad Peller wrote: 
>> In some cases the driver might want to change the
>> default dynamic ps timeout (e.g. coex activity adds
>> latency to the rx/tx path, which might result in
>> redundant psm entrance).
>> 
>> Introduce a new ieee80211_set_dyn_ps_timeout() function
>> to let low-level drivers change the default timeout.
>> 
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
>
> Let's see what Johannes is going to say about this change in mac80211,
> but IIRC this timeout used to exist with WEXT, but it was not
> implemented in nl80211.  We (at Nokia, probably Juuso) tried to
> implement it a long time ago, but after some discussions with Johannes,
> it was decided that this value wouldn't be settable from userspace at
> least.  I don't know if it was considered setting it from the driver
> side, though.

My first thought about this was: "This is so wrong." :)

So we now have the wext interface for setting the timeout, we also use
the PM QoS framework to set it and with this patch even from drivers
can set it. That's quite a mess.

What are these "some cases" referred above? I'm just worried that this
is just a workaround for an issue and adding the extra complexity is a
high cost just to workaround something. Please remember that mac80211
power save is a big problem already now.

-- 
Kalle Valo
