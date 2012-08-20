Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab2HTHNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 03:13:17 -0400
Message-ID: <1345446793.4504.0.camel@jlt3.sipsolutions.net> (sfid-20120820_091321_572127_9AFB458C)
Subject: Re: [PATCH] ath6kl: protect firmware from excessive WoW pattern
 length
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Mon, 20 Aug 2012 09:13:13 +0200
In-Reply-To: <1345076116-5053-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120816_021530_554431_E3CCD682)
References: <1345076116-5053-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 (sfid-20120816_021530_554431_E3CCD682)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-15 at 17:15 -0700, Thomas Pedersen wrote:
> Don't accept WoW patterns longer than supported by firmware.
> 
> Reported-by: Haijun Jin <nhjin@qca.qualcomm.com>
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index bd003fe..ffa18f3 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -1876,6 +1876,9 @@ static int ath6kl_wow_usr(struct ath6kl *ar, struct ath6kl_vif *vif,
>  	/* Configure the patterns that we received from the user. */
>  	for (i = 0; i < wow->n_patterns; i++) {
>  
> +		if (wow->patterns[i].pattern_len > WOW_MASK_SIZE)
> +			return -EINVAL;
> +

No objection, but doesn't nl80211 already validate that (assuming you
give the right pattern_max_len, of course)?

johannes

