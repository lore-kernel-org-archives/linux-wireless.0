Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46695 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1BON1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 08:27:24 -0500
Received: by pwj3 with SMTP id 3so73106pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 05:27:24 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19802.32554.909253.235878@gargle.gargle.HOWL>
Date: Tue, 15 Feb 2011 18:57:06 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath9k htc bug?
In-Reply-To: <1297773308.3935.11.camel@jlt3.sipsolutions.net>
References: <1297773308.3935.11.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> This code in ath9k_ht_tx looks buggy:
> 
>         if (padsize && skb->len > padpos) {
>                 if (skb_headroom(skb) < padsize)
>                         return -1;
>                 skb_push(skb, padsize);
>                 memmove(skb->data, skb->data + padsize, padpos);
>         }
> 
> -1 isn't a valid netdev tx status code -- I think this should just be
> "goto fail_tx;" instead?

Yep, I have a fix lined up in my pending queue doing exactly that. :)

Sujith
