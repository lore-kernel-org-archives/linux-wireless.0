Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42462 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbcGSOKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 10:10:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	"open list\:MEMORY TECHNOLOGY DEVICES \(MTD\)"
	<linux-mtd@lists.infradead.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: add arch dependency for MTD_BCM47XXSFLASH symbol
References: <1468912123-14899-1-git-send-email-zajec5@gmail.com>
	<20160719072613.GA96986@google.com>
Date: Tue, 19 Jul 2016 17:10:10 +0300
In-Reply-To: <20160719072613.GA96986@google.com> (Brian Norris's message of
	"Tue, 19 Jul 2016 00:26:13 -0700")
Message-ID: <87d1m9vhvh.fsf@kamboji.qca.qualcomm.com> (sfid-20160719_161031_090247_B83F9160)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <computersforpeace@gmail.com> writes:

> On Tue, Jul 19, 2016 at 09:08:32AM +0200, Rafał Miłecki wrote:
>> We dropped strict MIPS dependency for bcm47xxsflash driver in:
>> commit 5651d6aaf489 ("mtd: bcm47xxsflash: use ioremap_cache() instead of
>> KSEG0ADDR()") but using ioremap_cache still limits building it to few
>> selected architectures only.
>> 
>> A recent commit 57d8f7dd2132 ("bcma: allow enabling serial flash support
>> on non-MIPS SoCs") automatically dropped MIPS dependency for
>> MTD_BCM47XXSFLASH which broke building e.g. on powerpc and cris.
>> 
>> The bcma change is alright as it doesn't break building bcma code in any
>> way. MTD_BCM47XXSFLASH on the other hand should be limited to archs
>> which need it and can build it (by providing ioremap_cache).
>> 
>> Fixes: 57d8f7dd2132 ("bcma: allow enabling serial flash support on non-MIPS SoCs")
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> Cc: Brian Norris <computersforpeace@gmail.com>
>
> While I might prefer we have a better consistent set of portable I/O
> accessors (it's really a mess), it seems quite reasonable to restrict
> the damage to ARM and MIPS here if it saves some short-term hassle:
>
> Acked-by: Brian Norris <computersforpeace@gmail.com>
>
>> ---
>> That bcma commit breaking building landed in the wireless-drivers-next.
>> Is that possible to get this patch through the same tree?
>
> That's fine with me.

Great, thanks. I'm planning to apply this later tonight to fix the build
error.

-- 
Kalle Valo
