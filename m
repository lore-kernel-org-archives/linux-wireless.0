Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45835 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbYGRVHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 17:07:34 -0400
Date: Fri, 18 Jul 2008 13:48:46 -0700
From: Greg KH <greg@kroah.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Pavel Roskin <proski@gnu.org>, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	linville@tuxdriver.com, ath5k-devel@venema.h4ckr.net
Subject: Re: [stable] [PATCH] ath5k: don't enable MSI, we cannot handle it
	yet
Message-ID: <20080718204846.GA3181@kroah.com> (sfid-20080718_230736_959120_7D8FDE1C)
References: <20080718162855.22182.97573.stgit@dv.roinet.com> <1216399487.18320.16.camel@dv> <200807181849.25320.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807181849.25320.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 18, 2008 at 06:49:24PM +0200, Michael Buesch wrote:
> On Friday 18 July 2008 18:44:47 Pavel Roskin wrote:
> > On Fri, 2008-07-18 at 12:28 -0400, Pavel Roskin wrote:
> > > This fixes support for AR5006 chipset, which supports MSI
> > 
> > Sorry, I found Documentation/stable_kernel_rules.txt minutes after
> > sending the patch.  We need to get it to the Linus' tree first, then to
> > the stable tree.  I hope it won't take long.
> > 
> > To preempt possible questions: MSI is a nice thing, but we cannot enable
> > it without changing the interrupt handler.  If we do it, we break MSI
> > capable hardware.
> 
> Please include this into the patch changelog. It's highly confusing otherwise ;)

I agree.

Also, to get stuff into -stable easily, just add:
	Cc: stable <stable@kernel.org>
to the signed-off-by area in the patch and then when it goes into
Linus's tree, it will automatically be sent to us for inclusion.

Much easier on you and everyone else that way.

thanks,

greg k-h
