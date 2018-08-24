Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbeHXLlx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 07:41:53 -0400
Date: Fri, 24 Aug 2018 10:08:18 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76: Fix comparisons with invalid hardware key index
Message-ID: <20180824080817.GA6651@redhat.com> (sfid-20180824_100836_839771_5C02F6D3)
References: <20180823212738.18431-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180823212738.18431-1-geert@linux-m68k.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 23, 2018 at 11:27:38PM +0200, Geert Uytterhoeven wrote:
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

Ack for mt76x0. I think Lorenzo already posted patch for mt76x2.

Thanks
Stanislaw
