Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42876 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdCPIOn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 04:14:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] mwifiex: pcie: don't leak DMA buffers when removing
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170311013924.73348-2-briannorris@chromium.org>
References: <20170311013924.73348-2-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajat Jain <rajatja@google.com>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Message-Id: <20170316081442.01B1B60C94@smtp.codeaurora.org> (sfid-20170316_091529_405685_B30833A5)
Date: Thu, 16 Mar 2017 08:14:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> When PCIe FLR support was added, much of the remove/release code for
> PCIe was migrated to ->down_dev(), but ->down_dev() is never called for
> device removal. Let's refactor the cleanup to be done in both cases.
> 
> Also, drop the comments above mwifiex_cleanup_pcie(), because they were
> clearly wrong, and it's better to have clear and obvious code than to
> detail the code steps in comments anyway.
> 
> Fixes: 4c5dae59d2e9 ("mwifiex: add PCIe function level reset support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

3 patches applied to wireless-drivers.git, thanks.

4e841d3eb929 mwifiex: pcie: don't leak DMA buffers when removing
ba1c7e45ec22 mwifiex: set adapter->dev before starting to use mwifiex_dbg()
36908c4e5b10 mwifiex: uninit wakeup info when removing device

-- 
https://patchwork.kernel.org/patch/9618297/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
