Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41828 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbeAPQBO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 11:01:14 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] Revert "mwifiex: cancel pcie/sdio work in remove/shutdown
 handler"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180112210837.112628-1-briannorris@chromium.org>
References: <20180112210837.112628-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Ellie Reeves <ellierevves@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Brian Norris <briannorris@chromium.org>,
        "Signed-off-by : Xinming Hu" <huxm@marvell.com>
Message-Id: <20180116160114.43329608BF@smtp.codeaurora.org> (sfid-20180116_170129_542185_ABEF6577)
Date: Tue, 16 Jan 2018 16:01:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:

> This reverts commit b713bbf1471b56b572ce26bd02b81a85c2b007f4.
> 
> The "fix" in question does not actually fix all related problems, and it
> also introduces new deadlock possibilities. Since commit b014e96d1abb
> ("PCI: Protect pci_error_handlers->reset_notify() usage with
> device_lock()"), the race in question is actually resolved (PCIe reset
> cannot happen at the same time as remove()). Instead, this "fix" just
> introduces a deadlock where mwifiex_pcie_card_reset_work() is waiting on
> device_lock, which is held by PCIe device remove(), which is waiting
> on...mwifiex_pcie_card_reset_work().
> 
> The proper thing to do is just to fix the deadlock. Patch for this will
> come separately.
> 
> Cc: Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

2 patches applied to wireless-drivers-next.git, thanks.

7e34c0d2f631 Revert "mwifiex: cancel pcie/sdio work in remove/shutdown handler"
a64e7a79dd60 mwifiex: resolve reset vs. remove()/shutdown() deadlocks

-- 
https://patchwork.kernel.org/patch/10161659/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
