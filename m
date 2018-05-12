Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43734 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbeELJDc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 05:03:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix return value check in wake_tx_q op
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180506132500.16888-1-erik.stromdahl@gmail.com>
References: <20180506132500.16888-1-erik.stromdahl@gmail.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Message-Id: <20180512090332.895FF6079C@smtp.codeaurora.org> (sfid-20180512_110335_895100_2DC56A48)
Date: Sat, 12 May 2018 09:03:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:

> ath10k_mac_tx_push_txq returns either a postive integer (length) on
> success or a negative error code on error.
> 
> The "if (ret) break;" statement will thus always break out of the loop
> immediately after ath10k_mac_tx_push_txq has returned (making the loop
> pointless).
> 
> A side effect of this fix is that we will iterate the queue until
> ath10k_mac_tx_push_txq returns -ENOENT. This will make sure the queue is
> not added back to ar->txqs when it is empty. This could potentially
> improve performance somewhat (I have seen a small improvement with SDIO
> devices).
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e3148cc5fecf ath10k: fix return value check in wake_tx_q op

-- 
https://patchwork.kernel.org/patch/10382789/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
