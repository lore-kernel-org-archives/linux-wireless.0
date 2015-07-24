Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5349 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846AbbGXLMQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 07:12:16 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH 1/4] mwifiex: remove explicit mwifiex_complete_cmd calls
Date: Fri, 24 Jul 2015 11:12:10 +0000
Message-ID: <758ab3b3a6f344d1abeda85b6d230823@SC-EXCH04.marvell.com> (sfid-20150724_131219_869444_C05BF964)
References: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
 <1437117186-25243-2-git-send-email-afenkart@gmail.com>
In-Reply-To: <1437117186-25243-2-git-send-email-afenkart@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

> From: Andreas Fenkart [mailto:afenkart@gmail.com]
> Sent: Friday, July 17, 2015 12:43 PM
> To: linux-wireless@vger.kernel.org
> Cc: Amitkumar Karwar; Kalle Valo; Andreas Fenkart
> Subject: [PATCH 1/4] mwifiex: remove explicit mwifiex_complete_cmd calls
> 
> standard call chain when releasing a cmd node:
> mwifiex_recycle_cmd_node
> -> mwifiex_insert_cmd_to_free_q
> -> mwifiex_complete_cmd, if wait_q_enabled
> 
> calling mwifiex_complete_cmd explicitly and setting wait_q_enabled =
> false is redundant
> 
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> ---
>  drivers/net/wireless/mwifiex/cmdevt.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/cmdevt.c
> b/drivers/net/wireless/mwifiex/cmdevt.c
> index 207da40..2f4715e 100644
> --- a/drivers/net/wireless/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/mwifiex/cmdevt.c
> @@ -167,8 +167,6 @@ static int mwifiex_dnld_cmd_to_fw(struct
> mwifiex_private *priv,
>  		mwifiex_dbg(adapter, ERROR,
>  			    "DNLD_CMD: FW in reset state, ignore cmd %#x\n",
>  			cmd_code);
> -		if (cmd_node->wait_q_enabled)
> -			mwifiex_complete_cmd(adapter, cmd_node);
>  		mwifiex_recycle_cmd_node(adapter, cmd_node);
>  		queue_work(adapter->workqueue, &adapter->main_work);
>  		return -1;
> @@ -1024,6 +1022,7 @@ mwifiex_cancel_all_pending_cmd(struct
> mwifiex_adapter *adapter)
>  		adapter->curr_cmd->wait_q_enabled = false;
>  		adapter->cmd_wait_q.status = -1;
>  		mwifiex_complete_cmd(adapter, adapter->curr_cmd);
> +		/* no recycle probably wait for response */
>  	}
>  	/* Cancel all pending command */
>  	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags); @@ -
> 1032,11 +1031,8 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter
> *adapter)
>  		list_del(&cmd_node->list);
>  		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
> 
> -		if (cmd_node->wait_q_enabled) {
> +		if (cmd_node->wait_q_enabled)
>  			adapter->cmd_wait_q.status = -1;
> -			mwifiex_complete_cmd(adapter, cmd_node);
> -			cmd_node->wait_q_enabled = false;
> -		}
>  		mwifiex_recycle_cmd_node(adapter, cmd_node);
>  		spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
>  	}
> @@ -1094,10 +1090,8 @@ mwifiex_cancel_pending_ioctl(struct
> mwifiex_adapter *adapter)
>  	    (adapter->curr_cmd->wait_q_enabled)) {
>  		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
>  		cmd_node = adapter->curr_cmd;
> -		cmd_node->wait_q_enabled = false;
>  		cmd_node->cmd_flag |= CMD_F_CANCELED;
>  		mwifiex_recycle_cmd_node(adapter, cmd_node);
> -		mwifiex_complete_cmd(adapter, adapter->curr_cmd);
>  		adapter->curr_cmd = NULL;
>  		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock,
> cmd_flags);
>  	}
> --
> 2.1.4

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
