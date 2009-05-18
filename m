Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:35000 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZERSxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 14:53:07 -0400
Received: by bwz22 with SMTP id 22so3389228bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 11:53:07 -0700 (PDT)
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
Subject: Re: [PATCH 5/5] p54spi: use firmware/DMA bug workaround that work under hight load in p54spi_rx
References: <1242601355-3178-1-git-send-email-jcmvbkbc@gmail.com>
	<1242601355-3178-2-git-send-email-jcmvbkbc@gmail.com>
	<1242601355-3178-3-git-send-email-jcmvbkbc@gmail.com>
	<1242601355-3178-4-git-send-email-jcmvbkbc@gmail.com>
	<1242601355-3178-5-git-send-email-jcmvbkbc@gmail.com>
	<1242601355-3178-6-git-send-email-jcmvbkbc@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 18 May 2009 21:53:05 +0300
In-Reply-To: <1242601355-3178-6-git-send-email-jcmvbkbc@gmail.com> (Max Filippov's message of "Mon\, 18 May 2009 03\:02\:35 +0400")
Message-ID: <87tz3i9ram.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Max Filippov <jcmvbkbc@gmail.com> writes:

> Under high load first data word, read after available data size
> is sometimes lost in p54spi_rx. It seems to depend on frequency
> of interrupts and latency of data read request relatively to
> 'data available' interrupt. The worst consequence of this bug
> is loss of packet transmission acknowledgement, which in turn
> causes overflow of tx queues and permanent link loss.
>
> Read data size and first data word in one SPI transaction.
> No packets from LMAC should have length less than 1 word,
> so this shouldn't interfere with the next read transaction.

There is a bug in omap2_mcspi which corrupts some DMA transfers, I don't
know if the bug you see is this one or something else. I'll send the
patch to linux-omap sometime later this week.

-- 
Kalle Valo
