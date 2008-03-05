Return-path: <linux-wireless-owner@vger.kernel.org>
Subject: [Fwd: Re: hostapd with mac80211 progress]
From: Zhu Yi <yi.zhu@intel.com>
To: Jouni Malinen <j@w1.fi>
Cc: Linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 09:20:20 +0800
Message-Id: <1204680021.3087.132.camel@debian.sh.intel.com> (sfid-20080305_012101_176265_C2D04100)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni,

Does hostpad disable 5GHz channels intentionally? For regulation reason?

Thanks,
-yi
-------- Forwarded Message --------
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Jouni Malinen <jkmaline@cc.hut.fi>, linux-wireless@vger.kernel.org
Subject: Re: hostapd with mac80211 progress
Date: Tue, 04 Mar 2008 11:00:22 +0100

> Well, it (HOSTAPD_CHAN_W_SCAN) was removed somewhere after
> driver_nl80211.c set it. I think it's a hostapd bug. Please take a look
> at the hostapd_get_hw_features() function:
> 
> 
> if ((feature->mode == HOSTAPD_MODE_IEEE80211G ||
>      feature->mode == HOSTAPD_MODE_IEEE80211B) &&
>     feature->channels[j].chan >= 1 &&
>     feature->channels[j].chan <= 11) {
>         power_level = 20;
>         feature->channels[j].flag |=
>                 HOSTAPD_CHAN_W_SCAN;
> } else
>         feature->channels[j].flag &=
>               ~HOSTAPD_CHAN_W_SCAN;
> 
> 
> Apparently, A channels all have this flag removed. What does this flag
> stand for? I assume it stands for passive scan, right?

Ah, you're on 5 GHz then? Sorry, I'm not too familiar with hostapd
internals yet. I don't think the flag stands for passive scan, I think
it pretty much used to stand for "channel is usable at all" in the
dscape stack.

johannes

