Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39294 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbdGFH5l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 03:57:41 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH] mwifiex: fix compile warning of unused variable
References: <1499327433-70786-1-git-send-email-shawn.lin@rock-chips.com>
Date: Thu, 06 Jul 2017 10:57:14 +0300
In-Reply-To: <1499327433-70786-1-git-send-email-shawn.lin@rock-chips.com>
        (Shawn Lin's message of "Thu, 6 Jul 2017 15:50:33 +0800")
Message-ID: <87k23mf15x.fsf@kamboji.qca.qualcomm.com> (sfid-20170706_095748_886050_66E6E5D4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shawn Lin <shawn.lin@rock-chips.com> writes:

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

I don't see that warning, any ideas why? My compiler:

gcc (Ubuntu 5.4.0-6ubuntu1~16.04.4) 5.4.0 20160609


-- 
Kalle Valo
