Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35154 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbeG3T2Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 15:28:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] ath10k: Disable bundle mgmt tx completion event
 support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1530177537-18487-2-git-send-email-pillair@codeaurora.org>
References: <1530177537-18487-2-git-send-email-pillair@codeaurora.org>
To: Rakesh Pillai <pillair@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Message-Id: <20180730175217.8584A62256@smtp.codeaurora.org> (sfid-20180730_195220_448196_44EDC0C1)
Date: Mon, 30 Jul 2018 17:52:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@codeaurora.org> wrote:

> The tx completion of multiple mgmt frames can be bundled
> in a single event and sent by the firmware to host, if this
> capability is not disabled explicitly by the host. If the host
> cannot handle the bundled mgmt tx completion, this capability
> support needs to be disabled in the wmi init cmd, sent to the firmware.
> 
> Add the host capability indication flag in the wmi ready command,
> to let firmware know the features supported by the host driver.
> This field is ignored if it is not supported by firmware.
> 
> Set the host capability indication flag(i.e. host_capab) to zero,
> for disabling the support of bundle mgmt tx completion. This will
> indicate the firmware to send completion event for every mgmt tx
> completion, instead of bundling them together and sending in a single
> event.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

673bc519c558 ath10k: disable bundle mgmt tx completion event support
dc405152bb64 ath10k: handle mgmt tx completion event

-- 
https://patchwork.kernel.org/patch/10493381/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
