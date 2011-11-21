Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2015 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1KURMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 12:12:31 -0500
Message-ID: <4ECA861A.4040906@qca.qualcomm.com> (sfid-20111121_181234_890884_949F9007)
Date: Mon, 21 Nov 2011 19:10:50 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Use mutex to protect dma buffer in sync read
 write
References: <1321858611-2729-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1321858611-2729-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2011 08:56 AM, Raja Mani wrote:
> Firmware crashes while starting Soft AP in 32 bit x86 platform.
> The reason is that the single dma buffer (ar_sdio->dma_buffer)
> is used in ath6kl_sdio_read_write_sync() for unaligned buffer
> handling and this function is called in the multiple context
> at the same time. So, finally hits dma buffer corruption and
> firmware crash.
> 
> Mutex is used to protect dma buffer to avoid data corruption.
> Spin lock can not used to fix this issue since mmc stack
> read/write calls may for sleep.
> 
> Observed this issue with recently commited patch
> "ath6kl: Claim sdio function only at appropriate places"
> 861dd058f495973c7ad2a44b8f68f3cc05733eab
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

I really would not like to add yet another lock (or mutex) to ath6kl,
but I don't see any other quick fix for this. So I have applied this for
now, but I hope that in the future we get to remove the ugly bounce
buffer altogether.

But I did minor changes in the patch: I added a comment to the mutex
(which I now require for all new locks), renamed the lock to something
easier and moved it after the buffer.

Kalle
