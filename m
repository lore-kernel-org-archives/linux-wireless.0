Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17725 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab2KQARg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 19:17:36 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Date: Fri, 16 Nov 2012 16:20:15 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: support NL80211_USER_REG_HINT_CELL_BASE events
Message-ID: <20121117002015.GQ3354@lenteja.do-not-panic.com> (sfid-20121117_011739_717661_D818D7DB)
References: <20121116082804.10073.67557.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121116082804.10073.67557.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 16, 2012 at 10:28:04AM +0200, Kalle Valo wrote:
> As ath6kl firmware can't do intersections the driver should only listen
> to regdom changes from cellular base stations, all other requests need to
> be refused.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index bf5e7d5..41dea0d 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -3500,11 +3500,18 @@ static int ath6kl_cfg80211_reg_notify(struct wiphy *wiphy,
>  	int ret, i;
>  
>  	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
> -		   "cfg reg_notify %c%c%s%s initiator %d\n",
> +		   "cfg reg_notify %c%c%s%s initiator %d hint_type %d\n",
>  		   request->alpha2[0], request->alpha2[1],
>  		   request->intersect ? " intersect" : "",
>  		   request->processed ? " processed" : "",
> -		   request->initiator);
> +		   request->initiator, request->user_reg_hint_type);
> +
> +	/*
> +	 * As firmware is not able intersect regdoms, we can only listen to
> +	 * cellular hints.
> +	 */
> +	if (request->user_reg_hint_type != NL80211_USER_REG_HINT_CELL_BASE)
> +		return -EOPNOTSUPP;

The reg_notifier() doesn't need to process all requests and we don't care
if it fails so a few things for the future if its not too late to respin:

  * The reg_notifier() on the kernel can be made to return void, and simply
    allow routines to exit early by a simple non return return.

  * The comment at the top here seems non relevant as feature is to
    support cell base station hints, not to support or process all
    hints. That is, the reg notifier does work with the fimrware only
    in case of the cell base station hint.

  Luis
