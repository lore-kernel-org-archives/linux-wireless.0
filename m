Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39588 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab3ITNza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 09:55:30 -0400
Date: Fri, 20 Sep 2013 14:49:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: alsa-devel@alsa-project.org, b43-dev@lists.infradead.org,
	devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, e1000-devel@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 42/51] DMA-API: usb: musb: use
	platform_device_register_full() to avoid directly messing with dma
	masks
Message-ID: <20130920134938.GO25647@n2100.arm.linux.org.uk> (sfid-20130920_155607_108076_58335DDB)
References: <20130919212235.GD12758@n2100.arm.linux.org.uk> <E1VMnQk-0007sX-Ty@rmk-PC.arm.linux.org.uk> <20130920131125.GO26101@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130920131125.GO26101@radagast>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 20, 2013 at 08:11:25AM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Sep 20, 2013 at 12:14:38AM +0100, Russell King wrote:
> > Use platform_device_register_full() for those drivers which can, to
> > avoid messing directly with DMA masks.  This can only be done when
> > the driver does not need to access the allocated musb platform device
> > from within its callbacks, which may be called during the musb
> > device probing.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> you want me to carry this one through my tree or you prefer getting my
> Acked-by ? Either way works for me:
> 
> Acked-by: Felipe Balbi <balbi@ti.com>
> 
> there's also the third option of me setting up a branch with only this
> patch and we both merge it, that'd also work.

I think this patch is sufficiently stand-alone that it should be fine
if you want to take it through your tree.  That may be better in the
long run to avoid conflicts with this patch and any future work in
this area during this cycle.

Thanks.
