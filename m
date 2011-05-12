Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:59694 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932122Ab1ELUYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 16:24:23 -0400
Received: by mail-ey0-f175.google.com with SMTP id 27so796721eye.34
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 13:24:22 -0700 (PDT)
Subject: Re: [PATCH 7/7] wl12xx: enter/exit psm on wowlan suspend/resume
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305104068-32240-8-git-send-email-eliad@wizery.com>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
	 <1305104068-32240-8-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 23:24:18 +0300
Message-ID: <1305231858.12586.1050.camel@cumari> (sfid-20110512_222426_452320_620F42A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-11 at 11:54 +0300, Eliad Peller wrote:
> When operating as station, enter psm before suspending
> the device into wowlan state.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 308855a..b4dd1d9 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -1332,6 +1332,79 @@ static struct notifier_block wl1271_dev_notifier = {
>  	.notifier_call = wl1271_dev_notify,
>  };
>  
> +static int wl1271_configure_suspend(struct wl1271 *wl)
> +{
> +	int ret;
> +
> +	if (wl->bss_type != BSS_TYPE_STA_BSS)
> +		return 0;
> +
> +	mutex_lock(&wl->mutex);
> +
> +	ret = wl1271_ps_elp_wakeup(wl);
> +	if (ret < 0)
> +		goto out_unlock;
> +
> +	/* enter psm if needed*/
> +	if (!test_bit(WL1271_FLAG_PSM, &wl->flags)) {
> +		DECLARE_COMPLETION_ONSTACK(compl);
> +
> +		wl->ps_compl = &compl;
> +		ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
> +				   wl->basic_rate, true);
> +		if (ret < 0)
> +			goto out_sleep;
> +
> +		/* we must unlock here so we will be able to get events */
> +		wl1271_ps_elp_sleep(wl);
> +		mutex_unlock(&wl->mutex);
> +
> +		ret = wait_for_completion_timeout(
> +			&compl, msecs_to_jiffies(500));

We have this for the ELP wakeup:

#define WL1271_WAKEUP_TIMEOUT 500

We should have a similar definition PS timeout.  And is this value just
a guess or is there a real meaning to it? Can these timeouts be combined
instead of having separate defines?


-- 
Cheers,
Luca.

