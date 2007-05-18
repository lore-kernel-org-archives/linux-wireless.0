Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3671 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbXERSCu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 14:02:50 -0400
Date: Fri, 18 May 2007 13:47:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Eugene Teo <eteo@redhat.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
	linux-wireless@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/wireless/libertas/fw.c: fix use-before-check
Message-ID: <20070518174721.GB3492@tuxdriver.com>
References: <464DDD29.3000009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <464DDD29.3000009@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should be sent to linux-wireless (and CC'ed to me) as well...

On Sat, May 19, 2007 at 01:06:49AM +0800, Eugene Teo wrote:
> NULL checks should be performed before the dereference.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Eugene Teo <eteo@redhat.com>
> 
> diff --git a/drivers/net/wireless/libertas/fw.c b/drivers/net/wireless/libertas/fw.c
> index 441123c..5c63c9b 100644
> --- a/drivers/net/wireless/libertas/fw.c
> +++ b/drivers/net/wireless/libertas/fw.c
> @@ -333,18 +333,22 @@ static void command_timer_fn(unsigned long data)
>         unsigned long flags;
> 
>         ptempnode = adapter->cur_cmd;
> +       if (ptempnode == NULL) {
> +               lbs_pr_debug(1, "PTempnode Empty\n");
> +               return;
> +       }
> +
>         cmd = (struct cmd_ds_command *)ptempnode->bufvirtualaddr;
> +       if (!cmd) {
> +               lbs_pr_debug(1, "cmd is NULL\n");
> +               return;
> +       }
> 
>         lbs_pr_info("command_timer_fn fired (%x)\n", cmd->command);
> 
>         if (!adapter->fw_ready)
>                 return;
> 
> -       if (ptempnode == NULL) {
> -               lbs_pr_debug(1, "PTempnode Empty\n");
> -               return;
> -       }
> -
>         spin_lock_irqsave(&adapter->driver_lock, flags);
>         adapter->cur_cmd = NULL;
>         spin_unlock_irqrestore(&adapter->driver_lock, flags);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
John W. Linville
linville@tuxdriver.com
