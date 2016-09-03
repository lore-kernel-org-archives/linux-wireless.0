Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47030 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753168AbcICOK3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 10:10:29 -0400
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
Message-Id: <20160903140819.359A96216A@smtp.codeaurora.org> (sfid-20160903_161037_454187_64E079B5)
Date: Sat,  3 Sep 2016 14:08:19 +0000 (UTC)
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

Nobody tested this, so I'll drop the patch.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8608751/
