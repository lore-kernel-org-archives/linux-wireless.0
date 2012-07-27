Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:51660 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab2G0LqX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:46:23 -0400
Message-ID: <50127F8D.9050602@tieto.com> (sfid-20120727_134627_920394_A4FF2E7F)
Date: Fri, 27 Jul 2012 13:46:21 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC 20/20] mac80211: use channel contexts
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net> <1343387816-9414-21-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1343387816-9414-21-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27/07/12 13:16, Johannes Berg wrote:
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index d062085..bf2bc19 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -26,7 +26,6 @@
>   #include "rate.h"
>
>   #define IEEE80211_SCAN_INTERVAL (2 * HZ)
> -#define IEEE80211_SCAN_INTERVAL_SLOW (15 * HZ)
>   #define IEEE80211_IBSS_JOIN_TIMEOUT (7 * HZ)
>
>   #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
> @@ -80,17 +79,15 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>
>          sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
>
> -       local->oper_channel = chan;
>          channel_type = ifibss->channel_type;
>          if (!cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
>                  channel_type = NL80211_CHAN_HT20;
> -       if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
> -               /* can only fail due to HT40+/- mismatch */
> -               channel_type = NL80211_CHAN_HT20;
> -               WARN_ON(!ieee80211_set_channel_type(local, sdata,
> -                                                   NL80211_CHAN_HT20));
> -       }
> -       ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> +
> +       ieee80211_vif_release_channel(sdata);
> +       ieee80211_vif_use_channel(sdata, chan, channel_type,
> +                                 ifibss->fixed_channel ?
> +                                       IEEE80211_CHANCTX_SHARED :
> +                                       IEEE80211_CHANCTX_EXCLUSIVE);

ieee80211_vif_use_channel() may fail. Can we just ignore it here?


-- Pozdrawiam / Best regards, Michal Kazior.
