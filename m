Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3CDUNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:13:05 -0500
Message-ID: <1362427980.21028.43.camel@jlt4.sipsolutions.net> (sfid-20130304_211309_300952_300D02A1)
Subject: Re: [PATCH v2 2/2] mac80211: fix the check for mcs rates masking
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Mon, 04 Mar 2013 21:13:00 +0100
In-Reply-To: <1362421635-28008-2-git-send-email-karl.beldan@gmail.com> (sfid-20130304_193008_536244_6F0E85C9)
References: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com>
	 <1362421635-28008-2-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130304_193008_536244_6F0E85C9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 19:27 +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Currently the mcs bitrates mask rate_idx_mcs_mask is only applied when
> the pre-ht bitrates mask rate_idx_mask of the same band differs from the
> default mask.
> Fix it by comparing the rate_idx_mcs_mask with the driver ht caps.
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> ---
>  net/mac80211/rate.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
> index c1e5f25..28f1936 100644
> --- a/net/mac80211/rate.c
> +++ b/net/mac80211/rate.c
> @@ -455,13 +455,15 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
>  	ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
>  
>  	/*
> -	 * Try to enforce the rateidx mask the user wanted. skip this if the
> -	 * default mask (allow all rates) is used to save some processing for
> -	 * the common case.
> +	 * Try to enforce the rateidx masks the user wanted. Skip this if mask
> +	 * is the default mask (allow all rates) and mcs_mask does not differ
> +	 * from the driver ht caps to save some processing for the common case.
>  	 */
>  	mask = &txrc->rate_idx_mask;
>  	mcs_mask = txrc->rate_idx_mcs_mask;
> -	if (*mask != (1 << txrc->sband->n_bitrates) - 1) {
> +	if (*mask != (1 << txrc->sband->n_bitrates) - 1 ||
> +		memcmp(txrc->sband->ht_cap.mcs.rx_mask, txrc->rate_idx_mcs_mask,
> +		       sizeof(txrc->rate_idx_mcs_mask))) {

Please fix the indentation, the memcmp should be indented to just after
the opening parenthesis of "if ("

johannes

