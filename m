Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39628 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab1LHWhI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 17:37:08 -0500
Message-ID: <4EE13C0C.30602@hauke-m.de> (sfid-20111208_233712_673856_F259C0D8)
Date: Thu, 08 Dec 2011 23:37:00 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Michael Buesch <m@bues.ch>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH] ssb: fix init regression with SoCs
References: <1323123591-11982-1-git-send-email-hauke@hauke-m.de> <4EDD574E.9090801@lwfinger.net>
In-Reply-To: <4EDD574E.9090801@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On 12/06/2011 12:44 AM, Larry Finger wrote:
> On 12/05/2011 04:19 PM, Hauke Mehrtens wrote:
>> --- a/drivers/ssb/driver_pcicore.c
>> +++ b/drivers/ssb/driver_pcicore.c
>> @@ -517,10 +517,14 @@ static void
>> ssb_pcicore_pcie_setup_workarounds(struct ssb_pcicore *pc)
>>
>>   static void __devinit ssb_pcicore_init_clientmode(struct ssb_pcicore
>> *pc)
>>   {
>> -    ssb_pcicore_fix_sprom_core_index(pc);
>> +    struct ssb_device *pdev = pc->dev;
>> +    struct ssb_bus *bus = pdev->bus;
>> +
>> +    if (bus->bustype == SSB_BUSTYPE_PCI)
>> +        ssb_pcicore_fix_sprom_core_index(pc);
>>
>>       /* Disable PCI interrupts. */
>> -    ssb_write32(pc->dev, SSB_INTVEC, 0);
>> +    ssb_write32(pdev, SSB_INTVEC, 0);
> 
> As bus == pc->dev->bus is only used once, why bother to create it? If
> you were to change that, then pdev == pc->dev is only used once. Any
> real reason to change the lines above?
Not really, I will send  a v2.

Hauke
