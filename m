Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38580 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbeHaUA4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 16:00:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] mt76: Fix comparisons with invalid hardware key index
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180823212738.18431-1-geert@linux-m68k.org>
References: <20180823212738.18431-1-geert@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Message-Id: <20180831155248.B4F3460445@smtp.codeaurora.org> (sfid-20180831_175323_576894_AA35747C)
Date: Fri, 31 Aug 2018 15:52:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> With gcc 4.1.2:
> 
>     drivers/net/wireless/mediatek/mt76/mt76x0/tx.c: In function ‘mt76x0_tx’:
>     drivers/net/wireless/mediatek/mt76/mt76x0/tx.c:169: warning: comparison is always true due to limited range of data type
>     drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c: In function ‘mt76x2_tx’:
>     drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c:35: warning: comparison is always true due to limited range of data type
> 
> While assigning -1 to a u8 works fine, comparing with -1 does not work
> as expected.
> 
> Fix this by comparing with 0xff, like is already done in some other
> places.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Patch applied to wireless-drivers-next.git, thanks.

81c8eccc2404 mt76: Fix comparisons with invalid hardware key index

-- 
https://patchwork.kernel.org/patch/10574583/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
