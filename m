Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:50066 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab2FZOE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 10:04:56 -0400
Received: by yhnn12 with SMTP id n12so4499067yhn.10
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 07:04:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340714242-20032-7-git-send-email-michal.kazior@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
	<1340714242-20032-7-git-send-email-michal.kazior@tieto.com>
Date: Tue, 26 Jun 2012 17:04:55 +0300
Message-ID: <CAB3XZEcua0xvBnNR7OsmaTTayad8hj7CSaTRSKbex7M_DV8iHg@mail.gmail.com> (sfid-20120626_160459_724741_AA3F7D47)
Subject: Re: [RFC v3 6/7] mac80211: refactor set_channel_type
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Michal,

On Tue, Jun 26, 2012 at 3:37 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> From: Kazior Michal <Michal.Kazior@tieto.com>
>
> Split functionality for further reuse.
>
> Will prevent code duplication when channel context
> channel_type merging is introduced.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> +static bool
> +ieee80211_channel_types_are_compatible(enum nl80211_channel_type chantype1,
> +                                      enum nl80211_channel_type chantype2,
> +                                      enum nl80211_channel_type *compat)
> +{
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
> -               superchan = chantype;
> +               *compat = chantype2;
>                break;
>        case NL80211_CHAN_HT40PLUS:
>        case NL80211_CHAN_HT40MINUS:
> +               *compat = chantype1;

this should be outside of switch, as it applies to the first cases as
well (chantype1=ht20, chantype2=no_ht will return the original *compat
value (no_ht) instead of ht20).

Eliad.
