Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:34680 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0IQX17 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:27:59 -0400
Date: Fri, 17 Sep 2010 16:26:43 -0700
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: ath6kl: Including a header file to fix a
 compilation error
Message-ID: <20100917232643.GA25757@kroah.com>
References: <1284742495-2970-1-git-send-email-vmehta@atheros.com>
 <4C93A412.2070005@oracle.com>
 <35B17FE5076C7040809188FBE7913F983F23937DAE@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <35B17FE5076C7040809188FBE7913F983F23937DAE@SC1EXMB-MBCL.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 17, 2010 at 04:11:57PM -0700, Vipin Mehta wrote:
> > Hi,
> > Thanks for the patch, but I still get these errors & warnings:
> > 
> > on linux-next 2010-0915:
> > 
> > drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c: In function
> > 'SetupHIFScatterSupport':
> > drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:288: error:
> > 'struct mmc_host' has no member named 'max_hw_segs'
> > drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c:289: error:
> > 'struct mmc_host' has no member named 'max_hw_segs'
> > 
> This is because of a recent change in the mmc_host structure that removes the distinction between hw and phys segments. The structure is different in the staging-next-2.6 tree which is where I usually build and test the changes. 

Please, fix your email client to wrap lines at a sane place...

> Greg, 
> The two trees linux-next and staging-next are not in sync so what is
> the process that is usually followed under these circumstances? I see
> little point in using the staging-next-2.6 tree to generate and test
> my patches since the tree eventually drains into linux-next. Should I
> stop worrying about if the patch works for the staging-next tree and
> just focus on that things should work with linux-next?

If the problem is due to another change in a different tree, send me the
patch and I'll hold on to it until the mmc tree is merged with Linus
(during the .37 merge window) and then I'll apply it and push it out.

Until then, we can ask Stephen to hold the patch in linux-next to fix
the build issue.

But I'd still like the .h file fixup patch to be resolved and in my tree
first, right?

thanks,

greg k-h
