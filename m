Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59597 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbaCRQmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 12:42:00 -0400
Received: by mail-ie0-f180.google.com with SMTP id as1so7427801iec.39
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 09:42:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395150804-24090-8-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395150804-24090-8-git-send-email-michal.kazior@tieto.com>
Date: Tue, 18 Mar 2014 18:42:00 +0200
Message-ID: <CAB3XZEern9n0HZtMui1nGZvsx0wOR_L1EbTJt5gR30VebWAizg@mail.gmail.com> (sfid-20140318_174205_812488_FC9BD45D)
Subject: Re: [RFC 07/21] mac80211: improve find_chanctx() for reservations
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> Relax ieee80211_find_chanctx(). If chanctx
> reservation chandef is compatible with
> current-future assigned interfaces chandef then
> allow it to be used by new interfaces.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> +static const struct cfg80211_chan_def *
> +ieee80211_chanctx_reserved_chandef(struct ieee80211_local *local,
> +                                  struct ieee80211_chanctx *ctx,
> +                                  const struct cfg80211_chan_def *compat)
> +{
> +       struct ieee80211_sub_if_data *sdata;
> +
> +       lockdep_assert_held(&local->chanctx_mtx);
> +
> +       list_for_each_entry(sdata, &ctx->reserved_vifs,
> +                           reserved_chanctx_list) {
> +               if (!compat)
> +                       compat = &sdata->reserved_chandef;
this check is redundant.

Eliad.
