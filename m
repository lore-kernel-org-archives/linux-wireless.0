Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34174 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758234AbcKCQL6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Nov 2016 12:11:58 -0400
Received: by mail-pf0-f181.google.com with SMTP id n85so34026034pfi.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2016 09:11:57 -0700 (PDT)
Date: Thu, 3 Nov 2016 09:11:54 -0700
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Shengzhen Li <szli@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Wei-Ning Huang <wnhuang@chromium.org>
Subject: Re: [PATCH v2 01/12] mwifiex: check tx_hw_pending before downloading
 sleep confirm
Message-ID: <20161103161153.GA37095@google.com> (sfid-20161103_171225_926803_FA84BABD)
References: <1478002098-14189-1-git-send-email-huxinming820@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1478002098-14189-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Wei-Ning

On Tue, Nov 01, 2016 at 08:08:17PM +0800, Xinming Hu wrote:
> From: Shengzhen Li <szli@marvell.com>
> 
> We may get SLEEP event from firmware even if TXDone interrupt
> for last Tx packet is still pending. In this case, we may
> end up accessing PCIe memory for handling TXDone after power
> save handshake is completed. This causes kernel crash with
> external abort.
> 
> This patch will only allow downloading sleep confirm
> when no tx done interrupt is pending in the hardware.
> 
> ---
> v2: address format issues(Brain)
> ---

Nit: typically, it's best if the changelog is placed after the
Sign-offs, so that the first "---" line denotes the beginning of text
that can be discarded. (Typically the changelog doesn't go into the
final git commit, and it also happens that git-am discards everything
between the first "---" line and the actual patch content.)

> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c | 5 +++--
>  drivers/net/wireless/marvell/mwifiex/init.c   | 1 +
>  drivers/net/wireless/marvell/mwifiex/main.h   | 1 +
>  drivers/net/wireless/marvell/mwifiex/pcie.c   | 5 +++++
>  4 files changed, 10 insertions(+), 2 deletions(-)

Overall, I think this change is good, and it tests out fine for me so
far. Do we have the same problem for other interfaces too? e.g., SDIO?
It seems to me that the root problem is generic (i.e., don't try to
SLEEP while processing TX traffic) but the symptom just happened to be
fatal on a particular PCIe controller.

Brian

> diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> index 5347728..25a7475 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> @@ -1118,13 +1118,14 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
>  void
>  mwifiex_check_ps_cond(struct mwifiex_adapter *adapter)
>  {
> -	if (!adapter->cmd_sent &&
> +	if (!adapter->cmd_sent && !atomic_read(&adapter->tx_hw_pending) &&
>  	    !adapter->curr_cmd && !IS_CARD_RX_RCVD(adapter))
>  		mwifiex_dnld_sleep_confirm_cmd(adapter);
>  	else
>  		mwifiex_dbg(adapter, CMD,
> -			    "cmd: Delay Sleep Confirm (%s%s%s)\n",
> +			    "cmd: Delay Sleep Confirm (%s%s%s%s)\n",
>  			    (adapter->cmd_sent) ? "D" : "",
> +			    atomic_read(&adapter->tx_hw_pending) ? "T" : "",
>  			    (adapter->curr_cmd) ? "C" : "",
>  			    (IS_CARD_RX_RCVD(adapter)) ? "R" : "");
>  }
> diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
> index 82839d9..b36cb3f 100644
> --- a/drivers/net/wireless/marvell/mwifiex/init.c
> +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> @@ -270,6 +270,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
>  	adapter->adhoc_11n_enabled = false;
>  
>  	mwifiex_wmm_init(adapter);
> +	atomic_set(&adapter->tx_hw_pending, 0);
>  
>  	sleep_cfm_buf = (struct mwifiex_opt_sleep_confirm *)
>  					adapter->sleep_cfm->data;
> diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> index d61fe3a..7f67f23 100644
> --- a/drivers/net/wireless/marvell/mwifiex/main.h
> +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> @@ -857,6 +857,7 @@ struct mwifiex_adapter {
>  	atomic_t rx_pending;
>  	atomic_t tx_pending;
>  	atomic_t cmd_pending;
> +	atomic_t tx_hw_pending;
>  	struct workqueue_struct *workqueue;
>  	struct work_struct main_work;
>  	struct workqueue_struct *rx_workqueue;
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 063c707..4aa5d91 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -516,6 +516,7 @@ static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
>  		}
>  	}
>  
> +	atomic_set(&adapter->tx_hw_pending, 0);
>  	return 0;
>  }
>  
> @@ -689,6 +690,7 @@ static void mwifiex_cleanup_txq_ring(struct mwifiex_adapter *adapter)
>  		card->tx_buf_list[i] = NULL;
>  	}
>  
> +	atomic_set(&adapter->tx_hw_pending, 0);
>  	return;
>  }
>  
> @@ -1126,6 +1128,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
>  							    -1);
>  			else
>  				mwifiex_write_data_complete(adapter, skb, 0, 0);
> +			atomic_dec(&adapter->tx_hw_pending);
>  		}
>  
>  		card->tx_buf_list[wrdoneidx] = NULL;
> @@ -1218,6 +1221,7 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
>  		wrindx = (card->txbd_wrptr & reg->tx_mask) >> reg->tx_start_ptr;
>  		buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
>  		card->tx_buf_list[wrindx] = skb;
> +		atomic_inc(&adapter->tx_hw_pending);
>  
>  		if (reg->pfu_enabled) {
>  			desc2 = card->txbd_ring[wrindx];
> @@ -1295,6 +1299,7 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
>  done_unmap:
>  	mwifiex_unmap_pci_memory(adapter, skb, PCI_DMA_TODEVICE);
>  	card->tx_buf_list[wrindx] = NULL;
> +	atomic_dec(&adapter->tx_hw_pending);
>  	if (reg->pfu_enabled)
>  		memset(desc2, 0, sizeof(*desc2));
>  	else
> -- 
> 1.8.1.4
> 
