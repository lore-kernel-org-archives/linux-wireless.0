Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2315 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbaH2ENX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 00:13:23 -0400
From: Avinash Patil <patila@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Marc Yang <yangyang@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Date: Thu, 28 Aug 2014 21:13:06 -0700
Subject: RE: [PATCH 2/4] mwifiex: rework internal scan for association
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC47817B1F76@SC-VEXCH2.marvell.com> (sfid-20140829_061326_774097_282E1A91)
References: <CBACCFA0AEB13A41977475BCF3E896FC4781147C22@SC-VEXCH2.marvell.com>
 <20140828184143.GP13758@tuxdriver.com>
In-Reply-To: <20140828184143.GP13758@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Thanks for the information.
I will rebase these patches on top of 3.17rc2 and resend them.

Thanks,
Avinash

-----Original Message-----
From: John W. Linville [mailto:linville@tuxdriver.com] 
Sent: Friday, August 29, 2014 12:12 AM
To: Avinash Patil
Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo; Marc Yang; Xinming Hu
Subject: Re: [PATCH 2/4] mwifiex: rework internal scan for association

This one either, nor the rest in the series.

Please rebase as necessary and repost the series.  I'm dropping these patches.

John

On Mon, Aug 18, 2014 at 02:12:50AM -0700, Avinash Patil wrote:
> There was an issue with internal scan during association wherein we 
> would complete internal scan on first scan command response.
> This would cause association failure if AP is not found in first scan 
> response e.g. APs from A band.
> This patch fixes this issue by completing internal scan only when all 
> scan commands from scan pending queue and command pending queue are 
> sent to FW and response to last scan command is received.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Tested-by: Xinmin Hu <huxm@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/scan.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/scan.c 
> b/drivers/net/wireless/mwifiex/scan.c
> index dee717a..bec48cc 100644
> --- a/drivers/net/wireless/mwifiex/scan.c
> +++ b/drivers/net/wireless/mwifiex/scan.c
> @@ -1970,9 +1970,34 @@ int mwifiex_cmd_802_11_scan_ext(struct 
> mwifiex_private *priv,
>  /* This function handles the command response of extended scan */  
> int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv)  {
> +       struct mwifiex_adapter *adapter = priv->adapter;
> +       struct host_cmd_ds_command *cmd_ptr;
> +       struct cmd_ctrl_node *cmd_node;
> +       unsigned long cmd_flags, scan_flags;
> +       bool complete_scan = false;
> +
>         dev_dbg(priv->adapter->dev, "info: EXT scan returns 
> successfully\n");
> 
> -       mwifiex_complete_scan(priv);
> +       spin_lock_irqsave(&adapter->cmd_pending_q_lock, cmd_flags);
> +       spin_lock_irqsave(&adapter->scan_pending_q_lock, scan_flags);
> +       if (list_empty(&adapter->scan_pending_q)) {
> +               complete_scan = true;
> +               list_for_each_entry(cmd_node, &adapter->cmd_pending_q, list) {
> +                       cmd_ptr = (void *)cmd_node->cmd_skb->data;
> +                       if (le16_to_cpu(cmd_ptr->command) ==
> +                           HostCmd_CMD_802_11_SCAN_EXT) {
> +                               dev_dbg(priv->adapter->dev,
> +                                       "Scan pending in command pending list");
> +                               complete_scan = false;
> +                               break;
> +                       }
> +               }
> +       }
> +       spin_unlock_irqrestore(&adapter->scan_pending_q_lock, scan_flags);
> +       spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, 
> + cmd_flags);
> +
> +       if (complete_scan)
> +               mwifiex_complete_scan(priv);
> 
>         return 0;
>  }
> --
> 1.8.1.4
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
