Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54162 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab2FKVgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 17:36:24 -0400
Message-ID: <4FD664D1.5000308@hauke-m.de> (sfid-20120611_233627_463232_F88B0C46)
Date: Mon, 11 Jun 2012 23:36:17 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/18] brcmsmac: remove PCIE() makro
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-2-git-send-email-hauke@hauke-m.de> <4FD10989.6040701@broadcom.com> <4FD4A102.20805@hauke-m.de> <4FD5A39F.4090805@broadcom.com>
In-Reply-To: <4FD5A39F.4090805@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2012 09:51 AM, Arend van Spriel wrote:
> On 06/10/2012 03:28 PM, Hauke Mehrtens wrote:
>> On 06/07/2012 10:05 PM, Arend van Spriel wrote:
>>> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>>>> Instead of checking if there is a PCIe core on the bus, better check if
>>>> hosttype is PCIe.
>>>
>>> I was under the impression that the macro was used for code needed when
>>> the chip has a PCIe core instead of a PCI core. Maybe BCMA only supports
>>> chips with PCIe core and in the respect checking the hosttype is
>>> essentially the same, but I would not necessarily call it better.
>>>
>>
>> The code from the initial submission to staging looked like this:
>>
>> #define PCIE(si) ((BUSTYPE((si)->pub.bustype) == PCI_BUS) &&	\
>> 		  ((si)->pub.buscoretype == PCIE_CORE_ID))
>>
>> I have never seen a device using the AI bus (bcma) and a PCI core and
>> not a PCIe core and I do not think bcma will work with a PCI device or
>> core. The bustype in your old code is the same as the hosttype in bcma,
>> so under the assumption that all device are using PCIe that are coming
>> to this code the code now does the same as in the initial submission to
>> staging.
> 
> If bcma does not work with a PCI core, maybe we could/should add a
> WARN_ON() in host_pci.c when it has no PCIe core.
> 
> Gr. AvS
> 
That sounds good, for now bcma displays this warning if it detects a PCI
and not a PCIe card: "PCI card detected, report problems." adding a
warning looks better to me. bcma_core_pci_init() is just run for PCIE
cores and not for PCI cores, so I do not think PCI cores will work with
the current code.

Hauke
