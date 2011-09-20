Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49295 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1ITOtG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 10:49:06 -0400
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	<1316408970.2157.9.camel@cumari> <87aaa0k0a1.fsf@purkki.adurom.net>
	<CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
	<87litjipda.fsf@purkki.adurom.net>
	<CAK=WgbZM5zdgOurFfGbQR3V_mqd85qjS_u1_tU35oaVPCh0Rkg@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 20 Sep 2011 17:49:04 +0300
In-Reply-To: <CAK=WgbZM5zdgOurFfGbQR3V_mqd85qjS_u1_tU35oaVPCh0Rkg@mail.gmail.com> (Ohad Ben-Cohen's message of "Tue\, 20 Sep 2011 11\:49\:55 +0300")
Message-ID: <87aa9zi80v.fsf@purkki.adurom.net> (sfid-20110920_164910_893147_FF00388C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ohad Ben-Cohen <ohad@wizery.com> writes:

> On Tue, Sep 20, 2011 at 11:34 AM, Kalle Valo <kvalo@adurom.com> wrote:
>> IIRC Juuso added ieee80211_enable/disable_dyn_ps() to make it possible
>> use BT COEX with wl12xx.
>
> A lot has happened since then :) The wl12xx firmware today is vastly
> different and much improved.

Yeah, quite a turn. That's good :)

>> Now you are saying that you actually want the opposite?
>
> Yes. The firmware is now capable of doing coex without enforcing PSM.
> This leads to a much better WLAN TP while BT is on.

So we can remove the enable/disable dynps interface soon?

>> But nevertheless I'm not still convinced that doing all this in
>> mac80211 is the right thing. Especially that this seems to be very
>> wl12xx specific, right?
>
> Not really, why do you consider this wl12xx specific more than any
> other hw offloading or mac80211 API that is used by a single driver ?

Can we please avoid hand waving and stick to the matter at hand,
please?

The problem is that the current mac80211 powersave implementation is a
HUGE mess and nobody fully understands it nor wants to touch it. We
should be trying to simplify that instead of creating it more complex.

I actually believe that it's not possible to properly support all the
different power save hardware designs out there, instead I think that
some of the most eccentric implementations should not be supported by
mac80211 at all. For example, waking up for beacons or multicast
frames is a good example, we should just rip them out from mac80211
and let drivers deal that crap.

Now I try to understand what would be the best option for your
requirement. Are there any other drivers which needs this
ieee80211_set_dyn_ps_timeout() interface? If there is more than one
driver needing, implementing this to mac80211 would make more sense.

-- 
Kalle Valo
