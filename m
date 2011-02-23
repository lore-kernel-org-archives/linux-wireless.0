Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:37252 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1BWKS5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 05:18:57 -0500
Date: Wed, 23 Feb 2011 11:18:53 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: Nikolay Ledovskikh <nledovskikh@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd <nbd@openwrt.org>
Message-ID: <13107431.38.1298456333929.JavaMail.wlan@500181>
In-Reply-To: <AANLkTimP1r1A6nzcfh7kP=Hmcq9Cgha5Du28hE3zOs0x@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
 seqfault on AHB chips
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> So, the problems are in openwrt platform patches that should be
> rewriten:
> 1. Changes needed to avoid using code like "mem=res->start" without
> ioremap.
> 2. Changes needed to avoid using NULL in first argument of
> dma_alloc_coherent and others.
> 
> Without these changes ahb patch won't get into the kernel and we'll be
> lack of wisoc devices support?
> Is there any chance for the patch to get into the kernel and what
> should be done for it?
I can confirm that the problem is not in the driver but in openwrt
code. Dma mapping is assuming it has to shift address to pci bar
no matter whether PCI is enabled or not.
It seems to work on devices which don't have AHB arbitration
and PCI core. Somehow dma doesn't mind that destination address
with extra 0x2 at the beginning. Or at least it doesn't crash.

Also physical addresses need to be consistent in platform code which
is not the case at the moment. I am working now on the patch to fix it 
in openwrt.

To get ar231x platform into the kernel is another story but if it
was done for ar71xx it just matter of some effort. Actually is 
anyone working on it? It would allow to use platform code in the
wireless driver without extensive patching.

Cheers,
Wojtek

> 
> (PS: Sorry for my english.)
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
