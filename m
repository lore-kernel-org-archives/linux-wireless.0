Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64806 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854AbbGXLNz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 07:13:55 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH 4/4] mwifiex: simplify mwifiex_complete_cmd
Date: Fri, 24 Jul 2015 11:13:50 +0000
Message-ID: <bbe466740a444f61832ae7168f30db49@SC-EXCH04.marvell.com> (sfid-20150724_131357_848603_C8030F94)
References: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
 <1437117186-25243-5-git-send-email-afenkart@gmail.com>
In-Reply-To: <1437117186-25243-5-git-send-email-afenkart@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

> From: Andreas Fenkart [mailto:afenkart@gmail.com]
> Sent: Friday, July 17, 2015 12:43 PM
> To: linux-wireless@vger.kernel.org
> Cc: Amitkumar Karwar; Kalle Valo; Andreas Fenkart
> Subject: [PATCH 4/4] mwifiex: simplify mwifiex_complete_cmd
> 
> 600f5d909a54("mwifiex: cleanup ioctl wait queue and abstraction layer")
> introduced the wakeup_interruptible suppression in mwifiex_complete_cmd
> b1a47aa5e1e1("mwifiex: fix system hang issue in cmd timeout error case")
> then added wakup_interruptible to mwifiex_cmd_timeout_func the single
> place setting a status of ETIMEDOUT.
> Instead of doing extra work, using the standard call-chain will have the
> same effect:
> mwifiex_cancel_pending_ioctl
> -> mwifiex_recycle_cmd_node
> -> mwifiex_insert_cmd_to_free_q
> -> mwifiex_complete_cmd
> -> wake_up_interruptible
> 
> The difference is that previously the condition was not set to true, but
> that's probably just an oversight in b1a47aa5e1e1 and shouldn't have any
> consequence
> 
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> ---
>  drivers/net/wireless/mwifiex/cmdevt.c    |  1 -
>  drivers/net/wireless/mwifiex/sta_ioctl.c |  4 ++--
>  drivers/net/wireless/mwifiex/util.c      | 12 ++++--------
>  3 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/cmdevt.c
> b/drivers/net/wireless/mwifiex/cmdevt.c
> index 6458e17..27b778d 100644
> --- a/drivers/net/wireless/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/mwifiex/cmdevt.c
> @@ -976,7 +976,6 @@ mwifiex_cmd_timeout_func(unsigned long
> function_context)
> 
>  		if (cmd_node->wait_q_enabled) {
>  			adapter->cmd_wait_q.status = -ETIMEDOUT;
> -			wake_up_interruptible(&adapter->cmd_wait_q.wait);
>  			mwifiex_cancel_pending_ioctl(adapter);
>  		}
>  	}
> diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c
> b/drivers/net/wireless/mwifiex/sta_ioctl.c
> index d8b7d9c..a6c8a4f 100644
> --- a/drivers/net/wireless/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
> @@ -66,8 +66,8 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter
> *adapter,
>  	if (status <= 0) {
>  		if (status == 0)
>  			status = -ETIMEDOUT;
> -		mwifiex_dbg(adapter, ERROR,
> -			    "cmd_wait_q terminated: %d\n", status);
> +		mwifiex_dbg(adapter, ERROR, "cmd_wait_q terminated: %d\n",
> +			    status);
>  		mwifiex_cancel_all_pending_cmd(adapter);
>  		return status;
>  	}
> diff --git a/drivers/net/wireless/mwifiex/util.c
> b/drivers/net/wireless/mwifiex/util.c
> index 790e619..b65ef5b 100644
> --- a/drivers/net/wireless/mwifiex/util.c
> +++ b/drivers/net/wireless/mwifiex/util.c
> @@ -496,16 +496,12 @@ int mwifiex_recv_packet(struct mwifiex_private
> *priv, struct sk_buff *skb)  int mwifiex_complete_cmd(struct
> mwifiex_adapter *adapter,
>  			 struct cmd_ctrl_node *cmd_node)
>  {
> -	mwifiex_dbg(adapter, CMD,
> -		    "cmd completed: status=%d\n",
> +	WARN_ON(!cmd_node->wait_q_enabled);
> +	mwifiex_dbg(adapter, CMD, "cmd completed: status=%d\n",
>  		    adapter->cmd_wait_q.status);
> 
> -	*(cmd_node->condition) = true;
> -
> -	if (adapter->cmd_wait_q.status == -ETIMEDOUT)
> -		mwifiex_dbg(adapter, ERROR, "cmd timeout\n");
> -	else
> -		wake_up_interruptible(&adapter->cmd_wait_q.wait);
> +	*cmd_node->condition = true;
> +	wake_up_interruptible(&adapter->cmd_wait_q.wait);
> 
>  	return 0;
>  }
> --
> 2.1.4

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
