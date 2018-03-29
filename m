Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36398 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbeC2JDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 05:03:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix recent bandwidth conversion bug
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1520684438-9233-1-git-send-email-akolli@codeaurora.org>
References: <1520684438-9233-1-git-send-email-akolli@codeaurora.org>
To: akolli@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180329090335.8A89760C55@smtp.codeaurora.org> (sfid-20180329_110339_623454_C821AE97)
Date: Thu, 29 Mar 2018 09:03:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@codeaurora.org wrote:

> The commit "cfg80211: make RATE_INFO_BW_20 the default" changed
> the index of RATE_INFO_BW_20, but the updates to ath10k missed
> the special bandwidth calculation case in
> ath10k_update_per_peer_tx_stats().
> 
> This will fix below warning,
> 
>  WARNING: CPU: 0 PID: 609 at net/wireless/util.c:1254
>  cfg80211_calculate_bitrate+0x174/0x220
>  invalid rate bw=1, mcs=9, nss=2
> 
>  (unwind_backtrace) from
>  (cfg80211_calculate_bitrate+0x174/0x220)
>  (cfg80211_calculate_bitrate) from
>  (nl80211_put_sta_rate+0x44/0x1dc)from
>  (nl80211_put_sta_rate) from
>  (nl80211_send_station+0x388/0xaf0)
>  (nl80211_get_station+0xa8/0xec)
>  [ end trace da8257d6a850e91a ]
> 
> Fixes: 842be75c77cb ("cfg80211: make RATE_INFO_BW_20 the default")
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

91493e8e10f0 ath10k: fix recent bandwidth conversion bug

-- 
https://patchwork.kernel.org/patch/10273445/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
