Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55913 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbXGNR0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jul 2007 13:26:23 -0400
Date: Sat, 14 Jul 2007 18:26:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	John Linville <linville@tuxdriver.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	linux-wireless@vger.kernel.org,
	Gary Zambrano <zambrano@broadcom.com>, netdev@vger.kernel.org
Subject: Re: [PATCH #2] Merge the Sonics Silicon Backplane subsystem
Message-ID: <20070714172605.GA15586@infradead.org>
References: <200707141918.22457.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200707141918.22457.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 14, 2007 at 07:18:20PM +0200, Michael Buesch wrote:
> --- /dev/null
> +++ b/drivers/ssb/Makefile
> @@ -0,0 +1,11 @@
> +ssb-builtin-drivers-y					+= driver_chipcommon.o
> +ssb-builtin-drivers-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o
> +ssb-builtin-drivers-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o
> +
> +ssb-hostsupport-$(CONFIG_SSB_PCIHOST)			+= pci.o pcihost_wrapper.o
> +ssb-hostsupport-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.o
> +
> +obj-$(CONFIG_SSB) += ssb.o
> +
> +ssb-objs	:= main.o scan.o \
> +		   $(ssb-hostsupport-y) $(ssb-builtin-drivers-y)

Whoa, this makefile is more than ugly :)

Please try something like:

# core
ssb-y					+= main.o scan.o

# host support
ssb-$(CONFIG_SSB_PCIHOST)		+= pci.o pcihost_wrapper.o
ssb-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.o

# drivers
ssb-y					+= driver_chipcommon.o
ssb-$(CONFIG_SSB_DRIVER_MIPS)		+= driver_mipscore.o
ssb-$(CONFIG_SSB_DRIVER_PCICORE)	+= driver_pcicore.o

obj-$(CONFIG_SSB)			+= ssb.o

instead


> +	default y

please don't add defauly y statements for random drivers.

