Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52336 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753558AbdCTRMo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:12:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: pcie: clean up error prints in
 mwifiex_pcie_reset_notify()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170307204746.6294-1-briannorris@chromium.org>
References: <20170307204746.6294-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170320170456.83A596084C@smtp.codeaurora.org> (sfid-20170320_181315_811759_CFF75269)
Date: Mon, 20 Mar 2017 17:04:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> We shouldn't be printing a kernel pointer as a decimal integer. But we
> really shouldn't be printing this case at all; we should never get here
> with NULL drvdata. We've eliminated this unnecessary conditional in
> several other places, so kill it here too.
> 
> Similarly, there's no need to check for '!pdev'; we are guaranteed to
> have a real device here.
> 
> And finally, use dev_err() instead of pr_err().
> 
> This yields (for failed PCIe resets):
> 
> [   68.286586] mwifiex_pcie 0000:01:00.0: mwifiex_pcie_reset_notify: adapter structure is not valid
> 
> instead of:
> 
> [   82.932658] mwifiex_pcie: mwifiex_pcie_reset_notify: Card or adapter structure is not valid (-270880688088)
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

520334156213 mwifiex: pcie: clean up error prints in mwifiex_pcie_reset_notify()

-- 
https://patchwork.kernel.org/patch/9609861/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
