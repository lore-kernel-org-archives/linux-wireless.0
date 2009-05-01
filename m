Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53554 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbZEAGLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 02:11:25 -0400
Date: Thu, 30 Apr 2009 23:11:18 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: linux-next: driver-core tree build warning
Message-ID: <20090501061118.GA19234@kroah.com>
References: <20090501152144.500e619a.sfr@canb.auug.org.au> <20090501054727.GB19020@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090501054727.GB19020@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 30, 2009 at 10:47:27PM -0700, Greg KH wrote:
> On Fri, May 01, 2009 at 03:21:44PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> > 
> > drivers/net/wireless/ipw2x00/ipw2100.c: In function 'show_cfg':
> > drivers/net/wireless/ipw2x00/ipw2100.c:3491: warning: passing argument 1 of 'dev_get_drvdata' from incompatible pointer type
> > include/linux/device.h:457: note: expected 'const struct device *' but argument is of type 'struct device **'
> > drivers/net/wireless/ipw2x00/ipw2100.c: In function 'show_status':
> > drivers/net/wireless/ipw2x00/ipw2100.c:3500: warning: passing argument 1 of 'dev_get_drvdata' from incompatible pointer type
> > include/linux/device.h:457: note: expected 'const struct device *' but argument is of type 'struct device **'
> > drivers/net/wireless/ipw2x00/ipw2100.c: In function 'show_capability':
> > drivers/net/wireless/ipw2x00/ipw2100.c:3509: warning: passing argument 1 of 'dev_get_drvdata' from incompatible pointer type
> > include/linux/device.h:457: note: expected 'const struct device *' but argument is of type 'struct device **'
> > drivers/net/wireless/ipw2x00/ipw2100.c: In function 'show_rf_kill':
> > drivers/net/wireless/ipw2x00/ipw2100.c:4227: warning: passing argument 1 of 'dev_get_drvdata' from incompatible pointer type
> > include/linux/device.h:457: note: expected 'const struct device *' but argument is of type 'struct device **'
> > 
> > Introduced by commit 73119f5e60e3b16577e99e2f035039bed0d2dcca ("Wireless:
> > remove driver_data direct access of struct device").
> 
> Ah crap, my bad.  I'll go fix this up, it passed my build tests, I
> wonder why this isn't an error, I missed the warning.

I've sent an updated version of the patch that fixes this to John and
the wireless mailing list and updated my tree as well.

thanks,

greg k-h
