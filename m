Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:58861 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab0IQXty (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:49:54 -0400
Date: Fri, 17 Sep 2010 16:46:27 -0700
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: ath6kl: Including a header file to fix a
 compilation error
Message-ID: <20100917234627.GA26329@kroah.com>
References: <1284742495-2970-1-git-send-email-vmehta@atheros.com>
 <4C93A412.2070005@oracle.com>
 <20100917180056.GA20199@kroah.com>
 <35B17FE5076C7040809188FBE7913F983F23A275AF@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <35B17FE5076C7040809188FBE7913F983F23A275AF@SC1EXMB-MBCL.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 17, 2010 at 04:26:41PM -0700, Vipin Mehta wrote:
> > 
> > Ok, I'll not apply this until it is all resolved.
> The error popped up due a recent commit which happened after I generated the patch below. I can regenerate the patch that takes care of these new errors as well but the following patch does fix the problem originally reported.

{sigh}  Line length please...

> > > > diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
> > b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
> > > > index 4358834..4e5b7bf 100644
> > > > --- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
> > > > +++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
> > > > @@ -36,15 +36,11 @@
> > > >
> > > >  #include <linux/fs.h>
> > > >  #include <linux/errno.h>
> > > > -#include <linux/string.h>
> > > >  #include <linux/signal.h>
> > > > -#include <linux/timer.h>
> > > >
> > > >
> > > >  #include <linux/ioctl.h>
> > > > -#include <linux/skbuff.h>
> > > >  #include <linux/firmware.h>
> > > > -#include <linux/wait.h>
> > 
> > Why are you removing these?
> The header files being removed are already included by a common header file osapi_linux.h. The file osapi_linux.h is included by all the source files. I saw little point in including these header files again.

But that has nothing to do with this fix, right?  Don't mix things in a
single patch.  Cleanup is good and nice, but don't do that in a "fix a
problem" patch at the same time.

Remember:
	One patch per "thing" you do.

> > > > -#include <linux/semaphore.h>
> > > >  #include <linux/wireless.h>
> > > >  #ifdef ATH6K_CONFIG_CFG80211
> > > >  #include <net/cfg80211.h>
> > 
> > And these?
> > 
> > All to fix the one build error?
> No. The header files being removed are just a minor clean up that I thought can be included along with the fix as they were kind of related. I guess I could use a separate patch.

Yes, that is required.

> > > >  #include <linux/timer.h>
> > > >  #include <linux/delay.h>
> > > >  #include <linux/wait.h>
> > > > +#include <linux/semaphore.h>
> > 
> > Don't put #include in a .h file if at all possible please.
> I guess the header files can be included explicitly within the source files but it requires a bigger change to the driver. There are some header files which are included by all the source files and contain some commonly used header files. These commonly used header files will otherwise have to be included separately in each of the source files.

That's work that can be done later, let's just fix this build error
first please.

thanks,

greg k-h
