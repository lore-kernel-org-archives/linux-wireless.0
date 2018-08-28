Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51940 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeH1R2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 13:28:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] ath10k: add debugfs support to dump per sta tx stats
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1533561223-342-5-git-send-email-akolli@codeaurora.org>
References: <1533561223-342-5-git-send-email-akolli@codeaurora.org>
To: Anilkumar Kolli <akolli@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180828133640.7D55E6044E@smtp.codeaurora.org> (sfid-20180828_153643_640376_8E868B4D)
Date: Tue, 28 Aug 2018 13:36:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anilkumar Kolli <akolli@codeaurora.org> wrote:

> This patch adds 'tx_stats' in per station debugfs entry.
> 
> Use this command to dump tx_stats:
> cat /sys/kernel/debug/ieee80211/phy0/netdev\:wlan0/
>     stations/<MACADDR>/tx_stats
> 
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

kbuild bot found new warnings:

   drivers/net/wireless/ath/ath10k/debugfs_sta.c: In function 'ath10k_dbg_sta_dump_tx_stats':
>> drivers/net/wireless/ath/ath10k/debugfs_sta.c:714:1: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]
    }
    ^

   drivers/net/wireless/ath/ath10k/debugfs_sta.c: In function 'ath10k_sta_add_debugfs':
>> drivers/net/wireless/ath/ath10k/debugfs_sta.c:737:41: error: 'struct ath10k' has no member named 'debug'
     if (ath10k_peer_stats_enabled(ar) && ar->debug.enable_extd_tx_stats)
                                            ^~

-- 
https://patchwork.kernel.org/patch/10557079/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
