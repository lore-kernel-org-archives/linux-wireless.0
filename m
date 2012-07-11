Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2312 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494Ab2GKP4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 11:56:08 -0400
Message-ID: <4FFDA20F.4000308@broadcom.com> (sfid-20120711_175613_452927_8341F45E)
Date: Wed, 11 Jul 2012 17:55:59 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hauke Mehrtens" <hauke@hauke-m.de>
Subject: Re: bcma-pci-bridge issue with bcm43224
References: <4FFD7B06.4010401@broadcom.com>
 <CACna6rxf2bmhEKqGPcgP50au=XxeRHUQUvMm1OSidp+oQ6ycuA@mail.gmail.com>
In-Reply-To: <CACna6rxf2bmhEKqGPcgP50au=XxeRHUQUvMm1OSidp+oQ6ycuA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2012 04:32 PM, Rafał Miłecki wrote:
> 2012/7/11 Arend van Spriel <arend@broadcom.com>:
>> Hi Rafal
>>
>> I am testing with BCM43224 in PCIe slot:
>> $ lspci -vns 03:00.0
>> 03:00.0 0280: 14e4:4353 (rev 01)
>>         Subsystem: 1028:000e
>>         Flags: bus master, fast devsel, latency 0, IRQ 17
>>         Memory at e6e00000 (64-bit, non-prefetchable) [size=16K]
>>         Capabilities: <access denied>
>>         Kernel driver in use: bcma-pci-bridge
>>
>> In the log the irq field in the bcma_device structure is printed in
>> brcmsmac probe function and the value seems invalid hence the
>> request_irq() failure. Any clues?
>>
>> Gr. AvS
>>
>> [86629.110723] bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and
>> package 0x0A
>> [86629.110783] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id
>> 0x800, rev 0x22, class 0x0)
>> [86629.110828] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id
>> 0x812, rev 0x17, class 0x0)
>> [86629.110939] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820,
>> rev 0x0F, class 0x0)
>> [86629.144286] bcma: bus0: Bus registered
>> [86672.144812] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq
>> -421527552
>> [86672.150745] brcmsmac: Applying 43224B0+ WARs
>> [86672.153155] ieee80211 phy0: wl0: request_irq() failed
>> [86672.153169] brcmsmac: brcms_bcma_probe: brcms_attach failed!
> 
> No idea at the moment. I can setup my machine and give it a try. I'll
> need a day or rather two.
> 
> Are you using wireless-testing?
> 

Yes. My branch is based on

commit 43eec16e655eeaee396fe20ab2e92f0fee5a9440
Merge: bb75604 abb14fc
Author: John W. Linville <linville@tuxdriver.com>
Date:   Fri Jul 6 16:30:45 2012 -0400

Gr. AvS

