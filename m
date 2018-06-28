Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51458 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935092AbeF1Jo5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 05:44:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] ath10k: transmit queued frames after processing rx packets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180523221508.26391-1-niklas.cassel@linaro.org>
References: <20180523221508.26391-1-niklas.cassel@linaro.org>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180628094457.25EF360B1A@smtp.codeaurora.org> (sfid-20180628_114516_358966_A9357BDF)
Date: Thu, 28 Jun 2018 09:44:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Niklas Cassel <niklas.cassel@linaro.org> wrote:

> When running iperf on ath10k SDIO, TX can stop working:
> 
> iperf -c 192.168.1.1 -i 1 -t 20 -w 10K
> [  3]  0.0- 1.0 sec  2.00 MBytes  16.8 Mbits/sec
> [  3]  1.0- 2.0 sec  3.12 MBytes  26.2 Mbits/sec
> [  3]  2.0- 3.0 sec  3.25 MBytes  27.3 Mbits/sec
> [  3]  3.0- 4.0 sec   655 KBytes  5.36 Mbits/sec
> [  3]  4.0- 5.0 sec  0.00 Bytes  0.00 bits/sec
> [  3]  5.0- 6.0 sec  0.00 Bytes  0.00 bits/sec
> [  3]  6.0- 7.0 sec  0.00 Bytes  0.00 bits/sec
> [  3]  7.0- 8.0 sec  0.00 Bytes  0.00 bits/sec
> [  3]  8.0- 9.0 sec  0.00 Bytes  0.00 bits/sec
> [  3]  9.0-10.0 sec  0.00 Bytes  0.00 bits/sec
> [  3]  0.0-10.3 sec  9.01 MBytes  7.32 Mbits/sec
> 
> There are frames in the ieee80211_txq and there are frames that have
> been removed from from this queue, but haven't yet been sent on the wire
> (num_pending_tx).
> 
> When num_pending_tx reaches max_num_pending_tx, we will stop the queues
> by calling ieee80211_stop_queues().
> 
> As frames that have previously been sent for transmission
> (num_pending_tx) are completed, we will decrease num_pending_tx and wake
> the queues by calling ieee80211_wake_queue(). ieee80211_wake_queue()
> does not call wake_tx_queue, so we might still have frames in the
> queue at this point.
> 
> While the queues were stopped, the socket buffer might have filled up,
> and in order for user space to write more, we need to free the frames
> in the queue, since they are accounted to the socket. In order to free
> them, we first need to transmit them.
> 
> This problem cannot be reproduced on low-latency devices, e.g. pci,
> since they call ath10k_mac_tx_push_pending() from
> ath10k_htt_txrx_compl_task(). ath10k_htt_txrx_compl_task() is not called
> on high-latency devices.
> Fix the problem by calling ath10k_mac_tx_push_pending(), after
> processing rx packets, just like for low-latency devices, also in the
> SDIO case. Since we are calling ath10k_mac_tx_push_pending() directly,
> we also need to export it.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3f04950f32d5 ath10k: transmit queued frames after processing rx packets

-- 
https://patchwork.kernel.org/patch/10422451/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
