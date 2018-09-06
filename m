Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34434 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbeIFUkx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 16:40:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] ath10k: avoid possible memory access violation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1533292805-9709-1-git-send-email-vijay.bvb@samsung.com>
References: <1533292805-9709-1-git-send-email-vijay.bvb@samsung.com>
To: "K.T.VIJAYAKUMAAR" <vijay.bvb@samsung.com>
Cc: davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpgs@samsung.com,
        vijay.bvb@samsung.com
Message-Id: <20180906160442.93AA16081A@smtp.codeaurora.org> (sfid-20180906_180453_448706_17BA47F2)
Date: Thu,  6 Sep 2018 16:04:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"K.T.VIJAYAKUMAAR" <vijay.bvb@samsung.com> wrote:

> array "ctl_power_table" access index "pream" is initialized with -1 and
> is raised as a static analysis tool issue.
> [drivers\net\wireless\ath\ath10k\wmi.c:4719] ->
> [drivers\net\wireless\ath\ath10k\wmi.c:4730]: (error) Array index -1 is
> out of bounds.
> 
> Since the "pream" index for accessing ctl_power_table array is initialized
> with -1, there is a chance of memory access violation for the cases below.
> 1) wmi_pdev_tpc_final_table_event change frequency is between 2483 and 5180
> 2) pream_idx is out of the enumeration ranges of wmi_tpc_pream_2ghz,
> wmi_tpc_pream_5ghz
> 
> Signed-off-by: K.T.VIJAYAKUMAAR <vijay.bvb@samsung.com>
> [kvalo@codeaurora.org: clean up the warning message]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

97c69a70dc2c ath10k: avoid possible memory access violation

-- 
https://patchwork.kernel.org/patch/10554929/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
