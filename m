Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:1996 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751702AbYBOKQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 05:16:13 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: DS params only in 2GHz band?
Date: Fri, 15 Feb 2008 19:16:07 +0900
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802151916.07629.bruno@thinktube.com> (sfid-20080215_101627_793671_DF5990DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello johannes!

in your commit e1251b1d3c0e12a481c4c6b3ef60dfdf0f6be8c1:
> @@ -2945,10 +2968,12 @@ static int ieee80211_sta_join_ibss(struct
> net_device *dev, *pos++ = rates;
>                 memcpy(pos, bss->supp_rates, rates);
>
> -               pos = skb_put(skb, 2 + 1);
> -               *pos++ = WLAN_EID_DS_PARAMS;
> -               *pos++ = 1;
> -               *pos++ = bss->channel;
> +               if (bss->band == IEEE80211_BAND_2GHZ) {
> +                       pos = skb_put(skb, 2 + 1);
> +                       *pos++ = WLAN_EID_DS_PARAMS;
> +                       *pos++ = 1;
> +                       *pos++ = ieee80211_frequency_to_channel(bss->freq);
> +               }
>
>                 pos = skb_put(skb, 2 + 2);
>                 *pos++ = WLAN_EID_IBSS_PARAMS;

what's the reason you changed the beacons to include DS params only in the 
2GHz band?

thanks,
bruno
