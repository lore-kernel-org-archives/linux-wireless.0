Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:49921 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750889Ab1ISFVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 01:21:55 -0400
Received: by bkbzt4 with SMTP id zt4so6511116bkb.33
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 22:21:53 -0700 (PDT)
Subject: Re: [PATCH 2/2] wl12xx: handle CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316347759-22030-2-git-send-email-eliad@wizery.com>
References: <1316347759-22030-1-git-send-email-eliad@wizery.com>
	 <1316347759-22030-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 08:21:50 +0300
Message-ID: <1316409710.2157.18.camel@cumari> (sfid-20110919_072203_740054_6369A736)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-18 at 15:09 +0300, Eliad Peller wrote: 
> The fw sends the CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID event
> when it wants the driver to increase the dynamic ps (auto-mode)
> timeout (or restore the original timeout).
> 
> unmask CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID, and increase/restore
> the dynamic ps default timeout upon getting this event.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Okay, now I see you're doing it automatically here (I should read all
the series before commenting :P).  Anyway, do we really need the debugfs
stuff? It's okay to make it readable, but I still don't see why we need
to write.


> diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
> index c73fe4c..79ff3bb 100644
> --- a/drivers/net/wireless/wl12xx/event.c
> +++ b/drivers/net/wireless/wl12xx/event.c
> @@ -258,6 +258,14 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
>  		wl12xx_event_soft_gemini_sense(wl,
>  					       mbox->soft_gemini_sense_info);
>  
> +	if (vector & CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID &&
> +	    wl->bss_type == BSS_TYPE_STA_BSS) {
> +		int timeout = -1;
> +		if (mbox->change_auto_mode_timeout)
> +			timeout = 500;
> +		ieee80211_set_dyn_ps_timeout(wl->vif, timeout);
> +	}
> +
>  	/*
>  	 * The BSS_LOSE_EVENT_ID is only needed while psm (and hence beacon
>  	 * filtering) is enabled. Without PSM, the stack will receive all

Any more details on why you chose 500? Should this be part of conf or a
macro to avoid magic numbers?

-- 
Cheers,
Luca.

