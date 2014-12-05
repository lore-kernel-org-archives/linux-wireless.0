Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39873 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751374AbaLETZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 14:25:54 -0500
Date: Fri, 5 Dec 2014 19:25:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	David Miller <davem@davemloft.net>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: using DMA-API on ARM
Message-ID: <20141205192544.GY11285@n2100.arm.linux.org.uk> (sfid-20141205_202556_843071_40805C08)
References: <5481794E.4050406@broadcom.com>
 <20141205094507.GP11285@n2100.arm.linux.org.uk>
 <20141205122423.GK1630@arm.com>
 <F51492713EF10846800D8C0ED37A7DCE019016E1@SJEXCHMB15.corp.ad.broadcom.com>
 <20141205132332.GS11285@n2100.arm.linux.org.uk>
 <20141205150648.GT11285@n2100.arm.linux.org.uk>
 <20141205182851.GC31222@e104818-lin.cambridge.arm.com>
 <548205DD.4080101@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <548205DD.4080101@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 05, 2014 at 08:22:05PM +0100, Arend van Spriel wrote:
> On 12/05/14 19:28, Catalin Marinas wrote:
> >This is solved by using a pre-allocated, pre-mapped atomic_pool which
> >avoids any further mapping. __dma_alloc() calls __alloc_from_pool() when
> >!__GFP_WAIT.
> 
> So we are actually calling dma_alloc_coherent() with GFP_KERNEL during
> device probe. That last paragraph Russell pointed out seems to suggest this
> is not allowed.

device probe is a schedulable, sleepable context, so dma_alloc_coherent()
is fine there.  As Catalin points out, and as I realised after sending
them ail, it does check for __GFP_WAIT and uses a smaller atomic pool
for those allocations.  This explains why no one has hit any warnings in
map_vm_area.

So, it's safe from atomic contexts after all.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
