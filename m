Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:53551 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbcBHMMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 07:12:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>,
	wnhuang@chromium.com, devicetree@vger.kernel.org,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v3 3/3] mwifiex: parse host wakeup configuration from device tree
Date: Mon, 08 Feb 2016 13:12:31 +0100
Message-ID: <2675319.xbIeWCdnho@wuerfel> (sfid-20160208_131243_035595_56695FF9)
In-Reply-To: <1454926528-17480-3-git-send-email-akarwar@marvell.com>
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com> <1454926528-17480-3-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 February 2016 02:15:28 Amitkumar Karwar wrote:
> @@ -30,6 +84,44 @@ static int mwifiex_plt_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
> +static int mwifiex_plt_suspend(struct device *dev)
> +{
> +	struct mwifiex_wake_dev *ctx = dev_get_drvdata(dev);
> +	int ret;
> +
...
> +static const struct dev_pm_ops mwifiex_plt_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(mwifiex_plt_suspend, mwifiex_plt_resume)
> +};
> +#endif /* CONFIG_PM_SLEEP */
> +
>  static const struct of_device_id mwifiex_dt_match[] = {
>  	{
>  		.compatible = "marvell,mwifiex",
> @@ -45,6 +137,9 @@ static struct platform_driver mwifiex_platform_driver = {
>  	.driver = {
>  		.name	= "mwifiex_plt",
>  		.of_match_table = mwifiex_dt_match,
> +#ifdef CONFIG_PM_SLEEP
> +		.pm             = &mwifiex_plt_pm_ops,
> +#endif
>  	}
>  };

Just remove the #ifdef here, and mark the functions as __maybe_unused.

	Arnd
