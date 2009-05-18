Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:62267 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZERVVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 17:21:22 -0400
Received: by ewy24 with SMTP id 24so4425975ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 14:21:23 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH 5/5] p54spi: use firmware/DMA bug workaround that work under hight load in p54spi_rx
Date: Tue, 19 May 2009 01:21:13 +0400
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>
References: <1242601355-3178-1-git-send-email-jcmvbkbc@gmail.com> <1242601355-3178-6-git-send-email-jcmvbkbc@gmail.com> <87tz3i9ram.fsf@litku.valot.fi>
In-Reply-To: <87tz3i9ram.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200905190121.14103.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Max Filippov <jcmvbkbc@gmail.com> writes:
> > Under high load first data word, read after available data size
> > is sometimes lost in p54spi_rx. It seems to depend on frequency
> > of interrupts and latency of data read request relatively to
> > 'data available' interrupt. The worst consequence of this bug
> > is loss of packet transmission acknowledgement, which in turn
> > causes overflow of tx queues and permanent link loss.
> >
> > Read data size and first data word in one SPI transaction.
> > No packets from LMAC should have length less than 1 word,
> > so this shouldn't interfere with the next read transaction.
>
> There is a bug in omap2_mcspi which corrupts some DMA transfers, I don't
> know if the bug you see is this one or something else. I'll send the
> patch to linux-omap sometime later this week.

I guess it will be easy to check whether your patch changes something in 
original p54spi behavior. I'll test this.

Thanks.
-- Max

