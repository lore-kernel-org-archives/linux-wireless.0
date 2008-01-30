Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:40895 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYA3T2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 14:28:47 -0500
Received: by fg-out-1718.google.com with SMTP id e21so326405fga.17
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2008 11:28:46 -0800 (PST)
Message-ID: <47A0CFEB.2080702@gmail.com> (sfid-20080130_192907_145433_CD81D510)
Date: Wed, 30 Jan 2008 20:28:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com, johannes@sipsolutions.net
Subject: Re: [PATCH] ath5k: Port to new bitrate/channel API
References: <20080130183824.GA7676@makis.domain.invalid>
In-Reply-To: <20080130183824.GA7676@makis.domain.invalid>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2008 07:38 PM, Nick Kossifidis wrote:
> Tested on 5211, 5213+5112, 5213A+2112A and it wors fine.
> 
> Also i figured out a way to process rate vallue found on status descriptors,
> it's still buggy but we are getting closer (i think it improved stability a little).
> 
> Changes-licensed-under: 3-clause-BSD
> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> 
> ---
> @@ -898,25 +879,26 @@ ath5k_copy_channels(struct ath5k_hw *ah,
>  	}
>  
>  	for (i = 0, count = 0; i < size && max > 0; i++) {
> -		ch = all ? i + 1 : chans[i].chan;
> -		f = ath5k_ieee2mhz(ch);
> -		/* Check if channel is supported by the chipset */
> -		if (!ath5k_channel_ok(ah, f, chfreq))
> -			continue;
> +		ch = i + 1 ;
> +		freq = ath5k_ieee2mhz(ch);
[...]
> -		if (!all && (chans[i].mode & map[mode].mask) != map[mode].mode)
> -			continue;
> +		/* Write channel info and increment counter */
> +		channels[count].center_freq = freq;
> +
> +		if((mode == AR5K_MODE_11A) ||
> +		(mode == AR5K_MODE_11G)){
> +			channels[count].hw_value = chfreq|CHANNEL_OFDM;
> +		} else if((mode == AR5K_MODE_11A_TURBO) ||
> +		(mode == AR5K_MODE_11G_TURBO)){
> +			channels[count].hw_value = chfreq|CHANNEL_OFDM|CHANNEL_TURBO;
> +		}if(mode == AR5K_MODE_11B) {
> +			channels[count].hw_value = CHANNEL_B;
> +		}

Please run with this patch through Lindent (use checkpatch), some parts are not 
much readable.

Otherwise seems pretty well.
