Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:42422 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755316AbaEGLsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 07:48:54 -0400
In-Reply-To: <1399460964.10517.12.camel@jlt4.sipsolutions.net>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com> <1398849681-3606-1-git-send-email-michal.kazior@tieto.com> <1399372915.4218.17.camel@jlt4.sipsolutions.net> <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com> <1399385141.4218.37.camel@jlt4.sipsolutions.net> <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com> <1399450061.5038.10.camel@jlt4.sipsolutions.net> <1399455657.6800.4.camel@dubbel> <CA+BoTQmXb=_jjE4-dL8U_-8=CxRMgo4qckUKF9LizfV2W0iC7A@mail.gmail.com> <1399457760.6800.7.camel@dubbel> <CA+BoTQnF3pVmGumqqHbfuphXbYhAybHUMosX4kJazfHWJDE+Fw@mail.gmail.com> (sfid-20140507_123846_454540_5D41186C) <1399460964.10517.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
From: Luca Coelho <luca@coelho.fi>
Date: Wed, 07 May 2014 14:48:47 +0300
To: Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Message-ID: <1369ec0d-d09f-4791-9431-d94a642ee979@email.android.com> (sfid-20140507_134857_667686_28E89DCD)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On May 7, 2014 2:09:24 PM EEST, Johannes Berg <johannes@sipsolutions.net> wrote:
>On Wed, 2014-05-07 at 12:38 +0200, Michal Kazior wrote:
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
>Not sure what you mean by "detect chanctx swapping" - the flags would
>indicate that anyway, no? In any case, I like this better than a more
>general transaction API I think, it's easier for the driver
>implementation and clearer as to what needs to be done/supported.

How is it clearer? I think having a list of transactions is clearer than trying to say with flags what needs to be done for each vif and what their relation to each context is...

Additionally, I'm always for more generic solutions that may help us with future cases we haven't thought of already... unless the generalization complicates things a lot, which I don't think is the case here.

--
Luca.

