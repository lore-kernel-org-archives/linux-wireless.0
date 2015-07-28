Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx12-05.smtp.antispamcloud.com ([46.165.232.175]:52207 "EHLO
	mx12-05.smtp.antispamcloud.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbbG1GVG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 02:21:06 -0400
Message-ID: <55B718D1.2030803@topic.nl> (sfid-20150728_082116_991711_B84D8C46)
Date: Tue, 28 Jul 2015 07:53:21 +0200
From: Mike Looijmans <mike.looijmans@topic.nl>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <khoroshilov@ispras.ru>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] rsi: Fix failure to load firmware after memory leak fix
 and fix the leak
References: <1437975813-3285-1-git-send-email-mike.looijmans@topic.nl> <87wpxlao8l.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87wpxlao8l.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

﻿On 27-07-15 12:28, Kalle Valo wrote:
> Mike Looijmans <mike.looijmans@topic.nl> writes:
>
>> Fixes commit eae79b4f3e82ca63a53478a161b190a0d38fe526 ("rsi: fix memory leak
>> in rsi_load_ta_instructions()") which stopped the driver from functioning.
>
> You can abbreviate the commit id:
>
> Fixes commit eae79b4f3e82 ("rsi: fix memory leak in
> rsi_load_ta_instructions()") which stopped the driver from functioning.
>
>> Firmware data has been allocated using vmalloc(), resulting in memory
>> that cannot be used for DMA. Hence the firmware was first copied to a
>> buffer allocated with kmalloc() in the original code. This patch reverts
>> the commit and only calls "kfree()" to release the buffer after sending
>> the data. This fixes the memory leak without breaking the driver.
>>
>> Add a comment to the kmemdup() calls to explain why this is done.
>>
>> Tested on a Topic Miami-Florida board which contains the rsi SDIO chip.
>>
>> Also added the same kfree() call to the USB glue driver. This was not
>> tested on actual hardware though, as I only have the SDIO version.
>>
>> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
>
> Add this before Signed-off-by line:
>
> Fixes: eae79b4f3e82 ("rsi: fix memory leak in rsi_load_ta_instructions()")
>
>> Cc: stable@vger.kernel.org
>
> Also no need to send email to stable@vger.kernel.org list, this line is
> enough and the stable team will pick the commit automatically.

I wondered why that happened, and just noticed that git send-email 
automatically added this to the recipients. So it happened for v2 as well, 
sorry for that.



Kind regards,

Mike Looijmans
System Expert

TOPIC Embedded Products
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: +31 (0) 499 33 69 79
Telefax: +31 (0) 499 33 69 70
E-mail: mike.looijmans@topicproducts.com
Website: www.topicproducts.com

Please consider the environment before printing this e-mail





