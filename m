Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab0D1Nj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 09:39:28 -0400
Subject: Re: [PATCH 2/2] mac80211: fix supported rates IE if AP doesn't
 give us it's rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1272460624-3611-2-git-send-email-sgruszka@redhat.com>
References: <1272460624-3611-1-git-send-email-sgruszka@redhat.com>
	 <1272460624-3611-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 15:39:24 +0200
Message-ID: <1272461964.3565.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-04-28 at 15:17 +0200, Stanislaw Gruszka wrote:
> If AP do not provide us supported rates before assiociation, send
> all rates we are supporting instead of empty information element.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  net/mac80211/work.c |   23 ++++++++++++++---------
>  1 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index 15e1ba9..f8f5c9a 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -213,15 +213,20 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
>  
>  	sband = local->hw.wiphy->bands[wk->chan->band];
>  
> -	/*
> -	 * Get all rates supported by the device and the AP as
> -	 * some APs don't like getting a superset of their rates
> -	 * in the association request (e.g. D-Link DAP 1353 in
> -	 * b-only mode)...
> -	 */
> -	rates_len = ieee80211_compatible_rates(wk->assoc.supp_rates,
> -					       wk->assoc.supp_rates_len,
> -					       sband, &rates);
> +	if (wk->assoc.supp_rates_len) {
> +		/*
> +		 * Get all rates supported by the device and the AP as
> +		 * some APs don't like getting a superset of their rates
> +		 * in the association request (e.g. D-Link DAP 1353 in
> +		 * b-only mode)...
> +		 */
> +		rates_len = ieee80211_compatible_rates(wk->assoc.supp_rates,
> +						       wk->assoc.supp_rates_len,
> +						       sband, &rates);
> +	} else {
> +		rates = ~0;
> +		rates_len = sband->n_bitrates;
> +	}

Could you add a comment about what AP this is, and that it's a
workaround please? The AP is surely supposed to send this information!

johannes

