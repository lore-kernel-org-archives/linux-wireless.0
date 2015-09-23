Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49033 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbbIWXKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 19:10:03 -0400
Subject: Re: [PATCH] mac80211: ensure association req uses configured
 ratemask.
To: linux-wireless@vger.kernel.org
References: <1442619806-29917-1-git-send-email-greearb@candelatech.com>
Cc: johannes@sipsolutions.net
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5603314A.4010505@candelatech.com> (sfid-20150924_011011_611720_D413DC11)
Date: Wed, 23 Sep 2015 16:10:02 -0700
MIME-Version: 1.0
In-Reply-To: <1442619806-29917-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2015 04:43 PM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> When sending the association request, pay attention to the
> legacy rates configured by the user, and do not advertise support
> for any that are not configured.
>
> This makes the assoc request packet look more correct when
> making modern hardware act like a /b mode station, for instance.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

>   	assoc_data->capability = req->bss->capability;
> -	assoc_data->supp_rates = bss->supp_rates;
> -	assoc_data->supp_rates_len = bss->supp_rates_len;
> +	if (sdata->cfg_bitrate_mask_set) {
> +		int band = req->bss->channel->band;
> +		u32 msk = sdata->cfg_bitrate_mask.control[band].legacy;
> +		u8 all_rates[12] = {0x82, 0x84, 0x8b, 0x96,
> +				    12, 18, 24, 36, 48, 72, 96, 108};
> +		int i;
> +		int q = 0;
> +
> +		for (i = 0; i < 12; i++) {
> +			int j;
> +
> +			if (!(msk & (1 << i)))
> +				break;
> +
> +			for (j = 0; j < bss->supp_rates_len; j++) {
> +				if (bss->supp_rates[j] == all_rates[i]) {
> +					assoc_data->supp_rates[q] =
> +						all_rates[i];
> +					q++;
> +					break;
> +				}
> +			}
> +		}
> +		assoc_data->supp_rates_len = q;


This logic is buggy in at least two ways...I'll re-post after I
get this working better.

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

