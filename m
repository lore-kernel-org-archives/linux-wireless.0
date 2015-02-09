Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14741 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbbBIN0B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 08:26:01 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t19DNq7L027897
	for <linux-wireless@vger.kernel.org>; Mon, 9 Feb 2015 05:26:00 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1set0u0u12-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 05:26:00 -0800
From: Avinash Patil <patila@marvell.com>
To: Avinash Patil <patila@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Shengzhen Li <szli@marvell.com>
Date: Mon, 9 Feb 2015 05:25:57 -0800
Subject: RE: [PATCH 1/5] mwifiex: more_task flag for main_process
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC6674321B02@SC-VEXCH2.marvell.com> (sfid-20150209_142606_999396_EA5283BF)
References: <1423240906-12951-1-git-send-email-patila@marvell.com>
In-Reply-To: <1423240906-12951-1-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> -----Original Message-----
> From: Avinash Patil [mailto:patila@marvell.com]
> Sent: Friday, February 06, 2015 10:12 PM
> To: linux-wireless@vger.kernel.org
> Cc: Amitkumar Karwar; Cathy Luo; Marc Yang; Shengzhen Li; Avinash Patil
> Subject: [PATCH 1/5] mwifiex: more_task flag for main_process
> 
> This patch handles a corner case where TX packet would remain in driver queue
> till next packet comes in.
> Here is sequence:
> 1. TX packet is queued via hard_start_xmit and main_work is queued 2. SDIO
> interrupt comes in which directly call mwifiex_main_process.
> This starts executing main superloop.
> 3. Now work from step1 is scheduled but at first check itself it sees
> mwifiex_processing is set and exits.
> 4. Now if superloop from step2 has passed TX processing part of superloop this
> packet would remain in queue until next packet/command/SDIO interrupt arrives
> and queues main_work.
> 
> This patch fixes this corner case by defining more_task flag which is set when
> mwifiex_processing is found to be true. At end of superloop we again check if
> more_task flag is set and if set, execute superloop again.
> 
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/main.c | 16 +++++++++-------
> drivers/net/wireless/mwifiex/main.h |  1 +
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/main.c
> b/drivers/net/wireless/mwifiex/main.c
> index 7e74b4f..74488ab 100644
> --- a/drivers/net/wireless/mwifiex/main.c
> +++ b/drivers/net/wireless/mwifiex/main.c
> @@ -190,14 +190,16 @@ int mwifiex_main_process(struct mwifiex_adapter
> *adapter)
> 
>  	/* Check if already processing */
>  	if (adapter->mwifiex_processing) {
> +		adapter->more_task_flag = true;
>  		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
>  		goto exit_main_proc;
>  	} else {
>  		adapter->mwifiex_processing = true;
> -		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
>  	}
>  process_start:
>  	do {
> +		adapter->more_task_flag = false;
> +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
>  		if ((adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING) ||
>  		    (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY))
>  			break;
> @@ -238,6 +240,7 @@ process_start:
>  			adapter->pm_wakeup_fw_try = true;
>  			mod_timer(&adapter->wakeup_timer, jiffies + (HZ*3));
>  			adapter->if_ops.wakeup(adapter);
> +			spin_lock_irqsave(&adapter->main_proc_lock, flags);
>  			continue;
>  		}
> 
> @@ -295,8 +298,10 @@ process_start:
>  		if ((adapter->ps_state == PS_STATE_SLEEP) ||
>  		    (adapter->ps_state == PS_STATE_PRE_SLEEP) ||
>  		    (adapter->ps_state == PS_STATE_SLEEP_CFM) ||
> -		    adapter->tx_lock_flag)
> +		    adapter->tx_lock_flag){
> +			spin_lock_irqsave(&adapter->main_proc_lock, flags);
>  			continue;
> +		}
> 
>  		if (!adapter->cmd_sent && !adapter->curr_cmd) {
>  			if (mwifiex_exec_next_cmd(adapter) == -1) { @@ -330,15
> +335,12 @@ process_start:
>  			}
>  			break;
>  		}
> +		spin_lock_irqsave(&adapter->main_proc_lock, flags);
>  	} while (true);
> 
>  	spin_lock_irqsave(&adapter->main_proc_lock, flags);
> -	if (!adapter->delay_main_work &&
> -	    (adapter->int_status || IS_CARD_RX_RCVD(adapter))) {
> -		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> +	if (adapter->more_task_flag)
>  		goto process_start;
> -	}
> -
>  	adapter->mwifiex_processing = false;
>  	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> 
> diff --git a/drivers/net/wireless/mwifiex/main.h
> b/drivers/net/wireless/mwifiex/main.h
> index f0a6af1..2089a30 100644
> --- a/drivers/net/wireless/mwifiex/main.h
> +++ b/drivers/net/wireless/mwifiex/main.h
> @@ -774,6 +774,7 @@ struct mwifiex_adapter {
>  	/* spin lock for main process */
>  	spinlock_t main_proc_lock;
>  	u32 mwifiex_processing;
> +	u8 more_task_flag;
>  	u16 tx_buf_size;
>  	u16 curr_tx_buf_size;
>  	u32 ioport;
> --
> 1.8.1.4

Please drop this series as we are seeing issue with DMA alignment patch.
I will resend v2 after fixing this.

Thanks,
Avinash
