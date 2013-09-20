Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39599 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3ITOBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 10:01:19 -0400
Date: Fri, 20 Sep 2013 15:00:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
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
Message-ID: <20130920140018.GP25647@n2100.arm.linux.org.uk> (sfid-20130920_160130_776590_A6BD83CD)
References: <20130919212235.GD12758@n2100.arm.linux.org.uk> <E1VMnNq-0007s4-HN@rmk-PC.arm.linux.org.uk> <20130920121652.GA7630@mtj.dyndns.org>
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

The plan is... I'm going to try and avoid going through the hell of
re-posting this patch series to all the recipients another time...
(It's taken some 17 hours and lots of hand holding to get this patch
set out without exim jumping off a cliff into deep OOM - soo deep that
even the OOM killer doesn't run and the CPU is 100% idle because
every single process stuck in an uninterruptible sleep waiting for
every other process to free some memory - ouch!)

I know that dealing with this patch set will be a problem due to how
widespread this is, but much of the driver level changes come down to
depending on a couple of patches.  One solution would be if I published
a branch with just the dependencies in, which subsystem maintainers
could pull, and then apply the appropriate patches on top.

Another would be if subsystem maintainers are happy that I carry them,
I can add the acks, and then later on towards the end of the cycle,
provide a branch subsystem maintainers could pull.

Or... if you can think of something easier...
