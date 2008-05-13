Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721AbYEMQX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 12:23:59 -0400
Subject: Re: libertas: fix command timeout after firmware failure
From: Dan Williams <dcbw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org,
	Brian Cavagnolo <brian@cozybit.com>,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1210683299.3582.240.camel@pmac.infradead.org>
References: <1210683299.3582.240.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Tue, 13 May 2008 12:19:28 -0400
Message-Id: <1210695568.9976.3.camel@localhost.localdomain> (sfid-20080513_182409_154305_C2803F27)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-13 at 13:54 +0100, David Woodhouse wrote:
> From: Brian Cavagnolo <brian@cozybit.com>
> 
> This is a fix for OLPC ticket #6586: "SCAN command fails, timer doesn't
> fire". In fact, the timer was firing; the problem was that the dnld_sent
> state variable was not being updated after the timer expired, so
> lbs_execute_next_command was not being called.
> 
> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> 
> ---
> Bug fix, for 2.6.26 please.
> 
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -756,6 +756,7 @@ static int lbs_thread(void *data)
>  				priv->nr_retries = 0;
>  			} else {
>  				priv->cur_cmd = NULL;
> +				priv->dnld_sent = DNLD_RES_RECEIVED;
>  				lbs_pr_info("requeueing command %x due to timeout (#%d)\n",
>  					    le16_to_cpu(cmdnode->cmdbuf->command), priv->nr_retries);

We really need to kill dnld_sent.

Dan


