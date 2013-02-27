Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54831 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3B0Nk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 08:40:27 -0500
Received: by mail-wi0-f179.google.com with SMTP id ez12so664092wid.0
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2013 05:40:25 -0800 (PST)
Date: Wed, 27 Feb 2013 14:38:02 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH 2/2] mac80211: fix the check for mcs rates masking
Message-ID: <20130227133802.GA28291@magnum.frso.rivierawaves.com> (sfid-20130227_144031_404768_364227C2)
References: <1361966434-28343-1-git-send-email-karl.beldan@gmail.com>
 <1361966434-28343-2-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1361966434-28343-2-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 27, 2013 at 01:00:34PM +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Currently the mcs bitrates mask rate_idx_mcs_mask is only applied when
> the pre-ht bitrates mask rate_idx_mask of the same band differs from the
> default mask.
> Fix it by comparing the rate_idx_mcs_mask with the ht_cap.mcs.rx_mask, the
> copy of the rate_idx_mcs_mask is now done if the check succeeds.
> This results, when no pre-ht bitrates is disabled && an mcs idx is, to
> one more memcmp, otherwise the cost remains identical.
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> ---
>  net/mac80211/rate.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
> index cfbd7d5..4c0a14d 100644
> --- a/net/mac80211/rate.c
> +++ b/net/mac80211/rate.c
> @@ -460,8 +460,11 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
>  	 * the common case.
>  	 */
>  	mask = txrc->rate_idx_mask;
> -	memcpy(mcs_mask, txrc->rate_idx_mcs_mask, sizeof(mcs_mask));
> -	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
> +	if (mask != (1 << txrc->sband->n_bitrates) - 1 ||
> +		memcmp(txrc->sband->ht_cap.mcs.rx_mask, txrc->rate_idx_mcs_mask,
> +		       sizeof(txrc->rate_idx_mcs_mask))) {
> +		memcpy(mcs_mask, txrc->rate_idx_mcs_mask, sizeof(mcs_mask));
> +
>  		if (sta) {
> 

I don't know why I refrained myself from getting rid of the copies of
the masks altogether.
