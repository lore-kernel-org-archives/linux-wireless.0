Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbeIEJU4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 05:20:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Carl Huang <cjhuang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath10k: download firmware via diag Copy Engine for QCA6174 and QCA9377.
References: <1535596182-18038-1-git-send-email-cjhuang@codeaurora.org>
        <1535596182-18038-4-git-send-email-cjhuang@codeaurora.org>
Date: Wed, 05 Sep 2018 07:52:25 +0300
In-Reply-To: <1535596182-18038-4-git-send-email-cjhuang@codeaurora.org> (Carl
        Huang's message of "Thu, 30 Aug 2018 10:29:42 +0800")
Message-ID: <87musw7dh2.fsf@kamboji.qca.qualcomm.com> (sfid-20180905_065257_877961_A596E085)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Carl Huang <cjhuang@codeaurora.org> writes:

> Downloading firmware via BMI protocol takes too long time. For example,
> a ~700K bytes firmware takes about 500ms to download via BMI protocol.
> This is too long especially in suspend and resume scenario where firmware
> is re-downloaded unless WoWLAN is enabled. Downloading firmware via diag CE
> can reduce the time to ~40ms for a ~700K bytes firmware binary.
>
> Ath10k driver parses the firmware to segments and downloads the segments
> to the specified address directly. If the firmware is compressed or has
> unsupported segments, ath10k driver will try BMI download again.
>
> It's tested with QCA6174 hw3.2 and
> firmware-6.bin_WLAN.RM.4.4.1-00111-QCARMSWP-1. QCA9377 is also affected.
>
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>

There were new warnings:

drivers/net/wireless/ath/ath10k/hw.c:1029:16: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath/ath10k/hw.c:1047:27: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/hw.c:1047:27:    expected unsigned int [unsigned] [usertype] base_addr
drivers/net/wireless/ath/ath10k/hw.c:1047:27:    got restricted __le32 [usertype] addr
drivers/net/wireless/ath/ath10k/hw.c:1048:26: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/hw.c:1048:26:    expected unsigned int [unsigned] [usertype] base_len
drivers/net/wireless/ath/ath10k/hw.c:1048:26:    got restricted __le32 [usertype] length

I fixed those in the pending branch, please review:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=f6f6f597654693ab122ecd950b56343489b91e59

-- 
Kalle Valo
