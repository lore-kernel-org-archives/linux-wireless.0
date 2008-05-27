Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019AbYE0UJB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 16:09:01 -0400
Subject: Re: [PATCH] libertas: before sleeping, check for a command result
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200805231604.13144.hs4233@mail.mn-solutions.de>
References: <200805231604.13144.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 27 May 2008 16:08:52 -0400
Message-Id: <1211918933.555.18.camel@localhost.localdomain> (sfid-20080527_220907_402651_882D1F1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-23 at 16:04 +0200, Holger Schurig wrote:
> If we don't check for a command response early, but rather sleep,
> then we might sleep despite an already-received command response.
> This will lead to a command-timeout.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-05-23 14:25:16.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-05-23 14:25:51.000000000 +0200
> @@ -722,14 +722,14 @@ static int lbs_thread(void *data)
>  			shouldsleep = 1;	/* Something is en route to the device already */
>  		else if (priv->tx_pending_len > 0)
>  			shouldsleep = 0;	/* We've a packet to send */
> +		else if (priv->resp_len[priv->resp_idx])
> +			shouldsleep = 0;	/* We have a command response */
>  		else if (priv->cur_cmd)
>  			shouldsleep = 1;	/* Can't send a command; one already running */
>  		else if (!list_empty(&priv->cmdpendingq))
>  			shouldsleep = 0;	/* We have a command to send */
>  		else if (__kfifo_len(priv->event_fifo))
>  			shouldsleep = 0;	/* We have an event to process */
> -		else if (priv->resp_len[priv->resp_idx])
> -			shouldsleep = 0;	/* We have a command response */
>  		else
>  			shouldsleep = 1;	/* No command */
>  

