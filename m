Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbeGaJ33 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:29:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] net: wireless: ath6kl: Replace GFP_ATOMIC with GFP_KERNEL
 in ath6kl_bmi_init()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180727084318.3345-1-baijiaju1990@gmail.com>
References: <20180727084318.3345-1-baijiaju1990@gmail.com>
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Message-Id: <20180731075027.1FA2D6071C@smtp.codeaurora.org> (sfid-20180731_095151_139006_27302497)
Date: Tue, 31 Jul 2018 07:50:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> ath6kl_bmi_init() is never called in atomic context.
> It calls kzalloc() with GFP_ATOMIC, which is not necessary.
> GFP_ATOMIC can be replaced with GFP_KERNEL.
> 
> This is found by a static analysis tool named DCNS written by myself.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

bfc55fe65987 ath6kl: replace GFP_ATOMIC with GFP_KERNEL in ath6kl_bmi_init()

-- 
https://patchwork.kernel.org/patch/10546741/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
