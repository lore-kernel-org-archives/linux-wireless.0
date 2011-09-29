Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1I2KVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 06:21:24 -0400
Subject: Re: [PATCH] mac80211: Allow NO_ACK flag overwrite for injected
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAGXE3d87utQhKifrA8bco14rv9zn3-uZEsDiisg8wkDfipeBMQ@mail.gmail.com> (sfid-20110929_120247_235174_E8D6A29A)
References: <1317288432-26380-1-git-send-email-helmut.schaa@googlemail.com>
	 <1317290375.3974.1.camel@jlt3.sipsolutions.net>
	 <CAGXE3d87utQhKifrA8bco14rv9zn3-uZEsDiisg8wkDfipeBMQ@mail.gmail.com>
	 (sfid-20110929_120247_235174_E8D6A29A)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Sep 2011 12:21:12 +0200
Message-ID: <1317291672.3974.3.camel@jlt3.sipsolutions.net> (sfid-20110929_122128_131233_D4F837B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-29 at 12:02 +0200, Helmut Schaa wrote:

> > Makes sense, but I wonder if we really should continue using
> > radiotap :-) Maybe mgmt-tx in nl80211 would be appropriate.

An nl80211 flag, and the right modifications in hostapd to use mgmt-tx
and the flag. But I guess that's just another thing on the growing list
of things to do to move hostapd to not use monitor interfaces ...

> Hmm, not sure how much work that would be ...
> 
> >> @@ -1257,7 +1265,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
> >>               tx->flags |= IEEE80211_TX_UNICAST;
> >>               if (unlikely(local->wifi_wme_noack_test))
> >>                       info->flags |= IEEE80211_TX_CTL_NO_ACK;
> >> -             else
> >> +             else if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
> >>                       info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
> >
> > ??
> 
> Don't remove the IEEE80211_TX_CTL_NO_ACK flag when it was set via radiotap.

Well, ok, but the logic is:

if (flag not set)
	unset flag

which is kinda useless, right?

johannes

