Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47644 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdF1QxO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 12:53:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath9k: fix tx99 use after free
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1497921220-12940-1-git-send-email-miaoqing@codeaurora.org>
References: <1497921220-12940-1-git-send-email-miaoqing@codeaurora.org>
To: miaoqing pan <miaoqing@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <sssa@qti.qualcomm.com>, Miaoqing Pan <miaoqing@codeaurora.org>
Message-ID: <159e88e84f13480b8b1d835b0fa42bd6@euamsexm01a.eu.qualcomm.com> (sfid-20170628_185318_379393_84DFFED6)
Date: Wed, 28 Jun 2017 18:53:07 +0200
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
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

2 patches applied to ath-next branch of ath.git, thanks.

cf8ce1ea61b7 ath9k: fix tx99 use after free
bde717ab4736 ath9k: fix tx99 bus error

-- 
https://patchwork.kernel.org/patch/9798309/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
