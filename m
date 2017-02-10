Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50978 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbdBJRhm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 12:37:42 -0500
Subject: Re: [PATCH 1/3] ath10k: remove ath10k_vif_to_arvif()
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <1486030773-30600-1-git-send-email-amadeusz.slawinski@tieto.com>
 <CAJ-VmonrHpS3MArM9ohHgLvb6xspP_gnVVeJWA9F-pjUpJ+LZA@mail.gmail.com>
 <87y3xi4b28.fsf@qca.qualcomm.com> <5899DDD7.7000605@candelatech.com>
 <87tw82il32.fsf@kamboji.qca.qualcomm.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        =?UTF-8?Q?Amadeusz_S=c5=82awi=c5=84ski?=
        <amadeusz.slawinski@tieto.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5fcaaf0e-5f35-fac8-c448-a29aeef9bf0f@candelatech.com> (sfid-20170210_183817_091643_C2696F4C)
Date: Fri, 10 Feb 2017 08:43:43 -0800
MIME-Version: 1.0
In-Reply-To: <87tw82il32.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2017 11:03 PM, Valo, Kalle wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> On 02/07/2017 01:14 AM, Valo, Kalle wrote:
>>> Adrian Chadd <adrian@freebsd.org> writes:
>>>
>>>> Removing this method makes the diff to FreeBSD larger, as "vif" in
>>>> FreeBSD is a different pointer.
>>>>
>>>> (Yes, I have ath10k on freebsd working and I'd like to find a way to
>>>> reduce the diff moving forward.)
>>>
>>> I don't like this "(void *) vif->drv_priv" style that much either but
>>> apparently it's commonly used in Linux wireless code and already parts
>>> of ath10k. So this patch just unifies the coding style.
>>
>> Surely the code compiles to the same thing, so why add a patch that
>> makes it more difficult for Adrian and makes the code no easier to read
>> for the rest of us?
>
> Because that's the coding style used already in Linux. It's great to see
> that parts of ath10k can be used also in other systems but in principle
> I'm not very fond of the idea starting to reject valid upstream patches
> because of driver forks.

There are lots of people trying to maintain out-of-tree or backported patches to ath10k,
and every time there is a meaningless style change, that just makes us
waste more time on useless work instead of having time to work on more important
matters.

Thanks,
Ben

> I think backports project is doing it right, it's not limiting upstream
> development in any way and handles all the API changes internally. Maybe
> FreeBSD could do something similar?
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
