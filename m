Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42640 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752955AbeDJO2u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 10:28:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: avoid possible string overflow
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180328220635.3704458-1-arnd@arndb.de>
References: <20180328220635.3704458-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, Arnd Bergmann <arnd@arndb.de>,
        Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180410142849.EB1DA60F5F@smtp.codeaurora.org> (sfid-20180410_162911_739095_67248F9A)
Date: Tue, 10 Apr 2018 14:28:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> The way that 'strncat' is used here raised a warning in gcc-8:
> 
> drivers/net/wireless/ath/ath10k/wmi.c: In function 'ath10k_wmi_tpc_stats_final_disp_tables':
> drivers/net/wireless/ath/ath10k/wmi.c:4649:4: error: 'strncat' output truncated before terminating nul copying as many bytes from a string as its length [-Werror=stringop-truncation]
> 
> Effectively, this is simply a strcat() but the use of strncat() suggests
> some form of overflow check. Regardless of whether this might actually
> overflow, using strlcat() instead of strncat() avoids the warning and
> makes the code more robust.
> 
> Fixes: bc64d05220f3 ("ath10k: debugfs support to get final TPC stats for 10.4 variants")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6707ba0105a2 ath10k: avoid possible string overflow

-- 
https://patchwork.kernel.org/patch/10314201/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
