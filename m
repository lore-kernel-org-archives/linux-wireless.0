Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:59443 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbaLHPWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 10:22:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
	Will Deacon <will.deacon@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Arend Van Spriel <arend@broadcom.com>,
	David Miller <davem@davemloft.net>,
	Marek Szyprowski <m.szyprowski@samsung.com>, hauke@hauke-m.de
Subject: Re: using DMA-API on ARM
Date: Mon, 08 Dec 2014 16:22:11 +0100
Message-ID: <2335290.YorTSI1K36@wuerfel> (sfid-20141208_162313_311291_E879722A)
In-Reply-To: <20141208151733.GF11285@n2100.arm.linux.org.uk>
References: <5481794E.4050406@broadcom.com> <2863746.4sUSEYqahB@wuerfel> <20141208151733.GF11285@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 December 2014 15:17:33 Russell King - ARM Linux wrote:
> On Mon, Dec 08, 2014 at 04:01:32PM +0100, Arnd Bergmann wrote:
> > In your log, I see this message:
> > 
> > [    0.000000] PL310 OF: cache setting yield illegal associativity
> > [    0.000000] PL310 OF: -1069781724 calculated, only 8 and 16 legal
> > [    0.000000] L2C-310 enabling early BRESP for Cortex-A9
> > [    0.000000] L2C-310 full line of zeros enabled for Cortex-A9
> > [    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
> > [    0.000000] L2C-310 cache controller enabled, 16 ways, 256 kB
> > [    0.000000] L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x4e130001
> > 
> > Evidently the cache controller information in DT is incorrect and
> > the setup may be wrong as a consequence, which may explain cache
> > coherency problems.
> 
> No.  See d0b92845e54 (ARM: 8182/1: l2c: Make l2x0_cache_size_of_parse() return 'int')
> which was merged in rc3, post-dating this kernel.  The original commit
> was buggy, and produces those harmless "illegal associativity" messages.
> They occur if DT *doesn't* specify the cache parameters, in which case
> we use the hardware-set value (which /should/ be correct.)
> 
> We made these optional in DT as hardware really should set these
> correctly in the first place.

Ok, good.

	Arnd
