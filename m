Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935097AbeF1Ju0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 05:50:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: Protect ath10k_htt_rx_ring_free with rx_ring.lock
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1529006895-5105-1-git-send-email-greearb@candelatech.com>
References: <1529006895-5105-1-git-send-email-greearb@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Ben Greear <greearb@candelatech.com>
Message-Id: <20180628095026.3376660B19@smtp.codeaurora.org> (sfid-20180628_115029_668230_84AE85F4)
Date: Thu, 28 Jun 2018 09:50:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> wrote:

> While debugging driver crashes related to a buggy firmware
> crashing under load, I noticed that ath10k_htt_rx_ring_free
> could be called without being under lock.  I'm not sure if this
> is the root cause of the crash or not, but it seems prudent to
> protect it.
> 
> Originally tested on 4.16+ kernel with ath10k-ct 10.4 firmware
> running on 9984 NIC.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

168f75f11fe6 ath10k: protect ath10k_htt_rx_ring_free with rx_ring.lock

-- 
https://patchwork.kernel.org/patch/10465229/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
