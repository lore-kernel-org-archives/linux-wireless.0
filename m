Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51405 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753022AbcHSGfW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 02:35:22 -0400
Date: Fri, 19 Aug 2016 12:05:11 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: greearb@candelatech.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath10k:  Improve logging message.
Message-ID: <20160819063511.GA16230@atheros-ThinkPad-T61> (sfid-20160819_083525_927022_C0462FAA)
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
 <1471569995-10028-3-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1471569995-10028-3-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Thu, Aug 18, 2016 at 06:26:35PM -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Helps to know the sta pointer.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index d96c06e..82bc0da 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -6491,8 +6491,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
>  		 * Existing station deletion.
>  		 */
>  		ath10k_dbg(ar, ATH10K_DBG_MAC,
> -			   "mac vdev %d peer delete %pM (sta gone)\n",
> -			   arvif->vdev_id, sta->addr);
> +			   "mac vdev %d peer delete %pM (sta gone) sta: %p\n",
> +			   arvif->vdev_id, sta->addr, sta);

good to rebase over Maharaja's change (%p to %pK) 
https://patchwork.kernel.org/patch/9263691/

>  
>  		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
>  		if (ret)
> -- 
> 2.4.11
> 
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
