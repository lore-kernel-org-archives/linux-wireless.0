Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43200 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753884AbeDMN4t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 09:56:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Balaji Pothunoori <bpothuno@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath10k: average ack rssi support for data frames
References: <1523619357-1963-4-git-send-email-bpothuno@codeaurora.org>
Date: Fri, 13 Apr 2018 16:56:45 +0300
In-Reply-To: <1523619357-1963-4-git-send-email-bpothuno@codeaurora.org>
        (Balaji Pothunoori's message of "Fri, 13 Apr 2018 17:05:57 +0530")
Message-ID: <87efjjqkf6.fsf@kamboji.qca.qualcomm.com> (sfid-20180413_155653_751770_D2C40149)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Balaji Pothunoori <bpothuno@codeaurora.org> writes:

> Average ack rssi value is weighted average of ack rssi for
> no of msdu's has been sent.
> This feature is enabled by the host driver if firmware is capable.
> After receiving event from host, firmware allocates the necessary
> memory to store the ack_rssi for data packets during the init time.
>
> After each successful transmission, If tx completion status is OK
> and 24th bit is set in HTT message header then host will fetch the
> ack_rssi else host can ignore the ack_rssi field.
>
> Note: This patch is depends on cfg80211 patch.
>
> Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/core.c   |  4 ++++
>  drivers/net/wireless/ath/ath10k/htt.h    |  6 +++++-
>  drivers/net/wireless/ath/ath10k/htt_rx.c | 21 +++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/mac.c    |  4 ++++
>  drivers/net/wireless/ath/ath10k/wmi.h    |  8 ++++++++
>  5 files changed, 42 insertions(+), 1 deletion(-)

Usually notes like above are better to put under "---" line, this way
git-am will not include in the git commit log.

-- 
Kalle Valo
