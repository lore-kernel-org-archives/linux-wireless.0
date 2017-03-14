Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:35004 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbdCNSdN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 14:33:13 -0400
Received: by mail-pg0-f41.google.com with SMTP id b129so94525128pgc.2
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 11:33:12 -0700 (PDT)
Date: Tue, 14 Mar 2017 11:33:08 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH] mwifiex: fix kernel crash after shutdown command timeout
Message-ID: <20170314183306.GA55602@google.com> (sfid-20170314_193331_431679_4AEFDF73)
References: <1487942964-3193-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1487942964-3193-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

You managed to CC several other Google folks, but not me, the one who
actually reviewed most of this! You might consider including me in the
future :)

On Fri, Feb 24, 2017 at 06:59:24PM +0530, Amitkumar Karwar wrote:
> We observed a SHUTDOWN command timeout during reboot stress test due
> to a corner case firmware bug. It leads to use-after-free on adapter
> structure pointer and crash.
> 
> We already have a cancel_work_sync() call in teardown thread. This
> issue is fixed by having this call just before mwifiex_remove_card().
> At this point no further work will be scheduled.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

I'm testing this artificially by testing things like this concurrently:

rmmod mwifiex_pcie &
cat /sys/kernel/debug/mwifiex/mlan0/device_dump

I'm using a 4.4-based kernel (plus quite a few backports) at the moment
and I'm having problems (I can retest on upstream if really needed), and
pretty sure this patch is buggy.

> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 3 +--
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index a0d9180..f31c5ea 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -294,8 +294,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
>  	if (!adapter || !adapter->priv_num)
>  		return;
>  
> -	cancel_work_sync(&card->work);
> -
>  	reg = card->pcie.reg;
>  	if (reg)
>  		ret = mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
> @@ -312,6 +310,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
>  		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
>  	}
>  
> +	cancel_work_sync(&card->work);

I don't think we want to move the cancellation to be this far; see the
mwifiex_init_shutdown_fw() above! If I add a msleep(3000) below this,
then run:

  rmmod mwifiex_pcie & sleep 0.5; cat /sys/kernel/debug/mwifiex/mlan0/device_dump

I can trigger an abort in mwifiex_pcie_rdwr_firmware(). The problem is
that you still allow a command timeout + firmware dump worker to still
race with the shutdown -- in this case, I think it's
mwifiex_init_shutdown_fw() that's disabling the device.

I think the real solution is to, somewhere before we shutdown the
firmware, *really* prevent any further work to be scheduled to
&card->work. Maybe that means adding another flag so that the worker
will just abort quickly in that case? So it's something like:

	card->worker_flags |= DONT_RUN_ANY_MORE;
	cancel_work_sync(&card->work);

	... (this can be done either above the FIRMWARE_READY_PCIE
	check, or else you need to write a different version for
	FIRMWARE_READY_PCIE vs. !FIRMWARE_READY_PCIE) ... but definitely
	before mwifiex_init_shutdown_fw() ) ...

And in mwifiex_pcie_work():

	if (card->worker_flags & DONT_RUN_ANY_MORE)
		return;

IOW, NAK to this patch.

Brian

>  	mwifiex_remove_card(adapter);
>  }
>  
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index a4b356d..9534b47 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -387,8 +387,6 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
>  	if (!adapter || !adapter->priv_num)
>  		return;
>  
> -	cancel_work_sync(&card->work);
> -
>  	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
>  
>  	ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
> @@ -400,6 +398,7 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
>  		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
>  	}
>  
> +	cancel_work_sync(&card->work);
>  	mwifiex_remove_card(adapter);
>  }
>  
> -- 
> 1.9.1
> 
