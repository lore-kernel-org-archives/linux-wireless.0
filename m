Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:39549 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752330AbdLNNVe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 08:21:34 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Christian Lamparter <chunkeey@gmail.com>
CC: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix recent bandwidth conversion bug
Date: Thu, 14 Dec 2017 13:21:27 +0000
Message-ID: <877etpmomh.fsf@kamboji.qca.qualcomm.com> (sfid-20171214_142137_864719_163E79F5)
References: <20171101200157.27096-1-chunkeey@gmail.com>
        <1666282.PC3nhpCf9f@debian64>   <87tvxpf9i8.fsf@kamboji.qca.qualcomm.com>
        <1882220.dvZB77Gu54@debian64>
In-Reply-To: <1882220.dvZB77Gu54@debian64> (Christian Lamparter's message of
        "Mon, 20 Nov 2017 18:05:00 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@gmail.com> writes:

> On Monday, November 20, 2017 11:57:21 AM CET Kalle Valo wrote:
>> Christian Lamparter <chunkeey@gmail.com> writes:
>>=20
>> > On Wednesday, November 1, 2017 9:37:53 PM CET Sebastian Gottschall wro=
te:
>> >> a additional array bounds check would be good
>> >
>> > Ah, about that:
>> >
>> > the bw variable in ath10k_htt_rx_h_rates() is extracted from info2
>> > in the following way [0]:
>> > |	bw =3D info2 & 3;
>> >
>> > the txrate.bw variable in ath10k_update_per_peer_tx_stats() is set by =
[1]:
>> > |	txrate.bw =3D ATH10K_HW_BW(peer_stats->flags);
>> >
>> > ATH10K_HW_BW is a macro defined as [2]:
>> > |	#define ATH10K_HW_BW(flags)		(((flags) >> 3) & 0x3)
>> >
>> > In both cases the bandwidth values already are limited to 0-3 by
>> > the "and 3" operation.
>>=20
>> Until someone changes that part of the code (and the firmware
>> interface). IMHO a switch is safer as there we don't have any risk of
>> out of bands access.
>
> The kbuild-bot/CI can catch this too.=20
>
> For example, it will look like this:
> drivers/net/wireless/ath/ath10k//htt_rx.c:710:52: warning: invalid
> access past the end of 'ath10k_bw_to_mac80211' (4 4)

Sure, but after reading about all these security vulnerabilities I have
become even more cautious and try to avoid all tricky stuff.

> BTW:
> Have you noticed:
>
> <https://github.com/lede-project/source/blob/master/package/kernel/mac802=
11/patches/319-ath10k-fix-recent-bandwidth-conversion-bug.patch>
>
> Is this really your signed-off-by or not?

I suspect that patch is taken from my pending branch.

> In any case, you - as the maintainer - can modify the patch as
> you see fit. So, please do so.

Ok, we'll send v2.

--=20
Kalle Valo=
