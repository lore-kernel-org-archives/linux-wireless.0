Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64733 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758970AbcHaIYZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 04:24:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix throughput regression in multi client mode
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160829081613.1474-1-rmanohar@qti.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>,
        <rmanohar@codeaurora.org>
Message-ID: <425ad8d804bf46feada839a8e0d0c77e@euamsexm01a.eu.qualcomm.com> (sfid-20160831_102429_469775_B8C95611)
Date: Wed, 31 Aug 2016 10:24:15 +0200
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

I'm planning to queue this to 4.8 if no objections.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9303279/
