Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:52063 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaCCMqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 07:46:44 -0500
Received: by mail-ee0-f52.google.com with SMTP id e49so718545eek.11
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2014 04:46:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393590200-25309-3-git-send-email-luca@coelho.fi>
References: <1393590200-25309-1-git-send-email-luca@coelho.fi>
	<1393590200-25309-3-git-send-email-luca@coelho.fi>
Date: Mon, 3 Mar 2014 13:46:42 +0100
Message-ID: <CA+BoTQm+X5F+fni+1+t7x773r3LYuT77yhxzwKWEWyJK-BA6Eg@mail.gmail.com> (sfid-20140303_134704_692300_823F0322)
Subject: Re: [PATCH v3 2/3] mac80211: implement chanctx reservation
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 February 2014 13:23, Luca Coelho <luca@coelho.fi> wrote:

[...]

> +int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
> +                                 const struct cfg80211_chan_def *chandef)
> +{
> +       struct ieee80211_local *local = sdata->local;
> +       struct ieee80211_chanctx_conf *conf;
> +       struct ieee80211_chanctx *new_ctx, *curr_ctx;
> +       int ret = 0;
> +
> +       mutex_lock(&local->chanctx_mtx);
> +
> +       conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
> +                                        lockdep_is_held(&local->chanctx_mtx));
> +       if (!conf) {
> +               ret = -EINVAL;
> +               goto out;
> +       }
> +
> +       curr_ctx = container_of(conf, struct ieee80211_chanctx, conf);
> +
> +       /* try to find another context with the chandef we want */
> +       new_ctx = ieee80211_find_chanctx(local, chandef,
> +                                        IEEE80211_CHANCTX_SHARED);

I find one thing puzzling -- why is ieee80211_find_chanctx() calling
ieee80211_change_chanctx()? I don't think it makes sense. I can't
understand why chanctx has two chandefs (isn't min_def enough
already?).


> +       /* TODO: we're assuming that the bandwidth of the context
> +        * changes here, but in fact, it will only change if the
> +        * combination of the channels used in this context change.
> +        * We should set this flag according to what happens when
> +        * ieee80211_recalc_chanctx_chantype() is called.  Maybe the
> +        * nicest thing to do would be to change that function so that
> +        * it returns changed flags (which will be either 0 or
> +        * BSS_CHANGED_BANDWIDTH).
> +        */

I don't understand this. Either I'm missing something here or we had a
misunderstanding earlier. It doesn't matter what chanctx width we end
up with. What's important is the BSS width here and it's readily
available to check & use.


> +
> +       if (sdata->vif.bss_conf.chandef.width != ctx->conf.def.width)
> +               local_changed |= BSS_CHANGED_BANDWIDTH;

This should use sdata->reserved_chandef.width instead of
ctx->conf.def.width, shouldn't it?


Michał
