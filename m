Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42482 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754100AbdDEMo1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 08:44:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: fix use-after-free for FW reinit errors
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170328235933.950-1-briannorris@chromium.org>
References: <20170328235933.950-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>, <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170405124426.83E2360E0E@smtp.codeaurora.org> (sfid-20170405_144740_482819_259B64BF)
Date: Wed,  5 Apr 2017 12:44:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> If we fail to reinit the FW when resetting the device (in the
> synchronous version of mwifiex_init_hw_fw() -> mwifiex_fw_dpc()),
> mwifiex_fw_dpc() will tear down the interface and free up the adapter.
> But we don't actually check for all failure cases of mwifiex_fw_dpc(),
> so some of them fall through and dereference adapter->fw_done with a
> freed adapter, causing a use-after-free bug.
> 
> In any case, mwifiex_fw_dpc() will always signal FW completion -- in the
> error OR success case -- so at best, this was repeat work. Let's not do
> it.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

2 patches applied to wireless-drivers-next.git, thanks.

ce8fad9a1f09 mwifiex: fix use-after-free for FW reinit errors
755b37c93a06 mwifiex: catch mwifiex_fw_dpc() errors properly in reset

-- 
https://patchwork.kernel.org/patch/9650725/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
