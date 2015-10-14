Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52824 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbbJNKzE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 06:55:04 -0400
Subject: Re: [PATCH] bcma: mips: Allow build if COMPILE_TEST is enabled
To: Kalle Valo <kvalo@codeaurora.org>
References: <201510132319.x2UV0LGD%fengguang.wu@intel.com>
 <561E1E69.3070108@osg.samsung.com> <87pp0hn2mf.fsf@kamboji.qca.qualcomm.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
	linux-kernel@vger.kernel.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <561E3481.4070008@osg.samsung.com> (sfid-20151014_125526_763608_9292E44B)
Date: Wed, 14 Oct 2015 12:54:57 +0200
MIME-Version: 1.0
In-Reply-To: <87pp0hn2mf.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

On 10/14/2015 12:52 PM, Kalle Valo wrote:
> Javier Martinez Canillas <javier@osg.samsung.com> writes:
> 
>> Hello,
>>
>> On 10/13/2015 05:25 PM, kbuild test robot wrote:
>>> Hi Javier,
>>>
>>> [auto build test ERROR on v4.3-rc5 -- if it's inappropriate base, please suggest rules for selecting the more suitable base]
>>>
>>> url:    https://github.com/0day-ci/linux/commits/Javier-Martinez-Canillas/bcma-mips-Allow-build-if-COMPILE_TEST-is-enabled/20151013-214630
>>> config: i386-allmodconfig (attached as .config)
>>> reproduce:
>>>         # save the attached .config to linux build tree
>>>         make ARCH=i386 
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>    drivers/mtd/devices/bcm47xxsflash.c: In function 'bcm47xxsflash_read':
>>>>> drivers/mtd/devices/bcm47xxsflash.c:112:37: error: implicit declaration of function 'KSEG0ADDR' [-Werror=implicit-function-declaration]
>>>      memcpy_fromio(buf, (void __iomem *)KSEG0ADDR(b47s->window + from),
>>>                    
>>
>> Thanks for reporting this issue. I only did a partial build with
>> make M=drivers/bcma but didn't think about implicit dependencies
>> on other drivers.
>>
>> I've posted this patch that should avoid this issue:
>> https://patchwork.kernel.org/patch/7391551/
> 
> So this patch ("bcma: mips: Allow build if COMPILE_TEST is enabled")
> depend on that patch ("mtd: Make MTD_BCM47XXSFLASH to depend on MIPS"),
> right? So I cannot apply the bcma patch until the mtd patch is in my
> tree.
>

That's correct, sorry for not stating it explicitly.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
