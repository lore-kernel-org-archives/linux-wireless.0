Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbYCDR1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 12:27:09 -0500
Subject: Re: [PATCH] [NET] libertas: compare the current command with
	response
From: Dan Williams <dcbw@redhat.com>
To: Sebastian Siewior <bigeasy@tglx.de>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20080304172227.GA14225@www.tglx.de>
References: <20080304172227.GA14225@www.tglx.de>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 12:23:10 -0500
Message-Id: <1204651390.30024.19.camel@localhost.localdomain> (sfid-20080304_172713_047843_4CDA7603)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-03-04 at 18:22 +0100, Sebastian Siewior wrote:
> instead of with itself.

Woodhouse already patched this, and Holger submitted woodhouse's patch.
So I think this is solved.

Dan

> Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
> ---
> Holger can please ACK/NACK this? According to my debug patch, it does
> the right thing.
> 
>  drivers/net/wireless/libertas/cmdresp.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
> index 159216a..013245b 100644
> --- a/drivers/net/wireless/libertas/cmdresp.c
> +++ b/drivers/net/wireless/libertas/cmdresp.c
> @@ -562,9 +562,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
>  	}
>  
>  	resp = (void *)priv->upld_buf;
> -
> -	curcmd = le16_to_cpu(resp->command);
> -
> +	curcmd = le16_to_cpu(priv->cur_cmd->cmdbuf->command);
>  	respcmd = le16_to_cpu(resp->command);
>  	result = le16_to_cpu(resp->result);
>  

