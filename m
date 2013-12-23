Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39561 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3LWNzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 08:55:13 -0500
Received: by mail-lb0-f170.google.com with SMTP id c11so2293902lbj.15
        for <linux-wireless@vger.kernel.org>; Mon, 23 Dec 2013 05:55:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87d2koxd8m.fsf@kamboji.qca.qualcomm.com>
References: <1387653946-2988-1-git-send-email-janusz.dziedzic@tieto.com>
	<87d2koxd8m.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 23 Dec 2013 14:55:12 +0100
Message-ID: <CALhHN=q4qgexWTfmmizt5+kNjkM6MfscYp=0VvEnj4YMHrRc1A@mail.gmail.com> (sfid-20131223_145519_258530_485FAF76)
Subject: Re: [PATCH] ath10k: add set_bitrate_mask callback
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 December 2013 08:01, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> Add set_bitrate_mask callback. Currently
>> ath10k HW is limited to handle only single
>> fixed rate setting or limit number of used
>> spatial streams.
>>
>> Example:
>> iw wlanX set bitrates legacy-5 ht-mcs-5 vht-mcs-5 2:9
>> will setup VHT, nss=2, mcs=9
>>
>> iw wlanX set bitrates legacy-5 18 ht-mcs-5 vht-mcs-5
>> will setup legacy, 18Mbps
>>
>> iw wlanX set bitrates legacy-5 ht-mcs-5 3 vht-mcs-5
>> will setup HT, nss=1, mcs=3
>>
>> iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9
>> will setup nss=1
>>
>> iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9 2:0-9
>> will setup nss=2
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> I see a new warning with this patch:
>
> ath10k/mac.c:3593:52: error: unknown field name in initializer
>
Will fix this.

>> Depends on, nl80211: add VHT support for set_bitrate_mask
>
> Good, I need to always know this. I now merged wireless-next to ath-next
> to get the dependency included.
>
>> --- a/drivers/net/wireless/ath/ath10k/wmi.h
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
>> @@ -3003,6 +3003,24 @@ struct wmi_vdev_install_key_arg {
>>       const void *key_data;
>>  };
>>
>> +/*
>> + * CCK:  0 - 11Mbps, 1 - 5,5Mbps, 2 - 2Mbps, 3 - 1Mbps,
>> + *       4 - 11Mbps (s), 5 - 5,5Mbps (s), 6 - 2Mbps (s)
>> + * OFDM: 0 - 48Mbps, 1 - 24Mbps, 2 - 12Mbps, 3 - 6Mbps,
>> + *       4 - 54Mbps, 5 - 36Mbps, 6 - 18Mbps, 7 - 9Mbps
>> + * HT/VHT: MCS index
>> + */
>> +struct wmi_vdev_fixed_rate {
>> +     union {
>> +             u8 rate;
>> +             struct {
>> +                     u8 preamble:2, /* %WMI_RATE_PREAMBLE_ */
>> +                        nss:2,
>> +                        rate_mcs:4; /* see above */
>> +             } __packed;
>> +     } __packed;
>> +} __packed;
>
> Bitfields are frowned upon in kernel, better to use SM() and MS().
>
I don't use them, just put as a documentation.
Will add note that this bitfields should not be used.

BR
Janusz
