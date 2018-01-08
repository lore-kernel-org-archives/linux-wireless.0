Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:43703 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754937AbeAHSLW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 13:11:22 -0500
Received: by mail-pf0-f195.google.com with SMTP id e3so6511403pfi.10
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jan 2018 10:11:21 -0800 (PST)
Date: Mon, 8 Jan 2018 10:11:18 -0800
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>
Subject: Re: [PATCH] mwifiex: cancel pcie/sdio work in remove/shutdown handler
Message-ID: <20180108181117.GA129772@google.com> (sfid-20180108_191127_098326_1AE5BC27)
References: <1513164473-13827-1-git-send-email-huxm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513164473-13827-1-git-send-email-huxm@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Dec 13, 2017 at 07:27:53PM +0800, Xinming Hu wrote:
> The last command used to shutdown firmware might be timeout,
> and trigger firmware dump in asynchronous pcie/sdio work.
> 
> The remove/shutdown handler will continue free core data
> structure private/adapter, which might be dereferenced in
> pcie/sdio work, finally crash the kernel.
> 
> Sync and Cancel pcie/sdio work, could be a fix for above
> cornel case. In this way, the last command timeout could

s/cornel/corner/

> be handled properly.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 2 ++
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index f666cb2..23209c5 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -310,6 +310,8 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
>  		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
>  	}
>  
> +	cancel_work_sync(&card->work);
> +

Just FYI, this "fix" is not a real fix. It will likely paper over some
of your bugs (where, e.g., the FW shutdown command times out in the
previous couple of lines), but this highlights the fact that there are
other races that could trigger the same behavior. You're not fixing
those.

For example, what if somebody initiates a scan or other nl80211 command
between the above line and mwifiex_remove_card()? That command could
potentially time out too.

The proper fix would be to institute some kind of mutual exclusion
(locking) between mwifiex_shutdown_sw() and mwifiex_remove_card(), so
that they can't occur at the same time.

Unfortunately, I only paid attention to this after Kalle already applied
this patch. Personally, I'd prefer this patch not get applied, since
it's a bad solution to an obvious problem, which instead leaves a subtle
problem that perhaps no one will bother fixing.

Brian

>  	mwifiex_remove_card(adapter);
>  }
>  
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index a828801..2488587 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -399,6 +399,8 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
>  		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
>  	}
>  
> +	cancel_work_sync(&card->work);
> +
>  	mwifiex_remove_card(adapter);
>  }
>  
> -- 
> 1.9.1
> 
