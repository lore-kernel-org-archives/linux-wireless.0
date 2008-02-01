Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:13260 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYBAPsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 10:48:05 -0500
Received: by nf-out-0910.google.com with SMTP id g13so228399nfb.21
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 07:48:01 -0800 (PST)
Message-ID: <47A33ECA.5030005@gmail.com> (sfid-20080201_154820_967056_FB1E3EB8)
Date: Fri, 01 Feb 2008 16:46:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, bruno@thinktube.com,
	johannes@sipsolutions.net, mickflemm@gmail.com
Subject: Re: [PATCH 1/1] ath5k: Cleanup after API changes patch
References: <20080201012544.GD28995@ruslug.rutgers.edu>
In-Reply-To: <20080201012544.GD28995@ruslug.rutgers.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2008 02:25 AM, Luis R. Rodriguez wrote:
> Cleanup after API changes patch (checkpatch.pl stuff) and on
> ath5k_hw_rf5112_channel() make use of the new channel->band and
> existing ath5k_channel_ok() instead of re-implementing the checks
> again. This was necessary to make the code cleaner and fit
> the 80-chars wide limit so sending it within the same patch.
> 
> Finally make a note that we should eventually move cap_range stuff
> to struct wiphy.
> 
> This patch applies ontop of Nick's API changes patch.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
> 
> drivers/net/wireless/ath5k/ath5k.h:	Changes-licensed-under: ISC
> drivers/net/wireless/ath5k/base.c:	Changes-licensed-under: 3-Clause-BSD
> drivers/net/wireless/ath5k/initvals.c:	Changes-licensed-under: ISC
> drivers/net/wireless/ath5k/phy.c:	Changes-licensed-under: ISC
> ---
>  drivers/net/wireless/ath5k/ath5k.h    |    8 ++-
>  drivers/net/wireless/ath5k/base.c     |  126 +++++++++++++++++++--------------
>  drivers/net/wireless/ath5k/initvals.c |    6 +-
>  drivers/net/wireless/ath5k/phy.c      |   48 +++++++++----
>  4 files changed, 118 insertions(+), 70 deletions(-)
> 
[...]
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 8ddac36..bd9c9a8 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
[...]
> @@ -889,13 +900,15 @@ ath5k_copy_channels(struct ath5k_hw *ah,
>  		/* Write channel info and increment counter */
>  		channels[count].center_freq = freq;
>  
> -		if((mode == AR5K_MODE_11A) ||
> -		(mode == AR5K_MODE_11G)){
> -			channels[count].hw_value = chfreq|CHANNEL_OFDM;
> -		} else if((mode == AR5K_MODE_11A_TURBO) ||
> -		(mode == AR5K_MODE_11G_TURBO)){
> -			channels[count].hw_value = chfreq|CHANNEL_OFDM|CHANNEL_TURBO;
> -		}if(mode == AR5K_MODE_11B) {
> +		if ((mode == AR5K_MODE_11A) ||
> +			(mode == AR5K_MODE_11G)) {
> +			channels[count].hw_value =
> +				chfreq | CHANNEL_OFDM;
> +		} else if ((mode == AR5K_MODE_11A_TURBO) ||
> +			(mode == AR5K_MODE_11G_TURBO)) {
> +			channels[count].hw_value =
> +				chfreq | CHANNEL_OFDM|CHANNEL_TURBO;
> +		} if (mode == AR5K_MODE_11B) {

'else' or '\n' before the if, please

>  			channels[count].hw_value = CHANNEL_B;
>  		}
>  

