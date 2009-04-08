Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41687 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbZDHOXP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 10:23:15 -0400
Subject: Re: [PATCH] libertas: don't leak skb on receive error
From: Dan Williams <dcbw@redhat.com>
To: Philip Rakity <prakity@yahoo.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	stable@kernel.org
In-Reply-To: <422915.71719.qm@web58908.mail.re1.yahoo.com>
References: <422915.71719.qm@web58908.mail.re1.yahoo.com>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 10:23:02 -0400
Message-Id: <1239200582.14879.5.camel@localhost.localdomain> (sfid-20090408_162318_171949_6627E1AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-04-07 at 12:41 -0700, Philip Rakity wrote:
> 
> Don't lead memory when receive errors 
> Signed-off-by: Philip Rakity <prakity@yahoo.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> --- linux-2.6.29/drivers/net/wireless/libertas/rx.c.old    2009-04-01 13:19:26.000000000 -0700
> +++ linux-2.6.29/drivers/net/wireless/libertas/rx.c    2009-04-01 13:19:57.000000000 -0700
> @@ -170,6 +170,7 @@
>          lbs_deb_rx("rx err: frame received with bad length\n");
>          priv->stats.rx_length_errors++;
>          ret = 0;
> +        dev_kfree_skb(skb);
>          goto done;
>      }
>  
> @@ -181,6 +182,7 @@
>          lbs_pr_alert("rxpd not ok\n");
>          priv->stats.rx_errors++;
>          ret = 0;
> +        dev_kfree_skb(skb);
>          goto done;
> 
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

