Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46844 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823Ab0HFVON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 17:14:13 -0400
Message-ID: <4C5C7B1F.1040500@candelatech.com>
Date: Fri, 06 Aug 2010 14:14:07 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wireless-testing won't build
References: <4C5C694A.7060500@candelatech.com> <20100806201956.GD2753@tuxdriver.com>
In-Reply-To: <20100806201956.GD2753@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2010 01:19 PM, John W. Linville wrote:
> On Fri, Aug 06, 2010 at 12:58:02PM -0700, Ben Greear wrote:
>> [greearb@grok2 wireless-testing.p4s]$ make bzImage modules
>> make -C /home/greearb/git/wireless-testing O=/home/greearb/kernel/2.6/wireless-testing.p4s/. bzImage modules
>>    Using /home/greearb/git/wireless-testing as source for kernel
>>    GEN     /home/greearb/kernel/2.6/wireless-testing.p4s/Makefile
>>    CHK     include/linux/version.h
>>    CHK     include/generated/utsrelease.h
>>    CALL    /home/greearb/git/wireless-testing/scripts/checksyscalls.sh
>>    CHK     include/generated/compile.h
>>    CC [M]  drivers/net/wireless/libertas/cfg.o
>> /home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c: In function ‘lbs_scan_worker’:
>> /home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:722: error: ‘TASK_NORMAL’ undeclared (first use in this function)
>> /home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:722: error: (Each undeclared identifier is reported only once
>> /home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:722: error: for each function it appears in.)
>> /home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c: In function ‘lbs_cfg_connect’:
>> /home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:1267: error: ‘TASK_INTERRUPTIBLE’ undeclared (first use in this function)
>> /home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:1267: error: implicit declaration of function ‘signal_pending’
>> /home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:1267: error: implicit declaration of function ‘schedule_timeout’
>> make[6]: *** [drivers/net/wireless/libertas/cfg.o] Error 1
>> make[5]: *** [drivers/net/wireless/libertas] Error 2
>> make[4]: *** [drivers/net/wireless] Error 2
>> make[3]: *** [drivers/net] Error 2
>> make[2]: *** [drivers] Error 2
>> make[1]: *** [sub-make] Error 2
>> make: *** [all] Error 2
>
> It builds here...does adding "#include<linux/sched.h>" at the top
> of drivers/net/wireless/libertas/cfg.c correct this for you?

That seems to do the trick.  Compile is continuing now...

Ben

>
> John


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
