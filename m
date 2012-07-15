Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42361 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab2GONAa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 09:00:30 -0400
Message-ID: <5002BEE6.3040502@hauke-m.de> (sfid-20120715_150035_267763_9EB98810)
Date: Sun, 15 Jul 2012 15:00:22 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcma-pci-bridge issue with bcm43224
References: <4FFD7B06.4010401@broadcom.com> <CACna6rxf2bmhEKqGPcgP50au=XxeRHUQUvMm1OSidp+oQ6ycuA@mail.gmail.com> <5001405A.6090308@broadcom.com>
In-Reply-To: <5001405A.6090308@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/14/2012 11:48 AM, Arend van Spriel wrote:
> On 07/11/2012 04:32 PM, Rafał Miłecki wrote:
>> 2012/7/11 Arend van Spriel <arend@broadcom.com>:
>>> Hi Rafal
>>>
>>> I am testing with BCM43224 in PCIe slot:
>>> $ lspci -vns 03:00.0
>>> 03:00.0 0280: 14e4:4353 (rev 01)
>>>         Subsystem: 1028:000e
>>>         Flags: bus master, fast devsel, latency 0, IRQ 17
>>>         Memory at e6e00000 (64-bit, non-prefetchable) [size=16K]
>>>         Capabilities: <access denied>
>>>         Kernel driver in use: bcma-pci-bridge
>>>
>>> In the log the irq field in the bcma_device structure is printed in
>>> brcmsmac probe function and the value seems invalid hence the
>>> request_irq() failure. Any clues?
brcmsmac prints: irq: -421527552 this is the reason request_irq() fails.

Does this problem also occurs on other wireless cards?
>>>
>>> Gr. AvS
>>>
>>> [86629.110723] bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and
>>> package 0x0A
>>> [86629.110783] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id
>>> 0x800, rev 0x22, class 0x0)
>>> [86629.110828] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id
>>> 0x812, rev 0x17, class 0x0)
>>> [86629.110939] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820,
>>> rev 0x0F, class 0x0)
>>> [86629.144286] bcma: bus0: Bus registered
>>> [86672.144812] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq
>>> -421527552
This number is wrong. This number is a unsigned int, and %d should only
be used for signed ints.

Have you checked if irq is set correctly in drivers/bcma/main.c or if
the pci_dev structure contains a wrong value?

-421527552 is 0xe6e00000 in hex, this looks like it reads out a wrong
memory region when accession a structure, have you tried to to a
complete recompile of the kernel?

>>> [86672.150745] brcmsmac: Applying 43224B0+ WARs
>>> [86672.153155] ieee80211 phy0: wl0: request_irq() failed
>>> [86672.153169] brcmsmac: brcms_bcma_probe: brcms_attach failed!
>>
>> No idea at the moment. I can setup my machine and give it a try. I'll
>> need a day or rather two.
>>
>> Are you using wireless-testing?
>>
> 
> Additional info: the issue does not show on a x86_64 platform, which has
> the same PCIe chip.
This is strange but it increases my thoughts that the error is not
directly related to brcmsmac and bcma.
