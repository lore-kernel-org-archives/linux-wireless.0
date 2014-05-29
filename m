Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1266 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044AbaE2CK7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 22:10:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 28 May 2014 19:10:38 -0700
Subject: RE: [RFC] mwifiex: block work queue while suspended
Message-ID: <477F20668A386D41ADCC57781B1F70430F71047BBF@SC-VEXCH1.marvell.com> (sfid-20140529_041102_630412_2B46E408)
References: <20140516012439.GI15430@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
 <20140526080110.GJ6118@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5E39F@SC-VEXCH1.marvell.com>
 <20140529012233.GC10000@us.netrek.org>
In-Reply-To: <20140529012233.GC10000@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> > > May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341764] mmc0: Timeout waiting for hardware interrupt.
> > > May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341784] mwifiex_sdio mmc0:0001:1: read mp_regs failed
> >
> > I was expecting that mwifiex_sdio_resume handler is called before
> > the SDIO interrupt function is called.
> 
> This does not happen.  The SDIO interrupt function is always called
> before the mwifiex_sdio_resume handler.

I see.

> 
> Method to test:
> 
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -712,6 +712,9 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
>  	u32 sdio_ireg;
>  	unsigned long flags;
> 
> +	if (adapter->is_suspended)
> +		dev_warn(adapter->dev, "interrupt while adapter is suspended\n");
> +
>  	if (mwifiex_read_data_sync(adapter, card->mp_regs, MAX_MP_REGS,
>  				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK,
>  				   0)) {
> 
> # grep -c "after resume" /var/log/messages
> 630
> # grep -c "interrupt while adapter" /var/log/messages
> 630
> 
> Also, sometimes mwifiex_sdio_suspend runs while an SDIO register
> operation is in progress, because of an interrupt.  I can reduce the
> frequency of the "mmc0: Timeout..." if I delay suspend until the
> register option is completed.
> 
> This occurs roughly 3 out of 630 suspends.
> 
> The platform is not SMP, even though it is mmp3.  So I made an
> unpleasant hack:
> 
> --- a/drivers/net/wireless/mwifiex/sdio.c
> +++ b/drivers/net/wireless/mwifiex/sdio.c
> @@ -54,6 +54,8 @@ static DEFINE_RATELIMIT_STATE(noskb_rs,
>  		120 * HZ,
>  		1);
> 
> +volatile static bool in_progress;
> +
>  /*
>   * SDIO probe.
>   *
> @@ -206,6 +208,22 @@ static int mwifiex_sdio_suspend(struct device *dev)
>  	struct mwifiex_adapter *adapter;
>  	mmc_pm_flag_t pm_flag = 0;
>  	int ret = 0;
> +	int i;
> +
> +	/* an attempt to avoid suspend for a short time while sdio i/o is in progress */
> +	if (in_progress) {
> +		pr_err("suspend: sdio i/o is in_progress, delaying\n");
> +		WARN_ON_ONCE(1);
> +
> +		i = 50;
> +		while (in_progress && i-- > 0) msleep(10);
> +
> +		if (in_progress) {
> +			pr_err("suspend: sdio i/o was in_progress\n");
> +			WARN_ON_ONCE(1);
> +			return -EFAULT;
> +		}
> +	}

I think MMC has better knowledge about the host being claimed or not. If a register read/write is in progress, host->claimed and host->claim_cnt should have non-zero values.
So, the delay logic is better to be done in MMC before calling driver's suspend handler.

Regards,
Bing
