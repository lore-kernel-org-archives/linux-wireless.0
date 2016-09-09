Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5376 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754143AbcIIMHo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 08:07:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix throughput regression in multi client mode
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160829081613.1474-1-rmanohar@qti.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>,
        <rmanohar@codeaurora.org>
Message-ID: <00fa6b69d3a645b19d85f2f3c83748b5@euamsexm01a.eu.qualcomm.com> (sfid-20160909_140748_203658_2FCD0A9D)
Date: Fri, 9 Sep 2016 14:07:34 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> commit 7a0adc83f34d ("ath10k: improve tx scheduling") is causing
> severe throughput drop in multi client mode. This issue is originally
> reported in veriwave setup with 50 clients with TCP downlink traffic.
> While increasing number of clients, the average throughput drops
> gradually. With 50 clients, the combined peak throughput is decreased
> to 98 Mbps whereas reverting given commit restored it to 550 Mbps.
> 
> Processing txqs for every tx completion is causing overhead. Ideally for
> management frame tx completion, pending txqs processing can be avoided.
> The change partly reverts the commit "ath10k: improve tx scheduling".
> Processing pending txqs after all skbs tx completion will yeild enough
> room to burst tx frames.
> 
> Fixes: 7a0adc83f34d ("ath10k: improve tx scheduling")
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

18f53fe0f303 ath10k: fix throughput regression in multi client mode

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9303279/
