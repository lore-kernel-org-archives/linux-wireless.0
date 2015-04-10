Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36103 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbDJRR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 13:17:28 -0400
Message-ID: <552805A6.6030108@candelatech.com> (sfid-20150410_191733_525233_20C82761)
Date: Fri, 10 Apr 2015 10:17:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] ath10k: fix multiple key static wep with ibss
References: <1428672203-8604-1-git-send-email-michal.kazior@tieto.com> <1428672203-8604-3-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1428672203-8604-3-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2015 06:23 AM, Michal Kazior wrote:
> Apparently firmware requires both pairwise and
> groupwise keys to be installed per-peer for static
> WEP in IBSS. This wasn't necessary for AP mode
> (and installing both doesn't seem to break AP
> mode thus there's no special handling).
> 
> Also there seems to be some kind of issue with
> mapping tx/rx keys in firmware properly which
> resulted in wrong keys being used and broken
> communication between devices.
> 
> It can be argued the vdev param part is more of a
> workaround than a real fix. However I couldn't
> figure out how to fix this differently. It works
> and isn't super ugly.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 6664bcc9ba88..93f753cb839a 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -230,9 +230,13 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
>  		flags = 0;
>  		flags |= WMI_KEY_PAIRWISE;
>  
> -		/* set TX_USAGE flag for default key id */
> -		if (arvif->def_wep_key_idx == i)
> -			flags |= WMI_KEY_TX_USAGE;
> +		ret = ath10k_install_key(arvif, arvif->wep_keys[i], SET_KEY,
> +					 addr, flags);
> +		if (ret)
> +			return ret;
> +
> +		flags = 0;
> +		flags |= WMI_KEY_GROUP;

That could be a single assigment to WMI_KEY_GROUP?

Also, this does not merge cleanly with my 4.0 tree,
but I'm not using WEP anyway, so no big deal...

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

