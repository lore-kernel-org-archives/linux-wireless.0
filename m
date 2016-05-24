Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32837 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbcEXXjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 19:39:04 -0400
Date: Wed, 25 May 2016 00:38:58 +0100
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: Andrew Worsley <amworsley@gmail.com>, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160524233858.GA5525@localhost> (sfid-20160525_013909_210300_472070E7)
References: <E1akxli-00030z-BC@bombadil.infradead.org>
 <CA+Y=x3=cLDHc7PK5h9n=ixdgVKWdVSu_v+-7jHJ-vBnDrv4sgg@mail.gmail.com>
 <20160403114912.GA11540@wunner.de>
 <CA+Y=x3nfe7CniNhruOhGmdxY3g4B1n3YRVWChoVYJns7D8pNEg@mail.gmail.com>
 <CA+Y=x3mVrSKMgzy74xtO5ZOc5kYLYU=iKZgqyjn0j94bXoebjg@mail.gmail.com>
 <20160412183202.GC13637@wunner.de>
 <CA+Y=x3mBm6==ffohf+aH2tHm9m+RSa7mZBJkDSvSmdCmEDdkNQ@mail.gmail.com>
 <20160424170423.GB17019@wunner.de>
 <20160523144216.GA4894@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160523144216.GA4894@wunner.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 23, 2016 at 04:42:16PM +0200, Lukas Wunner wrote:
> 
> The reason why my previous patches didn't work on your machine is
> because you're using grub, and grub contains a patch by Matthew
> Garrett which puts the wireless card into power state D3hot. The
> card's mmio space isn't accessible in D3hot. Included below is a
> new patch which transitions the card to D0 before resetting it.
> Please let me know if this fixes the issue for you.

The grub patch is in Debian but didn't prevent the issue on my setup,
presumably because of the Ubuntu "linuxefi" fallback that Matthew
previously posted about.

> @Chris Bainbridge: Please test this as well, this is no longer a
> plain vanilla PCI quirk but an early quirk, it should prevent any
> kind of memory corruption by DMAed packets.

I tested a "no b43" kernel for 10 boots with and without the patch.

Without the patch: 7 boots had potential memory corruption (caught by
the IOMMU) and all had IRQ 17 disabled.

With the patch: no memory corruption or disabled IRQ 17.

With b43 built in to the kernel wifi worked as expected.

So the patch looks good to me. Thanks for the fix.

Tested-by: Chris Bainbridge <chris.bainbridge@gmail.com> [MacBookPro10,2]
