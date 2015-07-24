Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33786 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbbGXOMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 10:12:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	<linux-wireless@vger.kernel.org>, <fariyaf@gmail.com>
Subject: Re: Commit "rsi: fix memory leak in rsi_load_ta_instructions()" breaks things
References: <55B1E2CB.3040908@topic.nl> <55B1F9CC.4060507@ispras.ru>
	<55B21B37.4080509@topic.nl> <55B222F2.1070207@ispras.ru>
	<55B240B4.9050202@topic.nl>
Date: Fri, 24 Jul 2015 17:12:27 +0300
In-Reply-To: <55B240B4.9050202@topic.nl> (Mike Looijmans's message of "Fri, 24
	Jul 2015 15:42:12 +0200")
Message-ID: <87k2tpejas.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_161239_698626_0B254292)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mike Looijmans <mike.looijmans@topic.nl> writes:

> ﻿On 24-07-15 13:35, Alexey Khoroshilov wrote:
>> On 24.07.2015 18:02, Mike Looijmans wrote:
>>> On 24-07-15 10:39, Alexey Khoroshilov wrote:
>>>> Dear Mike,
>>>>
>>>> On 24.07.2015 14:01, Mike Looijmans wrote:
>>>>> Regarding this commit:
>>>>>
>>>>> https://lkml.org/lkml/2014/12/12/709
>>>>>
>>>>>       rsi: fix memory leak in rsi_load_ta_instructions()
>>>>>
>>>>>       Memory allocated by kmemdup() in rsi_load_ta_instructions() is
>>>>> leaked.
>>>>>       But duplication of firmware data here is useless,
>>>>>       so the patch removes kmemdup() at all.
>>>>>
>>>>>       Found by Linux Driver Verification project (linuxtesting.org).
>>>>>
>>>>>       Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>>>>>       Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>>>>
>>>>> We use this driver for the Redpine Wifi chip on our "florida" board, and
>>>>> after this commit it stopped working. Symptom was that the "wlan0"
>>>>> device was not created at all. Reverting the commit makes it work again.
>>>>>
>>>>> Apparently, the kmemdup action is needed for something. I suspect the
>>>>> DMA controller is still copying the firmware data before the method
>>>>> returned.
>>>>
>>>> To test your hypothesis, could you please check if it is still broken
>>>> with kfree(fw); added just after release_firmware(fw_entry); in
>>>> rsi_load_ta_instructions().
>>>
>>> Tried, and appears to work if i just kfree() the firmware copy. It does
>>> leave a bad taste though. I'd expect fw_entry->data to point to a
>>> kmalloc'd area as well. So it might work now just because it happens to
>>> be that the memory if "far enough away" and isn't being touched by
>>> anything else until the transfer is done. And on some other setup, it
>>> may suddenly fail unexpectedly.
>>>
>>> I thought to move the kfree to a point where the driver unregisters, but
>>> apparently it doesn't have any internal hook for that (sdio_done or so).
>>>
>>> I'd really like to see some comment from the Redpine folks on this, but
>>> since there hasn't been any event in the past year or so, I don't expect
>>> much.
>>
>> May be if firmware comes from userspace it is mapped to both kernel and
>> userspace and by some reason it is not good for DMA.
>> Another idea is fw_entry->data appears to be misaligned somehow.
>
> Just read some documentation:
> https://kernel.org/doc/Documentation/firmware_class/README
> It states "kernel: grows a buffer in PAGE_SIZE increments to hold the
> image as it comes in". Probably the firmware buffer is fragmented in
> memory as a result, and that wouldn't be very DMA friendly indeed. The
> copy would be contiguous again.
>
> I noticed that the same kfree is missing in the usb glue part of the
> RSI driver. I can't test that though, we only have the SDIO connected.
>
> I can submit a patch to add the "kfree()" call. Don't know about the
> revert though, can I just submit the revert as a patch and then the
> "kfree" as a second patch in the same set?

Better to do the revert and kfree() addition in one patch, they are
simple enough. Just document in the commit log that it reverts the
broken commit.

And remember to add CC stable to the commit log so that the fix goes to
stable releases.

-- 
Kalle Valo
