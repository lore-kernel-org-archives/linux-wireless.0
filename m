Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60499 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaEWI6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:58:33 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so4574719wgh.35
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 01:58:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400834656.4358.1.camel@jlt4.sipsolutions.net>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	<1400767676-15994-5-git-send-email-michal.kazior@tieto.com>
	<1400770484.4174.35.camel@jlt4.sipsolutions.net>
	<CA+BoTQmdNV3XMmiAmA=bP4ZQ7dRZOwX8=_NYqmZW+orEA=OysA@mail.gmail.com>
	<1400834656.4358.1.camel@jlt4.sipsolutions.net>
Date: Fri, 23 May 2014 10:58:31 +0200
Message-ID: <CA+BoTQnLPEqTnyr98TmDETP_iBOAza_XLZ53Jd+GdG6sRc3=5Q@mail.gmail.com> (sfid-20140523_105837_759655_314BB643)
Subject: Re: [PATCH v6 4/6] mac80211: use chanctx reservation for AP CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 May 2014 10:44, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-05-23 at 08:49 +0200, Michal Kazior wrote:
>
>> > But you'll WARN_ON() if they're actually not at the same time and you
>> > grab a beacon (or for the template case, call csa_update) in the
>> > meantime, right? I'd really like to have all those driver requirements
>> > (e.g. to stop beaconing) better documented.
>>
>> Good point. I suppose it should be stated in the docs that once you
>> reach ieee80211_csa_is_complete() being true you must not call
>> ieee80211_beacon_get() nor ieee80211_csa_update_counter(). ath9k and
>> ath10k conform to this.
>
> Right, it's still a bit strange that you just have to stop beaconing.
> Dunno. I guess I don't care all that much since our driver won't support
> multiple AP interfaces anyway :-)

If you keep on beaconing for too long on a DFS channel after detecting
a radar you risk breaking local law (ETSI and FCC specify quiescing
periods).


>> I wonder what driver should be supposed to look at before starting to
>> beacon again? csa_active isn't well protected to be depended upon. If
>> we should create a ieee80211_csa_is_active() that just checks if
>> beacon->csa_counter_offset[0] != 0 (assuming my other csa counter
>> patches are applied) then it's still racy:
>>  a) rcu_dereference() across ieee80211_csa_is_active(), _is_complete()
>> and _beacon_get() can yield different beacon pointers
>>  b) cs_count <= 1 yields no beacon update (thus no counters/offsets,
>> meaning both _csa_is_complete and _csa_is_active() are `false` thus
>> suggesting driver can beacon as if nothing happened)
>>
>> We could fix (b) by simply not treating cs_count <= 1 so special and
>> update the beacon anyway. For (a) to work we'd need either make a
>> single-call do-all function or introduce an additional call and a
>> generic pointer/structure to be passed to other functions so that a
>> beacon pointer is consistent across calls.
>
> You could technically just return NULL in this period, but I don't know
> how well drivers would cope with that (though technically they have to
> cope with it due to memory allocation failures anyway)

Sounds good to me.

I guess you'd use ieee80211_csa_is_complete (or
ieee80211_csa_update_counter) for template-based drivers to stop
beaconing.


Michał
