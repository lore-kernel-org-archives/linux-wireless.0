Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45124 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaCIJkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 05:40:25 -0400
Received: by mail-ie0-f173.google.com with SMTP id rl12so6093315iec.4
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2014 01:40:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
Date: Sun, 9 Mar 2014 11:40:25 +0200
Message-ID: <CAB3XZEek76hKh_5nqOs66DgFHT9iki17rZD8EqJnccQty4FdeQ@mail.gmail.com> (sfid-20140309_104051_368560_079D19B1)
Subject: Re: [PATCH 1/3] mac80211: fix racy usage of chanctx->refcount
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 7, 2014 at 1:19 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> Channel context refcount is protected by
> chanctx_mtx. Accessing the value without holding
> the mutex is racy. RCU section didn't guarantee
> anything here.
>
> Theoretically ieee80211_channel_switch() could
> fail to see refcount change and read "1" instead
> of, e.g. "2". This means mac80211 could accept CSA
> even though it shouldn't have.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> @@ -3233,23 +3233,23 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
>                                        &sdata->vif.bss_conf.chandef))
>                 return -EINVAL;
>
> -       rcu_read_lock();
> +       mutex_lock(&local->chanctx_mtx);
>         chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
this should probably be rcu_dereference_protected now?

Eliad.
