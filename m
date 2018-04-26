Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:53501 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756589AbeDZPMO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 11:12:14 -0400
Subject: Re: [PATCH v1] ath10k: fix band_center_freq handling for VHT160 in
 recent firmwares
To: Ben Greear <greearb@candelatech.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
References: <20180426094357.24358-1-s.gottschall@dd-wrt.com>
 <19b8766e-d474-31d3-ff38-993498ee670d@candelatech.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <da5c7c56-9a41-99f0-28be-3a2c8e9fabbf@dd-wrt.com> (sfid-20180426_171222_072897_828BF8AD)
Date: Thu, 26 Apr 2018 17:12:11 +0200
MIME-Version: 1.0
In-Reply-To: <19b8766e-d474-31d3-ff38-993498ee670d@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 26.04.2018 um 15:44 schrieb Ben Greear:
>
>
> On 04/26/2018 02:43 AM, s.gottschall@dd-wrt.com wrote:
>> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>
>> starting with firmware 10.4.3.4.x series QCA changed the handling of 
>> the channel property band_center_freq1 and band_center_freq2 in 
>> vht160 operation mode
>> likelly for backward compatiblity with vht80 only capable clients.
>> this patch adjusts the handling to get vht160 to work again with 
>> official qca firmwares newer than 3.3
>> consider that this patch will not work with older firmwares anymore. 
>> to avoid undefined behaviour this we disable vht160 capability for 
>> outdated firmwares
>
> We should be able to use a feature-flag or otherwise determine if the 
> firmware needs the old or new
> API and make the driver able to handle both.
the new firmware must be used as is and it works. the old firmware can 
be detected on the missing vht cap flag.
but thats not my task. i can only use feature flags if they are included 
within the qca firmwares. but they arent
the old pre 3.3 firmwares should be treated as obsolete. they are more 
than 2 years old and do not announce vht160 capability
even if it works with some ignorance, but on the other side the it has 
backward incompatiblies with older vht80 only clients.
this is why the new way was introduced
>
> Thanks,
> Ben
>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c |  7 -------
>>  drivers/net/wireless/ath/ath10k/wmi.c | 11 ++++++++---
>>  2 files changed, 8 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c 
>> b/drivers/net/wireless/ath/ath10k/mac.c
>> index 5be6386ede8f..d1239d40ac19 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -4449,13 +4449,6 @@ static struct ieee80211_sta_vht_cap 
>> ath10k_create_vht_cap(struct ath10k *ar)
>>          vht_cap.cap |= val;
>>      }
>>
>> -    /* Currently the firmware seems to be buggy, don't enable 80+80
>> -     * mode until that's resolved.
>> -     */
>> -    if ((ar->vht_cap_info & IEEE80211_VHT_CAP_SHORT_GI_160) &&
>> -        (ar->vht_cap_info & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) 
>> == 0)
>> -        vht_cap.cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
>> -
>>      mcs_map = 0;
>>      for (i = 0; i < 8; i++) {
>>          if ((i < ar->num_rf_chains) && (ar->cfg_tx_chainmask & BIT(i)))
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c 
>> b/drivers/net/wireless/ath/ath10k/wmi.c
>> index 2c36256a441d..d78b8857a513 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -1671,13 +1671,18 @@ void ath10k_wmi_put_wmi_channel(struct 
>> wmi_channel *ch,
>>          flags |= WMI_CHAN_FLAG_HT40_PLUS;
>>      if (arg->chan_radar)
>>          flags |= WMI_CHAN_FLAG_DFS;
>> -
>> +    ch->band_center_freq2 = 0;
>>      ch->mhz = __cpu_to_le32(arg->freq);
>>      ch->band_center_freq1 = __cpu_to_le32(arg->band_center_freq1);
>>      if (arg->mode == MODE_11AC_VHT80_80)
>>          ch->band_center_freq2 = __cpu_to_le32(arg->band_center_freq2);
>> -    else
>> -        ch->band_center_freq2 = 0;
>> +    if (arg->mode == MODE_11AC_VHT160)  {
>> +        if (arg->freq < arg->band_center_freq1)
>> +            ch->band_center_freq1 = 
>> __cpu_to_le32(arg->band_center_freq1 - 40);
>> +        else
>> +            ch->band_center_freq1 = 
>> __cpu_to_le32(arg->band_center_freq1 + 40);
>> +        ch->band_center_freq2 = __cpu_to_le32(arg->band_center_freq1);
>> +    }
>>      ch->min_power = arg->min_power;
>>      ch->max_power = arg->max_power;
>>      ch->reg_power = arg->max_reg_power;
>>
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
