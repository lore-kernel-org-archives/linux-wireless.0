Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57886 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343Ab3DATa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 15:30:56 -0400
Date: Mon, 1 Apr 2013 15:18:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@laptop.org>,
	Paul Fox <pgf@laptop.org>, Tim Shepard <shep@laptop.org>,
	Marco Cesarano <marco@marvell.com>,
	John Rhodes <jrhodes@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH 3.9 1/2] mwifiex: fix negative cmd_pending count
Message-ID: <20130401191801.GD3526@tuxdriver.com> (sfid-20130401_213105_210750_DCA9BDC5)
References: <1364607959-28905-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364607959-28905-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch seems rather large and is not at all obvious to me...

What is the actual effect of it?  Does it cause a crash?  A lock-up?
Data loss?

Is this an actual regression?

John

On Fri, Mar 29, 2013 at 06:45:58PM -0700, Bing Zhao wrote:
> cmd_pending is increased in mwifiex_wait_queue_complete() and
> decreased in mwifiex_complete_cmd() currently.
> If there are two or more commands in the cmd_pending_q the main
> worker thread will pick up next command from cmd_pending_q
> automatically after finishing current command. As a result
> mwifiex_wait_queue_complete() will not be called because
> the command is alreay completed. This leads to a negative
> number in cmd_pending count.
> 
> Fix it by increasing cmd_pending when a cmd is queued into
> cmd_pending_q and decreasing when that cmd is recycled. For scan
> commands we don't perform inc/dec operations until it's moved
> from scan_pending_q to cmd_pending_q. This covers both
> synchronous and asynchronous commands.
> 
> Cc: <stable@vger.kernel.org> # 3.8
> Reported-by: Daniel Drake <dsd@laptop.org>
> Tested-by: Daniel Drake <dsd@laptop.org>
> Tested-by: Marco Cesarano <marco@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/cmdevt.c      |   35 ++++++++++++++++++++--------
>  drivers/net/wireless/mwifiex/init.c        |    2 +-
>  drivers/net/wireless/mwifiex/main.h        |    2 +
>  drivers/net/wireless/mwifiex/sta_cmdresp.c |    2 +-
>  drivers/net/wireless/mwifiex/sta_ioctl.c   |    3 --
>  drivers/net/wireless/mwifiex/util.c        |    1 -
>  6 files changed, 29 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
> index 9a1302b..da469c3 100644
> --- a/drivers/net/wireless/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/mwifiex/cmdevt.c
> @@ -153,7 +153,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
>  			" or cmd size is 0, not sending\n");
>  		if (cmd_node->wait_q_enabled)
>  			adapter->cmd_wait_q.status = -1;
> -		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
> +		mwifiex_recycle_cmd_node(adapter, cmd_node);
>  		return -1;
>  	}
>  
> @@ -167,7 +167,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
>  			"DNLD_CMD: FW in reset state, ignore cmd %#x\n",
>  			cmd_code);
>  		mwifiex_complete_cmd(adapter, cmd_node);
> -		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
> +		mwifiex_recycle_cmd_node(adapter, cmd_node);
>  		return -1;
>  	}
>  
> @@ -228,7 +228,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
>  			adapter->cmd_sent = false;
>  		if (cmd_node->wait_q_enabled)
>  			adapter->cmd_wait_q.status = -1;
> -		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
> +		mwifiex_recycle_cmd_node(adapter, adapter->curr_cmd);
>  
>  		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
>  		adapter->curr_cmd = NULL;
> @@ -632,6 +632,20 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
>  	spin_unlock_irqrestore(&adapter->cmd_free_q_lock, flags);
>  }
>  
> +/* This function reuses a command node. */
> +void mwifiex_recycle_cmd_node(struct mwifiex_adapter *adapter,
> +			      struct cmd_ctrl_node *cmd_node)
> +{
> +	struct host_cmd_ds_command *host_cmd = (void *)cmd_node->cmd_skb->data;
> +
> +	mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
> +
> +	atomic_dec(&adapter->cmd_pending);
> +	dev_dbg(adapter->dev, "cmd: FREE_CMD: cmd=%#x, cmd_pending=%d\n",
> +		le16_to_cpu(host_cmd->command),
> +		atomic_read(&adapter->cmd_pending));
> +}
> +
>  /*
>   * This function queues a command to the command pending queue.
>   *
> @@ -673,7 +687,9 @@ mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
>  		list_add(&cmd_node->list, &adapter->cmd_pending_q);
>  	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
>  
> -	dev_dbg(adapter->dev, "cmd: QUEUE_CMD: cmd=%#x is queued\n", command);
> +	atomic_inc(&adapter->cmd_pending);
> +	dev_dbg(adapter->dev, "cmd: QUEUE_CMD: cmd=%#x, cmd_pending=%d\n",
> +		command, atomic_read(&adapter->cmd_pending));
>  }
>  
>  /*
> @@ -783,7 +799,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
>  	if (adapter->curr_cmd->cmd_flag & CMD_F_CANCELED) {
>  		dev_err(adapter->dev, "CMD_RESP: %#x been canceled\n",
>  			le16_to_cpu(resp->command));
> -		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
> +		mwifiex_recycle_cmd_node(adapter, adapter->curr_cmd);
>  		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
>  		adapter->curr_cmd = NULL;
>  		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
> @@ -833,7 +849,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
>  		if (adapter->curr_cmd->wait_q_enabled)
>  			adapter->cmd_wait_q.status = -1;
>  
> -		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
> +		mwifiex_recycle_cmd_node(adapter, adapter->curr_cmd);
>  		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
>  		adapter->curr_cmd = NULL;
>  		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
> @@ -865,8 +881,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
>  		if (adapter->curr_cmd->wait_q_enabled)
>  			adapter->cmd_wait_q.status = ret;
>  
> -		/* Clean up and put current command back to cmd_free_q */
> -		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
> +		mwifiex_recycle_cmd_node(adapter, adapter->curr_cmd);
>  
>  		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
>  		adapter->curr_cmd = NULL;
> @@ -993,7 +1008,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
>  			mwifiex_complete_cmd(adapter, cmd_node);
>  			cmd_node->wait_q_enabled = false;
>  		}
> -		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
> +		mwifiex_recycle_cmd_node(adapter, cmd_node);
>  		spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
>  	}
>  	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
> @@ -1040,7 +1055,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
>  		cmd_node = adapter->curr_cmd;
>  		cmd_node->wait_q_enabled = false;
>  		cmd_node->cmd_flag |= CMD_F_CANCELED;
> -		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
> +		mwifiex_recycle_cmd_node(adapter, cmd_node);
>  		mwifiex_complete_cmd(adapter, adapter->curr_cmd);
>  		adapter->curr_cmd = NULL;
>  		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
> diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
> index daf8801..003c014 100644
> --- a/drivers/net/wireless/mwifiex/init.c
> +++ b/drivers/net/wireless/mwifiex/init.c
> @@ -713,7 +713,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
>  	if (adapter->curr_cmd) {
>  		dev_warn(adapter->dev, "curr_cmd is still in processing\n");
>  		del_timer(&adapter->cmd_timer);
> -		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
> +		mwifiex_recycle_cmd_node(adapter, adapter->curr_cmd);
>  		adapter->curr_cmd = NULL;
>  	}
>  
> diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
> index cab8a85..fef89fd 100644
> --- a/drivers/net/wireless/mwifiex/main.h
> +++ b/drivers/net/wireless/mwifiex/main.h
> @@ -798,6 +798,8 @@ void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter);
>  
>  void mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
>  				  struct cmd_ctrl_node *cmd_node);
> +void mwifiex_recycle_cmd_node(struct mwifiex_adapter *adapter,
> +			      struct cmd_ctrl_node *cmd_node);
>  
>  void mwifiex_insert_cmd_to_pending_q(struct mwifiex_adapter *adapter,
>  				     struct cmd_ctrl_node *cmd_node,
> diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
> index c7dc450..9f990e1 100644
> --- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
> +++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
> @@ -95,7 +95,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
>  		break;
>  	}
>  	/* Handling errors here */
> -	mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
> +	mwifiex_recycle_cmd_node(adapter, adapter->curr_cmd);
>  
>  	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
>  	adapter->curr_cmd = NULL;
> diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
> index 8c943b6..e6c9b2a 100644
> --- a/drivers/net/wireless/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
> @@ -59,9 +59,6 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter,
>  {
>  	int status;
>  
> -	dev_dbg(adapter->dev, "cmd pending\n");
> -	atomic_inc(&adapter->cmd_pending);
> -
>  	/* Wait for completion */
>  	status = wait_event_interruptible(adapter->cmd_wait_q.wait,
>  					  *(cmd_queued->condition));
> diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
> index 54667e6..e57ac0d 100644
> --- a/drivers/net/wireless/mwifiex/util.c
> +++ b/drivers/net/wireless/mwifiex/util.c
> @@ -239,7 +239,6 @@ int mwifiex_recv_packet(struct mwifiex_private *priv, struct sk_buff *skb)
>  int mwifiex_complete_cmd(struct mwifiex_adapter *adapter,
>  			 struct cmd_ctrl_node *cmd_node)
>  {
> -	atomic_dec(&adapter->cmd_pending);
>  	dev_dbg(adapter->dev, "cmd completed: status=%d\n",
>  		adapter->cmd_wait_q.status);
>  
> -- 
> 1.7.0.2
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
