Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:38294 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751167Ab1ITUnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 16:43:19 -0400
Message-ID: <4E78FAE6.6080903@xenotime.net> (sfid-20110920_224336_761640_D83D8FF4)
Date: Tue, 20 Sep 2011 13:43:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH -next] bcma: needs export.h
References: <20110920173102.d38155c7defbbc29beaae7c0@canb.auug.org.au>	<4E78CFC0.4020003@xenotime.net> <CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
In-Reply-To: <CACna6rxGrd-ORWZrc0xsAOKptU_Xj3eGh9qSfX9vJYCPTZrCRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2011 11:45 AM, Rafał Miłecki wrote:
> 2011/9/20 Randy Dunlap <rdunlap@xenotime.net>:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> bcma/driver_chipcommon_pmu.c needs to include <linux/export.h>,
>> so add it to the headers that are included by bcma_private.h.
> 
> Please take a look at discussion in:
> [PATCH -next] bcma: main.c needs to include <linux/slab.h>
> thread (by Andrew).
> 
> I believe that according to the discussion, such a includes should be
> done in .c files.
> 
> Andrew: can you comment? Am I right?


Sure, I'll resubmit the patch.

Is there already a patch to remove <linux/delay.h> from bcma_private.h ?

bcma_private.h uses __init & __exit, so it should #include <linux/init.h> ...


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
