Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64782 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbaITPkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2014 11:40:14 -0400
Message-ID: <541D9FD8.4000404@gmail.com> (sfid-20140920_174020_285689_27CD9522)
Date: Sat, 20 Sep 2014 21:10:08 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
CC: zajec5@gmail.com, arend@broadcom.com,
	linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/2] bcma: register bcma as device tree driver
References: <1411218125-32670-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1411218125-32670-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 20 September 2014 06:32 PM, Hauke Mehrtens wrote:
> This driver is used by the bcm53xx ARM SoC code. Now it is possible to
> give the address of the chipcommon core in device tree and bcma will
> search for all the other cores.

(...)

> +
> +static const struct of_device_id bcma_host_soc_of_match[] = {
> +	{ .compatible = "brcm,bus-axi", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, bcma_host_soc_of_match);
> +
> +static struct platform_driver bcma_host_soc_driver = {
> +	.driver = {
> +		.name = "bcma-host-soc",
> +		.owner = THIS_MODULE,

This field updated automatically...

> +		.of_match_table = bcma_host_soc_of_match,
> +	},
> +	.probe		= bcma_host_soc_probe,
> +	.remove		= bcma_host_soc_remove,
> +};
> +
> +int __init bcma_host_soc_register_driver(void)
> +{
> +	return platform_driver_register(&bcma_host_soc_driver);
> +}
> +
> +void __exit bcma_host_soc_unregister_driver(void)
> +{
> +	platform_driver_unregister(&bcma_host_soc_driver);
> +}
> +#endif /* CONFIG_OF */

Why dont you use module_platform_driver(...)...?

-- 
Regards,
Varka Bhadram.

