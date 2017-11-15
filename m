Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55904 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758004AbdKOOnI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 09:43:08 -0500
Message-ID: <1510756985.2030.33.camel@sipsolutions.net> (sfid-20171115_154404_864725_372236F3)
Subject: Re: [bug report] mac80211: fix VLAN handling with TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Nov 2017 15:43:05 +0100
In-Reply-To: <20171115122952.2rzx6kv2lycq5go5@mwanda> (sfid-20171115_133010_908764_213EBC40)
References: <20171115122952.2rzx6kv2lycq5go5@mwanda>
         (sfid-20171115_133010_908764_213EBC40)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> This is a semi-automatic email about new static checker warnings.
> 
> The patch 531682159092: "mac80211: fix VLAN handling with TXQs" from 
> Jun 22, 2017, leads to the following Smatch complaint:
> 
>     net/mac80211/tx.c:3529 ieee80211_tx_dequeue()
>      error: we previously assumed 'skb' could be null (see line 3511)

Thanks for the report.

> net/mac80211/tx.c
>   3500                                             tx.key, skb);
>   3501          } else {
>   3502                  if (invoke_tx_handlers_late(&tx))
>   3503                          goto begin;
>   3504  
>   3505                  skb = __skb_dequeue(&tx.skbs);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> The NULL skb would have to come from here.

Yeah - this can't actually be empty at this point, as far as I can
tell.

>   3511		if (skb && skb_has_frag_list(skb) &&
>                     ^^^
> Old code checks

So I guess this is just useless.

I can send a patch to remove this if the warning bothers you much, or
I'll defer until I get smatch updated and it starts bothering me ;-)

johannes
