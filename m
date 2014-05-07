Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37700 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaEGIv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 04:51:57 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so641760wgh.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 01:51:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399450061.5038.10.camel@jlt4.sipsolutions.net>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	<1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	<1399372915.4218.17.camel@jlt4.sipsolutions.net>
	<CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	<1399385141.4218.37.camel@jlt4.sipsolutions.net>
	<CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
	<1399450061.5038.10.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 10:51:55 +0200
Message-ID: <CA+BoTQkuHOXS92WOtNfRAu01n66CTpOdwTVNHHoa7=SfaFE=-g@mail.gmail.com> (sfid-20140507_105203_277181_AE42ADE0)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>,
	Simon Wunderlich <sw@simonwunderlich.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2014 10:07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-07 at 08:05 +0200, Michal Kazior wrote:
>
>> Hmm... Now that I think about the atomic swap - it actually becomes a
>> little bit of an issue in some cases.
>>
>> For one you might need to overcommit number of chanctx since swapping
>> requires both chanctx (old and new) to exist but that's the least of
>> the eproblem. If you have more than one interface you end up with
>> temporarily breaking interface combinations from driver point of view
>> while switching (first swap breaks it, last swap fixes it). Driver
>> won't know whether given swap is first/last unless we somehow pass it
>> through the switch_vif_chanctx(). IOW we actually need a "chanctx
>> transaction" (sort of a start-stop) that can batch up a couple of
>> chanctx switches for different vifs as an atomic op.
>
> Hmmm. Don't you already have that problem? Or you don't because you'd do
>
> for_each_affected_vif: unassign
> del chanctx [optional depending on reservation]
> add chanctx [ditto]
> for_each_affected_vif: assign
>
> right now?

Correct - this is how my patch deals with this problem. This was also
the reason why I split the new_chanctx() into alloc_chanctx() and
add_chanctx().


Michał
