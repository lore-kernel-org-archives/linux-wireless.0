Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0075.outbound.protection.outlook.com ([104.47.40.75]:16736
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750861AbdGYWBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 18:01:05 -0400
Date: Wed, 26 Jul 2017 01:00:52 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: imitsyanko@quantenna.com, avinashp@quantenna.com,
        smatyukevich@quantenna.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qtfnmac: Tidy up DMA mask setting
Message-ID: <20170725220050.eksg3j53lemrhgdd@bars> (sfid-20170726_000114_928487_65F58C67)
References: <2c3f47792b2e38d5584d641d98e82f8318fefc72.1500917445.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2c3f47792b2e38d5584d641d98e82f8318fefc72.1500917445.git.robin.murphy@arm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> As the only caller of dma_supported() outside of DMA API internals, the
> qtfnmac driver stands out and invites scrutiny. Thankfully, it's not
> being used for evil, but it is entirely redundant, since it open-codes a
> check that the DMA mask setting functions are going to perform anyway.
> In fact, the whole qtnf_pcie_init_dma_mask() function is nothing more
> than a rather long-winded implementation of dma_set_mask_and_coherent(),
> so let's just use that directly.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>


Nice, thanks you !

Acked-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
