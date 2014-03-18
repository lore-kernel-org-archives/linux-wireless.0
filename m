Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:57029 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbaCRQ5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 12:57:06 -0400
Received: by mail-ie0-f180.google.com with SMTP id as1so7187707iec.25
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 09:57:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395150804-24090-9-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395150804-24090-9-git-send-email-michal.kazior@tieto.com>
Date: Tue, 18 Mar 2014 18:57:05 +0200
Message-ID: <CAB3XZEdq=m2oFggRLRaJiMto3q37SFPU2u4uk2LkDqYJ4vt0ow@mail.gmail.com> (sfid-20140318_175711_280575_6DB5B4EE)
Subject: Re: [RFC 08/21] mac80211: improve chanctx reservation lookup
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> Use a separate function to look for reservation
> chanctx. For multi-interface/channel reservation
> search sematics differ slightly.
>
> The new routine allows reservations to be merged
> with chanctx that are already reserved by other
> interface(s).
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> +static const struct cfg80211_chan_def *
> +ieee80211_chanctx_non_reserved_chandef(struct ieee80211_local *local,
> +                                      struct ieee80211_chanctx *ctx,
> +                                      const struct cfg80211_chan_def *compat)
> +{
> +       struct ieee80211_sub_if_data *sdata;
> +
> +       lockdep_assert_held(&local->chanctx_mtx);
> +
> +       list_for_each_entry(sdata, &ctx->assigned_vifs,
> +                           assigned_chanctx_list) {
> +               if (rcu_access_pointer(sdata->reserved_chanctx) != NULL)
> +                       continue;
this is not rcu pointer...

> +static const struct cfg80211_chan_def *
> +ieee80211_chanctx_combined_chandef(struct ieee80211_local *local,
> +                                  struct ieee80211_chanctx *ctx,
> +                                  const struct cfg80211_chan_def *compat)
> +{
> +       lockdep_assert_held(&local->chanctx_mtx);
> +
> +       compat = ieee80211_chanctx_reserved_chandef(local, ctx, compat);
> +       if (!compat)
> +               return NULL;
> +
> +       compat = ieee80211_chanctx_non_reserved_chandef(local, ctx, compat);
> +       if (!compat)
> +               return NULL;
> +
> +       return compat;
> +}
> +
> +static bool
> +ieee80211_chanctx_can_reserve_chandef(struct ieee80211_local *local,
> +                                     struct ieee80211_chanctx *ctx,
> +                                     const struct cfg80211_chan_def *def)
> +{
> +       lockdep_assert_held(&local->chanctx_mtx);
> +
> +       if (ieee80211_chanctx_combined_chandef(local, ctx, NULL) &&
> +           ieee80211_chanctx_combined_chandef(local, ctx, def))
> +               return true;
> +
what's the reason for calling it with NULL?

> +       if (!list_empty(&ctx->reserved_vifs) &&
> +           ieee80211_chanctx_reserved_chandef(local, ctx, NULL) &&
> +           ieee80211_chanctx_reserved_chandef(local, ctx, def))
> +               return true;
and this seems redundant as _combined_chandef() should already check for it?

Eliad.
