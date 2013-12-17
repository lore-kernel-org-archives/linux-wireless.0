Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:58774 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3LQURX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:17:23 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: Circular lock with mac80211_hwsim and DFS
Date: Tue, 17 Dec 2013 21:17:17 +0100
Cc: linux-wireless@vger.kernel.org
References: <87lhzjeqg6.fsf@kamboji.qca.qualcomm.com> <201312171805.34821.sw@simonwunderlich.de>
In-Reply-To: <201312171805.34821.sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201312172117.17538.sw@simonwunderlich.de> (sfid-20131217_211728_045996_011D7C4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Hi,
> > 
> > I tried to run a simple DFS test with mac80211_hwsim for the first time
> > but got the deadlock below. Is this a regression or has DFS ever worked
> > with hwsim?
> > 
> > Using 31e1798fbf from mac80211-next.
> 
> just checked again with mac80211-next for ath9k, and I don't see this
> lockdep problem. Appearently this is a problem in hwsim only ....
> 

...after talking to Johannes, I could actually recreate the problem. I have 
never tried to scan before starting hostap (actually this would only be 
possible with force-ap when in AP mode). This will then mark the path for 
lockdep, which eventually will hit the splat you reported. So I take that 
back, the problem is also in ath9k and not in hwsim.

As Johannes pointed out, this should not happen when using DFS because of RTNL 
locking, but still this is ugly.

For reference, the problem is:

1)
 * ieee80211_request_scan locks local->mtx 
 * ieee80211_offchannel_stop_vifs locks local->iflist_mtx
2)
 * start_radar_detection locks local->iflist_mtx
 * ieee80211_vif_use_channel locks local->chanctx_mtx
 * ieee80211_new_chanctx locks local->mtx

And there we have the circular dependency.

Cheers,
    Simon
