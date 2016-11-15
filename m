Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19389 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753133AbcKOKyS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 05:54:18 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: Erik Stromdahl <erik.stromdahl@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC 10/12] ath10k: Added QCA65XX hw definition
Date: Tue, 15 Nov 2016 10:54:13 +0000
Message-ID: <87wpg5qai1.fsf@qca.qualcomm.com> (sfid-20161115_115422_250030_9486F8D4)
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
        <1479141222-8493-11-git-send-email-erik.stromdahl@gmail.com>
        <CA+BoTQmcyVQDOd2o0YDvepuLbSz76p8hetrWA6mWJeGxvbM8iQ@mail.gmail.com>
In-Reply-To: <CA+BoTQmcyVQDOd2o0YDvepuLbSz76p8hetrWA6mWJeGxvbM8iQ@mail.gmail.com>       (Michal
 Kazior's message of "Tue, 15 Nov 2016 11:34:11 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 14 November 2016 at 17:33, Erik Stromdahl <erik.stromdahl@gmail.com> w=
rote:
>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/hw.h |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless=
/ath/ath10k/hw.h
>> index 46142e9..ef45ecf 100644
>> --- a/drivers/net/wireless/ath/ath10k/hw.h
>> +++ b/drivers/net/wireless/ath/ath10k/hw.h
>> @@ -224,6 +224,7 @@ enum ath10k_hw_rev {
>>         ATH10K_HW_QCA9377,
>>         ATH10K_HW_QCA4019,
>>         ATH10K_HW_QCA9887,
>> +       ATH10K_HW_QCA65XX,
>
> Are you 100% positive that you're supporting all QCA65XX chips? The
> rule of thumb is to avoid Xs as much as possible unless totally
> perfectly completely sure.

But the thing is that nobody can't be absolutely sure as we never know
what marketing comes up within few years again. So I would say that XX
in chip names should be completely avoided to avoid any confusion. We
already suffer from this in ath10k with QCA988X and QCA9888 which are
different designs but the names overlap.

I haven't reviewed Erik's patches yet but I'm surprised why even a new
enum value is needed here. I was assuming we could use ATH10K_HW_QCA6174
because AFAIK they share the same design. Any particular reason for
this?

--=20
Kalle Valo=
