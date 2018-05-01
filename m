Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46292 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753423AbeEAN2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 May 2018 09:28:43 -0400
Subject: Re: [PATCH v7] ath10k: fix crash in recent 3.5.3 9984 firmware due
 wrong handling of peer_bw_rxnss_override parameter
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20180430213046.8393-1-s.gottschall@dd-wrt.com>
 <5AE78F7D.7090909@candelatech.com>
 <caeeaac0-dd71-89f3-8690-88d4a58ec5a0@dd-wrt.com>
Cc: kvalo@codeaurora.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <7297b5d2-21eb-1554-80ab-2975fffa9daf@candelatech.com> (sfid-20180501_152847_521392_6378818F)
Date: Tue, 1 May 2018 06:28:34 -0700
MIME-Version: 1.0
In-Reply-To: <caeeaac0-dd71-89f3-8690-88d4a58ec5a0@dd-wrt.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/30/2018 03:14 PM, Sebastian Gottschall wrote:
>
>>> +    /* only 4x4 configuration do support 2x2 for VHT160, everything else must use 1x1 */
>>> +    if (ar->cfg_rx_chainmask == 15)
>>> +        nss160 = arg->peer_num_spatial_streams <= 2 ? arg->peer_num_spatial_streams : 2;
>>
>> If peer nss == 3, then nss160 must be 1x1.  That is why I previously suggested the code that set nss160 to equal nss / 2
>> (with special case to bump nss160 to 1x1 if nss == 1.
> btw. it doesnt matter if the peer sends with 3x3 or even 4x4, i still can receive with 2x2. thats no conflict. switching back to 1x1 of the peer sends vht160 with 3x3 makes no real sense
> i dont have to turn off a chain, if i'm able todo 2x2, no matter what the peer does. i just have to limit the maximum

If the local system is nss 4x4 and the remote is nss 3x3, then the peer_num_spatial_streams will be 3 and the nss160 should be 1.

At least for ath10k chips, it requires 2 chains to receive a 1x1 signal at 160Mhz, so that is why
a nss 3x3 cannot receive at 2x2 160Mhz.

If you still think this makes no sense, think about it a bit before responding!

Thanks,
Ben

>
>>
>> A 9984 peer with chainmask configured to 0x7 would hit this case I think.
>>
>> Overall this looks better than previous patches though.
>>
>> Thanks,
>> Ben
>>
>>> +
>>> +    /* in case if peer is connected with vht160 or vht80+80, we need to properly adjust rxnss parameters otherwise firmware will raise a assert */
>>> +    switch(arg->peer_phymode) {
>>> +    case MODE_11AC_VHT80_80:
>>> +        arg->peer_bw_rxnss_override = BW_NSS_FWCONF_80_80(nss160);
>>> +    /* fall through */
>>> +    case MODE_11AC_VHT160:
>>> +        arg->peer_bw_rxnss_override |= BW_NSS_FWCONF_160(nss160);
>>> +    break;
>>> +    default:
>>> +    break;
>>>       }
>>> +
>>> +    ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x peer_bw_rxnss_override 0x%x\n",
>>> +           sta->addr, arg->peer_max_mpdu, arg->peer_flags, arg->peer_bw_rxnss_override);
>>>   }
>>>
>>>   static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
>>> @@ -2696,9 +2700,9 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
>>>       ath10k_peer_assoc_h_crypto(ar, vif, sta, arg);
>>>       ath10k_peer_assoc_h_rates(ar, vif, sta, arg);
>>>       ath10k_peer_assoc_h_ht(ar, vif, sta, arg);
>>> +    ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
>>>       ath10k_peer_assoc_h_vht(ar, vif, sta, arg);
>>>       ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
>>> -    ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
>>>
>>>       return 0;
>>>   }
>>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
>>> index 2c36256a441d..3797dca317ff 100644
>>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>>> @@ -7211,12 +7211,7 @@ ath10k_wmi_peer_assoc_fill_10_4(struct ath10k *ar, void *buf,
>>>       struct wmi_10_4_peer_assoc_complete_cmd *cmd = buf;
>>>
>>>       ath10k_wmi_peer_assoc_fill_10_2(ar, buf, arg);
>>> -    if (arg->peer_bw_rxnss_override)
>>> -        cmd->peer_bw_rxnss_override =
>>> -            __cpu_to_le32((arg->peer_bw_rxnss_override - 1) |
>>> -                      BIT(PEER_BW_RXNSS_OVERRIDE_OFFSET));
>>> -    else
>>> -        cmd->peer_bw_rxnss_override = 0;
>>> +    cmd->peer_bw_rxnss_override = __cpu_to_le32(arg->peer_bw_rxnss_override);
>>>   }
>>>
>>>   static int
>>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
>>> index 46ae19bb2c92..1fe0aa5523a6 100644
>>> --- a/drivers/net/wireless/ath/ath10k/wmi.h
>>> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
>>> @@ -6380,7 +6380,19 @@ struct wmi_10_2_peer_assoc_complete_cmd {
>>>       __le32 info0; /* WMI_PEER_ASSOC_INFO0_ */
>>>   } __packed;
>>>
>>> -#define PEER_BW_RXNSS_OVERRIDE_OFFSET  31
>>> +#define BW_NSS_FWCONF_MAP_ENABLE             (1 << 31)
>>> +#define BW_NSS_FWCONF_MAP_160MHZ_S           (0)
>>> +#define BW_NSS_FWCONF_MAP_160MHZ_M           (0x00000007)
>>> +#define BW_NSS_FWCONF_MAP_80_80MHZ_S         (3)
>>> +#define BW_NSS_FWCONF_MAP_80_80MHZ_M         (0x00000038)
>>> +#define BW_NSS_FWCONF_MAP_M                  (0x0000003F)
>>> +
>>> +#define GET_BW_NSS_FWCONF_160(x)             ((((x) & BW_NSS_FWCONF_MAP_160MHZ_M) >> BW_NSS_FWCONF_MAP_160MHZ_S) + 1)
>>> +#define GET_BW_NSS_FWCONF_80_80(x)           ((((x) & BW_NSS_FWCONF_MAP_80_80MHZ_M) >> BW_NSS_FWCONF_MAP_80_80MHZ_S) + 1)
>>> +
>>> +/* Values defined to set 160 MHz Bandwidth NSS Mapping into FW*/
>>> +#define BW_NSS_FWCONF_160(x)          (BW_NSS_FWCONF_MAP_ENABLE | (((x - 1) << BW_NSS_FWCONF_MAP_160MHZ_S) & BW_NSS_FWCONF_MAP_160MHZ_M))
>>> +#define BW_NSS_FWCONF_80_80(x)        (BW_NSS_FWCONF_MAP_ENABLE | (((x - 1) << BW_NSS_FWCONF_MAP_80_80MHZ_S) & BW_NSS_FWCONF_MAP_80_80MHZ_M))
>>>
>>>   struct wmi_10_4_peer_assoc_complete_cmd {
>>>       struct wmi_10_2_peer_assoc_complete_cmd cmd;
>>>
>>
>>
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
