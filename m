Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:33101 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaITPnm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2014 11:43:42 -0400
Message-ID: <541DA0AB.70307@hauke-m.de> (sfid-20140920_174345_548776_42416DFC)
Date: Sat, 20 Sep 2014 17:43:39 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
CC: zajec5@gmail.com, arend@broadcom.com,
	linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/2] bcma: register bcma as device tree driver
References: <1411218125-32670-1-git-send-email-hauke@hauke-m.de> <541D9FD8.4000404@gmail.com>
In-Reply-To: <541D9FD8.4000404@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2014 05:40 PM, Varka Bhadram wrote:
> On Saturday 20 September 2014 06:32 PM, Hauke Mehrtens wrote:
>> This driver is used by the bcm53xx ARM SoC code. Now it is possible to
>> give the address of the chipcommon core in device tree and bcma will
>> search for all the other cores.
> 
> (...)
> 
>> +
>> +static const struct of_device_id bcma_host_soc_of_match[] = {
>> +    { .compatible = "brcm,bus-axi", },
>> +    {},
>> +};
>> +MODULE_DEVICE_TABLE(of, bcma_host_soc_of_match);
>> +
>> +static struct platform_driver bcma_host_soc_driver = {
>> +    .driver = {
>> +        .name = "bcma-host-soc",
>> +        .owner = THIS_MODULE,
> 
> This field updated automatically...

Ok, I will remove this line.

>> +        .of_match_table = bcma_host_soc_of_match,
>> +    },
>> +    .probe        = bcma_host_soc_probe,
>> +    .remove        = bcma_host_soc_remove,
>> +};
>> +
>> +int __init bcma_host_soc_register_driver(void)
>> +{
>> +    return platform_driver_register(&bcma_host_soc_driver);
>> +}
>> +
>> +void __exit bcma_host_soc_unregister_driver(void)
>> +{
>> +    platform_driver_unregister(&bcma_host_soc_driver);
>> +}
>> +#endif /* CONFIG_OF */
> 
> Why dont you use module_platform_driver(...)...?

module_platform_driver() does not work, because we can only have one
module_init() method in a module and main.c already has one. This driver
can also be registered as an PCI device.

Hauke
