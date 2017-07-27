Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55218 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbdG0K6g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 06:58:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [-next] rtlwifi: kfree entry until after entry->bssid has been
 accessed
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170630100843.9188-1-colin.king@canonical.com>
References: <20170630100843.9188-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20170727105836.02AB5607C8@smtp.codeaurora.org> (sfid-20170727_125856_105180_8A981663)
Date: Thu, 27 Jul 2017 10:58:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The current code kfree's entry and then dereferences it by accessing
> entry->bssid.  Avoid the dereference-after-free by moving the kfree
> after the access to entry->bssid.
> 
> Detected by CoverityScan, CID#1448600 ("Read from pointer after free")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

d0116f6f7b30 rtlwifi: kfree entry until after entry->bssid has been accessed

-- 
https://patchwork.kernel.org/patch/9819083/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
