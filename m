Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:43989 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab2LGMIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 07:08:45 -0500
Message-ID: <1354882082.31150.3.camel@cumari.coelho.fi> (sfid-20121207_130847_685059_83BB33B5)
Subject: Re: [PATCH 12/20] wl18xx: limit Tx for the AP single-STA-in-PSM case
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 7 Dec 2012 14:08:02 +0200
In-Reply-To: <1354095769-8724-13-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-13-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> Treat a single connected STA in PSM as a slow link and regulate Tx speed
> according to slow link priority/stop thresholds.
> This allows us to avoid flooding the FW, while delivering decent
> throughput to a peer in forced-PSM.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
>  drivers/net/wireless/ti/wl18xx/main.c |   14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
> index 3836dbd..ada4616 100644
> --- a/drivers/net/wireless/ti/wl18xx/main.c
> +++ b/drivers/net/wireless/ti/wl18xx/main.c
> @@ -1446,10 +1446,11 @@ static bool wl18xx_lnk_high_prio(struct wl1271 *wl, u8 hlid,
>  		return false;
>  
>  	/* the priority thresholds are taken from FW */
> -	if (test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map))
> -		thold = status_priv->tx_fast_link_prio_threshold;
> -	else
> +	if (!test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map) ||
> +	    test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map))
>  		thold = status_priv->tx_slow_link_prio_threshold;
> +	else
> +		thold = status_priv->tx_fast_link_prio_threshold;

Am I missing something or is this kind of inverted logic? For some
reason I always think it is simpler to have something like this:

if (fast_link && !ps)
	thold = fast;
else
	thold = slow;

But maybe it's just me...

--
Luca.

