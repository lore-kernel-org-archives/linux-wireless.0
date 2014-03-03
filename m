Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:44208 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbaCCLyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 06:54:07 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so4361198eae.23
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2014 03:54:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393590200-25309-3-git-send-email-luca@coelho.fi>
References: <1393590200-25309-1-git-send-email-luca@coelho.fi>
	<1393590200-25309-3-git-send-email-luca@coelho.fi>
Date: Mon, 3 Mar 2014 12:54:06 +0100
Message-ID: <CA+BoTQnXUzJWfe3yoVoLDB=dSvZUsuCEVoX1UFk8KOBxzZr=6Q@mail.gmail.com> (sfid-20140303_125438_244175_43E6F7AA)
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
> +       if (!new_ctx) {
> +               /* create a new context */
> +               new_ctx = ieee80211_new_chanctx(local, chandef,
> +                                               IEEE80211_CHANCTX_SHARED);

Shouldn't you use curr_ctx->mode here instead of SHARED? Or perhaps
the function should take `mode` argument..

For CSA it's probably okay to just use curr_ctx->mode, but for a more
generic reservation it should probably be an argument.


Michał
