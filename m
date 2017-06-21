Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52348 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdFUNwz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 09:52:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath9k: fix tx99 use after free
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1497921220-12940-1-git-send-email-miaoqing@codeaurora.org>
References: <1497921220-12940-1-git-send-email-miaoqing@codeaurora.org>
To: miaoqing pan <miaoqing@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <sssa@qti.qualcomm.com>, Miaoqing Pan <miaoqing@codeaurora.org>
Message-ID: <e99476beba52495e8e40aca9c545bd67@euamsexm01a.eu.qualcomm.com> (sfid-20170621_155258_573593_93BA7734)
Date: Wed, 21 Jun 2017 15:52:47 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing pan <miaoqing@codeaurora.org> wrote:

> One scenario that could lead to UAF is two threads writing
> simultaneously to the "tx99" debug file. One of them would
> set the "start" value to true and follow to ath9k_tx99_init().
> Inside the function it would set the sc->tx99_state to true
> after allocating sc->tx99skb. Then, the other thread would
> execute write_file_tx99() and call ath9k_tx99_deinit().
> sc->tx99_state would be freed. After that, the first thread
> would continue inside ath9k_tx99_init() and call
> r = ath9k_tx99_send(sc, sc->tx99_skb, &txctl);
> that would make use of the freed sc->tx99_skb memory.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

I added Cc stable to both patches.

-- 
https://patchwork.kernel.org/patch/9798309/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
