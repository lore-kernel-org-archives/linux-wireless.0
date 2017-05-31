Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751000AbdEaNMW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 09:12:22 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4VDA5r1118016
        for <linux-wireless@vger.kernel.org>; Wed, 31 May 2017 09:12:22 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2asw7bkrs9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 31 May 2017 09:12:21 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Wed, 31 May 2017 09:12:20 -0400
Date: Wed, 31 May 2017 06:12:16 -0700
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK8P3a2-kO==gMDm3E6U8CR-zhwmZGztRy7Trcezf8oZxgn01g@mail.gmail.com>
Message-Id: <20170531131216.GJ3956@linux.vnet.ibm.com> (sfid-20170531_151244_714314_DF56A10D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 31, 2017 at 12:21:10PM +0200, Arnd Bergmann wrote:
> On Wed, May 31, 2017 at 11:43 AM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
> > On 5/30/2017 1:20 PM, Arnd Bergmann wrote:
> >>
> >> An unknown change in the kernel headers caused a build regression
> >> in an MTD partition driver:
> >>
> >> In file included from drivers/mtd/bcm47xxpart.c:12:0:
> >> include/linux/bcm47xx_nvram.h: In function 'bcm47xx_nvram_init_from_mem':
> >> include/linux/bcm47xx_nvram.h:27:10: error: 'ENOTSUPP' undeclared (first
> >> use in this function)
> >>
> >> Clearly we want to include linux/errno.h here.
> >
> >
> > unfortunate that you did not find the commit that caused this build
> > regression. You could produce preprocessor output when it was working to see
> > where errno.h got implicitly included and start looking there for git
> > history.
> 
> I did a 'git bisect run make drivers/mtd/bcm47xxpart.o' now, which pointed to
> 0bc2d534708b ("rcu: Refactor #includes from include/linux/rcupdate.h").
> 
> That commit seems reasonable, it was just bad luck that it caused this
> regression. The commit is currently in the rcu/rcu/next branch of tip.git,
> so Paul could merge the patch there.

Apologies for the inconvenience, not sure why 0day test robot didn't
find this.  Probably because it cannot test each and every driver.  ;-)

This patch, correct?

	https://lkml.org/lkml/2017/5/30/348

							Thanx, Paul
