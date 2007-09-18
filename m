Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45223 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754142AbXIRWTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 18:19:03 -0400
Date: Tue, 18 Sep 2007 23:25:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Jeff Garzik <jeff@garzik.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
Message-ID: <20070918232546.004af9ff@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
	<20070918113401.6a8a737f@the-village.bc.nu>
	<43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
	<alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If you use ioport_map/unmap, then you really *should* access them with the 
> proper iomem accessors (ioread/iowrite). The fact that it may happen to 
> work (when using the default lib/iomap.c implementation, at least) on 
> some architectures and with the current implementation still doesn't mean 
> that you should necessarily use readb/writeb.

Another reason we should enforce the use of ioread/iowrite is that some
platforms do daft things like map mmio type devices through indirect
register access. Sparc PCMCIA is a classic example. The only sane way to
make these work is to require ioread/iowrite is used with iomap

