Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39091 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2ETK7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 May 2012 06:59:31 -0400
Received: by obbtb18 with SMTP id tb18so6543013obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 May 2012 03:59:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337342589-10617-6-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
	<1337342589-10617-6-git-send-email-michal.kazior@tieto.com>
Date: Sun, 20 May 2012 13:59:30 +0300
Message-ID: <CAB3XZEd=k7JjpvxYBQv1peDny7+Bax+7eBVuWfC4QpBFENpRDA@mail.gmail.com> (sfid-20120520_125935_731267_162348EC)
Subject: Re: [RFC 5/6] mac80211: refactor set_channel_type
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Michal,

On Fri, May 18, 2012 at 3:03 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> Split functionality for further reuse.
>
> Will prevent code duplication when channel context
> channel_type merging is introduced.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> -       switch (superchan) {
> +static bool
> +ieee80211_channel_types_are_compatible(enum nl80211_channel_type chantype1,
> +                                      enum nl80211_channel_type chantype2,
> +                                      enum nl80211_channel_type *compat)
> +{

you split superchan (in + out) into chantype1 (in) + compat (out)
here, but it looks a bit broken -

> +       switch (chantype1) {
>        case NL80211_CHAN_NO_HT:
>        case NL80211_CHAN_HT20:
>                /*
>                 * allow any change that doesn't go to no-HT
>                 * (if it already is no-HT no change is needed)
>                 */
> -               if (chantype == NL80211_CHAN_NO_HT)
> +               if (chantype2 == NL80211_CHAN_NO_HT)
>                        break;

you don't set compat here...

> +
> +bool ieee80211_set_channel_type(struct ieee80211_local *local,
> +                               struct ieee80211_sub_if_data *sdata,
> +                               enum nl80211_channel_type chantype)
> +{
> +       enum nl80211_channel_type superchan;
> +       enum nl80211_channel_type compatchan = NL80211_CHAN_NO_HT;
> +
> +       superchan = ieee80211_get_superchan(local, sdata);
> +       if (!ieee80211_channel_types_are_compatible(superchan, chantype,
> +                                                   &compatchan))
> +               return false;
> +
> +       local->_oper_channel_type = compatchan;
>
so when superchan=NL80211_CHAN_HT20, and chantype=NL80211_CHAN_NO_HT,
you'll end up with compatchan=NL80211_CHAN_NO_HT which is wrong.

Eliad.
