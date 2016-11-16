Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48864 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753564AbcKPOJE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 09:09:04 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Matthias Schiffer <mschiffer@universe-factory.net>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath9k-devel@lists.ath9k.org, miaoqing@codeaurora.org
Subject: Re: [PATCH] ath9k: fix ath9k_hw_gpio_get() to return 0 or 1 on success
References: <44116a7bca8524a187083916bdea535145e7a23a.1479232041.git.mschiffer@universe-factory.net>
Date: Wed, 16 Nov 2016 16:08:58 +0200
In-Reply-To: <44116a7bca8524a187083916bdea535145e7a23a.1479232041.git.mschiffer@universe-factory.net>
        (Matthias Schiffer's message of "Tue, 15 Nov 2016 18:47:21 +0100")
Message-ID: <8760nno6th.fsf@kamboji.qca.qualcomm.com> (sfid-20161116_150908_672149_6A08A576)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias Schiffer <mschiffer@universe-factory.net> writes:

> Commit b2d70d4944c1 ("ath9k: make GPIO API to support both of WMAC and
> SOC") refactored ath9k_hw_gpio_get() to support both WMAC and SOC GPIOs,
> changing the return on success from 1 to BIT(gpio). This broke some callers
> like ath_is_rfkill_set().
>
> Instead of fixing all callers, change ath9k_hw_gpio_get() back to only
> return 0 or 1.
>
> Fixes: b2d70d4944c1 ("ath9k: make GPIO API to support both of WMAC and SOC")
> Cc: <stable@vger.kernel.org> # v4.7+
> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>

Can you describe more about the symptoms, how did this break from user's
point of view? I can add that to the commit log.

-- 
Kalle Valo
