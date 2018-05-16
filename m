Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59508 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752555AbeEPNuQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 09:50:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH V2 3/6] mwifiex: support sysfs initiated device coredump
References: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
        <1526472723-15758-4-git-send-email-arend.vanspriel@broadcom.com>
Date: Wed, 16 May 2018 16:50:10 +0300
In-Reply-To: <1526472723-15758-4-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Wed, 16 May 2018 14:12:00 +0200")
Message-ID: <87h8n7lnfx.fsf@kamboji.qca.qualcomm.com> (sfid-20180516_155019_711575_BF92927E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
> it is possible to initiate a device coredump from user-space. This
> patch adds support for it adding the .coredump() driver callback.
> As there is no longer a need to initiate it through debugfs remove
> that code.
>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  V2:
>   - export mwifiex_send_cmd() needed by mwifiex_usb.ko.
> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c  |  1 +
>  drivers/net/wireless/marvell/mwifiex/debugfs.c | 31 +-------------------------
>  drivers/net/wireless/marvell/mwifiex/pcie.c    | 18 +++++++++++++--
>  drivers/net/wireless/marvell/mwifiex/sdio.c    | 12 ++++++++++
>  drivers/net/wireless/marvell/mwifiex/usb.c     | 13 +++++++++++
>  5 files changed, 43 insertions(+), 32 deletions(-)

You forgot to CC mwifiex maintainers, doing it now. Full patch here:

https://patchwork.kernel.org/patch/10403717/

-- 
Kalle Valo
