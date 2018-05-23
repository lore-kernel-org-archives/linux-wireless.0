Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:44972 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934512AbeEWWUG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 18:20:06 -0400
Received: by mail-wr0-f196.google.com with SMTP id y15-v6so29205667wrg.11
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2018 15:20:06 -0700 (PDT)
Date: Thu, 24 May 2018 00:20:02 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ath10k: transmit queued frames after processing rx
 packets
Message-ID: <20180523222002.GA26565@localhost.localdomain> (sfid-20180524_002111_850399_E6725E3C)
References: <20180523221508.26391-1-niklas.cassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180523221508.26391-1-niklas.cassel@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 24, 2018 at 12:15:08AM +0200, Niklas Cassel wrote:
> This problem cannot be reproduced on low-latency devices, e.g. pci,
> since they call ath10k_mac_tx_push_pending() from
> ath10k_htt_txrx_compl_task(). ath10k_htt_txrx_compl_task() is not called
> on high-latency devices.
> Fix the problem by calling ath10k_mac_tx_push_pending(), after
> processing rx packets, just like for low-latency devices, also in the
> SDIO case. Since we are calling ath10k_mac_tx_push_pending() directly,
> we also need to export it.
> 

Even if we are now calling ath10k_mac_tx_push_pending each time we process rx packets,
the number of packets we actually queue from ath10k_mac_tx_push_pending are quite few:

>From running iperf for 20 seconds:

# grep ath10k_mac_tx_push_txq /sys/kernel/debug/tracing/trace | grep -v ath10k_mac_op_wake_tx_queue | wc -l
233
number of times ath10k_mac_tx_push_txq was called, but not from ath10k_mac_op_wake_tx_queue,
i.e. number of times ath10k_mac_tx_push_txq was called from ath10k_mac_tx_push_pending.


# grep ath10k_mac_tx_push_txq /sys/kernel/debug/tracing/trace | grep -v ath10k_mac_tx_push_pending | wc -l
28415
number of times ath10k_mac_tx_push_txq was called, but not from ath10k_mac_tx_push_pending,
i.e number of times ath10k_mac_tx_push_txq was called from ath10k_mac_op_wake_tx_queue.


Regards,
Niklas
