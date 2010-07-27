Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0G0Wvs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 18:51:48 -0400
Date: Tue, 27 Jul 2010 15:39:32 -0700
From: Greg KH <greg@kroah.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [stable] [PATCH 2/2 2.6.32.y] mac80211: fix supported rates IE
 if AP doesn't give us it's rates
Message-ID: <20100727223932.GL14257@kroah.com>
References: <1275904783-6563-1-git-send-email-sgruszka@redhat.com>
 <1275904783-6563-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1275904783-6563-2-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 07, 2010 at 11:59:43AM +0200, Stanislaw Gruszka wrote:
> If AP do not provide us supported rates before assiociation, send
> all rates we are supporting instead of empty information element.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  net/mac80211/mlme.c |   17 +++++++++++------

What is the commit id of this patch upstream?

thanks,

greg k-h

>  1 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index d3950b7..abd62fc 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -269,12 +269,6 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
>  	if (wk->bss->wmm_used)
>  		wmm = 1;
>  
> -	/* get all rates supported by the device and the AP as
> -	 * some APs don't like getting a superset of their rates
> -	 * in the association request (e.g. D-Link DAP 1353 in
> -	 * b-only mode) */
> -	rates_len = ieee80211_compatible_rates(wk->bss, sband, &rates);
> -
>  	if ((wk->bss->cbss.capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
>  	    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
>  		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
> @@ -309,6 +303,17 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
>  	*pos++ = wk->ssid_len;
>  	memcpy(pos, wk->ssid, wk->ssid_len);
>  
> +	if (wk->bss->supp_rates_len) {
> +		/* get all rates supported by the device and the AP as
> +		 * some APs don't like getting a superset of their rates
> +		 * in the association request (e.g. D-Link DAP 1353 in
> +		 * b-only mode) */
> +		rates_len = ieee80211_compatible_rates(wk->bss, sband, &rates);
> +	} else {
> +		rates = ~0;
> +		rates_len = sband->n_bitrates;
> +	}
> +
>  	/* add all rates which were marked to be used above */
>  	supp_rates_len = rates_len;
>  	if (supp_rates_len > 8)
> -- 
> 1.6.2.5
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
