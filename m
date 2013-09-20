Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:45430 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab3ITMSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 08:18:40 -0400
Date: Fri, 20 Sep 2013 07:18:34 -0500
From: Tejun Heo <tj@kernel.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>
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
	Inki Dae <inki.dae@samsung.com>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	David Airlie <airlied@linux.ie>,
	Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 39/51] DMA-API: others: use dma_set_coherent_mask()
Message-ID: <20130920121834.GB7630@mtj.dyndns.org> (sfid-20130920_141854_476639_EBC98338)
References: <20130919212235.GD12758@n2100.arm.linux.org.uk>
 <E1VMnNq-0007s4-HN@rmk-PC.arm.linux.org.uk>
 <20130920121652.GA7630@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130920121652.GA7630@mtj.dyndns.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 20, 2013 at 07:16:52AM -0500, Tejun Heo wrote:
> On Fri, Sep 20, 2013 at 12:11:38AM +0100, Russell King wrote:
> > The correct way for a driver to specify the coherent DMA mask is
> > not to directly access the field in the struct device, but to use
> > dma_set_coherent_mask().  Only arch and bus code should access this
> > member directly.
> > 
> > Convert all direct write accesses to using the correct API.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> The patch is pretty widely spread.  I don't mind how it gets routed
> but what's the plan?

Hmm... maybe hte pata_ixp4xx_cf.c part should be moved to the one
which updates pata_octeon_cf.c?

Thanks.

-- 
tejun
