Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40019 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934899AbcKOKqq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 05:46:46 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: Erik Stromdahl <erik.stromdahl@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC 05/12] ath10k: htc: Added ATH10K_HTC_FLAG_BUNDLE_LSB
Date: Tue, 15 Nov 2016 10:46:30 +0000
Message-ID: <8760nprpfa.fsf@qca.qualcomm.com> (sfid-20161115_114700_998622_4AF4413E)
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
        <1479141222-8493-6-git-send-email-erik.stromdahl@gmail.com>
        <CA+BoTQmcB7+aH3wvG-mRSdBS8VaJ1OrLYQ0HCbCJeoH9ccxXNQ@mail.gmail.com>
In-Reply-To: <CA+BoTQmcB7+aH3wvG-mRSdBS8VaJ1OrLYQ0HCbCJeoH9ccxXNQ@mail.gmail.com>       (Michal
 Kazior's message of "Tue, 15 Nov 2016 11:25:40 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 14 November 2016 at 17:33, Erik Stromdahl <erik.stromdahl@gmail.com> w=
rote:
>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/htc.h |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireles=
s/ath/ath10k/htc.h
>> index 589800a..df16a04 100644
>> --- a/drivers/net/wireless/ath/ath10k/htc.h
>> +++ b/drivers/net/wireless/ath/ath10k/htc.h
>> @@ -62,6 +62,8 @@ enum ath10k_htc_rx_flags {
>>         ATH10K_HTC_FLAG_BUNDLE_MASK     =3D 0xF0
>>  };
>>
>> +#define ATH10K_HTC_FLAG_BUNDLE_LSB         4
>
> Just an idea - we could start using FIELD_GET() with
> ATH10K_HTC_FLAG_BUNDLE_MASK alone. I would love to see Jakub's
> bitfield stuff be used more. Kalle, thoughts?

Yeah, the bitfield macros are handy and we should definitely switch to
them (slowly). But definitely not a must for these SDIO patches, more
like a nice bonus.

--=20
Kalle Valo=
