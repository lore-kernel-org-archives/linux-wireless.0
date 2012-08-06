Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61448 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2HFPWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 11:22:16 -0400
Received: by wgbdr13 with SMTP id dr13so2896041wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 08:22:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343387816-9414-21-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net> <1343387816-9414-21-git-send-email-johannes@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 6 Aug 2012 18:21:59 +0300
Message-ID: <CA+XVXfc2QZTrWnp07oQdfNi4LwyT76ibEYDycpL8Sj5aR=_odA@mail.gmail.com> (sfid-20120806_172220_210454_8ED22A1E)
Subject: Re: [RFC 20/20] mac80211: use channel contexts
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 27, 2012 at 2:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Instead of operating on a single channel only,
> use the new channel context infrastructure in
> all mac80211 code.
>
> This enables drivers that want to use the new
> channel context infrastructure to use multiple
> channels, while nothing should change for all
> the other drivers that don't support it.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[...]
>  static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
>                                          struct ieee80211_channel *chan,
>                                          enum nl80211_channel_type channel_type)
>  {
> -       return ieee80211_set_channel(wiphy, NULL, chan, channel_type);
> +       return 0;
> +//return ieee80211_set_channel(wiphy, NULL, chan, channel_type);

typo?

[...]
> @@ -1278,11 +1271,6 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
>         if (type == ieee80211_vif_type_p2p(&sdata->vif))
>                 return 0;
>
> -       /* Setting ad-hoc mode on non-IBSS channel is not supported. */
> -       if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
> -           type == NL80211_IFTYPE_ADHOC)
> -               return -EOPNOTSUPP;
> -
>         if (ieee80211_sdata_running(sdata)) {
>                 ret = ieee80211_runtime_change_iftype(sdata, type);
>                 if (ret)
> @@ -1294,9 +1282,6 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
>         }
>
>         /* reset some values that shouldn't be kept across type changes */
> -       sdata->vif.bss_conf.basic_rates =
> -               ieee80211_mandatory_rates(sdata->local,
> -                       sdata->local->oper_channel->band);

was this a bug? shouldn't be updated to use the channel context?

Arik
