Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:59639 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864AbaIRUwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 16:52:13 -0400
Message-ID: <541B45FB.3000503@hauke-m.de> (sfid-20140918_225217_531450_A17CF0BA)
Date: Thu, 18 Sep 2014 22:52:11 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arend Van Spriel <arend@broadcom.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/2] bcma: register bcma as device tree driver
References: <1410904582-6519-1-git-send-email-hauke@hauke-m.de> <CACna6rw0-g+v6u3Yxhnmy1NT0mhj-s4re5R3z0dbBV-tMvky6Q@mail.gmail.com>
In-Reply-To: <CACna6rw0-g+v6u3Yxhnmy1NT0mhj-s4re5R3z0dbBV-tMvky6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2014 10:03 PM, Rafał Miłecki wrote:
> On 16 September 2014 23:56, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> +The cores on the AXI bus are auto detected by bcma. bcma automatically
>> +detects the cores
> 
> I'm far from being an English expert, but above is kind of pleonasm to me ;)

Yes to me too. ;-)

>> and the memory ranges they are using and they get
>> +registered afterwards. Automatic detection of the IRQ number is not
>> +possible on BCM47xx/BCM53xx ARM and MIPS SoCs.
> 
> Should we replace "not possible" with something like "not reliable"?
> After the last info we got from Arend.

Yes that sounds good.

> 
> 
>> +#ifdef CONFIG_BCMA_HOST_SOC
>> +/* host_pci.c */
> 
> s/pci/soc/
> 
> 
>> +#ifdef CONFIG_OF
>> +extern int __init bcma_host_soc_register_driver(void);
>> +extern void __exit bcma_host_soc_unregister_driver(void);
>> +#else
>> +static inline int __init bcma_host_soc_register_driver(void)
>> +{
>> +       return 0;
>> +}
>> +static inline void __exit bcma_host_soc_unregister_driver(void)
>> +{
>> +}
>> +#endif /* CONFIG_OF */
>> +#endif /* CONFIG_BCMA_HOST_SOC */
> 
> OK, so you just made bcma_host_soc_(un)register_driver calls safe above.
> 
> 
>> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
>> index c421403..e5d578c 100644
>> --- a/drivers/bcma/main.c
>> +++ b/drivers/bcma/main.c
>> @@ -528,6 +528,13 @@ static int __init bcma_modinit(void)
>>         if (err)
>>                 return err;
>>
>> +#ifdef CONFIG_BCMA_HOST_SOC
>> +       err = bcma_host_soc_register_driver();
>> +       if (err) {
>> +               pr_err("SoC host initialization failed\n");
>> +               err = 0;
>> +       }
>> +#endif
> 
> And above you check for CONFIG_ anyway.
> 
Yes that sounds good.

