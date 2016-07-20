Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40506 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbcGTSly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 14:41:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Reizer\, Eyal" <eyalr@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-next\@vger.kernel.org" <linux-next@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the wireless-drivers-next tree
References: <20160720122503.09a46d7b@canb.auug.org.au>
	<8665E2433BC68541A24DFFCA87B70F5B3616184A@DFRE01.ent.ti.com>
Date: Wed, 20 Jul 2016 21:41:49 +0300
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B3616184A@DFRE01.ent.ti.com>
	(Eyal Reizer's message of "Wed, 20 Jul 2016 06:18:00 +0000")
Message-ID: <87oa5sqhhu.fsf@kamboji.qca.qualcomm.com> (sfid-20160720_204158_969165_CDC5F933)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Reizer, Eyal" <eyalr@ti.com> writes:

>> After merging the wireless-drivers-next tree, today's linux-next build
>> (x86_64 allmodconfig) produced this warning:
>> 
>> drivers/net/wireless/ti/wlcore/spi.c: In function 'wlcore_probe_of':
>> drivers/net/wireless/ti/wlcore/spi.c:457:6: warning: unused variable 'ret' [-
>> Wunused-variable]
>>   int ret;
>>       ^
>> 
>> Introduced by commit
>> 
>>   01efe65aba65 ("wlcore: spi: add wl18xx support")
>
> Of course you are right. It is indeed redundant now. Don't know how I
>have missed it. Don't remember seeing a warning from the tool chain I
>have used. Anyway ,will submit an amended patch soon.
 
I didn't notice it either as I didn't have CONFIG_WLCORE_SPI enabled.
But what's odd is that kbuild didn't report anything, it's usually quite
good to catch warnings like this.

Anyway, I have pushed the fix to wireless-drivers-next:

cb6a11518850 wlcore: spi: fix build warning caused by redundant variable

-- 
Kalle Valo
