Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35748 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967748AbeCALw4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 06:52:56 -0500
Received: by mail-oi0-f68.google.com with SMTP id x10so4253822oig.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 03:52:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <877etpmomh.fsf@kamboji.qca.qualcomm.com>
References: <20171101200157.27096-1-chunkeey@gmail.com> <1666282.PC3nhpCf9f@debian64>
 <87tvxpf9i8.fsf@kamboji.qca.qualcomm.com> <1882220.dvZB77Gu54@debian64> <877etpmomh.fsf@kamboji.qca.qualcomm.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 1 Mar 2018 12:52:55 +0100
Message-ID: <CACna6ryUYb8ACVaRx3jROgxfUvBV5p4+3UsNEV8FEU1R_2sxdQ@mail.gmail.com> (sfid-20180301_125300_905344_22A9036D)
Subject: Re: [PATCH] ath10k: fix recent bandwidth conversion bug
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Christian Lamparter <chunkeey@gmail.com>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 December 2017 at 14:21, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Christian Lamparter <chunkeey@gmail.com> writes:
>
>> On Monday, November 20, 2017 11:57:21 AM CET Kalle Valo wrote:
>>> Christian Lamparter <chunkeey@gmail.com> writes:
>>>
>>> > On Wednesday, November 1, 2017 9:37:53 PM CET Sebastian Gottschall wr=
ote:
>>> >> a additional array bounds check would be good
>>> >
>>> > Ah, about that:
>>> >
>>> > the bw variable in ath10k_htt_rx_h_rates() is extracted from info2
>>> > in the following way [0]:
>>> > |  bw =3D info2 & 3;
>>> >
>>> > the txrate.bw variable in ath10k_update_per_peer_tx_stats() is set by=
 [1]:
>>> > |  txrate.bw =3D ATH10K_HW_BW(peer_stats->flags);
>>> >
>>> > ATH10K_HW_BW is a macro defined as [2]:
>>> > |  #define ATH10K_HW_BW(flags)             (((flags) >> 3) & 0x3)
>>> >
>>> > In both cases the bandwidth values already are limited to 0-3 by
>>> > the "and 3" operation.
>>>
>>> Until someone changes that part of the code (and the firmware
>>> interface). IMHO a switch is safer as there we don't have any risk of
>>> out of bands access.
>>
>> The kbuild-bot/CI can catch this too.
>>
>> For example, it will look like this:
>> drivers/net/wireless/ath/ath10k//htt_rx.c:710:52: warning: invalid
>> access past the end of 'ath10k_bw_to_mac80211' (4 4)
>
> Sure, but after reading about all these security vulnerabilities I have
> become even more cautious and try to avoid all tricky stuff.
>
>> BTW:
>> Have you noticed:
>>
>> <https://github.com/lede-project/source/blob/master/package/kernel/mac80=
211/patches/319-ath10k-fix-recent-bandwidth-conversion-bug.patch>
>>
>> Is this really your signed-off-by or not?
>
> I suspect that patch is taken from my pending branch.
>
>> In any case, you - as the maintainer - can modify the patch as
>> you see fit. So, please do so.
>
> Ok, we'll send v2.

Hi Kalle,

I'm trying to figure out the fate of that LEDE's patch. I don't think
you ever sent V2.

Is that fix still needed? Are you planning to send V2?

--=20
Rafa=C5=82
