Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53134 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbcIIJDu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 05:03:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] bcma: use of_dma_configure() to set initial dma mask
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1458207563-3453369-1-git-send-email-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160909090349.B94E261E8F@smtp.codeaurora.org> (sfid-20160909_110419_085915_93D36A0D)
Date: Fri,  9 Sep 2016 09:03:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:
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

Thanks, 1 patch applied to wireless-drivers-next.git:

defb893fffef bcma: use of_dma_configure() to set initial dma mask

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8608751/
