Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35570 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdEaKVL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 06:21:11 -0400
MIME-Version: 1.0
In-Reply-To: <7b6903a2-ce54-44f9-18ed-a14bd32069ce@broadcom.com>
References: <20170530112027.3983554-1-arnd@arndb.de> <7b6903a2-ce54-44f9-18ed-a14bd32069ce@broadcom.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 31 May 2017 12:21:10 +0200
Message-ID: <CAK8P3a2-kO==gMDm3E6U8CR-zhwmZGztRy7Trcezf8oZxgn01g@mail.gmail.com> (sfid-20170531_122138_656271_4EE50A7C)
Subject: Re: [PATCH] bcm47xx: fix build regression
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 31, 2017 at 11:43 AM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 5/30/2017 1:20 PM, Arnd Bergmann wrote:
>>
>> An unknown change in the kernel headers caused a build regression
>> in an MTD partition driver:
>>
>> In file included from drivers/mtd/bcm47xxpart.c:12:0:
>> include/linux/bcm47xx_nvram.h: In function 'bcm47xx_nvram_init_from_mem':
>> include/linux/bcm47xx_nvram.h:27:10: error: 'ENOTSUPP' undeclared (first
>> use in this function)
>>
>> Clearly we want to include linux/errno.h here.
>
>
> unfortunate that you did not find the commit that caused this build
> regression. You could produce preprocessor output when it was working to see
> where errno.h got implicitly included and start looking there for git
> history.

I did a 'git bisect run make drivers/mtd/bcm47xxpart.o' now, which pointed to
0bc2d534708b ("rcu: Refactor #includes from include/linux/rcupdate.h").

That commit seems reasonable, it was just bad luck that it caused this
regression. The commit is currently in the rcu/rcu/next branch of tip.git,
so Paul could merge the patch there.

       Arnd
