Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:51813 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756177AbZLUTDa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 14:03:30 -0500
Received: from chimera.site ([96.253.169.185]) by xenotime.net for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 11:03:25 -0800
Date: Mon, 21 Dec 2009 11:03:25 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Can't turn off SSB (CONFIG_SSB)?
Message-Id: <20091221110325.95cfcc92.rdunlap@xenotime.net>
In-Reply-To: <4B2FC3A4.9080804@redfish-solutions.com>
References: <4B2ECC72.40703@redfish-solutions.com>
	<200912210924.16481.holgerschurig@gmail.com>
	<4B2FC3A4.9080804@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Dec 2009 10:51:16 -0800 Philip A. Prindeville wrote:

> On 12/21/2009 12:24 AM, Holger Schurig wrote:
> >> And what are the steps to figuring out the dependency that
> >> keeps forcing it on?  Something must be doing a "select SSB"
> >> but I'm not sure what.  
> > 
> > "make xconfig", and then turn on "Options -> Show Debug Info".
> > 
> > Then you see the reverse dep.
> > 
> > 
> > Another thing would be "find -name Kconfig |xargs grep 
> > SSB_POSSIBLE" and then carefully check those files.
> 
> Well, as I mentioned, arch/x86/configs/i386_defconfig contains:
> 
> CONFIG_SSB_POSSIBLE=y

That is =y iff:

config SSB_POSSIBLE
	bool
	depends on HAS_IOMEM && HAS_DMA
	default y

HAS_IOMEM=y and HAS_DMA=y.  Aren't those both =y on your platform?

Other than being set, it shouldn't be hurting anything.


> which I've not been able to understand why.  There are lots of x86 configurations where this might *not* be possible, in embedded platforms in particular.


---
~Randy
