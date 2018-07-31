Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42774 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbeGaJ1X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:27:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH RESENT] ath10k: Prevent active scans on potential unusable
 channels
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180726135948.29160-1-sven@narfation.org>
References: <20180726135948.29160-1-sven@narfation.org>
To: Sven Eckelmann <sven@narfation.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Simon Wunderlich <simon.wunderlich@openmesh.com>,
        Marek Puzyniak <marek.puzyniak@tieto.com>
Message-Id: <20180731074821.AC7A160708@smtp.codeaurora.org> (sfid-20180731_094839_781431_97073086)
Date: Tue, 31 Jul 2018 07:48:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven@narfation.org> wrote:

> The QCA4019 hw1.0 firmware 10.4-3.2.1-00050 and 10.4-3.5.3-00053 (and most
> likely all other) seem to ignore the WMI_CHAN_FLAG_DFS flag during the
> scan. This results in transmission (probe requests) on channels which are
> not "available" for transmissions.
> 
> Since the firmware is closed source and nothing can be done from our side
> to fix the problem in it, the driver has to work around this problem. The
> WMI_CHAN_FLAG_PASSIVE seems to be interpreted by the firmware to not
> scan actively on a channel unless an AP was detected on it. Simple probe
> requests will then be transmitted by the STA on the channel.
> 
> ath10k must therefore also use this flag when it queues a radar channel for
> scanning. This should reduce the chance of an active scan when the channel
> might be "unusable" for transmissions.
> 
> Fixes: e8a50f8ba44b ("ath10k: introduce DFS implementation")
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3f2591115838 ath10k: prevent active scans on potential unusable channels

-- 
https://patchwork.kernel.org/patch/10545939/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
