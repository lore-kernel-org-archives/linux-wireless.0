Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52155 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3GXPaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 11:30:12 -0400
Date: Wed, 24 Jul 2013 11:16:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH 18/21] mwifiex: handle driver initialization error paths
Message-ID: <20130724151651.GD2385@tuxdriver.com> (sfid-20130724_173033_625482_CC2DE2E3)
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
 <1374545878-15683-19-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374545878-15683-19-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This one didn't apply on the current wireless-next tree.  Can you
fix it up?

On Mon, Jul 22, 2013 at 07:17:55PM -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> mwifiex_fw_dpc() asynchronously takes care of firmware download
> and initialization. Currently the error paths in mwifiex_fw_dpc()
> are not handled. So if wrong firmware is downloaded, required
> cleanup work is not performed. memory is leaked and workqueue
> remains unterminated in this case.
> 
> mwifiex_terminate_workqueue() is moved to avoid forward
> declaration.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/main.c | 83 ++++++++++++++++++++++++-------------
>  drivers/net/wireless/mwifiex/main.h |  1 +
>  2 files changed, 56 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
> index e64c369..5644c7f 100644
> --- a/drivers/net/wireless/mwifiex/main.c
> +++ b/drivers/net/wireless/mwifiex/main.c
> @@ -390,6 +390,17 @@ static void mwifiex_free_adapter(struct mwifiex_adapter *adapter)
>  }
>  
>  /*
> + * This function cancels all works in the queue and destroys
> + * the main workqueue.
> + */
> +static void mwifiex_terminate_workqueue(struct mwifiex_adapter *adapter)
> +{
> +	flush_workqueue(adapter->workqueue);
> +	destroy_workqueue(adapter->workqueue);
> +	adapter->workqueue = NULL;
> +}
> +
> +/*
>   * This function gets firmware and initializes it.
>   *
>   * The main initialization steps followed are -
> @@ -398,7 +409,7 @@ static void mwifiex_free_adapter(struct mwifiex_adapter *adapter)
>   */
>  static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
>  {
> -	int ret;
> +	int ret, i;
>  	char fmt[64];
>  	struct mwifiex_private *priv;
>  	struct mwifiex_adapter *adapter = context;
> @@ -407,7 +418,7 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
>  	if (!firmware) {
>  		dev_err(adapter->dev,
>  			"Failed to get firmware %s\n", adapter->fw_name);
> -		goto done;
> +		goto err_dnld_fw;
>  	}
>  
>  	memset(&fw, 0, sizeof(struct mwifiex_fw_image));
> @@ -420,7 +431,7 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
>  	else
>  		ret = mwifiex_dnld_fw(adapter, &fw);
>  	if (ret == -1)
> -		goto done;
> +		goto err_dnld_fw;
>  
>  	dev_notice(adapter->dev, "WLAN FW is active\n");
>  
> @@ -432,13 +443,15 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
>  	}
>  
>  	/* enable host interrupt after fw dnld is successful */
> -	if (adapter->if_ops.enable_int)
> -		adapter->if_ops.enable_int(adapter);
> +	if (adapter->if_ops.enable_int) {
> +		if (adapter->if_ops.enable_int(adapter))
> +			goto err_dnld_fw;
> +	}
>  
>  	adapter->init_wait_q_woken = false;
>  	ret = mwifiex_init_fw(adapter);
>  	if (ret == -1) {
> -		goto done;
> +		goto err_init_fw;
>  	} else if (!ret) {
>  		adapter->hw_status = MWIFIEX_HW_STATUS_READY;
>  		goto done;
> @@ -447,12 +460,12 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
>  	wait_event_interruptible(adapter->init_wait_q,
>  				 adapter->init_wait_q_woken);
>  	if (adapter->hw_status != MWIFIEX_HW_STATUS_READY)
> -		goto done;
> +		goto err_init_fw;
>  
>  	priv = adapter->priv[MWIFIEX_BSS_ROLE_STA];
>  	if (mwifiex_register_cfg80211(adapter)) {
>  		dev_err(adapter->dev, "cannot register with cfg80211\n");
> -		goto err_init_fw;
> +		goto err_register_cfg80211;
>  	}
>  
>  	rtnl_lock();
> @@ -483,13 +496,39 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
>  	goto done;
>  
>  err_add_intf:
> -	mwifiex_del_virtual_intf(adapter->wiphy, priv->wdev);
> +	for (i = 0; i < adapter->priv_num; i++) {
> +		priv = adapter->priv[i];
> +
> +		if (!priv)
> +			continue;
> +
> +		if (priv->wdev && priv->netdev)
> +			mwifiex_del_virtual_intf(adapter->wiphy, priv->wdev);
> +	}
>  	rtnl_unlock();
> +err_register_cfg80211:
> +	wiphy_unregister(adapter->wiphy);
> +	wiphy_free(adapter->wiphy);
>  err_init_fw:
>  	if (adapter->if_ops.disable_int)
>  		adapter->if_ops.disable_int(adapter);
> +err_dnld_fw:
>  	pr_debug("info: %s: unregister device\n", __func__);
> -	adapter->if_ops.unregister_dev(adapter);
> +	if (adapter->if_ops.unregister_dev)
> +		adapter->if_ops.unregister_dev(adapter);
> +
> +	if ((adapter->hw_status == MWIFIEX_HW_STATUS_FW_READY) ||
> +	    (adapter->hw_status == MWIFIEX_HW_STATUS_READY)) {
> +		pr_debug("info: %s: shutdown mwifiex\n", __func__);
> +		adapter->init_wait_q_woken = false;
> +
> +		if (mwifiex_shutdown_drv(adapter) == -EINPROGRESS)
> +			wait_event_interruptible(adapter->init_wait_q,
> +						 adapter->init_wait_q_woken);
> +	}
> +	adapter->surprise_removed = true;
> +	mwifiex_terminate_workqueue(adapter);
> +	mwifiex_free_adapter(adapter);
>  done:
>  	if (adapter->cal_data) {
>  		release_firmware(adapter->cal_data);
> @@ -497,6 +536,7 @@ done:
>  	}
>  	release_firmware(adapter->firmware);
>  	complete(&adapter->fw_load);
> +	up(adapter->card_sem);
>  	return;
>  }
>  
> @@ -807,18 +847,6 @@ static void mwifiex_main_work_queue(struct work_struct *work)
>  }
>  
>  /*
> - * This function cancels all works in the queue and destroys
> - * the main workqueue.
> - */
> -static void
> -mwifiex_terminate_workqueue(struct mwifiex_adapter *adapter)
> -{
> -	flush_workqueue(adapter->workqueue);
> -	destroy_workqueue(adapter->workqueue);
> -	adapter->workqueue = NULL;
> -}
> -
> -/*
>   * This function adds the card.
>   *
>   * This function follows the following major steps to set up the device -
> @@ -846,6 +874,7 @@ mwifiex_add_card(void *card, struct semaphore *sem,
>  	}
>  
>  	adapter->iface_type = iface_type;
> +	adapter->card_sem = sem;
>  
>  	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
>  	adapter->surprise_removed = false;
> @@ -876,17 +905,12 @@ mwifiex_add_card(void *card, struct semaphore *sem,
>  		goto err_init_fw;
>  	}
>  
> -	up(sem);
>  	return 0;
>  
>  err_init_fw:
>  	pr_debug("info: %s: unregister device\n", __func__);
>  	if (adapter->if_ops.unregister_dev)
>  		adapter->if_ops.unregister_dev(adapter);
> -err_registerdev:
> -	adapter->surprise_removed = true;
> -	mwifiex_terminate_workqueue(adapter);
> -err_kmalloc:
>  	if ((adapter->hw_status == MWIFIEX_HW_STATUS_FW_READY) ||
>  	    (adapter->hw_status == MWIFIEX_HW_STATUS_READY)) {
>  		pr_debug("info: %s: shutdown mwifiex\n", __func__);
> @@ -896,7 +920,10 @@ err_kmalloc:
>  			wait_event_interruptible(adapter->init_wait_q,
>  						 adapter->init_wait_q_woken);
>  	}
> -
> +err_registerdev:
> +	adapter->surprise_removed = true;
> +	mwifiex_terminate_workqueue(adapter);
> +err_kmalloc:
>  	mwifiex_free_adapter(adapter);
>  
>  err_init_sw:
> diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
> index bb28d3d..9ee3b1b 100644
> --- a/drivers/net/wireless/mwifiex/main.h
> +++ b/drivers/net/wireless/mwifiex/main.h
> @@ -749,6 +749,7 @@ struct mwifiex_adapter {
>  
>  	atomic_t is_tx_received;
>  	atomic_t pending_bridged_pkts;
> +	struct semaphore *card_sem;
>  };
>  
>  int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
> -- 
> 1.8.2.3
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
