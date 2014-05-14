Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63370 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaENIv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 04:51:26 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so1976813wiv.9
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 01:51:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400055913.4759.7.camel@jlt4.sipsolutions.net>
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
	<CA+BoTQnSJgaN=incAtW08tSqDgW2jRm1cdarMhupArGBAw7FRQ@mail.gmail.com>
	<1399463646.10517.28.camel@jlt4.sipsolutions.net>
	<1399464536.6800.11.camel@dubbel>
	<1399464789.10517.29.camel@jlt4.sipsolutions.net>
	<1399465244.6800.13.camel@dubbel>
	<1399466312.10517.34.camel@jlt4.sipsolutions.net>
	<CA+BoTQmDF2NiWK_PbTYKxFecajiaH6nEPej0ENP7HBZ1ym83sw@mail.gmail.com>
	<1399467225.10517.35.camel@jlt4.sipsolutions.net>
	<CA+BoTQn0LR9SMzY3zQQXwuPOdkBUgMpADOrHucMKxjouRcap8Q@mail.gmail.com>
	<1399543568.9163.5.camel@jlt4.sipsolutions.net>
	<CA+BoTQk_hm-dgNftTK_WdPQFNgD9WyRG01sPQ0vcO=cw7+BNrg@mail.gmail.com>
	<1399988536.4137.23.camel@jlt4.sipsolutions.net>
	<CA+BoTQmG_oFNgjJLr4DdEwnjtu0pC9HiQ8DhapVuhu1u1hXypw@mail.gmail.com>
	<1399996416.4137.27.camel@jlt4.sipsolutions.net>
	<CA+BoTQn9Th=x+0iWOacYS6h1csy-2snDV5vmjeLzptd2ZXn9Pg@mail.gmail.com>
	<1400055913.4759.7.camel@jlt4.sipsolutions.net>
Date: Wed, 14 May 2014 10:51:24 +0200
Message-ID: <CA+BoTQnCp3cgWNBFAELTdWjw6TSwZ+Ymz=8sg9AnN_p3ijPu0A@mail.gmail.com> (sfid-20140514_105133_708426_2363B997)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 May 2014 10:25, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-14 at 07:14 +0200, Michal Kazior wrote:
>
>> Hmm.. I thought of it more as a theoretical appliance of the transaction API.
>>
>> Let me re-post his example:
>>
>> > With the generic transactions you could do:
>> >  - new chanctx2
>> >  - new chanctx3
>> >  - switch vif1 chanctx1->chanctx2
>> >  - switch vif2 chanctx1->chanctx3
>> >  - del chanctx1
>>
>> From this I infer you can run at least 2 chanctx since that's what you
>> end up with. This means you can perform one of the switches separately
>> because only 1 chanctx was used (that's the easy part that never
>> really required transactions or multi-vif-chanctx-assign to begin
>> with). The other switch would fall into the "incompat case" where you
>> need to basically swap chanctx for one of the vifs in the example.
>>
>> So I fail to see why we would need to have a list of old/new contexts
>> in the proposed switch_vif_chanctx(), at least for now.
>
> Further down the thread there was a discussion about e.g. radar
> detection with the combinations, when one needs radar and the other
> doesn't or something, then maybe you're running into a situation where
> some interface combination allows more than 2 channels and the other
> doesn't, or such.

Ah, you're right. I missed that. In that case we need to pass a list
of old/new contexts to switch_vif_chanctx().


Michał
