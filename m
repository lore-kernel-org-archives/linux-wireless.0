Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50840 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633AbaEGLTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 07:19:12 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so4371000wib.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 04:19:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399460964.10517.12.camel@jlt4.sipsolutions.net>
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
	<CA+BoTQnF3pVmGumqqHbfuphXbYhAybHUMosX4kJazfHWJDE+Fw@mail.gmail.com>
	<1399460964.10517.12.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 13:19:11 +0200
Message-ID: <CA+BoTQnSJgaN=incAtW08tSqDgW2jRm1cdarMhupArGBAw7FRQ@mail.gmail.com> (sfid-20140507_131925_907183_7284643D)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2014 13:09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-07 at 12:38 +0200, Michal Kazior wrote:
>
>> I was actually thinking of just providing the bare minimum to fulfill
>> requirements for the CSA case: int foo(*hw, **vifs, n_vifs, *oldctx,
>> *newctx, flags).
>>
>> Having an array of transactions passed through a single call seems
>> more robust and cleaner. Naiive drivers might just iterate over each
>> entry while more complex drivers might examine the whole request and
>> detect chanctx swapping.
>
> Not sure what you mean by "detect chanctx swapping" - the flags would
> indicate that anyway, no? In any case, I like this better than a more
> general transaction API I think, it's easier for the driver
> implementation and clearer as to what needs to be done/supported.

You could submit a transaction sequence:
 - new chanctx2
 - switch vif1 chanctx1->chanctx2
 - switch vif2 chanctx1->chanctx2
 - remove chanctx1

Driver could infer this is a channel switch and depending on it's
capabilities/limitations perform some extra actions or just map it to
internal commands 1:1.


Michał
