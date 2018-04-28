Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:60258 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933146AbeD1Afw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 20:35:52 -0400
Subject: Re: [PATCH v2] ath10k: fix crash in recent 3.5.3 9984 firmware due
 wrong handling of peer_bw_rxnss_override parameter
To: Ben Greear <greearb@candelatech.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
References: <20180426092848.23069-1-s.gottschall@dd-wrt.com>
 <f288f18c-684d-2ff9-5739-648e8e716653@candelatech.com>
 <db214e94-1052-d6fa-744a-7c8ebcc84aee@dd-wrt.com>
 <96d512b3-3261-c6cf-e0eb-a9f5fe91f3b8@candelatech.com>
 <8263a720-07a2-dc5d-f8fc-2153574cbafc@dd-wrt.com>
 <96f0393e-6bab-d397-d2b6-4538da7fc275@candelatech.com>
 <f410c1d7-6b19-032d-7f03-6cb1d52f6956@dd-wrt.com>
 <ebaf2806-a63b-5611-41f4-817b1f471fd1@candelatech.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <e7036e06-9f4d-05bc-ea77-e0a6876f3394@dd-wrt.com> (sfid-20180428_023557_738142_BA45EA3F)
Date: Sat, 28 Apr 2018 02:35:51 +0200
MIME-Version: 1.0
In-Reply-To: <ebaf2806-a63b-5611-41f4-817b1f471fd1@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I did some testing with the patch below.
i mean you tested your own patch here but i dont see results for mine.
i tested my patch in the same way, just not on firmware side
but i logged the values for rxnss_override and the looked correct all 
the time

>
> The CHAIMASK_ERR is a debug log from FW that I added to help make sure 
> the patch is
> acting as desired.  The first hex is an identifier, second is the 
> value passed in,
> third is phymode, 4th is the tx-chain-mask for 160Mhz frames.
>
> On station side, when associating a 4x4 9984 station to 9984 
> configured for nss4, 160Mhz, I see:
> [86376.620303] ath10k_pci 0000:04:00.0: NIC rx-max-rate: 1560 
> calculated-max: 1560 rxnss_override: 0x80000009  nss160: 2 
> spatial-streams: 4
>   ath10k-fw: ts: 15229 args: 4 RATE_CTRL(19) vid: 255 
> CHAINMASK_ERR(03)  0x000000af 0x80000009 0x0000000f 0x00000003
>
> On station side, when associating a 4x4 9984 station with chain-mask 
> of 0x3 (2x2) to 9984 configured for nss4, 160Mhz, I see:
>
> [86147.569319] ath10k_pci 0000:04:00.0: NIC rx-max-rate: 1560 
> calculated-max: 780 rxnss_override: 0x80000000  nss160: 1 
> spatial-streams: 2
> ath10k-fw: ts: 6807 args: 4 RATE_CTRL(19) vid: 255 CHAINMASK_ERR(03)  
> 0x000000af 0x80000000 0x0000000f 0x00000001
>
>
> On AP side, when associating a 4x4 9984 station to 9984 configured for 
> 160Mhz, I see:
>
> [11167.635324] ath10k_pci 0000:04:00.0: NIC rx-max-rate: 1560 
> calculated-max: 1560 rxnss_override: 0x80000009  nss160: 2 
> spatial-streams: 4
>   ath10k-fw: ts: 72917 args: 4 RATE_CTRL(19) vid: 255 
> CHAINMASK_ERR(03)  0x000000af 0x80000009 0x0000000f 0x00000003
>
> On AP side, when associating a 4x4 9984 station with chain-mask of 0x3 
> (2x2) to 9984 configured for nss4, 160Mhz, I see:
>
> [11422.887181] ath10k_pci 0000:04:00.0: NIC rx-max-rate: 1560 
> calculated-max: 780 rxnss_override: 0x80000000  nss160: 1 
> spatial-streams: 2
>   ath10k-fw: ts: 334266 args: 4 RATE_CTRL(19) vid: 255 
> CHAINMASK_ERR(03)  0x000000af 0x80000000 0x0000000f 0x00000001
>
> On AP side, when associating a 4x4 9984 station configured for 80Mhz 
> instead of 160,
> then logging from firmware indicates full 4x4 rates are supported for 
> 80Mhz and below,
> and the rxnss_override does not have the (1<<31) bit set:
>
>   ath10k-fw: ts: 519211 args: 4 RATE_CTRL(19) vid: 255 
> CHAINMASK_ERR(03)  0x000000af 0x00000000 0x0000000a 0x00000001
>
>
> So, I think this might be a better fix for this problem (included 
> inline for discussion,
> probably white-space damaged by email client:
>
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c 
> b/drivers/net/wireless/ath/ath10k/mac.c
> index e1ad983..8bce916 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2860,18 +2860,39 @@ static void ath10k_peer_assoc_h_vht(struct 
> ath10k *ar,
>             arg->peer_vht_rates.rx_max_rate, 
> arg->peer_vht_rates.rx_mcs_set,
>             arg->peer_vht_rates.tx_max_rate, 
> arg->peer_vht_rates.tx_mcs_set);
>
> -    if (arg->peer_vht_rates.rx_max_rate &&
> -        (sta->vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK)) {
> -        switch (arg->peer_vht_rates.rx_max_rate) {
> +    if (arg->peer_phymode == MODE_11AC_VHT80_80 ||
> +        arg->peer_phymode == MODE_11AC_VHT160) {
> +        int nss160;
> +        int rx = arg->peer_vht_rates.rx_max_rate;
> +        /* Deal with cases where chainmask has been decreased.
> +         * All known chips that support 160Mhz can do only 1/2 of
> +         * the available chains at 160Mhz.
> +         */
> +        rx = min((int)(arg->peer_num_spatial_streams * 390), rx);
> +
> +        switch (rx) {
> +            /* When a NIC shows up that can do 4x4 at 160Mhz, its
> +             * max-rate should be higher, and we can set nss160
> +             * to 4 here.
> +             */
>          case 1560:
>              /* Must be 2x2 at 160Mhz is all it can do. */
> -            arg->peer_bw_rxnss_override = 2;
> +            nss160 = 2;
>              break;
> -        case 780:
> -            /* Can only do 1x1 at 160Mhz (Long Guard Interval) */
> -            arg->peer_bw_rxnss_override = 1;
> +        default:
> +            /* Assume we can only do 1x1 at 160Mhz */
> +            nss160 = 1;
>              break;
>          }
> +
> +        arg->peer_bw_rxnss_override = ((nss160 - 1) | /* 160Mhz nss */
> +                           ((nss160 - 1) << 3) | /* 80+80 nss */
> +                           BIT(PEER_BW_RXNSS_OVERRIDE_OFFSET));
> +
> +        ath10k_warn(ar, "NIC rx-max-rate: %d calculated-max: %d 
> rxnss_override: 0x%x  nss160: %d  spatial-streams: %d\n",
> +                arg->peer_vht_rates.rx_max_rate, rx,
> +                arg->peer_bw_rxnss_override, nss160,
> +                arg->peer_num_spatial_streams);
>      }
>  }
>
> @@ -3115,9 +3136,9 @@ static int ath10k_peer_assoc_prepare(struct 
> ath10k *ar,
>      ath10k_peer_assoc_h_crypto(ar, vif, sta, arg);
>      ath10k_peer_assoc_h_rates(ar, vif, sta, arg);
>      ath10k_peer_assoc_h_ht(ar, vif, sta, arg);
> +    ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
>      ath10k_peer_assoc_h_vht(ar, vif, sta, arg);
>      ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
> -    ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
>
>      ath10k_peer_assoc_h_rate_overrides(ar, vif, sta, arg);
>
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c 
> b/drivers/net/wireless/ath/ath10k/wmi.c
> index 8eeeab0..365d509 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -7442,12 +7442,8 @@ ath10k_wmi_peer_assoc_fill_10_4(struct ath10k 
> *ar, void *buf,
>      struct wmi_10_4_peer_assoc_complete_cmd *cmd = buf;
>
>      ath10k_wmi_peer_assoc_fill_10_2(ar, buf, arg);
> -    if (arg->peer_bw_rxnss_override)
> -        cmd->peer_bw_rxnss_override =
> -            __cpu_to_le32((arg->peer_bw_rxnss_override - 1) |
> -                      BIT(PEER_BW_RXNSS_OVERRIDE_OFFSET));
> -    else
> -        cmd->peer_bw_rxnss_override = 0;
> +
> +    cmd->peer_bw_rxnss_override = 
> __cpu_to_le32(arg->peer_bw_rxnss_override);
>  }
>
>  static int
>
>
>
> Thanks,
> Ben
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
