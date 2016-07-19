Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42140 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbcGSOJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 10:09:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
	"linux-mtd\@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the wireless-drivers-next tree
References: <20160719160831.79c0303f@canb.auug.org.au>
	<8760s2w369.fsf@kamboji.qca.qualcomm.com>
	<CACna6rxVFD1MpAEYP_Zd4W8CvgnxSQpa0wJs83jwDJ5v11gZ=Q@mail.gmail.com>
	<871t2qw1cz.fsf@kamboji.qca.qualcomm.com>
	<CACna6ry6QgrbUoHuJacmr1EhHZyrwqsXfr51gENvY-0zM9L+3Q@mail.gmail.com>
Date: Tue, 19 Jul 2016 17:08:59 +0300
In-Reply-To: <CACna6ry6QgrbUoHuJacmr1EhHZyrwqsXfr51gENvY-0zM9L+3Q@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Tue, 19 Jul 2016
 09:11:11 +0200")
Message-ID: <87h9blvhxg.fsf@kamboji.qca.qualcomm.com> (sfid-20160719_160926_295459_66E3231D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> On 19 July 2016 at 09:09, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Rafał Miłecki <zajec5@gmail.com> writes:
>>
>>> On 19 July 2016 at 08:30, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>>>>
>>>>> After merging the wireless-drivers-next tree, today's linux-next build
>>>>> (powerpc allyesconfig) failed like this:
>>>>>
>>>>> drivers/mtd/devices/bcm47xxsflash.c: In function 'bcm47xxsflash_bcma_probe':
>>>>> drivers/mtd/devices/bcm47xxsflash.c:299:17: error: implicit declaration of function 'ioremap_cache' [-Werror=implicit-function-declaration]
>>>>>   b47s->window = ioremap_cache(res->start, resource_size(res));
>>>>>                  ^
>>>>> drivers/mtd/devices/bcm47xxsflash.c:299:15: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>>>>>   b47s->window = ioremap_cache(res->start, resource_size(res));
>>>>>                ^
>>>>>
>>>>> Caused by commit
>>>>>
>>>>>   57d8f7dd2132 ("bcma: allow enabling serial flash support on non-MIPS SoCs")
>>>>>
>>>>> I have reverted that commit for today.
>>>>
>>>> Thanks, kbuild bot also notified about this.
>>>>
>>>> Rafał, as the merge window is getting really close I would like to
>>>> revert this for now and we can reapply it once we the problem is fully
>>>> solved. And we can use my pending branch for build testing the patch
>>>> with kbuild bot. What do you think?
>>>
>>> The simplest fix sounds pretty much as simple as the revert.
>>
>> The problem is that I don't have much time, I need to send the pull
>> request to Dave within next few days. The fix might create other
>> problems so I'm not enthusiastic about iterating with this patch at the
>> moment. I think it can wait for 4.9.
>
> I sent a patch seconds ago, you may just take a look at it. If you
> still prefer to revert my commit, go ahead.

Ok, let's try your fix. We still have few days. I applied the patch[1]
to the pending branch this morning and if I don't see any errors I apply
it later tonight and hopefully it will be in tomorrow's linux-next
build. Thanks for the quick fix, very much appreciated.

[1] "mtd: add arch dependency for MTD_BCM47XXSFLASH symbol"
    https://patchwork.kernel.org/patch/9236053/

-- 
Kalle Valo
