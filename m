Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31305 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755531AbcLNNtX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 08:49:23 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: Erik Stromdahl <erik.stromdahl@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v2 05/11] ath10k: htc: refactorization
Date: Wed, 14 Dec 2016 13:49:10 +0000
Message-ID: <87wpf2wrhm.fsf@kamboji.qca.qualcomm.com> (sfid-20161214_144929_613037_DA77C8B8)
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
        <1479496971-19174-6-git-send-email-erik.stromdahl@gmail.com>
        <87inqoymd0.fsf@kamboji.qca.qualcomm.com>
        <CA+BoTQkuUFxnra75B4LpF5+k9yE7hkNYDXbtUMBLq2LFuPSasg@mail.gmail.com>
        <871sxbzqo6.fsf@kamboji.qca.qualcomm.com>
        <70b8a055-e6ba-857d-8b03-06f50e3f10fe@gmail.com>
        <CA+BoTQmRV59imnmSykjs=ym0qut9akUHzFKfAMioK=MT8my98A@mail.gmail.com>
In-Reply-To: <CA+BoTQmRV59imnmSykjs=ym0qut9akUHzFKfAMioK=MT8my98A@mail.gmail.com>       (Michal
 Kazior's message of "Tue, 13 Dec 2016 20:21:53 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> I have made a few updates since I submitted the original RFC and created
>> a repo on github:
>>
>> https://github.com/erstrom/linux-ath
>>
>> I have a bunch of branches that are all based on the tags on the ath mas=
ter.
>>
>> As of this moment the latest version is:
>>
>> ath-201612131156-ath10k-sdio
>>
>> This branch contains the original RFC patches plus some addons/fixes.
>>
>> In the above mentioned branch there are a few commits related to this
>> race condition. Perhaps you can have a look at them?
>>
>> The commits are:
>> 821672913328cf737c9616786dc28d2e4e8a4a90
>
> I would avoid if(bus=3D=3Dxx) checks.

Very much agreed. For example to enable HTT high latency support you
could add an enum to ath10k_core_create() with values for both high and
low latency. This way sdio.c and pci.c can enable the correct mode
during initialisation.

--=20
Kalle Valo=
