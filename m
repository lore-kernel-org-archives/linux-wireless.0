Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab0F3KRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 06:17:10 -0400
Subject: Re: [PATCH 1/2] mac80211: Dont allow to wake up netif tx queues
 while on off channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1277892907-2401-1-git-send-email-vasanth@atheros.com>
References: <1277892907-2401-1-git-send-email-vasanth@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Jun 2010 12:17:06 +0200
Message-ID: <1277893026.7823.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-30 at 03:15 -0700, Vasanthakumar Thiagarajan wrote:
> Drivers are not supposed to call ieee80211_wake_queue() while operating
> on off channel during sw scanning, but there is no clear way for
> the driver to know that it is operating on off channel during scanning.
> There are cases (unavailablity/availability of tx buffers in ath9k, for
> example) where driver needs to stop/restart tx queues during background
> scanning state, this might result in waking up the corresponding netif
> tx queue when the device is on off channel which is not desired. This
> patches fixes this by checking SCAN_OFF_CHANNEL bit in scanning before
> restarting the tx queue.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  net/mac80211/util.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index a54cf14..1938a67 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -277,7 +277,8 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
>  
>  	__clear_bit(reason, &local->queue_stop_reasons[queue]);
>  
> -	if (local->queue_stop_reasons[queue] != 0)
> +	if ((local->queue_stop_reasons[queue] != 0) ||
> +	    test_bit(SCAN_OFF_CHANNEL, &local->scanning))
>  		/* someone still has this queue stopped */
>  		return;

That doesn't seem to make sense, since we treat driver and scan stop
status separately via wake_queue_by_reason()

johannes

