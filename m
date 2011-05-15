Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1652 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab1EOIit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 04:38:49 -0400
Message-ID: <4DCF9105.6010504@broadcom.com> (sfid-20110515_103856_258350_6C4D67FE)
Date: Sun, 15 May 2011 10:38:29 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Gottfried Haider" <gottfried.haider@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"=?UTF-8?B?UmFmYcWCIE0=?= =?UTF-8?B?acWCZWNraQ==?="
	<zajec5@gmail.com>
Subject: Re: brcmsmac and BCM943224HMB (AXI?)
References: <BANLkTim78s_5DNateJDc7fF=Kh5bTMSUPw@mail.gmail.com>
In-Reply-To: <BANLkTim78s_5DNateJDc7fF=Kh5bTMSUPw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/14/2011 04:55 PM, Gottfried Haider wrote:
> Dear Arend,
>
> I am trying to get a BCM943224HMB module (a Half-Mini Card) [1]
> working with the brcmsmac driver.
>
> Broadcom's webpage mentions that the module includes a BCM43224 core
> (in addition to a BCM2070 Bluetooth one), but the device is not
> getting recognized by the driver in -rc7.
>
> Without understanding too much about AXI, I tried both your
> implementation and Rafał's (the latter with the addition of my PCI
> id). Both did not make the device magically work with brcmsmac, but
> with Rafał's code I got the following output, telling me that the
> device indeed makes use of AXI:
There are two modules for this support. One from Rafal called bcma.ko 
and I did one called brcmaxi.ko. I did not get combination brcmsmac/bcma 
working yet. So the brcmsmac which is in the linux-next tree does not 
need either brcmaxi nor bcma. That is work in progress.
> [    3.651668] bcma-pci-bridge 0000:04:00.0: PCI INT A ->  GSI 17
> (level, low) ->  IRQ 17
> [    3.651686] bcma-pci-bridge 0000:04:00.0: setting latency timer to 64
> [    3.651818] bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800,
> rev 0x22, class 0x0)
> [    3.651841] bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812,
> rev 0x17, class 0x0)
> [    3.651890] bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev
> 0x0F, class 0x0)
> [    3.651986] bcma: Switched to core: 0x800
> [    3.651998] bcma: Found rev 6 PMU (capabilities 0x108C2606)
> [    3.652020] bcma: Switched to core: 0x820
> [    3.710315] bcma: Bus registered
>
>
> Since you mentioned that you tested brcmaxi with brcmsmac, can you
> tell me what's missing to get the device working? Is this only a
> question of adding some device IDs to brcmsmac, or does the driver
> need some major changes to talk to the core through bcma/brcmaxi? (Or
> something completely different?)
As said brcmaxi and bcma are not needed for the current brcmsmac.
> thanks for your time,
> Gottfried
>
> [1] 14e4:0576, got this with a ThinkPad x120e .. the closed driver
> detects the device, but insists that it's disabled by a radio switch
> (tested on -rc7)
Let me ask around over here whether adding the device id will work.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


