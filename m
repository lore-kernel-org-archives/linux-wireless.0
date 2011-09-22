Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:39598 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab1IVNhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 09:37:04 -0400
Received: by mail-bw0-f47.google.com with SMTP id 11so2869023bke.6
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 06:37:02 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Add support for HW channel switch
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315476093-27583-1-git-send-email-shahar_levi@ti.com>
References: <1315476093-27583-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 16:36:59 +0300
Message-ID: <1316698619.2157.628.camel@cumari> (sfid-20110922_153709_094189_90C4FF26)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-08 at 13:01 +0300, Shahar Levi wrote: 
> WL12xx FW supports HW channel switch mechanism.
> Add HW channel switch support via channel_switch ops.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

[...]

> +static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
> +				     struct ieee80211_channel_switch *ch_switch)
> +{
> +	struct wl1271 *wl = hw->priv;
> +	int ret;
> +
> +	wl1271_debug(DEBUG_MAC80211, "mac80211 channel switch");
> +
> +	mutex_lock(&wl->mutex);
> +
> +	if (unlikely(wl->state == WL1271_STATE_OFF)) {
> +		mutex_unlock(&wl->mutex);
> +		ieee80211_chswitch_done(wl->vif, false);
> +		return;
> +	}
> +
> +	ret = wl1271_ps_elp_wakeup(wl);
> +	if (ret < 0)
> +		goto out;
> +
> +	/* send all pending packets */
> +	wl1271_tx_work_locked(wl);

Is this really needed? Can anyone tell why?

-- 
Cheers,
Luca.

