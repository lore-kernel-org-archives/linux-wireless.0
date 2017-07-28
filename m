Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdG1OuC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:50:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: fix compile warning of unused variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1499327433-70786-1-git-send-email-shawn.lin@rock-chips.com>
References: <1499327433-70786-1-git-send-email-shawn.lin@rock-chips.com>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Shawn Lin <shawn.lin@rock-chips.com>
Message-Id: <20170728145002.5F3C860128@smtp.codeaurora.org> (sfid-20170728_165009_410521_5FC92117)
Date: Fri, 28 Jul 2017 14:50:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shawn Lin <shawn.lin@rock-chips.com> wrote:

> We got a compile warning shows below:
> 
> drivers/net/wireless/marvell/mwifiex/sdio.c: In function
> 'mwifiex_sdio_remove':
> drivers/net/wireless/marvell/mwifiex/sdio.c:377:6: warning: variable
> 'ret' set but not used [-Wunused-but-set-variable]
> 
> Per the code, it didn't check if mwifiex_sdio_read_fw_status
> finish successfully. We should at least check the return of
> mwifiex_sdio_read_fw_status, otherwise the following check of
> firmware_stat and adapter->mfg_mode is pointless as the device
> is probably dead.
> 
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

f46a5b0156b1 mwifiex: fix compile warning of unused variable

-- 
https://patchwork.kernel.org/patch/9827585/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
