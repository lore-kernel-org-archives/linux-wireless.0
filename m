Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50545 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbbGXQ7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 12:59:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Mike Looijmans <mike.looijmans@topic.nl>,
	linux-wireless@vger.kernel.org, fariyaf@gmail.com
Subject: Re: Commit "rsi: fix memory leak in rsi_load_ta_instructions()" breaks things
References: <55B1E2CB.3040908@topic.nl> <55B1F9CC.4060507@ispras.ru>
	<55B21B37.4080509@topic.nl> <55B222F2.1070207@ispras.ru>
	<55B240B4.9050202@topic.nl> <87k2tpejas.fsf@kamboji.qca.qualcomm.com>
	<55B26728.1010804@ispras.ru>
Date: Fri, 24 Jul 2015 19:59:08 +0300
In-Reply-To: <55B26728.1010804@ispras.ru> (Alexey Khoroshilov's message of
	"Fri, 24 Jul 2015 23:26:16 +0700")
Message-ID: <871tfxcx0j.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_185926_608901_0FBAFBED)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexey Khoroshilov <khoroshilov@ispras.ru> writes:

> On 24.07.2015 21:12, Kalle Valo wrote:
>> Mike Looijmans <mike.looijmans@topic.nl> writes:
>> 

>>> Just read some documentation:
>>> https://kernel.org/doc/Documentation/firmware_class/README
>>> It states "kernel: grows a buffer in PAGE_SIZE increments to hold the
>>> image as it comes in". Probably the firmware buffer is fragmented in
>>> memory as a result, and that wouldn't be very DMA friendly indeed. The
>>> copy would be contiguous again.
>
> Interesting idea. Even fw_get_filesystem_firmware() uses vmalloc(), so
> fw_entry->data may be physically noncontiguous in case of reading
> firmware from file system as well.
>
> The only my doubt is whether contiguous memory is required here. As far
> as I can see, rsi_copy_to_card() writes data by blocks of size
> dev->tx_blk_size that is 256 for rsi_91x_sdio. So, it is not clear where
> problems can appear.

You cannot DMA from memory allocated with vmalloc(). So kmalloc() & co
has to be used when doing DMA.

>>> I can submit a patch to add the "kfree()" call. Don't know about the
>>> revert though, can I just submit the revert as a patch and then the
>>> "kfree" as a second patch in the same set?
>> 
>> Better to do the revert and kfree() addition in one patch, they are
>> simple enough. Just document in the commit log that it reverts the
>> broken commit.
>> 
>> And remember to add CC stable to the commit log so that the fix goes to
>> stable releases.
>
> Agree with Kalle with a couple of notes.
>
> To document a fix of a broken commit the preferable way is to use Fixes:
> tag.
> https://kernel.org/doc/Documentation/SubmittingPatches
>
> Also it would be useful to add a comment before kmemdup() with
> information why it is needed there.

Good points.

-- 
Kalle Valo
