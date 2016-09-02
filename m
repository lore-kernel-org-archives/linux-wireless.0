Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6668 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932701AbcIBPxy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 11:53:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix sending frame in management path in push txq logic
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1471514404-24098-1-git-send-email-arnagara@qti.qualcomm.com>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        <arnagara@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <d88420cfb8264f28ac04cce477ed5cf1@euamsexm01a.eu.qualcomm.com> (sfid-20160902_175401_528926_7693D290)
Date: Fri, 2 Sep 2016 17:53:46 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ashok Raj Nagarajan <arnagara@qti.qualcomm.com> wrote:
> In the wake tx queue path, we are not checking if the frame to be sent
> takes management path or not. For eg. QOS null func frame coming here will
> take the management path. Since we are not incrementing the descriptor
> counter (num_pending_mgmt_tx) w.r.t tx management, on tx completion it is
> possible to see negative values.
> 
> When the above counter reaches a negative value, we will not be sending a
> probe response out.
> 
>     if (is_presp &&
> 	ar->hw_params.max_probe_resp_desc_thres < htt->num_pending_mgmt_tx)
> 
> For IPQ4019, max_probe_resp_desc_thres (u32) is 24 is compared against
> num_pending_mgmt_tx (int) and the above condtions comes true if the counter
> is negative and we drop the probe response.
> 
> To avoid this, check on the wake tx queue path as well for the tx path of
> the frame and increment the appropriate counters
> 
> Fixes: cac085524cf1 "ath10k: move mgmt descriptor limit handle under mgmt_tx"
> Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

e4fd726f21cd ath10k: fix sending frame in management path in push txq logic

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9287191/
