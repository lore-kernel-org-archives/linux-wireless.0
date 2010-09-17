Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21839 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0IQX0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:26:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 16:26:36 -0700
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Fri, 17 Sep 2010 16:26:41 -0700
Subject: RE: [PATCH] staging: ath6kl: Including a header file to fix a
 compilation error
Message-ID: <35B17FE5076C7040809188FBE7913F983F23A275AF@SC1EXMB-MBCL.global.atheros.com>
References: <1284742495-2970-1-git-send-email-vmehta@atheros.com>
 <4C93A412.2070005@oracle.com> <20100917180056.GA20199@kroah.com>
In-Reply-To: <20100917180056.GA20199@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Ok, I'll not apply this until it is all resolved.
The error popped up due a recent commit which happened after I generated the patch below. I can regenerate the patch that takes care of these new errors as well but the following patch does fix the problem originally reported.

> 
> > > diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
> b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
> > > index 4358834..4e5b7bf 100644
> > > --- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
> > > +++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
> > > @@ -36,15 +36,11 @@
> > >
> > >  #include <linux/fs.h>
> > >  #include <linux/errno.h>
> > > -#include <linux/string.h>
> > >  #include <linux/signal.h>
> > > -#include <linux/timer.h>
> > >
> > >
> > >  #include <linux/ioctl.h>
> > > -#include <linux/skbuff.h>
> > >  #include <linux/firmware.h>
> > > -#include <linux/wait.h>
> 
> Why are you removing these?
The header files being removed are already included by a common header file osapi_linux.h. The file osapi_linux.h is included by all the source files. I saw little point in including these header files again.


> > > -#include <linux/semaphore.h>
> > >  #include <linux/wireless.h>
> > >  #ifdef ATH6K_CONFIG_CFG80211
> > >  #include <net/cfg80211.h>
> 
> And these?
> 
> All to fix the one build error?
No. The header files being removed are just a minor clean up that I thought can be included along with the fix as they were kind of related. I guess I could use a separate patch.

> > >  #include <linux/timer.h>
> > >  #include <linux/delay.h>
> > >  #include <linux/wait.h>
> > > +#include <linux/semaphore.h>
> 
> Don't put #include in a .h file if at all possible please.
I guess the header files can be included explicitly within the source files but it requires a bigger change to the driver. There are some header files which are included by all the source files and contain some commonly used header files. These commonly used header files will otherwise have to be included separately in each of the source files.

> 
> > >
> > >  #include <linux/cache.h>
> > >
> > > diff --git a/drivers/staging/ath6kl/os/linux/netbuf.c
> b/drivers/staging/ath6kl/os/linux/netbuf.c
> > > index 63fa49c..15e5d04 100644
> > > --- a/drivers/staging/ath6kl/os/linux/netbuf.c
> > > +++ b/drivers/staging/ath6kl/os/linux/netbuf.c
> > > @@ -20,8 +20,6 @@
> > >  //
> > >  // Author(s): ="Atheros"
> > >  //-------------------------------------------------------------------
> -----------
> > > -#include <linux/kernel.h>
> > > -#include <linux/skbuff.h>
> 
> Why remove these?
> 
> Totally confused,
> 
> greg k-h
