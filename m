Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46240 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932080AbeCKHM5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Mar 2018 03:12:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Christian Lamparter <chunkeey@gmail.com>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix recent bandwidth conversion bug
References: <20171101200157.27096-1-chunkeey@gmail.com>
        <1666282.PC3nhpCf9f@debian64>
        <87tvxpf9i8.fsf@kamboji.qca.qualcomm.com>
        <1882220.dvZB77Gu54@debian64>
        <877etpmomh.fsf@kamboji.qca.qualcomm.com>
        <CACna6ryUYb8ACVaRx3jROgxfUvBV5p4+3UsNEV8FEU1R_2sxdQ@mail.gmail.com>
Date: Sun, 11 Mar 2018 09:12:53 +0200
In-Reply-To: <CACna6ryUYb8ACVaRx3jROgxfUvBV5p4+3UsNEV8FEU1R_2sxdQ@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Thu, 1 Mar 2018
 12:52:55 +0100")
Message-ID: <87zi3f6q6i.fsf@qca.qualcomm.com> (sfid-20180311_081302_075426_4E962CC2)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On 14 December 2017 at 14:21, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Christian Lamparter <chunkeey@gmail.com> writes:
>>
>>> On Monday, November 20, 2017 11:57:21 AM CET Kalle Valo wrote:
>>>> Christian Lamparter <chunkeey@gmail.com> writes:
>>>>
>>>> > On Wednesday, November 1, 2017 9:37:53 PM CET Sebastian Gottschall w=
rote:
>>>> >> a additional array bounds check would be good
>>>> >
>>>> > Ah, about that:
>>>> >
>>>> > the bw variable in ath10k_htt_rx_h_rates() is extracted from info2
>>>> > in the following way [0]:
>>>> > |  bw =3D info2 & 3;
>>>> >
>>>> > the txrate.bw variable in ath10k_update_per_peer_tx_stats() is set b=
y [1]:
>>>> > |  txrate.bw =3D ATH10K_HW_BW(peer_stats->flags);
>>>> >
>>>> > ATH10K_HW_BW is a macro defined as [2]:
>>>> > |  #define ATH10K_HW_BW(flags)             (((flags) >> 3) & 0x3)
>>>> >
>>>> > In both cases the bandwidth values already are limited to 0-3 by
>>>> > the "and 3" operation.
>>>>
>>>> Until someone changes that part of the code (and the firmware
>>>> interface). IMHO a switch is safer as there we don't have any risk of
>>>> out of bands access.
>>>
>>> The kbuild-bot/CI can catch this too.
>>>
>>> For example, it will look like this:
>>> drivers/net/wireless/ath/ath10k//htt_rx.c:710:52: warning: invalid
>>> access past the end of 'ath10k_bw_to_mac80211' (4 4)
>>
>> Sure, but after reading about all these security vulnerabilities I have
>> become even more cautious and try to avoid all tricky stuff.
>>
>>> BTW:
>>> Have you noticed:
>>>
>>> <https://github.com/lede-project/source/blob/master/package/kernel/mac8=
0211/patches/319-ath10k-fix-recent-bandwidth-conversion-bug.patch>
>>>
>>> Is this really your signed-off-by or not?
>>
>> I suspect that patch is taken from my pending branch.
>>
>>> In any case, you - as the maintainer - can modify the patch as
>>> you see fit. So, please do so.
>>
>> Ok, we'll send v2.
>
> Hi Kalle,
>
> I'm trying to figure out the fate of that LEDE's patch. I don't think
> you ever sent V2.
>
> Is that fix still needed? Are you planning to send V2?

Anil now sent v2 (he just forgot to mark it as such):

https://patchwork.kernel.org/patch/10273445/

Thanks for the reminder.

--=20
Kalle Valo
