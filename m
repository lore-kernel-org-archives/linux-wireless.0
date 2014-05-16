Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52708 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaEPGpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 02:45:21 -0400
Received: by mail-lb0-f171.google.com with SMTP id 10so1579342lbg.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 23:45:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5374F84E.1090208@candelatech.com>
References: <1395692698-4745-1-git-send-email-janusz.dziedzic@tieto.com>
	<1395692698-4745-2-git-send-email-janusz.dziedzic@tieto.com>
	<5374F84E.1090208@candelatech.com>
Date: Fri, 16 May 2014 08:45:19 +0200
Message-ID: <CALhHN=oUaP7rQB+hP8iyjEPiVqbbXY8_o5g=JwBcQpt36AJO2Q@mail.gmail.com> (sfid-20140516_084524_826554_8392FF55)
Subject: Re: [PATCH v2 2/2] ath10k: fix rssi and rate reporting
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 May 2014 19:24, Ben Greear <greearb@candelatech.com> wrote:
> I have a few questions on this patch (long since accepted upstream).
>
> First, why do you only memset the rx_status if START_VALID is set,
> and why do you not set:
>
> rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL
>
> in an else clause if START_VALID is not set?
>
> The patch definitely helps, but I'm still getting less accuracy than expected
> (as compared to ath9k going through a similar rate vs range test).
>

>From START_VALID to END_VALID we have same RSSI/RATES like reported
when START_VALID.
We could wait to get all packets from START_VALID to END_VALID and
after that report them to upper
layer. But currently we don't do that and report what we have and have
to remember RSSI/RATES.

BTW there is still a problem with TSF which is valid only when
END_VALID. So in current implementation we don't report this correctly
for packets we report when only START_VALID.

BR
Janusz

>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>> @@ -1154,8 +1154,6 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
>>
>>       lockdep_assert_held(&htt->rx_ring.lock);
>>
>> -     memset(rx_status, 0, sizeof(*rx_status));
>> -
>>       fw_desc_len = __le16_to_cpu(rx->prefix.fw_rx_desc_bytes);
>>       fw_desc = (u8 *)&rx->fw_desc;
>>
>> @@ -1164,8 +1162,11 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
>>       mpdu_ranges = htt_rx_ind_get_mpdu_ranges(rx);
>>
>>       /* Fill this once, while this is per-ppdu */
>> -     rx_status->signal  = ATH10K_DEFAULT_NOISE_FLOOR;
>> -     rx_status->signal += rx->ppdu.combined_rssi;
>> +     if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_START_VALID) {
>> +             memset(rx_status, 0, sizeof(*rx_status));
>> +             rx_status->signal  = ATH10K_DEFAULT_NOISE_FLOOR +
>> +                                  rx->ppdu.combined_rssi;
>> +     }
>>
>>       if (rx->ppdu.info0 & HTT_RX_INDICATION_INFO0_END_VALID) {
>>               /* TSF available only in 32-bit */
>>
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
