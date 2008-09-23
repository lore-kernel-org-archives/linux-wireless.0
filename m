Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:26026 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYIWTFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 15:05:40 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2209095fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2008 12:05:38 -0700 (PDT)
Message-ID: <1ba2fa240809231205x7bf0000ci7ad307a54497bed4@mail.gmail.com> (sfid-20080923_210544_917610_9CD0802E)
Date: Tue, 23 Sep 2008 22:05:38 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] iwlagn: downgrade BUG_ON in interrupt
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1222190323.18015.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222190062.18015.34.camel@johannes.berg>
	 <1222190323.18015.36.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 23, 2008 at 8:18 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> This BUG_ON really shouldn't trigger, but if it does, as on my machine,
> it leaves you wondering what happened because you won't see it. Let's
> instead leak a bit of state and memory and at least make it possible to
> report it to the kerneloops project to track it.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-tx.c 2008-09-23 13:00:01.096489715 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-tx.c      2008-09-23 19:07:14.107323109 +0200
> @@ -1200,10 +1200,9 @@ void iwl_tx_cmd_complete(struct iwl_priv
>        /* If a Tx command is being handled and it isn't in the actual
>         * command queue then there a command routing bug has been introduced
>         * in the queue management code. */
> -       if (txq_id != IWL_CMD_QUEUE_NUM)
> -               IWL_ERROR("Error wrong command queue %d command id 0x%X\n",
> -                         txq_id, pkt->hdr.cmd);
> -       BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
> +       if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
> +                "wrong command queue %d, command id 0x%X\n", txq_id, pkt->hdr.cmd))
> +               return;
>
>        cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
>        cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
>
>
>

Find with me
Tomas
