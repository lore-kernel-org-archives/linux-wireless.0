Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22560 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdBJHEA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 02:04:00 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Adrian Chadd <adrian@freebsd.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        =?iso-8859-2?Q?Amadeusz_S=B3awi=F1ski?=
        <amadeusz.slawinski@tieto.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: remove ath10k_vif_to_arvif()
Date: Fri, 10 Feb 2017 07:03:56 +0000
Message-ID: <87tw82il32.fsf@kamboji.qca.qualcomm.com> (sfid-20170210_080425_072254_4237DB14)
References: <1486030773-30600-1-git-send-email-amadeusz.slawinski@tieto.com>
        <CAJ-VmonrHpS3MArM9ohHgLvb6xspP_gnVVeJWA9F-pjUpJ+LZA@mail.gmail.com>
        <87y3xi4b28.fsf@qca.qualcomm.com> <5899DDD7.7000605@candelatech.com>
In-Reply-To: <5899DDD7.7000605@candelatech.com> (Ben Greear's message of "Tue,
        7 Feb 2017 06:46:47 -0800")
Content-Type: text/plain; charset="iso-8859-2"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 02/07/2017 01:14 AM, Valo, Kalle wrote:
>> Adrian Chadd <adrian@freebsd.org> writes:
>>
>>> Removing this method makes the diff to FreeBSD larger, as "vif" in
>>> FreeBSD is a different pointer.
>>>
>>> (Yes, I have ath10k on freebsd working and I'd like to find a way to
>>> reduce the diff moving forward.)
>>
>> I don't like this "(void *) vif->drv_priv" style that much either but
>> apparently it's commonly used in Linux wireless code and already parts
>> of ath10k. So this patch just unifies the coding style.
>
> Surely the code compiles to the same thing, so why add a patch that
> makes it more difficult for Adrian and makes the code no easier to read
> for the rest of us?

Because that's the coding style used already in Linux. It's great to see
that parts of ath10k can be used also in other systems but in principle
I'm not very fond of the idea starting to reject valid upstream patches
because of driver forks.

I think backports project is doing it right, it's not limiting upstream
development in any way and handles all the API changes internally. Maybe
FreeBSD could do something similar?

--=20
Kalle Valo=
