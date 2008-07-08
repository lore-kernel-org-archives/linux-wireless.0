Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [66.209.47.173] ([66.209.47.173]:37397 "EHLO mythtv.ewol.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753489AbYGHQjq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 12:39:46 -0400
Message-ID: <48738EC2.1060402@cortland.com> (sfid-20080708_183949_537668_F551B9CC)
Date: Tue, 08 Jul 2008 11:58:58 -0400
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Felipe Maya <felipe.maya@vexcorp.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] ssb, b43, b43legacy, b44: Rewrite SSB DMA API
References: <200806201150.29497.mb@bu3sch.de> <1215102618.17143.13.camel@you> <200807032252.35662.mb@bu3sch.de>
In-Reply-To: <200807032252.35662.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Thursday 03 July 2008 18:30:18 Felipe Maya wrote:
>   
>> Hi, I have applied this patch and i tested on a wl500gpv2 (BCM5354). The
>> following part disable the ethernet device. If this part of the patch is
>> restored the device work ok.
>>     
>
>
> Well, I would say your architecture is pretty broken then.
> This patch replaces an incorrect manual DMA mask setting by
> a call to the official API.
> Please report this to your archtitecture maintainer.
>
>
>   
This also breaks at least b44 on my wl500gpv1.

with wireless-testing rc9-wl tree:
b44.c:v2.0
b44 ssb0:0: Required 30BIT DMA mask unsupported by the system.
b44: probe of ssb0:0 failed with error -5
b44 ssb0:1: Required 30BIT DMA mask unsupported by the system.
b44: probe of ssb0:1 failed with error -5

and reverting the patch:
b44.c:v2.0
eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:17:31:ba:ec:35
eth1: Broadcom 44xx/47xx 10/100BaseT Ethernet 40:10:18:00:00:2d

The problem appears to be a missing non-pci equivalent of 
pci_set_consistent_dma_mask. Maybe that's why the mask was set manually. 
I can not find anything that sets coherent_dma_mask for other than a pci 
device. If somebody can confirm my (mis)understanding of this, I'll post 
the problem to linux-mips.

Steve


