Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34244 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753393AbeDZUf7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 16:35:59 -0400
Subject: Re: [PATCH v2] ath10k: fix crash in recent 3.5.3 9984 firmware due
 wrong handling of peer_bw_rxnss_override parameter
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20180426092848.23069-1-s.gottschall@dd-wrt.com>
 <f288f18c-684d-2ff9-5739-648e8e716653@candelatech.com>
 <db214e94-1052-d6fa-744a-7c8ebcc84aee@dd-wrt.com>
Cc: kvalo@codeaurora.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <96d512b3-3261-c6cf-e0eb-a9f5fe91f3b8@candelatech.com> (sfid-20180426_223603_003831_3F704ABC)
Date: Thu, 26 Apr 2018 13:35:56 -0700
MIME-Version: 1.0
In-Reply-To: <db214e94-1052-d6fa-744a-7c8ebcc84aee@dd-wrt.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2018 01:21 PM, Sebastian Gottschall wrote:
> Am 26.04.2018 um 17:30 schrieb Ben Greear:
>> On 04/26/2018 02:28 AM, s.gottschall@dd-wrt.com wrote:
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
>>> ---
>>>  drivers/net/wireless/ath/ath10k/mac.c | 36 +++++++++++++++++++----------------
>>>  drivers/net/wireless/ath/ath10k/wmi.c |  4 +---
>>>  drivers/net/wireless/ath/ath10k/wmi.h | 14 +++++++++++++-
>>>  3 files changed, 34 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>>> index 5be6386ede8f..df79af89ee71 100644
>>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>> @@ -2505,8 +2505,9 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
>>>      if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
>>>          arg->peer_flags |= ar->wmi.peer_flags->bw80;
>>>
>>> -    if (sta->bandwidth == IEEE80211_STA_RX_BW_160)
>>> +    if (sta->bandwidth == IEEE80211_STA_RX_BW_160) {
>>>          arg->peer_flags |= ar->wmi.peer_flags->bw160;
>>> +    }
>>>
>>>      /* Calculate peer NSS capability from VHT capabilities if STA
>>>       * supports VHT.
>>> @@ -2529,22 +2530,25 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
>>>      arg->peer_vht_rates.tx_mcs_set = ath10k_peer_assoc_h_vht_limit(
>>>          __le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map), vht_mcs_mask);
>>>
>>> -    ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
>>> -           sta->addr, arg->peer_max_mpdu, arg->peer_flags);
>>> +    if (arg->peer_num_spatial_streams && (arg->peer_phymode == MODE_11AC_VHT160 || arg->peer_phymode == MODE_11AC_VHT80_80)) {
>>> +        arg->peer_bw_rxnss_override = BW_NSS_FWCONF_160(arg->peer_num_spatial_streams);
>>> +    }
>>
>> So, an 80Mhz peer could be 4x4 and could connect to a VHT-160 AP. From what I can tell,
>> the VHT-160 AP can talk 4x4 @ 80Mhz to the peer in this case, but if peer is VHT-160,
>> then of course it can only talk at 2x2.
>>
>> So, I don't think you can just look at the peer_num_spatial_streams here.
> no? rxnss_override is only taked if peer phymode is vht160 or vht80_80. vht80 is not considered in that code PEER phy_mode, not HOST phy_mode
> this parameter is a assoc per peer parameter as far as i can say here.
> consider that the firmware will accept anything except 0 for peer_bw_rxnss_override in vht160 operation mode
> if a peer is 80 mhz, the code will be skipped here.

 From what I can tell, this feature is supposed to configure the rate-ctrl in the firmware to know that
it can only send 1x1 or 2x2 when sending at 160Mhz, but that it can send at higher NSS if it sends
at 80Mhz or lower.

If a 2x2 peer connects to the AP, will it have peer_num_spatial_streams set to 2?  If so,
then your code will configure the peer_bw_rxnss_override to indicate it can send at 160Mhz
2x2 as well, right?  And if so, then that is incorrect.

Probably if you connected something like a IPQ4019 station to a 9984 AP configured for 160Mhz,
the peer_bw_rxnss_override would be set to 2x2 instead of 1x1?


>>> -    if (arg->peer_vht_rates.rx_max_rate &&
>>> -        (sta->vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK)) {
>>> -        switch (arg->peer_vht_rates.rx_max_rate) {
>>> -        case 1560:
>>> -            /* Must be 2x2 at 160Mhz is all it can do. */
>>> -            arg->peer_bw_rxnss_override = 2;
>>> -            break;
>>> -        case 780:
>>> -            /* Can only do 1x1 at 160Mhz (Long Guard Interval) */
>>> -            arg->peer_bw_rxnss_override = 1;
>>> -            break;
>>> -        }
>>
>> This old code does look wrong, the firmware is using zero-based, so override-0 == nss-1, override-1 == nss-2.
> 0 = crash
>
> and 1 and 2 is wrong.

Yes, it should be 0 and 1.  The old code | in the (1<<31) later.

>
> +#define BW_NSS_FWCONF_MAP_ENABLE             (1 << 31)
> +#define BW_NSS_FWCONF_MAP_160MHZ_S           (0)
> +#define BW_NSS_FWCONF_MAP_160MHZ_M           (0x00000007)
> +#define BW_NSS_FWCONF_MAP_80_80MHZ_S         (3)
> +#define BW_NSS_FWCONF_MAP_80_80MHZ_M         (0x00000038)
>>
>> This is confusing enough that it deserves a comment in the code I think....
> the removal doesnt deserve a comment. i dont know how to explain that its simply wrong. it uses the wrong
> bit masks and this has been written in the initial patch description

I think a comment like this would be helpful:

/* Note that the rxnss_override is 0 based, so 0 means nss-1 and 7 means nss-8. */

>>
>>> +    if (arg->peer_num_spatial_streams && arg->peer_phymode == MODE_11AC_VHT80_80) {
>>> +        arg->peer_bw_rxnss_override |= BW_NSS_FWCONF_80_80(arg->peer_num_spatial_streams);
>>>      }
>>> +
>>> +    /* In very exceptional  conditions it is observed  that
>>> +     * firmware was receiving bw_rxnss_override as 0 for peer from host, and resulting in Target Assert.
>>> +     * Changing the rxnss_override to minimum nss. This is a temporary WAR. Needs to be fixed
>>> +     * properly.
>>> +     */
>>> +    if (!arg->peer_num_spatial_streams && (arg->peer_phymode == MODE_11AC_VHT80_80 || arg->peer_phymode == MODE_11AC_VHT160)) {
>>> +        arg->peer_bw_rxnss_override = BW_NSS_FWCONF_MAP_ENABLE;
>>> +    }
>>> +
>>> +    ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
>>> +           sta->addr, arg->peer_max_mpdu, arg->peer_flags);
>>>  }
>>>
>>>  static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
>>> @@ -2696,9 +2700,9 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
>>>      ath10k_peer_assoc_h_crypto(ar, vif, sta, arg);
>>>      ath10k_peer_assoc_h_rates(ar, vif, sta, arg);
>>>      ath10k_peer_assoc_h_ht(ar, vif, sta, arg);
>>> +    ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
>>>      ath10k_peer_assoc_h_vht(ar, vif, sta, arg);
>>>      ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
>>> -    ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
>>>
>>>      return 0;
>>>  }
>>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
>>> index 2c36256a441d..7d72fdc703c8 100644
>>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>>> @@ -7212,9 +7212,7 @@ ath10k_wmi_peer_assoc_fill_10_4(struct ath10k *ar, void *buf,
>>>
>>>      ath10k_wmi_peer_assoc_fill_10_2(ar, buf, arg);
>>>      if (arg->peer_bw_rxnss_override)
>>> -        cmd->peer_bw_rxnss_override =
>>> -            __cpu_to_le32((arg->peer_bw_rxnss_override - 1) |
>>> -                      BIT(PEER_BW_RXNSS_OVERRIDE_OFFSET));
>>> +        cmd->peer_bw_rxnss_override = __cpu_to_le32(arg->peer_bw_rxnss_override);
>>>      else
>>>          cmd->peer_bw_rxnss_override = 0;
>>>  }
>>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
>>> index 46ae19bb2c92..1fe0aa5523a6 100644
>>> --- a/drivers/net/wireless/ath/ath10k/wmi.h
>>> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
>>> @@ -6380,7 +6380,19 @@ struct wmi_10_2_peer_assoc_complete_cmd {
>>>      __le32 info0; /* WMI_PEER_ASSOC_INFO0_ */
>>>  } __packed;
>>>
>>> -#define PEER_BW_RXNSS_OVERRIDE_OFFSET  31
>>> +#define BW_NSS_FWCONF_MAP_ENABLE             (1 << 31)
>>> +#define BW_NSS_FWCONF_MAP_160MHZ_S           (0)
>>> +#define BW_NSS_FWCONF_MAP_160MHZ_M           (0x00000007)
>>> +#define BW_NSS_FWCONF_MAP_80_80MHZ_S         (3)
>>> +#define BW_NSS_FWCONF_MAP_80_80MHZ_M         (0x00000038)
>>
>> Older FW does not pay attention to the 80_80 bits.  It uses masks so it is
>> backwards-compat, but maybe worth a comment.
> i took that masks from recent 3.5.3 based qca code. its correct and if its backward compatible, it's still correct
> i mean the old code did not coment anything. so dont know how to write anything more about it now. see patch description
>
>>
>>> +#define BW_NSS_FWCONF_MAP_M                  (0x0000003F)
>>> +
>>> +#define GET_BW_NSS_FWCONF_160(x)             ((((x) & BW_NSS_FWCONF_MAP_160MHZ_M) >> BW_NSS_FWCONF_MAP_160MHZ_S) + 1)
>>> +#define GET_BW_NSS_FWCONF_80_80(x)           ((((x) & BW_NSS_FWCONF_MAP_80_80MHZ_M) >> BW_NSS_FWCONF_MAP_80_80MHZ_S) + 1)
>>> +
>>> +/* Values defined to set 160 MHz Bandwidth NSS Mapping into FW*/
>>> +#define BW_NSS_FWCONF_160(x)          (BW_NSS_FWCONF_MAP_ENABLE | (((x - 1) << BW_NSS_FWCONF_MAP_160MHZ_S) & BW_NSS_FWCONF_MAP_160MHZ_M))
>>> +#define BW_NSS_FWCONF_80_80(x)        (BW_NSS_FWCONF_MAP_ENABLE | (((x - 1) << BW_NSS_FWCONF_MAP_80_80MHZ_S) & BW_NSS_FWCONF_MAP_80_80MHZ_M))
>>>
>>>  struct wmi_10_4_peer_assoc_complete_cmd {
>>>      struct wmi_10_2_peer_assoc_complete_cmd cmd;
>>>
>>
>> Thanks,
>> Ben
>>
>

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
