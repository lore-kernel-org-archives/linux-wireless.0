Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55098 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932671Ab0BCTrr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 14:47:47 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43/b43legacy: Wake queues in wireless_core_start
Date: Wed, 3 Feb 2010 20:47:38 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4b69cf98.XrygqPz8t8ULClLG%Larry.Finger@lwfinger.net>
In-Reply-To: <4b69cf98.XrygqPz8t8ULClLG%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002032047.40531.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 03 February 2010 20:33:44 Larry Finger wrote:
> If b43 or b43legacy are deauthenticated or disconnected, there is a
> possibility that a reconnection is tried with the queues stopped in
> mac80211. To prevent this, start the queues before setting
> STAT_INITIALIZED.
> 
> In b43, a similar change has been in place (twice) in the
> wireless_core_init() routine. Remove the duplicate and add similar
> code to b43legacy.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@kernel.org>   [2.6.32]
> ---
> 
> John,
> 
> The b43 patch to wireless_core_start() seems to help a regression
> between 2.6.31 and 2.6.32. Accordingly, these changes should be
> applied to 2.6.33 with the automatic backport to 2.6.32.
> 
> Larry
> ---
> 
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> +++ wireless-testing/drivers/net/wireless/b43/main.c
> @@ -3980,6 +3980,7 @@ static int b43_wireless_core_start(struc
>  	}
>  
>  	/* We are ready to run. */
> +	ieee80211_wake_queues(dev->wl->hw);
>  	b43_set_status(dev, B43_STAT_STARTED);
>  
>  	/* Start data flow (TX/RX). */
> @@ -4389,8 +4390,6 @@ static int b43_wireless_core_init(struct
>  
>  	ieee80211_wake_queues(dev->wl->hw);
>  
> -	ieee80211_wake_queues(dev->wl->hw);
> -
>  	b43_set_status(dev, B43_STAT_INITIALIZED);

Well, I wonder why it makes a difference.
I think we only call core_start() right after core_init() calls.

Anyway, I think wake_queues should both be removed from core_init()
and queues should only be woken in core_start.

-- 
Greetings, Michael.
