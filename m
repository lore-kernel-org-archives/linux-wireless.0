Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdAMNrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 08:47:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: linux-next: build warning after merge of the wireless-drivers-next tree
References: <20170113111250.2023a160@canb.auug.org.au>
Date: Fri, 13 Jan 2017 15:47:41 +0200
In-Reply-To: <20170113111250.2023a160@canb.auug.org.au> (Stephen Rothwell's
        message of "Fri, 13 Jan 2017 11:12:50 +1100")
Message-ID: <87shonjcle.fsf@codeaurora.org> (sfid-20170113_144805_604490_0CC4068C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> After merging the wireless-drivers-next tree, today's linux-next build
> (x86_64 allmodconfig) produced this warning:
>
> drivers/net/wireless/marvell/mwifiex/pcie.c: In function 'mwifiex_pcie_remove':
> drivers/net/wireless/marvell/mwifiex/pcie.c:303:5: warning: 'fw_status' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   if (fw_status == FIRMWARE_READY_PCIE && !adapter->mfg_mode) {
>      ^
>
> Introduced by commit
>
>   045f0c1b5e26 ("mwifiex: get rid of global user_rmmod flag")
>
> This is not a false positive since "reg" could be NULL just above
> (otherwise it would be tested for).

Thanks, I noticed this myself yesterday (after I had applied the patch)
and I have asked Marvell to send a fix.

-- 
Kalle Valo
