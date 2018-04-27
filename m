Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49304 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758578AbeD0QHv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 12:07:51 -0400
Subject: Re: [PATCH v2] ath10k: fix crash in recent 3.5.3 9984 firmware due
 wrong handling of peer_bw_rxnss_override parameter
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20180426092848.23069-1-s.gottschall@dd-wrt.com>
 <f288f18c-684d-2ff9-5739-648e8e716653@candelatech.com>
 <db214e94-1052-d6fa-744a-7c8ebcc84aee@dd-wrt.com>
 <96d512b3-3261-c6cf-e0eb-a9f5fe91f3b8@candelatech.com>
 <8263a720-07a2-dc5d-f8fc-2153574cbafc@dd-wrt.com>
Cc: kvalo@codeaurora.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <96f0393e-6bab-d397-d2b6-4538da7fc275@candelatech.com> (sfid-20180427_180755_933097_1831EE61)
Date: Fri, 27 Apr 2018 09:07:48 -0700
MIME-Version: 1.0
In-Reply-To: <8263a720-07a2-dc5d-f8fc-2153574cbafc@dd-wrt.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2018 09:40 PM, Sebastian Gottschall wrote:
> Am 26.04.2018 um 22:35 schrieb Ben Greear:
>> On 04/26/2018 01:21 PM, Sebastian Gottschall wrote:
>>> Am 26.04.2018 um 17:30 schrieb Ben Greear:
>>>> On 04/26/2018 02:28 AM, s.gottschall@dd-wrt.com wrote:
>>>>> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>>>>
>>>>> current handling of peer_bw_rxnss_override parameter is based on guessing the VHT160/8080 capability by rx rate. this is wrong and may lead
>>>>> to a non initialized peer_bw_rxnss_override parameter which is required since VHT160 operation mode only supports 2x2 chainmasks in addition the original code
>>>>> initialized the parameter with wrong masked values.
>>>>> This patch uses the peer phymode and peer nss information for correct initialisation of the peer_bw_rxnss_override parameter.
>>>>> if this peer information is not available, we initialize the parameter by minimum nss which is suggested by QCA as temporary workaround according
>>>>> to the QCA sourcecodes.
>>>>>
>>>>> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>>>>
>>>>> v2: remove debug messages
>>>>> ---
>>>>>  drivers/net/wireless/ath/ath10k/mac.c | 36 +++++++++++++++++++----------------
>>>>>  drivers/net/wireless/ath/ath10k/wmi.c |  4 +---
>>>>>  drivers/net/wireless/ath/ath10k/wmi.h | 14 +++++++++++++-
>>>>>  3 files changed, 34 insertions(+), 20 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>>>>> index 5be6386ede8f..df79af89ee71 100644
>>>>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>>>>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>>>> @@ -2505,8 +2505,9 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
>>>>>      if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
>>>>>          arg->peer_flags |= ar->wmi.peer_flags->bw80;
>>>>>
>>>>> -    if (sta->bandwidth == IEEE80211_STA_RX_BW_160)
>>>>> +    if (sta->bandwidth == IEEE80211_STA_RX_BW_160) {
>>>>>          arg->peer_flags |= ar->wmi.peer_flags->bw160;
>>>>> +    }
>>>>>
>>>>>      /* Calculate peer NSS capability from VHT capabilities if STA
>>>>>       * supports VHT.
>>>>> @@ -2529,22 +2530,25 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
>>>>>      arg->peer_vht_rates.tx_mcs_set = ath10k_peer_assoc_h_vht_limit(
>>>>>          __le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map), vht_mcs_mask);
>>>>>
>>>>> -    ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
>>>>> -           sta->addr, arg->peer_max_mpdu, arg->peer_flags);
>>>>> +    if (arg->peer_num_spatial_streams && (arg->peer_phymode == MODE_11AC_VHT160 || arg->peer_phymode == MODE_11AC_VHT80_80)) {
>>>>> +        arg->peer_bw_rxnss_override = BW_NSS_FWCONF_160(arg->peer_num_spatial_streams);
>>>>> +    }
>>>>
>>>> So, an 80Mhz peer could be 4x4 and could connect to a VHT-160 AP. From what I can tell,
>>>> the VHT-160 AP can talk 4x4 @ 80Mhz to the peer in this case, but if peer is VHT-160,
>>>> then of course it can only talk at 2x2.
>>>>
>>>> So, I don't think you can just look at the peer_num_spatial_streams here.
>>> no? rxnss_override is only taked if peer phymode is vht160 or vht80_80. vht80 is not considered in that code PEER phy_mode, not HOST phy_mode
>>> this parameter is a assoc per peer parameter as far as i can say here.
>>> consider that the firmware will accept anything except 0 for peer_bw_rxnss_override in vht160 operation mode
>>> if a peer is 80 mhz, the code will be skipped here.
>>
>> From what I can tell, this feature is supposed to configure the rate-ctrl in the firmware to know that
>> it can only send 1x1 or 2x2 when sending at 160Mhz, but that it can send at higher NSS if it sends
>> at 80Mhz or lower.
> right. but thats exactly what it should does in case that a peer is connecting with vht160 / 80_80
> and the peer itself does also send his own nss capabilities which is used if available. if not ,it uses the fallback.
>>
>> If a 2x2 peer connects to the AP, will it have peer_num_spatial_streams set to 2?
> yes. i had some debug code in my initial early versions. the peer does transmit his own nss capabilities.
>> If so,
>> then your code will configure the peer_bw_rxnss_override to indicate it can send at 160Mhz
>> 2x2 as well, right?  And if so, then that is incorrect.
> no. since nss_override is only set if peer phymode is 160 mhz as well

The peer can run at 2x2 80Mhz and 1x1 160Mhz at the same time, so it can advertise
2x2 nss and phy-mode of 160Mhz when associating to the 160Mhz AP, but the peer can only do 1x1 at 160Mhz.  There
is no standard way I know of for the peer to tell you specifically that it can only do
1x1 at 160Mhz and also 2x2 at 80Mhz in this case.

That is why this rxnns_override exists, to hack around this problem.

Your patch is going to break in this case as far as I can tell.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
