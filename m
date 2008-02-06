Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47497 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYBFVyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 16:54:45 -0500
Date: Wed, 6 Feb 2008 21:47:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Helge Deller <deller@gmx.de>, jt@hpl.hp.com, rjw@sisk.pl,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk, linville@tuxdriver.com
Subject: Re: [PATCH] WAVELAN - compile-time check for struct sizes
Message-ID: <20080206214747.GG32245@flint.arm.linux.org.uk> (sfid-20080206_215449_680868_7F75C517)
References: <200801131516.34567.deller@gmx.de> <20080202224515.20a09553.akpm@linux-foundation.org> <200802062150.23930.deller@gmx.de> <20080206130448.564f18bb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080206130448.564f18bb.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 06, 2008 at 01:04:48PM -0800, Andrew Morton wrote:
> On Wed, 6 Feb 2008 21:50:23 +0100
> Helge Deller <deller@gmx.de> wrote:
> 
> > > > +	/* compile-time check the sizes of structures */
> > > > +	BUILD_BUG_ON(sizeof(psa_t) != PSA_SIZE);
> > > > +	BUILD_BUG_ON(sizeof(mmw_t) != MMW_SIZE);
> > > 
> > > This assertion is now triggering with arm allmodconfig.
> > > 
> > > Rafael, please track this as a post-2.6.24 regression.
> > 
> > Hello Andrew,
> > 
> > with which arm platform did you found this assertion to trigger ?
> > I tried a few (e.g. ARM-poodle and CONFIG_ARCH_SA1100 w/ISA) but didn't saw it breaking.
> > Maybe you could send me you .config file ?
> > 
> 
> allmodconfig
> 
> > 
> > PS: I tried Linus' current git tree which now includes my patch above as well.
> 
> The assertion triggers with current mainline.  I'm using gcc-3.4.5, from
> http://userweb.kernel.org/~akpm/cross-compilers/

I assume that it's the second BUILD_BUG_ON() which is triggering?

Given that:

#define MMW_SIZE        37

is not a multiple of sizeof(unsigned long) this is hardly surprising.

If structures are used to define a layout of something and must not
contain compiler padding, it must be packed.  Given these structures
contain just unsigned char, there's no concerns about >8bit loads
becoming less efficient.
