Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36559 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752040AbdDJViE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 17:38:04 -0400
Received: by mail-wm0-f44.google.com with SMTP id o81so49182389wmb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 14:38:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1896493.H38pOMoCHn@debian64>
References: <1491801800-4371-1-git-send-email-mhjungk@gmail.com>
 <3716717.OUypxXNBrR@debian64> <20170410205414.GB12557@fqdn.specialj.com> <1896493.H38pOMoCHn@debian64>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 10 Apr 2017 14:38:02 -0700
Message-ID: <CANn89iK+DciFiUwPjQv5SSj_wp+CjiPtG5GO8bBKkkyrqDrNxg@mail.gmail.com> (sfid-20170410_233817_713297_080FC082)
Subject: Re: [PATCH] p54: add null pointer check before releasing socket buffer
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Myungho Jung <mhjungk@gmail.com>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@redhat.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 10, 2017 at 2:22 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:

> Well, the patch could be as simple as this:
> ---
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 7869ae3837ca..44f7d5a1c67c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2450,6 +2450,9 @@ void __dev_kfree_skb_irq(struct sk_buff *skb, enum skb_free_reason reason)
>  {
>         unsigned long flags;
>
> +       if (!skb)
> +               return;
> +
>         if (likely(atomic_read(&skb->users) == 1)) {
>                 smp_rmb();
>                 atomic_set(&skb->users, 0);
> ---
>
> The question is: would David or Eric support the change. Any comments,
> what's the prefered solution? Just patch __dev_kfree_skb_irq to make
> it consistent with *kfree*, or patch the driver? I'm fine either way,
> but I would prefere patching __dev_kfree_skb_irq.

This is fine, same check happens in consume_skb()
