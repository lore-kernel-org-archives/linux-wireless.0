Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32169 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221Ab1JEMAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 08:00:00 -0400
Date: Wed, 5 Oct 2011 14:57:38 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: ath6kl: pass only unicast frames for aggregation
Message-ID: <20111005115738.GA7368@jouni.qca.qualcomm.com> (sfid-20111005_140005_375816_F350CDF9)
References: <20111005055958.GA32513@elgon.mountain>
 <4E8C2CF1.7000206@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E8C2CF1.7000206@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 05, 2011 at 01:09:53PM +0300, Kalle Valo wrote:
> Good catch, thanks! I should run smatch more, it's a really nice tool.

This could have actually been found even before
5694f962964c5162f6b49ddb5d517180bd7d1d98 with more thorough static
analysis since an A-MSDU sent to ath6kl AP would have hit the NULL
pointer dereference in aggr_slice_amsdu().. Anyway, this new commit does
indeed seem to make this much more likely to hit the issue (any data
frame between two associated STAs).

> I think a fix like this would be appropriate. Jouni, what do you think?

> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
> @@ -1247,6 +1247,10 @@ void ath6kl_rx(struct htc_target *target, struct
> htc_packet *packet)
>                 }
>                 if (skb1)
>                         ath6kl_data_tx(skb1, ar->net_dev);
> +
> +               if (skb == NULL)
> +                       /* nothing to deliver up the stack */
> +                       return;
>         }
> 
>         datap = (struct ethhdr *) skb->data;


This looks like the correct behavior here. However, I would recommend
using braces around any multi-line conditional statement even if it
really is a comment and a single statement that would not, in theory,
require this in C language. Leaving those out here seems to be just
asking for problems should someone add something before the "return;"
line and not notice to add braces at that point. The same comment would
actually apply for the commit 5694f962964c5162f6b49ddb5d517180bd7d1d98,
too. If you want to avoid the extra line an braces, moving the comment
to the end of the return line would work for me.

-- 
Jouni Malinen                                            PGP id EFC895FA
