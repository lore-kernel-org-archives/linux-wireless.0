Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53542 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbZKWBwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2009 20:52:43 -0500
Received: by yxe17 with SMTP id 17so4340647yxe.33
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2009 17:52:49 -0800 (PST)
Message-ID: <4B09EAEF.6010202@lwfinger.net>
Date: Sun, 22 Nov 2009 19:52:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chris Vine <chris@cvine.freeserve.co.uk>
CC: wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: Fatal DMA error problem with netbook and BCM4312
References: <4AFA09C8.4060602@gmail.com> <200911131216.43704.mb@bu3sch.de>	<4AFD83CA.2050508@lwfinger.net> <200911131836.26857.mb@bu3sch.de>	<4AFD9E20.3060501@gmail.com> <4AFDD1C9.4050402@lwfinger.net>	<4AFDF68C.4040804@polymtl.ca> <4AFE1E5F.9040009@lwfinger.net>	<4AFEFC2C.5030704@polymtl.ca> <4B068ED9.5070107@lwfinger.net>	<20091120195834.334d8bc0@boulder.homenet>	<4B06F685.1020405@lwfinger.net>	<20091121001512.02326eda@boulder.homenet> <20091122190353.06cfdab7@boulder.homenet>
In-Reply-To: <20091122190353.06cfdab7@boulder.homenet>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/22/2009 01:03 PM, Chris Vine wrote:
> On Sat, 21 Nov 2009 00:15:12 +0000
> Chris Vine <chris@cvine.freeserve.co.uk> wrote:
>> WARM BOOT FROM KERNEL WITH WL MODULE INSTALLED
>>
>> The patched kernel makes no change on a warm boot in the sense that
>> if I warm boot after initialising the wireless device with the wl
>> module then the b43 module appears to work correctly, both with and
>> without the patch applied.
>>
>> On the same stress test as mentioned above, I have not been able to
>> induce the DMA errors nor kernel warnings.  It resolutely refuses to
>> do anything except work correctly.
> 
> This is just to say that I have carried out further stress tests today
> after warm booting to an unpatched linux-2.6.32-rc8 kernel with the b43
> driver (on the assumption that unpatched is the least favourable case
> for the driver).  This is a warm reboot from a 2.6.31.6 kernel which had
> the wl driver installed.
> 
> I have created an extended period of high speed traffic on my wireless
> lan and I cannot induce any errors at all with the b43 driver on a warm
> reboot.
> 
> This makes me wonder whether the patch is just (partially) masking the
> problem rather than actually dealing with it.

We know that the wl driver does something to the interface that persists across
a warm boot - we just do not know what. It does not appear to be done in any of
the MMIO traffic - at least I have not seen it in the mmio-trace output. If
anyone has a KVM setup using PCI passthrough, it is possible to trace PCI
configuration traffic?

Have you tried running your system with the patch entitled "[PATCH] b43: Rewrite
DMA Tx status handling sanity checks"? It cleared up some of the problems that I
was seeing with the open-source firmware.

Larry
