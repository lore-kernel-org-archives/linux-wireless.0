Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:63050 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423255AbcFMO2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 10:28:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] *** staging: wilc1000: Replace semaphores with mutexes or completions ***
Date: Mon, 13 Jun 2016 16:29:56 +0200
Message-ID: <3475016.uenfZZHUnB@wuerfel> (sfid-20160613_162859_001115_6BF0F1D9)
In-Reply-To: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, June 13, 2016 4:07:32 PM CEST Binoy Jayan wrote:
> Hi,
> 
> These are a set of patches which removes semaphores from:
> 
> drivers/staging/wilc1000
> 
> These are part of a bigger effort to eliminate all semaphores
> from the linux kernel.
> 
> They build correctly (individually and as a whole).
> 
> NB: The changes are untested
> 

Most of these look really good, but I've commented on what I think
should be done differently, most importantly using a work_queue
rather than a completion to replace the semaphore in patch 6.

Maybe you can resend the first five patches after addressing
my comments so we can get those tested and queued already while
you look into reworking patch 6. Let me know if that one ends up
being more complicated than I thought so we can come up with
a different approach.

	Arnd
