Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19175 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab1CaQVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:21:08 -0400
Subject: Re: [PATCH 3/3] iwlwifi: remove sync_cmd_mutex
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1301585788-7331-3-git-send-email-sgruszka@redhat.com>
References: <1301585788-7331-1-git-send-email-sgruszka@redhat.com>
	 <1301585788-7331-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 09:18:15 -0700
Message-ID: <1301588295.22383.10.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-31 at 08:36 -0700, Stanislaw Gruszka wrote:
> We now use priv->mutex to serialize sync command, remove old
> priv->sync_cmd_mutex and add assertion that priv->mutex must be locked.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c  |    4 ----
>  drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
>  drivers/net/wireless/iwlwifi/iwl-hcmd.c |   13 +++++--------
>  3 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 0c49d1a..6f188fd 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -2565,9 +2565,6 @@ static void __iwl_down(struct iwl_priv *priv)
>  	priv->bt_full_concurrent = false;
>  	priv->bt_ci_compliance = 0;
>  
> -	/* Unblock any waiting calls */
> -	wake_up_interruptible_all(&priv->wait_command_queue);
> -
>  	/* Wipe out the EXIT_PENDING status bit if we are not actually
>  	 * exiting the module */
>  	if (!exit_pending)
> @@ -3814,7 +3811,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
>  	INIT_LIST_HEAD(&priv->free_frames);
>  
>  	mutex_init(&priv->mutex);
> -	mutex_init(&priv->sync_cmd_mutex);
>  
>  	priv->ieee_channels = NULL;
>  	priv->ieee_rates = NULL;
> diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
> index 9e63bd8..ca30f95 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-dev.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
> @@ -1306,7 +1306,6 @@ struct iwl_priv {
>  	spinlock_t hcmd_lock;	/* protect hcmd */
>  	spinlock_t reg_lock;	/* protect hw register access */
>  	struct mutex mutex;
> -	struct mutex sync_cmd_mutex; /* enable serialization of sync commands */
>  
>  	/* basic pci-network driver stuff */
>  	struct pci_dev *pci_dev;
> diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
> index 02499f6..c71c0a4 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
> @@ -171,14 +171,13 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
>  	int cmd_idx;
>  	int ret;
>  
> -	BUG_ON(cmd->flags & CMD_ASYNC);
> +	lockdep_assert_held(&priv->mutex);
>  
>  	 /* A synchronous command can not have a callback set. */
> -	BUG_ON(cmd->callback);
> +	BUG_ON((cmd->flags & CMD_ASYNC) || cmd->callback);
>  
>  	IWL_DEBUG_INFO(priv, "Attempting to send sync command %s\n",
>  			get_cmd_string(cmd->id));
> -	mutex_lock(&priv->sync_cmd_mutex);
>  
>  	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
>  	IWL_DEBUG_INFO(priv, "Setting HCMD_ACTIVE for command %s\n",
> @@ -189,7 +188,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
>  		ret = cmd_idx;
>  		IWL_ERR(priv, "Error sending %s: enqueue_hcmd failed: %d\n",
>  			  get_cmd_string(cmd->id), ret);
> -		goto out;
> +		return ret;
>  	}
>  
>  	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
> @@ -229,8 +228,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
>  		goto cancel;
>  	}
>  
> -	ret = 0;
> -	goto out;
> +	return 0;
>  
>  cancel:
>  	if (cmd->flags & CMD_WANT_SKB) {
> @@ -248,8 +246,7 @@ fail:
>  		iwl_free_pages(priv, cmd->reply_page);
>  		cmd->reply_page = 0;
>  	}
> -out:
> -	mutex_unlock(&priv->sync_cmd_mutex);
> +
>  	return ret;
>  }
>  


