Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38200 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbeD1Phm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Apr 2018 11:37:42 -0400
Subject: Re: [PATCH v4] ath10k: fix crash in recent 3.5.3 9984 firmware due
 wrong handling of peer_bw_rxnss_override parameter
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20180428004752.16659-1-s.gottschall@dd-wrt.com>
 <b9039c6f-17bd-2d30-79ec-4b70dc76ad75@candelatech.com>
 <fa914b1a-3529-f179-d7a0-b2aec54b1c8f@dd-wrt.com>
Cc: kvalo@codeaurora.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <e1e5da2a-cd36-f460-f986-eccdabad8b73@candelatech.com> (sfid-20180428_174026_973247_29480E97)
Date: Sat, 28 Apr 2018 08:37:26 -0700
MIME-Version: 1.0
In-Reply-To: <fa914b1a-3529-f179-d7a0-b2aec54b1c8f@dd-wrt.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/28/2018 08:26 AM, Sebastian Gottschall wrote:
> Am 28.04.2018 um 17:01 schrieb Ben Greear:
>>
>>
>> On 04/27/2018 05:47 PM, s.gottschall@dd-wrt.com wrote:
>>> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>>
>>> current handling of peer_bw_rxnss_override parameter is based on guessing the VHT160/8080 capability by rx rate. this is wrong and may lead
>>> to a non initialized peer_bw_rxnss_override parameter which is required since VHT160 operation mode only supports 2x2 chainmasks in addition the original code
>>> initialized the parameter with wrong masked values.
>>> This patch uses the peer phymode and peer nss information for correct initialisation of the peer_bw_rxnss_override parameter.
>>> if this peer information is not available, we initialize the parameter by minimum nss which is suggested by QCA as temporary workaround according
>>> to the QCA sourcecodes.
>>>
>>> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>>
>>> v2: remove debug messages
>>> v3: apply some cosmetics, update documentation
>>> v4: fix compile warning and truncate nss to maximum of 2x2 since current chipsets only support 2x2 at vht160
>>> ---
>>>  drivers/net/wireless/ath/ath10k/mac.c | 44 ++++++++++++++++++---------
>>>  drivers/net/wireless/ath/ath10k/wmi.c |  7 +----
>>>  drivers/net/wireless/ath/ath10k/wmi.h | 14 ++++++++-
>>>  3 files changed, 43 insertions(+), 22 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>>> index 5be6386ede8f..de8a099c9f5a 100644
>>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>> @@ -2528,23 +2528,37 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
>>>          __le16_to_cpu(vht_cap->vht_mcs.tx_highest);
>>>      arg->peer_vht_rates.tx_mcs_set = ath10k_peer_assoc_h_vht_limit(
>>>          __le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map), vht_mcs_mask);
>>> +    arg->peer_bw_rxnss_override = 0;
>>> +
>>> +    if (arg->peer_num_spatial_streams) {
>>
>> Check for the 80+80 or 160 instead of num-spatial-streams, if if something has
>> nss == 0, then act like it is 1 instead since it is obviously configured incorrect.
> this check is bellow. see the switch statement for the VHT160, 80_80 case.
> if nss 0, it must fail here since we cannot handle nss = 0, in that case just bit 31 is masked
>
>>
>>> +        int nss160 = arg->peer_num_spatial_streams;
>>
>> I think this line should be:
>>         int nss160 = arg->peer_num_spatial_streams / 2;
> no. makes no sense. 2 would get 1 and 1 turns to zero. makes no sense
> read the macro BW_NSS_FWCONF_160 first. it already does nss160-1
> this would lead to -1 if spatial_streams is 1

Well, nss160 should be the number of streams we can use at 160 Mhz.  The macro
can convert to zero-based api that the firmware wants.  A 9984 will have nss == 4,
but you want nss160 to be 2.  A 4019 will have nss == 2, but nss160 should be 1.


>>                 if (nss160 == 0) { nss160 = 1; } /* deal with mis-configured nss */
> no
> if peer_num_spatial_stream is 0 (so nss160 too), the code is not triggered. but another code. same as above

If NSS was 1, and you do 1/2, you get zero.

>
> if (!arg->peer_num_spatial_streams && (arg->peer_phymode == MODE_11AC_VHT80_80 || arg->peer_phymode == MODE_11AC_VHT160)) {
>        arg->peer_bw_rxnss_override = BW_NSS_FWCONF_MAP_ENABLE;
>  }
>>
>> If you have a 4019 client, it will have arg->peer_num_spatial_streams == 2, but
>> it can only do 1x1 at 160Mhz.
> peer_num_spatial_streams is calculated from mcs rate set. so why should 4019 announce 2x2 if it just can to 1x1.
> have you checked the mcs set at assoc management frame?

You are confused about nss vs the 160nss.  They are different.  I do not know how to explain
this better.  Dig through the firmware source and look at how they are used.  Basically, if
rate-ctrl decides 80Mhz is best, it can send at the normal 80Mhz NSS (so, 4 for 9984, 2 for 4019),
but if rate-ctrl uses 160, it uses the different nss max (2 for 9984, one for 4019).

>>
>>
>>> +        /* truncate vht160 nss value to 2x2 since all known chipsets do not support more than 2x2 in vht160 modes */
>>> +        if (nss160 > 2)
>>> +            nss160 = 2;
>>> +        /* in case if peer is connected with vht160 or vht80+80, we need to properly adjust rxnss parameters */
>>> +        switch(arg->peer_phymode) {
>>> +        case MODE_11AC_VHT80_80:
>>> +            arg->peer_bw_rxnss_override = BW_NSS_FWCONF_80_80(nss160);
>>> +        /* fall through */
>>> +        case MODE_11AC_VHT160:
>>> +            arg->peer_bw_rxnss_override |= BW_NSS_FWCONF_160(nss160);
>>
>> From looking at firmware, it will just ignore the bits it does not need, so you do not need
>> to special case adding the 80_80 fields, you can do more like my patch and just always add
>> those bits.
> i'm following the reference code. in case 80_80 only is configure vht160 nd 80_80 must be masked. for everything else vht160 only must be masked.
> thats the meaning. there are 2 override masks. independend for vht160 and 80_80. for sure i can do always both, but the reference code does not
> and who knows what else changed in the firmware. consider that the crash bug first occured on 3.5.3. your CT codebase is older as far as i know

I looked at both my code and the most recent QCA FW code.  You can leave the exra
complexity in the code if you wish, it at least does not break anything.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
