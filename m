Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42584 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbG0K2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 06:28:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-wireless@vger.kernel.org, khoroshilov@ispras.ru,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] rsi: Fix failure to load firmware after memory leak fix and fix the leak
References: <1437975813-3285-1-git-send-email-mike.looijmans@topic.nl>
Date: Mon, 27 Jul 2015 13:28:26 +0300
In-Reply-To: <1437975813-3285-1-git-send-email-mike.looijmans@topic.nl> (Mike
	Looijmans's message of "Mon, 27 Jul 2015 07:43:33 +0200")
Message-ID: <87wpxlao8l.fsf@kamboji.qca.qualcomm.com> (sfid-20150727_122853_181962_CBE131C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mike Looijmans <mike.looijmans@topic.nl> writes:

> Fixes commit eae79b4f3e82ca63a53478a161b190a0d38fe526 ("rsi: fix memory leak
> in rsi_load_ta_instructions()") which stopped the driver from functioning.

You can abbreviate the commit id:

Fixes commit eae79b4f3e82 ("rsi: fix memory leak in
rsi_load_ta_instructions()") which stopped the driver from functioning.

> Firmware data has been allocated using vmalloc(), resulting in memory
> that cannot be used for DMA. Hence the firmware was first copied to a
> buffer allocated with kmalloc() in the original code. This patch reverts
> the commit and only calls "kfree()" to release the buffer after sending
> the data. This fixes the memory leak without breaking the driver.
>
> Add a comment to the kmemdup() calls to explain why this is done.
>
> Tested on a Topic Miami-Florida board which contains the rsi SDIO chip.
>
> Also added the same kfree() call to the USB glue driver. This was not
> tested on actual hardware though, as I only have the SDIO version.
>
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>

Add this before Signed-off-by line:

Fixes: eae79b4f3e82 ("rsi: fix memory leak in rsi_load_ta_instructions()")

> Cc: stable@vger.kernel.org

Also no need to send email to stable@vger.kernel.org list, this line is
enough and the stable team will pick the commit automatically.

-- 
Kalle Valo
