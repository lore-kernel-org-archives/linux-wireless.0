Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756715AbYBFVHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 16:07:01 -0500
Date: Wed, 6 Feb 2008 13:04:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Deller <deller@gmx.de>
Cc: jt@hpl.hp.com, linux-wireless@vger.kernel.org, rjw@sisk.pl,
	linux-arm-kernel@lists.arm.linux.org.uk, linville@tuxdriver.com
Subject: Re: [PATCH] WAVELAN - compile-time check for struct sizes
Message-Id: <20080206130448.564f18bb.akpm@linux-foundation.org> (sfid-20080206_210719_622562_C5E67102)
In-Reply-To: <200802062150.23930.deller@gmx.de>
References: <200801131516.34567.deller@gmx.de>
	<20080202224515.20a09553.akpm@linux-foundation.org>
	<200802062150.23930.deller@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 6 Feb 2008 21:50:23 +0100
Helge Deller <deller@gmx.de> wrote:

> > > +	/* compile-time check the sizes of structures */
> > > +	BUILD_BUG_ON(sizeof(psa_t) != PSA_SIZE);
> > > +	BUILD_BUG_ON(sizeof(mmw_t) != MMW_SIZE);
> > 
> > This assertion is now triggering with arm allmodconfig.
> > 
> > Rafael, please track this as a post-2.6.24 regression.
> 
> Hello Andrew,
> 
> with which arm platform did you found this assertion to trigger ?
> I tried a few (e.g. ARM-poodle and CONFIG_ARCH_SA1100 w/ISA) but didn't saw it breaking.
> Maybe you could send me you .config file ?
> 

allmodconfig

> 
> PS: I tried Linus' current git tree which now includes my patch above as well.

The assertion triggers with current mainline.  I'm using gcc-3.4.5, from
http://userweb.kernel.org/~akpm/cross-compilers/
