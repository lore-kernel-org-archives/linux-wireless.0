Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893Ab0IQSBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 14:01:14 -0400
Date: Fri, 17 Sep 2010 11:00:56 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
	Vipin Mehta <vmehta@Atheros.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: ath6kl: Including a header file to fix a
 compilation error
Message-ID: <20100917180056.GA20199@kroah.com>
References: <1284742495-2970-1-git-send-email-vmehta@atheros.com>
 <4C93A412.2070005@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C93A412.2070005@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 17, 2010 at 10:23:30AM -0700, Randy Dunlap wrote:
> On 09/17/10 09:54, Vipin Mehta wrote:
> > The commit fixes a compilation error that was encountered while using
> > a specific kernel configuration file. The problem was the use of some
> > functions defined in <linux/semaphore.h> without including the header
> > file explicitly. It was probably working before because of the
> > dependency getting implicitly satisfied via some other header file.
> > Also, eliminating the inclusion of the same header file more than
> > once. The code needs additional cleanup and may be addressed by a
> > subsequent commit.
> > 
> > Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Signed-off-by: Vipin Mehta <vmehta@atheros.com>
> > ---
> 
> Hi,
> Thanks for the patch, but I still get these errors & warnings:

<snip>

Ok, I'll not apply this until it is all resolved.

> > diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
> > index 4358834..4e5b7bf 100644
> > --- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
> > +++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
> > @@ -36,15 +36,11 @@
> >  
> >  #include <linux/fs.h>
> >  #include <linux/errno.h>
> > -#include <linux/string.h>
> >  #include <linux/signal.h>
> > -#include <linux/timer.h>
> >  
> >  
> >  #include <linux/ioctl.h>
> > -#include <linux/skbuff.h>
> >  #include <linux/firmware.h>
> > -#include <linux/wait.h>

Why are you removing these?

> >  
> >  
> >  #include <net/bluetooth/bluetooth.h>
> > diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
> > index 7a3784d..f51c5e1 100644
> > --- a/drivers/staging/ath6kl/os/linux/cfg80211.c
> > +++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
> > @@ -21,8 +21,6 @@
> >  // Author(s): ="Atheros"
> >  //------------------------------------------------------------------------------
> >  
> > -#include <linux/kernel.h>
> > -#include <linux/netdevice.h>

And this?

> >  #include <linux/wireless.h>
> >  #include <linux/ieee80211.h>
> >  #include <net/cfg80211.h>
> > diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
> > index 8be4f55..e624883 100644
> > --- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
> > +++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
> > @@ -24,22 +24,14 @@
> >  #ifndef _AR6000_H_
> >  #define _AR6000_H_
> >  
> > -#include <linux/version.h>
> > -
> > -
> > -#include <generated/autoconf.h>
> >  #include <linux/init.h>
> > -#include <linux/kernel.h>
> >  #include <linux/sched.h>
> >  #include <linux/spinlock.h>
> > -#include <linux/skbuff.h>
> >  #include <linux/if_ether.h>
> > -#include <linux/netdevice.h>
> >  #include <linux/etherdevice.h>
> >  #include <net/iw_handler.h>
> >  #include <linux/if_arp.h>
> >  #include <linux/ip.h>
> > -#include <linux/semaphore.h>
> >  #include <linux/wireless.h>
> >  #ifdef ATH6K_CONFIG_CFG80211
> >  #include <net/cfg80211.h>

And these?

All to fix the one build error?

> > diff --git a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
> > index ef7cc82..9892dfc 100644
> > --- a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
> > +++ b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
> > @@ -39,6 +39,7 @@
> >  #include <linux/timer.h>
> >  #include <linux/delay.h>
> >  #include <linux/wait.h>
> > +#include <linux/semaphore.h>

Don't put #include in a .h file if at all possible please.

> >  
> >  #include <linux/cache.h>
> >  
> > diff --git a/drivers/staging/ath6kl/os/linux/netbuf.c b/drivers/staging/ath6kl/os/linux/netbuf.c
> > index 63fa49c..15e5d04 100644
> > --- a/drivers/staging/ath6kl/os/linux/netbuf.c
> > +++ b/drivers/staging/ath6kl/os/linux/netbuf.c
> > @@ -20,8 +20,6 @@
> >  //
> >  // Author(s): ="Atheros"
> >  //------------------------------------------------------------------------------
> > -#include <linux/kernel.h>
> > -#include <linux/skbuff.h>

Why remove these?

Totally confused,

greg k-h
