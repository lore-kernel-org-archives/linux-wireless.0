Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38600 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbGaGXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 02:23:13 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] rsi: Fix failure to load firmware after memory leak fix and
 fixthe leak
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438062661-3173-1-git-send-email-mike.looijmans@topic.nl>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-wireless@vger.kernel.org, khoroshilov@ispras.ru,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mike Looijmans <mike.looijmans@topic.nl>,
	stable@vger.kernel.org
Message-Id: <20150731062312.CF880140A4E@smtp.codeaurora.org> (sfid-20150731_082335_336698_92F77EE2)
Date: Fri, 31 Jul 2015 06:23:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Fixes commit eae79b4f3e82 ("rsi: fix memory leak in rsi_load_ta_instructions()")
> which stopped the driver from functioning.
> 
> Firmware data has been allocated using vmalloc(), resulting in memory
> that cannot be used for DMA. Hence the firmware was first copied to a
> buffer allocated with kmalloc() in the original code. This patch reverts
> the commit and only calls "kfree()" to release the buffer after sending
> the data. This fixes the memory leak without breaking the driver.
> 
> Add a comment to the kmemdup() calls to explain why this is done, and abort
> if memory allocation fails.
> 
> Tested on a Topic Miami-Florida board which contains the rsi SDIO chip.
> 
> Also added the same kfree() call to the USB glue driver. This was not
> tested on actual hardware though, as I only have the SDIO version.
> 
> Fixes: eae79b4f3e82 ("rsi: fix memory leak in rsi_load_ta_instructions()")
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
> Cc: stable@vger.kernel.org

Thanks, applied to wireless-drivers.git.

Kalle Valo
