Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52930 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbGXICj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 04:02:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: <linux-wireless@vger.kernel.org>, <khoroshilov@ispras.ru>,
	Fariya Fatima <fariyaf@gmail.com>
Subject: Re: Commit "rsi: fix memory leak in rsi_load_ta_instructions()" breaks things
References: <55B1E2CB.3040908@topic.nl>
Date: Fri, 24 Jul 2015 11:02:32 +0300
In-Reply-To: <55B1E2CB.3040908@topic.nl> (Mike Looijmans's message of "Fri, 24
	Jul 2015 09:01:31 +0200")
Message-ID: <87egjyf0fb.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_100244_425048_8BC78EC0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mike Looijmans <mike.looijmans@topic.nl> writes:

> ﻿Regarding this commit:
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
> We use this driver for the Redpine Wifi chip on our "florida" board,
> and after this commit it stopped working. Symptom was that the "wlan0"
> device was not created at all. Reverting the commit makes it work
> again.
>
> Apparently, the kmemdup action is needed for something. I suspect the
> DMA controller is still copying the firmware data before the method
> returned.
>
> Having no experience with this part of the kernel, I wasn't able to
> come up with a more constructive solution than just reverting the
> patch.

Hmm, rsi doesn't seem to have an entry in MAINTAINERS? Do we have a
maintainer for this driver? Adding Fariya as the first rsi commiter.

Unless someone has better suggestions I'll just revert the patch.

-- 
Kalle Valo
