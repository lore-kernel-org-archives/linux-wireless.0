Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:45596 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755634AbeEaROY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 13:14:24 -0400
Date: Thu, 31 May 2018 10:14:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [RFT 3/6] wlcore: Add support for runtime PM
Message-ID: <20180531171420.GQ5705@atomide.com> (sfid-20180531_191430_223901_26CC204F)
References: <20180529180605.73622-1-tony@atomide.com>
 <20180529180605.73622-4-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180529180605.73622-4-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [180529 18:09]:
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
...
> +static int __maybe_unused wlcore_runtime_resume(struct device *dev)
> +{
> +	struct wl1271 *wl = dev_get_drvdata(dev);
> +	DECLARE_COMPLETION_ONSTACK(compl);
> +	unsigned long flags;
> +	int ret;
> +	unsigned long start_time = jiffies;
> +	bool pending = false;
> +
> +	/* Nothing to do if no ELP mode requested */
> +	if (!test_bit(WL1271_FLAG_IN_ELP, &wl->flags))
> +		return 0;
> +
> +	wl1271_debug(DEBUG_PSM, "waking up chip from elp");
> +
> +	spin_lock_irqsave(&wl->wl_lock, flags);
> +	if (test_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags))
> +		pending = true;
> +	else
> +		wl->elp_compl = &compl;
> +	spin_unlock_irqrestore(&wl->wl_lock, flags);
> +
> +	ret = wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
> +	if (ret < 0) {
> +		wl12xx_queue_recovery_work(wl);
> +		goto err;
> +	}
> +
> +	if (!pending) {
> +		ret = wait_for_completion_timeout(&compl,
> +			msecs_to_jiffies(WL1271_WAKEUP_TIMEOUT));
> +		if (ret == 0) {
> +			wl1271_error("ELP wakeup timeout!");
> +			wl12xx_queue_recovery_work(wl);
> +
> +			/* Return no error for runtime PM for recovery */
> +			return 0;

I noticed returning here and not clearing WL1271_FLAG_IN_ELP can
produce errors. But I think it's unsafe to clear WL1271_FLAG_IN_ELP
if wlcore did not wake. So I suggest we return early here to see the
errors so we can fix the issues. I'll post one more patch that fixes
the init time "ELP wakeup timeout!" issues for me.

Regards,

Tony
