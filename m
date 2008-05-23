Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbYEWNkL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 09:40:11 -0400
Subject: Re: [PATCH] libertas: don't spin_unlock_irq() twice
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200805231007.56665.hs4233@mail.mn-solutions.de>
References: <200805231007.56665.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 23 May 2008 09:40:04 -0400
Message-Id: <1211550004.31559.0.camel@localhost.localdomain> (sfid-20080523_154015_748199_0D80495B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-23 at 10:07 +0200, Holger Schurig wrote:
> priv->driver_lock has already been unlocked some lines above. This patch
> fixes the sparse warning:
> 
> drivers/net/wireless/libertas/main.c:792:6: warning: context problem in 'lbs_thread': '_spin_unlock_irq' expected different context
> drivers/net/wireless/libertas/main.c:792:6:    context 'lock': wanted >= 1, got 0
> 
> Signed-of-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-05-23 08:43:05.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-05-23 08:43:22.000000000 +0200
> @@ -788,11 +788,8 @@ static int lbs_thread(void *data)
>  					le16_to_cpu(cmdnode->cmdbuf->command));
>  				lbs_complete_command(priv, cmdnode, -ETIMEDOUT);
>  				priv->nr_retries = 0;
> -				if (priv->reset_card) {
> -					spin_unlock_irq(&priv->driver_lock);
> +				if (priv->reset_card)
>  					priv->reset_card(priv);
> -					spin_lock_irq(&priv->driver_lock);
> -				}
>  			} else {
>  				priv->cur_cmd = NULL;
>  				priv->dnld_sent = DNLD_RES_RECEIVED;

