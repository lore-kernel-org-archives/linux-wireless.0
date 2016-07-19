Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34329 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbcGSGvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 02:51:49 -0400
MIME-Version: 1.0
In-Reply-To: <8760s2w369.fsf@kamboji.qca.qualcomm.com>
References: <20160719160831.79c0303f@canb.auug.org.au> <8760s2w369.fsf@kamboji.qca.qualcomm.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 19 Jul 2016 08:51:48 +0200
Message-ID: <CACna6rxVFD1MpAEYP_Zd4W8CvgnxSQpa0wJs83jwDJ5v11gZ=Q@mail.gmail.com> (sfid-20160719_085217_929442_F816C4E7)
Subject: Re: linux-next: build failure after merge of the wireless-drivers-next
 tree
To: Kalle Valo <kvalo@codeaurora.org>,
	Brian Norris <computersforpeace@gmail.com>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 July 2016 at 08:30, Kalle Valo <kvalo@codeaurora.org> wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>
>> After merging the wireless-drivers-next tree, today's linux-next build
>> (powerpc allyesconfig) failed like this:
>>
>> drivers/mtd/devices/bcm47xxsflash.c: In function 'bcm47xxsflash_bcma_probe':
>> drivers/mtd/devices/bcm47xxsflash.c:299:17: error: implicit declaration of function 'ioremap_cache' [-Werror=implicit-function-declaration]
>>   b47s->window = ioremap_cache(res->start, resource_size(res));
>>                  ^
>> drivers/mtd/devices/bcm47xxsflash.c:299:15: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>>   b47s->window = ioremap_cache(res->start, resource_size(res));
>>                ^
>>
>> Caused by commit
>>
>>   57d8f7dd2132 ("bcma: allow enabling serial flash support on non-MIPS SoCs")
>>
>> I have reverted that commit for today.
>
> Thanks, kbuild bot also notified about this.
>
> Rafał, as the merge window is getting really close I would like to
> revert this for now and we can reapply it once we the problem is fully
> solved. And we can use my pending branch for build testing the patch
> with kbuild bot. What do you think?

The simplest fix sounds pretty much as simple as the revert. In the
seconds thread I was considering two fixes: switching to memremap and
adding depends on.

What about trying a simple "depends on"?

-- 
Rafał
