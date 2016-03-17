Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:54952 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbcCQJWb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 05:22:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bcma: use of_dma_configure() to set initial dma mask
Date: Thu, 17 Mar 2016 10:22:21 +0100
Message-ID: <13546368.rS15i1tsqM@wuerfel> (sfid-20160317_102321_157425_3A4D155F)
In-Reply-To: <1458206432-3039552-2-git-send-email-arnd@arndb.de>
References: <1458206432-3039552-1-git-send-email-arnd@arndb.de> <1458206432-3039552-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 17 March 2016 10:20:21 Arnd Bergmann wrote:
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
> 
> This patch needs to be tested to ensure we don't introduce
> regressions, and should probably go into 4.7 as a cleanup.
> 

I had meant to send at least a build-tested version of this,
sorry for the premature submission that breaks the build.

v2 coming.

	Arnd
