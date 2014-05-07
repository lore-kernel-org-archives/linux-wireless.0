Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41827 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaEGKir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 06:38:47 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so4323018wib.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 03:38:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399457760.6800.7.camel@dubbel>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	<1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	<1399372915.4218.17.camel@jlt4.sipsolutions.net>
	<CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	<1399385141.4218.37.camel@jlt4.sipsolutions.net>
	<CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
	<1399450061.5038.10.camel@jlt4.sipsolutions.net>
	<1399455657.6800.4.camel@dubbel>
	<CA+BoTQmXb=_jjE4-dL8U_-8=CxRMgo4qckUKF9LizfV2W0iC7A@mail.gmail.com>
	<1399457760.6800.7.camel@dubbel>
Date: Wed, 7 May 2014 12:38:45 +0200
Message-ID: <CA+BoTQnF3pVmGumqqHbfuphXbYhAybHUMosX4kJazfHWJDE+Fw@mail.gmail.com> (sfid-20140507_123851_059266_B882E586)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2014 12:16, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2014-05-07 at 12:02 +0200, Michal Kazior wrote:
>> On 7 May 2014 11:40, Luca Coelho <luca@coelho.fi> wrote:
>> > On Wed, 2014-05-07 at 10:07 +0200, Johannes Berg wrote:
>> >> On Wed, 2014-05-07 at 08:05 +0200, Michal Kazior wrote:
>> >>
>> >> > Hmm... Now that I think about the atomic swap - it actually becomes a
>> >> > little bit of an issue in some cases.
>> >> >
>> >> > For one you might need to overcommit number of chanctx since swapping
>> >> > requires both chanctx (old and new) to exist but that's the least of
>> >> > the eproblem. If you have more than one interface you end up with
>> >> > temporarily breaking interface combinations from driver point of view
>> >> > while switching (first swap breaks it, last swap fixes it). Driver
>> >> > won't know whether given swap is first/last unless we somehow pass it
>> >> > through the switch_vif_chanctx(). IOW we actually need a "chanctx
>> >> > transaction" (sort of a start-stop) that can batch up a couple of
>> >> > chanctx switches for different vifs as an atomic op.
>> >>
>> >> Hmmm. Don't you already have that problem? Or you don't because you'd do
>> >>
>> >> for_each_affected_vif: unassign
>> >> del chanctx [optional depending on reservation]
>> >> add chanctx [ditto]
>> >> for_each_affected_vif: assign
>> >>
>> >> right now?
>> >>
>> >> I suppose a sort of transaction API, if designed the right way, would
>> >> also work somehow - Luca?
>> >
>> > Yeah, I think this is a good idea.  If we have an atomic transaction API
>> > towards the driver, we can solve the problems of switching several vifs
>> > at once.
>>
>> Hmm.. I assume all chanctx calls would be subject to the transaction
>> API, i.e. add_chanctx/remove_chanctx/switch_vif_chanctx/change_chanctx.
>> Then all calls except begin/commit would return void - I guess this
>> could make handling errors a little saner.
>>
>> Another approach would be to merge all separate chanctx ops into a
>> single one. This would have the benefit of providing driver all
>> information in one place and possibly making it easier to handle
>> errors internally (due to single function flow instead of having stuff
>> all over the place). But I imagine this could become a little
>> ambiguous in some parameter combinations. Any thoughts?
>
> I think the latter is a better option.  Instead of having multiple calls
> and requiring the driver to save all the new information until it's
> committed (as would be the case with the first approach), the driver
> would have all the information it needs at once.
>
> Maybe you could have a single function call with an array of
> transactions?

Hmm..

I was actually thinking of just providing the bare minimum to fulfill
requirements for the CSA case: int foo(*hw, **vifs, n_vifs, *oldctx,
*newctx, flags).

Having an array of transactions passed through a single call seems
more robust and cleaner. Naiive drivers might just iterate over each
entry while more complex drivers might examine the whole request and
detect chanctx swapping.


Michał
