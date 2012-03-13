Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52019 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab2CMPH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 11:07:57 -0400
Received: by iagz16 with SMTP id z16so885664iag.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2012 08:07:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120313144736.7DC272046A@glenhelen.mtv.corp.google.com>
References: <20120313144736.7DC272046A@glenhelen.mtv.corp.google.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 13 Mar 2012 08:07:36 -0700
Message-ID: <CAB=NE6VOgOdk=ThMq+H_nGkJoG40hiakQHQue+gy0GzNz1UaFw@mail.gmail.com> (sfid-20120313_160800_124861_2C6BAF47)
Subject: Re: [PATCH RESEND] mac80211: Don't let regulatory make us deaf
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org, sleffler@chromium.org,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2012 at 7:46 AM, Paul Stewart <pstew@chromium.org> wrote:
> When regulatory information changes our HT behavior (e.g,
> when we get a country code from the AP we have just associated
> with), we should use this information to change the power with
> which we transmit, and what channels we transmit.  Sometimes
> the channel parameters we derive from regulatory information
> contradicts the parameters we used in association.  For example,
> we could have associated specifying HT40, but the regulatory
> rules we apply may forbid HT40 operation.
>
> In the situation above, we should reconfigure ourselves to
> transmit in HT20 only, however it makes no sense for us to
> disable receive in HT40, since if we associated with these
> parameters, the AP has every reason to expect we can and
> will receive packets this way.  The code in mac80211 does
> not have the capability of sending the appropriate action
> frames to signal a change in HT behaviour so the AP has
> no clue we can no longer receive frames encoded this way.
> In some broken AP implementations, this can leave us
> effectively deaf if the AP never retries in lower HT rates.
>
> This change breaks up the channel_type parameter in the
> ieee80211_enable_ht function into a separate receive and
> transmit part.  It honors the channel flags set by regulatory
> in order to configure the rate control algorithm, but uses
> the capability flags to configure the channel on the radio,
> since these were used in association to set the AP's transmit
> rate.
>
> Signed-off-by: Paul Stewart <pstew@chromium.org>
> Cc: Sam Leffler <sleffler@chromium.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Luis R Rodriguez <mcgrof@frijolero.org>

Thanks for all your hard work on this. This makes this even more readable too.

Reviewed-by: Luis R Rodriguez <mcgrof@frijolero.org>

One small comment below.

> @@ -134,3 +135,29 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
>
>        return result;
>  }
> +
> +/*
> + * ieee80211_get_tx_channel_type returns the channel type we should
> + * use for packet transmission, given the channel capability and
> + * whatever regulatory flags we have been given.
> + */
> +enum nl80211_channel_type ieee80211_get_tx_channel_type(
> +                               struct ieee80211_local *local,
> +                               enum nl80211_channel_type channel_type)
> +{
> +       switch (channel_type) {
> +       case NL80211_CHAN_HT40PLUS:
> +               if (local->hw.conf.channel->flags &
> +                               IEEE80211_CHAN_NO_HT40PLUS)
> +                       return NL80211_CHAN_HT20;
> +               break;
> +       case NL80211_CHAN_HT40MINUS:
> +               if (local->hw.conf.channel->flags &
> +                               IEEE80211_CHAN_NO_HT40MINUS)
> +                       return NL80211_CHAN_HT20;
> +               break;

You could just do this instead for less code:

+       switch (channel_type) {
+       case NL80211_CHAN_HT40PLUS:
+       case NL80211_CHAN_HT40MINUS:
+               if (local->hw.conf.channel->flags &
+                               IEEE80211_CHAN_NO_HT40PLUS)
+                       return NL80211_CHAN_HT20;
+               break;

This will also get a lot funner with VHT, can't wait :)

  Luis
