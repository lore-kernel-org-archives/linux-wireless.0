Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750916AbdEaQbP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 12:31:15 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4VGTttZ134675
        for <linux-wireless@vger.kernel.org>; Wed, 31 May 2017 12:31:14 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2at0xpscvt-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 31 May 2017 12:31:14 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Wed, 31 May 2017 12:31:13 -0400
Date: Wed, 31 May 2017 09:31:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] bcm47xx: fix build regression
Reply-To: paulmck@linux.vnet.ibm.com
References: <20170530112027.3983554-1-arnd@arndb.de>
 <7b6903a2-ce54-44f9-18ed-a14bd32069ce@broadcom.com>
 <CAK8P3a2-kO==gMDm3E6U8CR-zhwmZGztRy7Trcezf8oZxgn01g@mail.gmail.com>
 <20170531131216.GJ3956@linux.vnet.ibm.com>
 <CAK8P3a1wcVC1+dPbtAgn=2RbToV_ai+dGc2tJxdQ4r1s+nxAFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK8P3a1wcVC1+dPbtAgn=2RbToV_ai+dGc2tJxdQ4r1s+nxAFg@mail.gmail.com>
Message-Id: <20170531163110.GL3956@linux.vnet.ibm.com> (sfid-20170531_183145_950745_FB47B4FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 31, 2017 at 03:34:57PM +0200, Arnd Bergmann wrote:
> On Wed, May 31, 2017 at 3:12 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, May 31, 2017 at 12:21:10PM +0200, Arnd Bergmann wrote:
> >> On Wed, May 31, 2017 at 11:43 AM, Arend van Spriel
> >> <arend.vanspriel@broadcom.com> wrote:
> >> > On 5/30/2017 1:20 PM, Arnd Bergmann wrote:
> >> >>
> >> >> An unknown change in the kernel headers caused a build regression
> >> >> in an MTD partition driver:
> >> >>
> >> >> In file included from drivers/mtd/bcm47xxpart.c:12:0:
> >> >> include/linux/bcm47xx_nvram.h: In function 'bcm47xx_nvram_init_from_mem':
> >> >> include/linux/bcm47xx_nvram.h:27:10: error: 'ENOTSUPP' undeclared (first
> >> >> use in this function)
> >> >>
> >> >> Clearly we want to include linux/errno.h here.
> >> >
> >> >
> >> > unfortunate that you did not find the commit that caused this build
> >> > regression. You could produce preprocessor output when it was working to see
> >> > where errno.h got implicitly included and start looking there for git
> >> > history.
> >>
> >> I did a 'git bisect run make drivers/mtd/bcm47xxpart.o' now, which pointed to
> >> 0bc2d534708b ("rcu: Refactor #includes from include/linux/rcupdate.h").
> >>
> >> That commit seems reasonable, it was just bad luck that it caused this
> >> regression. The commit is currently in the rcu/rcu/next branch of tip.git,
> >> so Paul could merge the patch there.
> >
> > Apologies for the inconvenience, not sure why 0day test robot didn't
> > find this.  Probably because it cannot test each and every driver.  ;-)
> 
> No worries.
> 
> > This patch, correct?
> >
> >         https://lkml.org/lkml/2017/5/30/348
> 
> Right, I should have included the link.

And my turn to say "no worries".  ;-)

I reworked the commit log to tell the full story as shown below.
Anything I misstated or otherwise missed?

							Thanx, Paul

------------------------------------------------------------------------

commit ff278071dce9af9da2b5e2b33f682710a855d266
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Wed May 31 09:26:07 2017 -0700

    bcm47xx: fix build regression
    
    Commit 0bc2d534708b ("rcu: Refactor #includes from include/linux/rcupdate.h")
    caused a build regression in an MTD partition driver:
    
    In file included from drivers/mtd/bcm47xxpart.c:12:0:
    include/linux/bcm47xx_nvram.h: In function 'bcm47xx_nvram_init_from_mem':
    include/linux/bcm47xx_nvram.h:27:10: error: 'ENOTSUPP' undeclared (first use in this function)
    
    The rcupdate.h file has no particular need for linux/errno.h, so this
    commit includes linux/errno.h into bcm47xx_nvram.h.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/bcm47xx_nvram.h b/include/linux/bcm47xx_nvram.h
index 2793652fbf66..a414a2b53e41 100644
--- a/include/linux/bcm47xx_nvram.h
+++ b/include/linux/bcm47xx_nvram.h
@@ -8,6 +8,7 @@
 #ifndef __BCM47XX_NVRAM_H
 #define __BCM47XX_NVRAM_H
 
+#include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>
