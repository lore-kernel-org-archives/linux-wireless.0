Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39340 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab2CEUCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:02:06 -0500
Date: Mon, 5 Mar 2012 14:46:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 3.3] iwlwifi: always monitor for stuck queues
Message-ID: <20120305194644.GF18128@tuxdriver.com> (sfid-20120305_210211_266165_46802003)
References: <1330879846-30311-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330879846-30311-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 04, 2012 at 08:50:46AM -0800, Wey-Yi Guy wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If we only monitor while associated, the following
> can happen:
>  - we're associated, and the queue stuck check
>    runs, setting the queue "touch" time to X
>  - we disassociate, stopping the monitoring,
>    which leaves the time set to X
>  - almost 2s later, we associate, and enqueue
>    a frame
>  - before the frame is transmitted, we monitor
>    for stuck queues, and find the time set to
>    X, although it is now later than X + 2000ms,
>    so we decide that the queue is stuck and
>    erroneously restart the device
> 
> It happens more with P2P because there we can
> go between associated/unassociated frequently.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Ben Cahill <ben.m.cahill@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---

So what is the effect of this bug?  An unnecessary firmware restart?  How often does this happen?

It is very late in the 3.3 cycle.  Fixes should be for regressions, crashes, etc.

John

> this patch will be also available from wireless branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git
> 
>  drivers/net/wireless/iwlwifi/iwl-core.c |   18 ++++--------------
>  1 files changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
> index 7bcfa78..3abe9ed 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -1465,20 +1465,10 @@ void iwl_bg_watchdog(unsigned long data)
>  	if (timeout == 0)
>  		return;
>  
> -	/* monitor and check for stuck cmd queue */
> -	if (iwl_check_stuck_queue(priv, priv->shrd->cmd_queue))
> -		return;
> -
> -	/* monitor and check for other stuck queues */
> -	if (iwl_is_any_associated(priv)) {
> -		for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
> -			/* skip as we already checked the command queue */
> -			if (cnt == priv->shrd->cmd_queue)
> -				continue;
> -			if (iwl_check_stuck_queue(priv, cnt))
> -				return;
> -		}
> -	}
> +	/* monitor and check for stuck queues */
> +	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++)
> +		if (iwl_check_stuck_queue(priv, cnt))
> +			return;
>  
>  	mod_timer(&priv->watchdog, jiffies +
>  		  msecs_to_jiffies(IWL_WD_TICK(timeout)));
> -- 
> 1.7.0.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
