Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab2FKPI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 11:08:58 -0400
Message-ID: <1339427336.4520.29.camel@jlt3.sipsolutions.net> (sfid-20120611_170902_404052_E07986A8)
Subject: Re: [PATCH] wlcore: send EAPOLs with basic rate policy
From: Johannes Berg <johannes@sipsolutions.net>
To: Eyal Shapira <eyal@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Date: Mon, 11 Jun 2012 17:08:56 +0200
In-Reply-To: <1339426884-6591-1-git-send-email-eyal@wizery.com> (sfid-20120611_170225_495226_E5119F12)
References: <1339426884-6591-1-git-send-email-eyal@wizery.com>
	 (sfid-20120611_170225_495226_E5119F12)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-11 at 18:01 +0300, Eyal Shapira wrote:
> EAPOLs are sent at high rates as they are considered
> data packets. Some APs don't respond well to these rates
> and don't respond with EAPOL 3/4.
> Send EAPOLs with basic rate policy in order to avoid that.
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---
>  drivers/net/wireless/ti/wlcore/tx.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
> index 6983e7a..8ee82b9 100644
> --- a/drivers/net/wireless/ti/wlcore/tx.c
> +++ b/drivers/net/wireless/ti/wlcore/tx.c
> @@ -305,11 +305,15 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>  	if (is_dummy || !wlvif)
>  		rate_idx = 0;
>  	else if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
> -		/* if the packets are destined for AP (have a STA entry)
> -		   send them with AP rate policies, otherwise use default
> -		   basic rates */
> +		/*
> +		 * if the packets are destined for AP (have a STA entry)
> +		 * send them with AP rate policies (EAPOLs are an exception),
> +		 * otherwise use default basic rates
> +		 */

Might be worth indicating what APs have this bug, and possibly putting
something like this into mac80211 (as well)?

johannes

