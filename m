Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44821 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaCIJry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 05:47:54 -0400
Received: by mail-ie0-f176.google.com with SMTP id rd18so6132693iec.21
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2014 01:47:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1394191196-6425-3-git-send-email-michal.kazior@tieto.com>
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
	<1394191196-6425-3-git-send-email-michal.kazior@tieto.com>
Date: Sun, 9 Mar 2014 11:47:53 +0200
Message-ID: <CAB3XZEfEk72og-WkfYOyfExaC8iAxMo44japLu39Zrk5JNwi7g@mail.gmail.com> (sfid-20140309_104822_608105_75F493B3)
Subject: Re: [PATCH 3/3] mac80211: compute chanctx refcount dynamically
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 7, 2014 at 1:19 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> It doesn't make much sense to have a manually
> managed chanctx refcount. It isn't performance
> critical and it can't be even used outside the
> protection of chanctx_mtx.
>
> With future enhancements to channel contenxt
> (namely reservations) refcount accounting will
> become more complex and having manually managed
> refcount is going to be error-prone and confusing.
>
> The refcount is now equal to the number of vifs it
> is assigned to. However in the future this will
> change so keep the refcount/num_assigned_vifs
> functions split now.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> +int ieee80211_chanctx_num_assigned_vifs(struct ieee80211_chanctx *ctx)
> +{
> +       struct ieee80211_local *local = ctx->local;
> +       struct ieee80211_sub_if_data *sdata;
> +       int num = 0;
> +
> +       lockdep_assert_held(&local->chanctx_mtx);
> +
> +       rcu_read_lock();
> +       list_for_each_entry_rcu(sdata, &local->interfaces, list)
> +               if (ieee80211_vif_assigned_chanctx(sdata) == ctx)
> +                       num++;
> +       rcu_read_unlock();

i don't think you need rcu_read_lock if you already hold chanctx_mtx

Eliad.
