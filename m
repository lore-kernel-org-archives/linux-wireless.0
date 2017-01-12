Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42762 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbdALOza (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 09:55:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja\@google.com" <rajatja@google.com>,
        "briannorris\@google.com" <briannorris@google.com>,
        "dmitry.torokhov\@gmail.com" <dmitry.torokhov@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [1/2] mwifiex: code rearrangement in pcie.c and sdio.c
References: <1480517537-9920-1-git-send-email-akarwar@marvell.com>
        <20161205110906.28C706034F@smtp.codeaurora.org>
        <25e936b31e1e4f3d9db2c2309da9f798@SC-EXCH04.marvell.com>
        <87mvfdk65r.fsf@kamboji.qca.qualcomm.com>
        <e03f76e98fae4ce1a6cf254a1838574c@SC-EXCH04.marvell.com>
Date: Thu, 12 Jan 2017 16:55:24 +0200
In-Reply-To: <e03f76e98fae4ce1a6cf254a1838574c@SC-EXCH04.marvell.com>
        (Amitkumar Karwar's message of "Wed, 11 Jan 2017 15:47:43 +0000")
Message-ID: <87lgugnx9f.fsf@kamboji.qca.qualcomm.com> (sfid-20170112_155533_055324_AAD1D2B2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

>> But these didn't. Can you please rebase these and resubmit in one
>> patchset? Less conflicts that way.
>> 
>
> The problem here is you tried to apply the patches in reverse order. Sorry for the confusion.
> Please apply pending patches in below order.
>
> [v3,1/5] mwifiex: don't wait for main_process in shutdown_drv --- Apply this patch first.
> [v3,2/5] mwifiex: do not free firmware dump memory in shutdown_drv
> [v3,3/5] mwifiex: get rid of drv_info* adapter variables
> [v3,4/5] mwifiex: wait firmware dump complete during card remove process
> [v3,5/5] mwifiex: move pcie_work and related variables inside card
>
> [1/2] mwifiex: code rearrangement in pcie.c and sdio.c
> [2/2] mwifiex: get rid of global user_rmmod flag
>
> mwifiex: use module_*_driver helper macros
>
> [1/5] mwifiex: get rid of mwifiex_do_flr wrapper
> [2/5] mwifiex: cleanup in PCIe flr code path
> [3/5] mwifiex: sdio card reset enhancement
> [4/5] mwifiex: get rid of __mwifiex_sdio_remove helper 
> [5/5] mwifiex: get rid of global save_adapter and sdio_work

Thanks, now I was able to apply these but please do double check the
result in wireless-drivers-next.

I also noticed a new warning:

drivers/net/wireless/marvell/mwifiex/pcie.c: In function 'mwifiex_pcie_remove':
drivers/net/wireless/marvell/mwifiex/pcie.c:303:5: warning: 'fw_status'
may be used uninitialized in this function [-Wmaybe-uninitialized]
  if (fw_status == FIRMWARE_READY_PCIE && !adapter->mfg_mode) {

Actually I'm not sure if this warning was caused by these patches as I
have recently updated my ancient gcc to a newer one (5.4.0), but please
take a look and send a fix if it's a valid warning.

-- 
Kalle Valo
