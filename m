Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38645 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbbJFQHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 12:07:22 -0400
Received: by igxx6 with SMTP id x6so83979923igx.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2015 09:07:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mvvw13rl.fsf@kamboji.qca.qualcomm.com>
References: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
	<87mvvw13rl.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 6 Oct 2015 09:07:22 -0700
Message-ID: <CAJ-VmomNSG14OxBAVOsL0ZB3d2BA0tNTzw+x_qOwY23dUE37cA@mail.gmail.com> (sfid-20151006_180729_862660_031A4A61)
Subject: Re: [PATCH RESEND] ath9k: Fix NF CCA limits for AR9287 and AR9227
From: Adrian Chadd <adrian@freebsd.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

from qca-wifi-1.2:

ar5416phy.h:#define AR_PHY_CCA_NOM_VAL_KIWI_2GHZ           -120
ar5416phy.h:#define AR_PHY_CCA_MIN_GOOD_VAL_KIWI_2GHZ    -127
ar5416phy.h:#define AR_PHY_CCA_MAX_GOOD_VAL_KIWI_2GHZ    -110

.. and:

ar5416phy.h:#define AR_PHY_CCA_NOM_VAL_MERLIN_2GHZ         -112
ar5416phy.h:#define AR_PHY_CCA_MIN_GOOD_VAL_MERLIN_2GHZ  -127
ar5416phy.h:#define AR_PHY_CCA_MAX_GOOD_VAL_MERLIN_2GHZ  -97

.. so although the reference driver has the lower values for AR9287,
the AR9280 values work better for him.

So, hm. I think I recall finding the same when I did the initial
AR9287 support and found the AR9280 ANI/CCA values behaved better. It
doesn't look like he has any noise spurs in the spectral scan output
in his NIC; it just looks like everything needs to be slightly higher
to deal with ambient noise.

I'm okay with including it but I'd like other feedback/testing from
AR9287/AR9227 users. I used the AR9287 in a laptop for about a year w/
the AR9280 values (running FreeBSD-HEAD) and it performed great.



-adrian


On 6 October 2015 at 07:16, Kalle Valo <kvalo@codeaurora.org> wrote:
> Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:
>
>> The FreeBSD driver [0] uses the same 2G values as for the AR9280 chips.
>> Using the same values in ath9k results in much better throughput for me.
>>
>> Before this patch I had a huge amount of packet loss (sometimes up to
>> 40%) and the max transfer speed was somewhere around 5Mbit/s. With this
>> patch applied I have zero packet loss and ten times the throughput.
>> My device uses a AR9227 which is the PCI variant of the AR9287.
>>
>> [0] http://bxr.su/FreeBSD/sys/dev/ath/ath_hal/ar9002/ar9287.h
>>
>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>
> So what should I do with this patch? Is this good to apply?
>
> Discussion here:
>
> https://patchwork.kernel.org/patch/6841051/
>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
