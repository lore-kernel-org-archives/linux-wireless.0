Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32850 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935287AbeFMLvY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 07:51:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix memory leak of tpc_stats
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180527211702.23778-1-colin.king@canonical.com>
References: <20180527211702.23778-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20180613115123.F3D0F60717@smtp.codeaurora.org> (sfid-20180613_135227_719155_CA7E19D3)
Date: Wed, 13 Jun 2018 11:51:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> Currently tpc_stats is allocated and is leaked on the return
> path if num_tx_chain is greater than WMI_TPC_TX_N_CHAIN. Avoid
> this leak by performing the check on num_tx_chain before the
> allocation of tpc_stats.
> 
> Detected by CoverityScan, CID#1469422 ("Resource Leak")
> Fixes: 4b190675ad06 ("ath10k: fix kernel panic while reading tpc_stats")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

260e629bbf44 ath10k: fix memory leak of tpc_stats

-- 
https://patchwork.kernel.org/patch/10429553/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
