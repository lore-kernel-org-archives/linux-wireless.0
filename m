Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f182.google.com ([209.85.210.182]:32815 "EHLO
        mail-wj0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756113AbdACLCi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 06:02:38 -0500
Received: by mail-wj0-f182.google.com with SMTP id tq7so205125934wjb.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 03:02:37 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: avoid writing channel out of allocated array
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170103083858.6981-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f74a07d7-94a6-f9c6-ba12-adec6f708c3a@broadcom.com> (sfid-20170103_120358_472918_7BBC0E94)
Date: Tue, 3 Jan 2017 12:02:31 +0100
MIME-Version: 1.0
In-Reply-To: <20170103083858.6981-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3-1-2017 9:38, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Our code was assigning number of channels to the index variable by
> default. If firmware reported channel we didn't predict this would
> result in using that initial index value and writing out of array.
> 
> Fix this by detecting unexpected channel and ignoring it.
> 
> Fixes: 58de92d2f95e ("brcmfmac: use static superset of channels for wiphy bands")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> I'm not sure what kind of material it is. It fixes possible memory corruption
> (serious thing?) but this bug was there since Apr 2015, so is it worth fixing
> in 4.10? Or maybe I should even cc stable?
> I don't think any released firmware reports any unexpected channel, so I guess
> noone ever hit this problem. I just noticed this possible problem when working
> on another feature.

Looking at the change I was going to ask if you actually hit the issue
you are addressing here. The channels in __wl_2ghz_channels and
__wl_5ghz_channels are complete list of channels for the particular band
so it would mean firmware behaves out-of-spec or firmware api was
changed. For robustness a change is acceptable I guess.

My general policy is to submit fixes to wireless-drivers (and stable)
only if it resolves a critical issue found during testing or a reported
issue.

> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 29 +++++++++++-----------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 13ca3eb..0babfc7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -5825,7 +5825,6 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
>  	u32 i, j;
>  	u32 total;
>  	u32 chaninfo;
> -	u32 index;
>  
>  	pbuf = kzalloc(BRCMF_DCMD_MEDLEN, GFP_KERNEL);
>  
> @@ -5873,33 +5872,33 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
>  		    ch.bw == BRCMU_CHAN_BW_80)
>  			continue;
>  
> -		channel = band->channels;
> -		index = band->n_channels;
> +		channel = NULL;
>  		for (j = 0; j < band->n_channels; j++) {
> -			if (channel[j].hw_value == ch.control_ch_num) {
> -				index = j;
> +			if (band->channels[j].hw_value == ch.control_ch_num) {
> +				channel = &band->channels[j];
>  				break;
>  			}
>  		}

You could have kept the index construct and simply check if j ==
band->n_channels here to determine something is wrong.

> -		channel[index].center_freq =
> -			ieee80211_channel_to_frequency(ch.control_ch_num,
> -						       band->band);
> -		channel[index].hw_value = ch.control_ch_num;

So you are also removing these assignments which indeed seem redundant.
Maybe make note of that in the commit message?

> +		if (!channel) {
> +			brcmf_err("Firmware reported unexpected channel %d\n",
> +				  ch.control_ch_num);
> +			continue;
> +		}

As stated above something is really off when this happens so should we
continue and try to make sense of what firmware provides or simply fail.

Regards,
Arend
