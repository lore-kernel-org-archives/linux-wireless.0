Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:59499 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420Ab0EEU6r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 16:58:47 -0400
Message-ID: <4BE1DBFE.2060909@free.fr>
Date: Wed, 05 May 2010 22:58:38 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] cfg80211/mac80211: better channel handling
References: <1273055797.3728.14.camel@jlt3.sipsolutions.net>	 <1273061543.3728.16.camel@jlt3.sipsolutions.net> <1273065902.3728.17.camel@jlt3.sipsolutions.net>
In-Reply-To: <1273065902.3728.17.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 05/05/2010 15:25, Johannes Berg a écrit :
> Currently (all tested with hwsim) you can do stupid
> things like setting up an AP on a certain channel,
> then adding another virtual interface and making
> that associate on another channel -- this will make
> the beaconing to move channel but obviously without
> the necessary IEs data update.
>
> In order to improve this situation, first make the
> configuration APIs (cfg80211 and nl80211) aware of
> multi-channel operation -- we'll eventually need
> that in the future anyway. There's one userland API
> change and one API addition. The API change is that
> now SET_WIPHY must be called with virtual interface
> index rather than only wiphy index in order to take
> effect for that interface -- luckily all current
> users (hostapd) do that. For monitor interfaces, the
> old setting is preserved, but monitors are always
> slaved to other devices anyway so no guarantees.

Real hardware are not capable of listening on multiple channels (except 
2 ht20 channels in ht40 mode, maybe?). So I don't understand why we 
should have a per-interface channel.

I think we should either have two strategies :

- "first one is the winner" : once a channel has been set, it cannot be 
changed. For instance, if you create an AP interface (with hostapd) and 
latter a STA interface, the STA interface can only scan on the channel 
the AP is.

- "last one is the winner" : in this case, the last call to set the 
channel is always successful. Of course, this will change channel on 
existing interfaces which might change their IE accordingly, through an 
appropriate API.

I might be wrong, but I don't see this multi-channel usage...

Regards,
Benoit
