Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:51396 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757766AbeD1P0Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Apr 2018 11:26:16 -0400
Subject: Re: [PATCH v4] ath10k: fix crash in recent 3.5.3 9984 firmware due
 wrong handling of peer_bw_rxnss_override parameter
To: Ben Greear <greearb@candelatech.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
References: <20180428004752.16659-1-s.gottschall@dd-wrt.com>
 <b9039c6f-17bd-2d30-79ec-4b70dc76ad75@candelatech.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <fa914b1a-3529-f179-d7a0-b2aec54b1c8f@dd-wrt.com> (sfid-20180428_172624_581344_2D2713A0)
Date: Sat, 28 Apr 2018 17:26:13 +0200
MIME-Version: 1.0
In-Reply-To: <b9039c6f-17bd-2d30-79ec-4b70dc76ad75@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 28.04.2018 um 17:01 schrieb Ben Greear:
>
>
> On 04/27/2018 05:47 PM, s.gottschall@dd-wrt.com wrote:
>> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>
>> current handling of peer_bw_rxnss_override parameter is based on 
>> guessing the VHT160/8080 capability by rx rate. this is wrong and may 
>> lead
>> to a non initialized peer_bw_rxnss_override parameter which is 
>> required since VHT160 operation mode only supports 2x2 chainmasks in 
>> addition the original code
>> initialized the parameter with wrong masked values.
>> This patch uses the peer phymode and peer nss information for correct 
>> initialisation of the peer_bw_rxnss_override parameter.
>> if this peer information is not available, we initialize the 
>> parameter by minimum nss which is suggested by QCA as temporary 
>> workaround according
>> to the QCA sourcecodes.
>>
>> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>
>> v2: remove debug messages
>> v3: apply some cosmetics, update documentation
>> v4: fix compile warning and truncate nss to maximum of 2x2 since 
>> current chipsets only support 2x2 at vht160
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c | 44 ++++++++++++++++++---------
>>  drivers/net/wireless/ath/ath10k/wmi.c |  7 +----
>>  drivers/net/wireless/ath/ath10k/wmi.h | 14 ++++++++-
>>  3 files changed, 43 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c 
>> b/drivers/net/wireless/ath/ath10k/mac.c
>> index 5be6386ede8f..de8a099c9f5a 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -2528,23 +2528,37 @@ static void ath10k_peer_assoc_h_vht(struct 
>> ath10k *ar,
>>          __le16_to_cpu(vht_cap->vht_mcs.tx_highest);
>>      arg->peer_vht_rates.tx_mcs_set = ath10k_peer_assoc_h_vht_limit(
>>          __le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map), vht_mcs_mask);
>> +    arg->peer_bw_rxnss_override = 0;
>> +
>> +    if (arg->peer_num_spatial_streams) {
>
> Check for the 80+80 or 160 instead of num-spatial-streams, if if 
> something has
> nss == 0, then act like it is 1 instead since it is obviously 
> configured incorrect.
this check is bellow. see the switch statement for the VHT160, 80_80 case.
if nss 0, it must fail here since we cannot handle nss = 0, in that case 
just bit 31 is masked

>
>> +        int nss160 = arg->peer_num_spatial_streams;
>
> I think this line should be:
>         int nss160 = arg->peer_num_spatial_streams / 2;
no. makes no sense. 2 would get 1 and 1 turns to zero. makes no sense
read the macro BW_NSS_FWCONF_160 first. it already does nss160-1
this would lead to -1 if spatial_streams is 1


>
>                 if (nss160 == 0) { nss160 = 1; } /* deal with 
> mis-configured nss */
no
if peer_num_spatial_stream is 0 (so nss160 too), the code is not 
triggered. but another code. same as above

if (!arg->peer_num_spatial_streams && (arg->peer_phymode == 
MODE_11AC_VHT80_80 || arg->peer_phymode == MODE_11AC_VHT160)) {
        arg->peer_bw_rxnss_override = BW_NSS_FWCONF_MAP_ENABLE;
  }
>
> If you have a 4019 client, it will have arg->peer_num_spatial_streams 
> == 2, but
> it can only do 1x1 at 160Mhz.
peer_num_spatial_streams is calculated from mcs rate set. so why should 
4019 announce 2x2 if it just can to 1x1.
have you checked the mcs set at assoc management frame?
>
>
>> +        /* truncate vht160 nss value to 2x2 since all known chipsets 
>> do not support more than 2x2 in vht160 modes */
>> +        if (nss160 > 2)
>> +            nss160 = 2;
>> +        /* in case if peer is connected with vht160 or vht80+80, we 
>> need to properly adjust rxnss parameters */
>> +        switch(arg->peer_phymode) {
>> +        case MODE_11AC_VHT80_80:
>> +            arg->peer_bw_rxnss_override = BW_NSS_FWCONF_80_80(nss160);
>> +        /* fall through */
>> +        case MODE_11AC_VHT160:
>> +            arg->peer_bw_rxnss_override |= BW_NSS_FWCONF_160(nss160);
>
> From looking at firmware, it will just ignore the bits it does not 
> need, so you do not need
> to special case adding the 80_80 fields, you can do more like my patch 
> and just always add
> those bits.
i'm following the reference code. in case 80_80 only is configure vht160 
nd 80_80 must be masked. for everything else vht160 only must be masked.
thats the meaning. there are 2 override masks. independend for vht160 
and 80_80. for sure i can do always both, but the reference code does not
and who knows what else changed in the firmware. consider that the crash 
bug first occured on 3.5.3. your CT codebase is older as far as i know
>
>> +        break;
>> +        default:
>> +        break;
>> +        }
>> +    }
>>
>> -    ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d 
>> flags 0x%x\n",
>> -           sta->addr, arg->peer_max_mpdu, arg->peer_flags);
>> +    /* in case peer has no nss properties for some reasons, we set 
>> local nss to minimum (1x1) to avoid a
>> +     * firmware assert / crash. this applies only to VHT160 or 
>> VHT80+80 and is a WAR for clients breaking
>> +     * the spec.
>> +     */
>>
>> -    if (arg->peer_vht_rates.rx_max_rate &&
>> -        (sta->vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK)) {
>> -        switch (arg->peer_vht_rates.rx_max_rate) {
>> -        case 1560:
>> -            /* Must be 2x2 at 160Mhz is all it can do. */
>> -            arg->peer_bw_rxnss_override = 2;
>> -            break;
>> -        case 780:
>> -            /* Can only do 1x1 at 160Mhz (Long Guard Interval) */
>> -            arg->peer_bw_rxnss_override = 1;
>> -            break;
>> -        }
>> +    if (!arg->peer_num_spatial_streams && (arg->peer_phymode == 
>> MODE_11AC_VHT80_80 || arg->peer_phymode == MODE_11AC_VHT160)) {
>> +        arg->peer_bw_rxnss_override = BW_NSS_FWCONF_MAP_ENABLE;
>>      }
>
> Init nss160 outside of the if loop to 1 and you don't need this logic 
> either.  If something can do 160Mhz,
> then we must assume it can do at least 1x1 tx/rx.
for sure i can mask it always to bit 31 if vht80_80 and/or vht160 is 
set, yes. makes no difference
>
>
>> +
>> +    ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d 
>> flags 0x%x\n",
>> +           sta->addr, arg->peer_max_mpdu, arg->peer_flags);
>>  }
>>
>>  static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
>> @@ -2696,9 +2710,9 @@ static int ath10k_peer_assoc_prepare(struct 
>> ath10k *ar,
>>      ath10k_peer_assoc_h_crypto(ar, vif, sta, arg);
>>      ath10k_peer_assoc_h_rates(ar, vif, sta, arg);
>>      ath10k_peer_assoc_h_ht(ar, vif, sta, arg);
>> +    ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
>>      ath10k_peer_assoc_h_vht(ar, vif, sta, arg);
>>      ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
>> -    ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
>>
>>      return 0;
>>  }
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c 
>> b/drivers/net/wireless/ath/ath10k/wmi.c
>> index 2c36256a441d..3797dca317ff 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -7211,12 +7211,7 @@ ath10k_wmi_peer_assoc_fill_10_4(struct ath10k 
>> *ar, void *buf,
>>      struct wmi_10_4_peer_assoc_complete_cmd *cmd = buf;
>>
>>      ath10k_wmi_peer_assoc_fill_10_2(ar, buf, arg);
>> -    if (arg->peer_bw_rxnss_override)
>> -        cmd->peer_bw_rxnss_override =
>> -            __cpu_to_le32((arg->peer_bw_rxnss_override - 1) |
>> -                      BIT(PEER_BW_RXNSS_OVERRIDE_OFFSET));
>> -    else
>> -        cmd->peer_bw_rxnss_override = 0;
>> +    cmd->peer_bw_rxnss_override = 
>> __cpu_to_le32(arg->peer_bw_rxnss_override);
>>  }
>>
>>  static int
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h 
>> b/drivers/net/wireless/ath/ath10k/wmi.h
>> index 46ae19bb2c92..1fe0aa5523a6 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.h
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
>> @@ -6380,7 +6380,19 @@ struct wmi_10_2_peer_assoc_complete_cmd {
>>      __le32 info0; /* WMI_PEER_ASSOC_INFO0_ */
>>  } __packed;
>>
>> -#define PEER_BW_RXNSS_OVERRIDE_OFFSET  31
>> +#define BW_NSS_FWCONF_MAP_ENABLE             (1 << 31)
>> +#define BW_NSS_FWCONF_MAP_160MHZ_S           (0)
>> +#define BW_NSS_FWCONF_MAP_160MHZ_M           (0x00000007)
>> +#define BW_NSS_FWCONF_MAP_80_80MHZ_S         (3)
>> +#define BW_NSS_FWCONF_MAP_80_80MHZ_M         (0x00000038)
>> +#define BW_NSS_FWCONF_MAP_M                  (0x0000003F)
>> +
>> +#define GET_BW_NSS_FWCONF_160(x)             ((((x) & 
>> BW_NSS_FWCONF_MAP_160MHZ_M) >> BW_NSS_FWCONF_MAP_160MHZ_S) + 1)
>> +#define GET_BW_NSS_FWCONF_80_80(x)           ((((x) & 
>> BW_NSS_FWCONF_MAP_80_80MHZ_M) >> BW_NSS_FWCONF_MAP_80_80MHZ_S) + 1)
>> +
>> +/* Values defined to set 160 MHz Bandwidth NSS Mapping into FW*/
>> +#define BW_NSS_FWCONF_160(x)          (BW_NSS_FWCONF_MAP_ENABLE | 
>> (((x - 1) << BW_NSS_FWCONF_MAP_160MHZ_S) & BW_NSS_FWCONF_MAP_160MHZ_M))
>> +#define BW_NSS_FWCONF_80_80(x)        (BW_NSS_FWCONF_MAP_ENABLE | 
>> (((x - 1) << BW_NSS_FWCONF_MAP_80_80MHZ_S) & 
>> BW_NSS_FWCONF_MAP_80_80MHZ_M))
>>
>>  struct wmi_10_4_peer_assoc_complete_cmd {
>>      struct wmi_10_2_peer_assoc_complete_cmd cmd;
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
