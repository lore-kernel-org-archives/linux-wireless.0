Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49522 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaEWGtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 02:49:52 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so4397824wgh.14
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 23:49:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400770484.4174.35.camel@jlt4.sipsolutions.net>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	<1400767676-15994-5-git-send-email-michal.kazior@tieto.com>
	<1400770484.4174.35.camel@jlt4.sipsolutions.net>
Date: Fri, 23 May 2014 08:49:50 +0200
Message-ID: <CA+BoTQmdNV3XMmiAmA=bP4ZQ7dRZOwX8=_NYqmZW+orEA=OysA@mail.gmail.com> (sfid-20140523_084955_464052_AAB1A3C6)
Subject: Re: [PATCH v6 4/6] mac80211: use chanctx reservation for AP CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2014 16:54, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-05-22 at 16:07 +0200, Michal Kazior wrote:
>> Channel switch finalization is now 2-step. First
>> step is when driver calls csa_finish(), the other
>> is when reservation is actually finalized (which
>> be defered for in-place reservation).
>>
>> It is now safe to call ieee80211_csa_finish() more
>> then once.
>
> But you'll WARN_ON() if they're actually not at the same time and you
> grab a beacon (or for the template case, call csa_update) in the
> meantime, right? I'd really like to have all those driver requirements
> (e.g. to stop beaconing) better documented.

Good point. I suppose it should be stated in the docs that once you
reach ieee80211_csa_is_complete() being true you must not call
ieee80211_beacon_get() nor ieee80211_csa_update_counter(). ath9k and
ath10k conform to this.

I wonder what driver should be supposed to look at before starting to
beacon again? csa_active isn't well protected to be depended upon. If
we should create a ieee80211_csa_is_active() that just checks if
beacon->csa_counter_offset[0] != 0 (assuming my other csa counter
patches are applied) then it's still racy:
 a) rcu_dereference() across ieee80211_csa_is_active(), _is_complete()
and _beacon_get() can yield different beacon pointers
 b) cs_count <= 1 yields no beacon update (thus no counters/offsets,
meaning both _csa_is_complete and _csa_is_active() are `false` thus
suggesting driver can beacon as if nothing happened)

We could fix (b) by simply not treating cs_count <= 1 so special and
update the beacon anyway. For (a) to work we'd need either make a
single-call do-all function or introduce an additional call and a
generic pointer/structure to be passed to other functions so that a
beacon pointer is consistent across calls.


Michał
