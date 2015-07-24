Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:54396 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbbGXIjr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 04:39:47 -0400
Message-ID: <55B1F9CC.4060507@ispras.ru> (sfid-20150724_103952_122642_764AA3BA)
Date: Fri, 24 Jul 2015 15:39:40 +0700
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>
CC: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	fariyaf@gmail.com
Subject: Re: Commit "rsi: fix memory leak in rsi_load_ta_instructions()" breaks
 things
References: <55B1E2CB.3040908@topic.nl>
In-Reply-To: <55B1E2CB.3040908@topic.nl>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Mike,

On 24.07.2015 14:01, Mike Looijmans wrote:
> Regarding this commit:
> 
> https://lkml.org/lkml/2014/12/12/709
> 
>     rsi: fix memory leak in rsi_load_ta_instructions()
> 
>     Memory allocated by kmemdup() in rsi_load_ta_instructions() is leaked.
>     But duplication of firmware data here is useless,
>     so the patch removes kmemdup() at all.
> 
>     Found by Linux Driver Verification project (linuxtesting.org).
> 
>     Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>     Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> We use this driver for the Redpine Wifi chip on our "florida" board, and
> after this commit it stopped working. Symptom was that the "wlan0"
> device was not created at all. Reverting the commit makes it work again.
> 
> Apparently, the kmemdup action is needed for something. I suspect the
> DMA controller is still copying the firmware data before the method
> returned.

To test your hypothesis, could you please check if it is still broken
with kfree(fw); added just after release_firmware(fw_entry); in
rsi_load_ta_instructions().

--
Thanks,
Alexey

