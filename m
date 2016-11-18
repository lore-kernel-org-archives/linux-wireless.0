Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33740 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751802AbcKRLau (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 06:30:50 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,
 01/11] mwifiex: check tx_hw_pending before downloading sleep confirm
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
References: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Shengzhen Li <szli@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161118113049.AFC0862669@smtp.codeaurora.org> (sfid-20161118_123054_271723_FAF26623)
Date: Fri, 18 Nov 2016 11:30:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Shengzhen Li <szli@marvell.com>
> 
> We may get SLEEP event from firmware even if TXDone interrupt
> for last Tx packet is still pending. In this case, we may
> end up accessing PCIe memory for handling TXDone after power
> save handshake is completed. This causes kernel crash with
> external abort.
> 
> This patch will only allow downloading sleep confirm
> when no tx done interrupt is pending in the hardware.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Tested-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

(A note to myself)

Depends on this patchset:

[ 12] [v4,1/3] mwifiex: Allow mwifiex early access to device st... 2016-11-15 Amitkumar Ka Awaiting Upstream
[ 13] [v4,2/3] mwifiex: Introduce mwifiex_probe_of() to parse c... 2016-11-15 Amitkumar Ka Awaiting Upstream
[ 14] [v4,3/3] mwifiex: Enable WoWLAN for both sdio and pcie       2016-11-15 Amitkumar Ka Awaiting Upstream

-- 
https://patchwork.kernel.org/patch/9423003/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
