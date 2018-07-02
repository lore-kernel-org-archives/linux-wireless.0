Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38388 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752550AbeGBOkU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 10:40:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <simon@thekelleys.org.uk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2] atmel: using strlcpy() to avoid possible buffer overflows
References: <20180630063341.9900-1-yuehaibing@huawei.com>
Date: Mon, 02 Jul 2018 17:40:14 +0300
In-Reply-To: <20180630063341.9900-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Sat, 30 Jun 2018 14:33:41 +0800")
Message-ID: <8736x1snu9.fsf@kamboji.qca.qualcomm.com> (sfid-20180702_164041_417322_10B837AC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> writes:

> 'firmware' is a module param which may been longer than firmware_id,
> so using strlcpy() to guard against overflows. Also priv is allocated
> with zeroed memory,no need to set firmware_id[0] to '\0'.
>
> v1 -> v2: remove priv->firmware_id[0] = '\0';
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/atmel/atmel.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

The changelog should be after "---" line. I can fix it this time, but in
the future please use the correct location.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

-- 
Kalle Valo
