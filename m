Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbdFMHCO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 03:02:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [wireless-next] qtnfmac: check band before allocating cmd_skb to
 avoid resource leak
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170602154045.28948-1-colin.king@canonical.com>
References: <20170602154045.28948-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20170613070213.64C55606DC@smtp.codeaurora.org> (sfid-20170613_090335_641278_57F89923)
Date: Tue, 13 Jun 2017 07:02:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The current code allocates cmd_skb and then will leak this if band->band
> is an illegal value. It is simpler to sanity check the band first before
> allocating cmd_skb so that we don't have to free cmd_skb if an invalid
> band occurs.
> 
> Detected by CoverityScan, CID#1437561 ("Resource Leak")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

bc0384eedb66 qtnfmac: check band before allocating cmd_skb to avoid resource leak

-- 
https://patchwork.kernel.org/patch/9762863/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
