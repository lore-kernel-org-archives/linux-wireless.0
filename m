Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33398 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753995AbeAHR27 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:28:59 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76: fix memcpy to potential null pointer on failed allocation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171214101322.10178-1-colin.king@canonical.com>
References: <20171214101322.10178-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180108172858.AB27260346@smtp.codeaurora.org> (sfid-20180108_182918_992975_86E21FDD)
Date: Mon,  8 Jan 2018 17:28:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently if the allocation of skb fails and returns NULL then the
> call to skb_put will cause a null pointer dereference. Fix this by
> checking for a null skb and returning NULL.  Note that calls to
> function mt76x2_mcu_msg_alloc don't directly check the null return
> but instead pass the NULL pointer to mt76x2_mcu_msg_send which
> checks for the NULL and returns ENOMEM in this case.
> 
> Detected by CoverityScan, CID#1462624 ("Dereference null return value")
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

364bea50dbea mt76: fix memcpy to potential null pointer on failed allocation

-- 
https://patchwork.kernel.org/patch/10111747/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
