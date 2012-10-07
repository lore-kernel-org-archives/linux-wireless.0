Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44426 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab2JGWB0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Oct 2012 18:01:26 -0400
Message-ID: <5071FBAB.3020909@hauke-m.de> (sfid-20121008_000131_036611_DD98B627)
Date: Mon, 08 Oct 2012 00:01:15 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: do not initialize deactivated PCIe cores
References: <1349043174-5371-1-git-send-email-hauke@hauke-m.de> <CACna6rw73feYKY7=5MyNjBeYjaC=Q+JmTeR7nfkmh9XxfKeJjw@mail.gmail.com>
In-Reply-To: <CACna6rw73feYKY7=5MyNjBeYjaC=Q+JmTeR7nfkmh9XxfKeJjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2012 09:48 AM, Rafał Miłecki wrote:
> 2012/10/1 Hauke Mehrtens <hauke@hauke-m.de>:
>> @@ -396,6 +391,11 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
>>
>>         bcma_info(bus, "PCIEcore in host mode found\n");
>>
>> +       if (bus->sprom.boardflags_lo & BCMA_CORE_PCI_BFL_NOPCI) {
>> +               bcma_info(bus, "This PCIE core is disabled and not working\n");
>> +               return;
>> +       }
>> +
> 
> I wonder if this bit is also valid for client mode PCIe core. Maybe
> this check should be put directly in bcma_core_pci_init?

I put it into the host mode code, because I do not want to interfere
with some wrongly programed client mode pcie devices. I have just seen a
SoC with a PCIe device in hostmode where this option was set. I would
have no problem with moving this into bcma_core_pci_init if someone with
some cards could test it before.

Hauke
