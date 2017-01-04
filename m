Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:34854 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758821AbdADJqx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 04:46:53 -0500
Received: by mail-pg0-f54.google.com with SMTP id i5so160847001pgh.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2017 01:46:45 -0800 (PST)
Subject: Re: [PATCH next V2] brcmfmac: avoid writing channel out of allocated
 array
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170103083858.6981-1-zajec5@gmail.com>
 <20170103164930.29989-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <17d4eeb8-0cc2-4e0a-ad16-442dfec32a08@broadcom.com> (sfid-20170104_104700_705574_483FE7FC)
Date: Wed, 4 Jan 2017 10:39:09 +0100
MIME-Version: 1.0
In-Reply-To: <20170103164930.29989-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3-1-2017 17:49, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Our code was assigning number of channels to the index variable by
> default. If firmware reported channel we didn't predict this would
> result in using that initial index value and writing out of array. This
> never happened so far (we got a complete list of supported channels) but
> it means possible memory corruption so we should handle it anyway.
> 
> This patch simply detects unexpected channel and ignores it.
> 
> As we don't try to create new entry now, it's also safe to drop hw_value
> and center_freq assignment. For known channels we have these set anyway.
> 
> I decided to fix this issue by assigning NULL or a target channel to the
> channel variable. This was one of possible ways, I prefefred this one as
> it also avoids using channel[index] over and over.
> 
> Fixes: 58de92d2f95e ("brcmfmac: use static superset of channels for wiphy bands")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Add extra comment in code for not-found channel.
>     Make it clear this problem have never been seen so far
>     Explain why it's safe to drop extra assignments
>     Note & reason changing channel variable usage
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 32 ++++++++++++----------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 9c2c128..a16dd7b 100644
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
> @@ -5873,33 +5872,36 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
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
> -		channel[index].center_freq =
> -			ieee80211_channel_to_frequency(ch.control_ch_num,
> -						       band->band);
> -		channel[index].hw_value = ch.control_ch_num;
> +		if (!channel) {
> +			/* It seems firmware supports some channel we never
> +			 * considered. Something new in IEEE standard?
> +			 */
> +			brcmf_err("Firmware reported unexpected channel %d\n",
> +				  ch.control_ch_num);

Maybe rephrase to "Ignoring unexpected firmware channel %d\n" so
end-users are not alarmed by this error message. I think using
brcmf_err() is justified, but you may even consider chiming down to
brcmf_dbg(INFO, ...).

Regards,
Arend
