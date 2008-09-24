Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53195 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbYIXBbV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 21:31:21 -0400
Subject: Re: [PATCH v2] iwlagn: downgrade BUG_ON in interrupt
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1222190323.18015.36.camel@johannes.berg>
References: <1222190062.18015.34.camel@johannes.berg>
	 (sfid-20080923_191515_468904_B9897FB7)  <1222190323.18015.36.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 09:30:36 +0800
Message-Id: <1222219836.2510.342.camel@debian.sh.intel.com> (sfid-20080924_033125_312475_DED78F5A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-23 at 11:18 -0600, Johannes Berg wrote:
> This BUG_ON really shouldn't trigger, but if it does, as on my machine,
> it leaves you wondering what happened because you won't see it. Let's
> instead leak a bit of state and memory and at least make it possible to
> report it to the kerneloops project to track it.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Ack for 2.6.27. We are also working on for the root cause btw.

Thanks,
-yi

> ---
> 
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-tx.c 2008-09-23 13:00:01.096489715 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-tx.c      2008-09-23 19:07:14.107323109 +0200
> @@ -1200,10 +1200,9 @@ void iwl_tx_cmd_complete(struct iwl_priv
>         /* If a Tx command is being handled and it isn't in the actual
>          * command queue then there a command routing bug has been introduced
>          * in the queue management code. */
> -       if (txq_id != IWL_CMD_QUEUE_NUM)
> -               IWL_ERROR("Error wrong command queue %d command id 0x%X\n",
> -                         txq_id, pkt->hdr.cmd);
> -       BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
> +       if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
> +                "wrong command queue %d, command id 0x%X\n", txq_id, pkt->hdr.cmd))
> +               return;
> 
>         cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
>         cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

