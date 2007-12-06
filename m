Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbXLFLK7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 06:10:59 -0500
Subject: Re: [PATCH] libertas: don't cast a pointer to pointer of
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200712061154.46070.hs4233@mail.mn-solutions.de>
References: <200712061154.46070.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 06:05:34 -0500
Message-Id: <1196939134.3980.25.camel@localhost.localdomain> (sfid-20071206_111106_135495_8AAACE6F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-12-06 at 11:54 +0100, Holger Schurig wrote:
> Don't cast struct foo * to struct list_head *, it's safe only when
> the list member is the first member of struct foo.
> 
> Also don't cast struct list_head * to struct foo *.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Haven't tested it, but this looks like the right thing to do.  I'll
probably step all over Woodhouse's command rework though.

Dan

> 
> Index: wireless-2.6/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/cmd.c	2007-12-06 12:47:21.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/cmd.c	2007-12-06 12:54:47.000000000 +0100
> @@ -1016,11 +1016,10 @@ void lbs_queue_cmd(struct lbs_adapter *a
>  	spin_lock_irqsave(&adapter->driver_lock, flags);
>  
>  	if (addtail) {
> -		list_add_tail((struct list_head *)cmdnode,
> -			      &adapter->cmdpendingq);
> +		list_add_tail(&cmdnode->list, &adapter->cmdpendingq);
>  		adapter->nr_cmd_pending++;
>  	} else
> -		list_add((struct list_head *)cmdnode, &adapter->cmdpendingq);
> +		list_add(&cmdnode->list, &adapter->cmdpendingq);
>  
>  	spin_unlock_irqrestore(&adapter->driver_lock, flags);
>  
> @@ -1139,7 +1138,7 @@ void __lbs_cleanup_and_insert_cmd(struct
>  		return;
>  
>  	cleanup_cmdnode(ptempcmd);
> -	list_add_tail((struct list_head *)ptempcmd, &adapter->cmdfreeq);
> +	list_add_tail(&ptempcmd->list, &adapter->cmdfreeq);
>  }
>  
>  static void lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
> @@ -1637,8 +1636,9 @@ struct cmd_ctrl_node *lbs_get_free_cmd_c
>  	spin_lock_irqsave(&adapter->driver_lock, flags);
>  
>  	if (!list_empty(&adapter->cmdfreeq)) {
> -		tempnode = (struct cmd_ctrl_node *)adapter->cmdfreeq.next;
> -		list_del((struct list_head *)tempnode);
> +		tempnode = list_first_entry(&adapter->cmdfreeq,
> +					    struct cmd_ctrl_node, list);
> +		list_del(&tempnode->list);
>  	} else {
>  		lbs_deb_host("GET_CMD_NODE: cmd_ctrl_node is not available\n");
>  		tempnode = NULL;
> @@ -1735,8 +1735,8 @@ int lbs_execute_next_command(struct lbs_
>  	}
>  
>  	if (!list_empty(&adapter->cmdpendingq)) {
> -		cmdnode = (struct cmd_ctrl_node *)
> -		    adapter->cmdpendingq.next;
> +		cmdnode = list_first_entry(&adapter->cmdpendingq,
> +					   struct cmd_ctrl_node, list);
>  	}
>  
>  	spin_unlock_irqrestore(&adapter->driver_lock, flags);
> @@ -1800,7 +1800,7 @@ int lbs_execute_next_command(struct lbs_
>  				    cpu_to_le16(CMD_SUBCMD_EXIT_PS)) {
>  					lbs_deb_host(
>  					       "EXEC_NEXT_CMD: ignore ENTER_PS cmd\n");
> -					list_del((struct list_head *)cmdnode);
> +					list_del(&cmdnode->list);
>  					lbs_cleanup_and_insert_cmd(priv, cmdnode);
>  
>  					ret = 0;
> @@ -1811,7 +1811,7 @@ int lbs_execute_next_command(struct lbs_
>  				    (adapter->psstate == PS_STATE_PRE_SLEEP)) {
>  					lbs_deb_host(
>  					       "EXEC_NEXT_CMD: ignore EXIT_PS cmd in sleep\n");
> -					list_del((struct list_head *)cmdnode);
> +					list_del(&cmdnode->list);
>  					lbs_cleanup_and_insert_cmd(priv, cmdnode);
>  					adapter->needtowakeup = 1;
>  
> @@ -1823,7 +1823,7 @@ int lbs_execute_next_command(struct lbs_
>  				       "EXEC_NEXT_CMD: sending EXIT_PS\n");
>  			}
>  		}
> -		list_del((struct list_head *)cmdnode);
> +		list_del(&cmdnode->list);
>  		lbs_deb_host("EXEC_NEXT_CMD: sending command 0x%04x\n",
>  			    le16_to_cpu(cmdptr->command));
>  		DownloadcommandToStation(priv, cmdnode);

