Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx6-14.smtp.antispamcloud.com ([95.211.2.226]:48725 "EHLO
	mx6-14.smtp.antispamcloud.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbbGXHrv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 03:47:51 -0400
Message-ID: <55B1E2CB.3040908@topic.nl> (sfid-20150724_094755_337088_CE674ECE)
Date: Fri, 24 Jul 2015 09:01:31 +0200
From: Mike Looijmans <mike.looijmans@topic.nl>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: <khoroshilov@ispras.ru>, <kvalo@codeaurora.org>
Subject: Commit "rsi: fix memory leak in rsi_load_ta_instructions()" breaks
 things
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

﻿Regarding this commit:

https://lkml.org/lkml/2014/12/12/709

     rsi: fix memory leak in rsi_load_ta_instructions()

     Memory allocated by kmemdup() in rsi_load_ta_instructions() is leaked.
     But duplication of firmware data here is useless,
     so the patch removes kmemdup() at all.

     Found by Linux Driver Verification project (linuxtesting.org).

     Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
     Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

We use this driver for the Redpine Wifi chip on our "florida" board, and after 
this commit it stopped working. Symptom was that the "wlan0" device was not 
created at all. Reverting the commit makes it work again.

Apparently, the kmemdup action is needed for something. I suspect the DMA 
controller is still copying the firmware data before the method returned.

Having no experience with this part of the kernel, I wasn't able to come up 
with a more constructive solution than just reverting the patch.

Kind regards,
Mike Looijmans.


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





