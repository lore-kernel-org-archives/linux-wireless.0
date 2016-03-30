Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35565 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbcC3Mae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 08:30:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bcma: use of_dma_configure() to set initial dma mask
References: <1458207563-3453369-1-git-send-email-arnd@arndb.de>
Date: Wed, 30 Mar 2016 15:30:29 +0300
In-Reply-To: <1458207563-3453369-1-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Thu, 17 Mar 2016 10:39:17 +0100")
Message-ID: <87h9fo5esa.fsf@purkki.adurom.net> (sfid-20160330_143106_158481_57EA93A4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> While fixing another bug, I noticed that bcma manually sets up
> a dma_mask pointer for its child devices. We have a generic
> helper for that now, which should be able to cope better with
> any variations that might be needed to deal with cache coherency,
> unusual DMA address offsets, iommus, or limited DMA masks, none
> of which are currently handled here.
>
> This changes the core to use the of_dma_configure(), like
> we do for platform devices that are probed directly from
> DT.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> This patch needs to be tested to ensure we don't introduce
> regressions, and should probably go into 4.7 as a cleanup.

Is anyone able to test this? The full patch is here:

https://patchwork.kernel.org/patch/8608751/

-- 
Kalle Valo
