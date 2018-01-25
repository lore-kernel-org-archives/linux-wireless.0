Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34676 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbeAYS7v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 13:59:51 -0500
Received: by mail-pf0-f196.google.com with SMTP id e76so6457630pfk.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jan 2018 10:59:51 -0800 (PST)
Date: Thu, 25 Jan 2018 10:59:48 -0800
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>
Subject: Re: [PATCH 1/2] mwifiex: schedule rx_work on RX interrupt for USB
Message-ID: <20180125185948.3k3tujvssw6xgt4r@ban.mtv.corp.google.com> (sfid-20180125_195955_492641_4EC48816)
References: <1516633497-6584-1-git-send-email-gbhat@marvell.com>
 <1516633497-6584-2-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1516633497-6584-2-git-send-email-gbhat@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 22, 2018 at 08:34:56PM +0530, Ganapathi Bhat wrote:
> From: Shrenik Shikhare <shrenik@marvell.com>
> 
> There is race for data_received flag between main thread and
> RX data interrupt(mwifiex_usb_rx_complete()):
> 1. USB received an RX data interrupt, set data_received flag
> 2. main thread checks data_received, if set queues rx_work

Stop right there.

There is a flag, data_received, and as you say, you are setting it one
thread, and reading it in another thread (and later clearing it; step
#5). Where is the locking? There is none. Therefore, you have a data
race.

You are not resolving any locking problems here, so you're not really
solving the entire problem.

Brian

> 3. rx worker thread independently start processing rx_data_q
> 4. rx work exits (once rx_data_q is empty)
> 5. main thread resets the data_received flag(after #2)
> 6. Now at the corner case there will be high RX data interrupts
> between #4 and #5
> 7. Driver stops submitting URBs to firmware, once rx_pending
> exceeds HIGH_RX_PENDING
> 8. The flag data_received(cleared in #5) will remain unset since
> there will be no interrupts from firmware to set it(after #7)
> 
> Above scenario causes RX stall in driver, which will finally
> result in command/TX timeouts in firmware.
> 
> As a fix, queue rx_work directly in mwifiex_usb_rx_complete()
> callback, instead in the main thread. This removes dependency
> of RX processing on data_received flag.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/main.c | 7 ++++---
>  drivers/net/wireless/marvell/mwifiex/main.h | 1 +
>  drivers/net/wireless/marvell/mwifiex/usb.c  | 2 ++
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
> index 12e7399..6e6e1a7 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.c
> +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> @@ -171,7 +171,7 @@ void mwifiex_queue_main_work(struct mwifiex_adapter *adapter)
>  }
>  EXPORT_SYMBOL_GPL(mwifiex_queue_main_work);
>  
> -static void mwifiex_queue_rx_work(struct mwifiex_adapter *adapter)
> +void mwifiex_queue_rx_work(struct mwifiex_adapter *adapter)
>  {
>  	unsigned long flags;
>  
> @@ -183,6 +183,7 @@ static void mwifiex_queue_rx_work(struct mwifiex_adapter *adapter)
>  		queue_work(adapter->rx_workqueue, &adapter->rx_work);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(mwifiex_queue_rx_work);
>  
>  static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
>  {
> @@ -283,10 +284,10 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
>  				mwifiex_process_hs_config(adapter);
>  			if (adapter->if_ops.process_int_status)
>  				adapter->if_ops.process_int_status(adapter);
> +			if (adapter->rx_work_enabled && adapter->data_received)
> +				mwifiex_queue_rx_work(adapter);
>  		}
>  
> -		if (adapter->rx_work_enabled && adapter->data_received)
> -			mwifiex_queue_rx_work(adapter);
>  
>  		/* Need to wake up the card ? */
>  		if ((adapter->ps_state == PS_STATE_SLEEP) &&
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> index 6b5539b..66ba95c 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.h
> +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> @@ -1667,6 +1667,7 @@ u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
>  void mwifiex_upload_device_dump(struct mwifiex_adapter *adapter);
>  void *mwifiex_alloc_dma_align_buf(int rx_len, gfp_t flags);
>  void mwifiex_queue_main_work(struct mwifiex_adapter *adapter);
> +void mwifiex_queue_rx_work(struct mwifiex_adapter *adapter);
>  int mwifiex_get_wakeup_reason(struct mwifiex_private *priv, u16 action,
>  			      int cmd_type,
>  			      struct mwifiex_ds_wakeup_reason *wakeup_reason);
> diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
> index 4bc2448..d20fda1 100644
> --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> @@ -144,6 +144,8 @@ static int mwifiex_usb_recv(struct mwifiex_adapter *adapter,
>  		skb_queue_tail(&adapter->rx_data_q, skb);
>  		adapter->data_received = true;
>  		atomic_inc(&adapter->rx_pending);
> +		if (adapter->rx_work_enabled)
> +			mwifiex_queue_rx_work(adapter);
>  		break;
>  	default:
>  		mwifiex_dbg(adapter, ERROR,
> -- 
> 1.9.1
> 
