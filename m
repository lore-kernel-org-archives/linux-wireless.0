Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50901 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758136Ab1FFWLK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 18:11:10 -0400
Message-ID: <4DED5077.9040503@hauke-m.de> (sfid-20110607_001120_277516_491AF8A5)
Date: Tue, 07 Jun 2011 00:11:03 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
Subject: Re: [RFC][PATCH 07/10] bcma: add pci(e) host mode
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>	<1307311658-15853-8-git-send-email-hauke@hauke-m.de> <BANLkTik93+7ujHyv0_Zk2Ma9BPsHvJTttg@mail.gmail.com>
In-Reply-To: <BANLkTik93+7ujHyv0_Zk2Ma9BPsHvJTttg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2011 01:32 PM, Rafał Miłecki wrote:
> 2011/6/6 Hauke Mehrtens <hauke@hauke-m.de>:
>> +config BCMA_PCICORE_HOSTMODE
>> +       bool "Hostmode support for BCMA PCI core"
>> +       depends on BCMA_DRIVER_MIPS
>> +       help
>> +         PCIcore hostmode operation (external PCI bus).
> 
> I think you started to use BCMA_DRIVER_corename. Could you stick to it
> (one schema), please? Maybe just
> BCMA_DRIVER_PCI_HOSTMODE
> ?
> 
Yes sounds better.
> 
>> +#ifdef CONFIG_BCMA_PCICORE_HOSTMODE
>> +       pc->hostmode = bcma_pcicore_is_in_hostmode(pc);
>> +       if (pc->hostmode)
>> +               bcma_pcicore_init_hostmode(pc);
>> +#endif /* CONFIG_BCMA_PCICORE_HOSTMODE */
>> +       if (!pc->hostmode)
>> +               bcma_pcicore_serdes_workaround(pc);
> 
> Does it make sense to init hostmode PCI like clientmode if we just
> disable CONFIG_BCMA_PCICORE_HOSTMODE?
> 
> I think we should always check if core is host or client mode and use
> correct initialization only. We should not init it as clientmode just
> because we do not have driver for host mode.
Yes we should not initialize a host mode pci core with client init code
as it will break my device. ;-) I will place
bcma_pcicore_is_in_hostmode() into the normal PCI driver code so it is
available all the time.
> 
> 
>> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
>> new file mode 100644
>> index 0000000..b52c6c9
>> --- /dev/null
>> +++ b/drivers/bcma/driver_pci_host.c
>> @@ -0,0 +1,44 @@
>> +/*
>> + * Broadcom specific AMBA
>> + * PCI Core
> 
> Please rename "PCI Core", add something about hostmode.
> 
Missed that while copy and past.

Hauke
