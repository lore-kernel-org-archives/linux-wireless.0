Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3CTV3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 17:29:14 -0400
Message-ID: <1363814947.9284.10.camel@jlt4.sipsolutions.net> (sfid-20130320_222918_154499_E497740E)
Subject: Re: rcutree tree warning during P2P device support testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: David Spinadel <dvdspndl@gmail.com>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Date: Wed, 20 Mar 2013 22:29:07 +0100
In-Reply-To: <514A274F.5030303@broadcom.com>
References: <5149CD81.40301@broadcom.com>
	 <1363792139.8224.10.camel@jlt4.sipsolutions.net>
	 <514A274F.5030303@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-20 at 22:17 +0100, Arend van Spriel wrote:
> > Hmm, why would stopping the supplicant cause brcmfmac to unload?? Or are
> > you saying you first stop the supplicant, which gets you that warning,
> > and then unload fails?
> 
> Indeed, upon stopping wpa_supplicant I get the warning. And doing a
> rmmod from the command line after that fails in the hang.

Right, ok.

> >> [ 1634.039095] WARNING: at kernel/rcutree.c:1960
> >> rcu_process_callbacks+0x469/0x560()
> > 
> >> [ 1634.133917] Call Trace:
> >> [ 1634.139833]  [<c1039c92>] warn_slowpath_common+0x72/0xa0
> >> [ 1634.148659]  [<c10c61f9>] ? rcu_process_callbacks+0x469/0x560
> >> [ 1634.157914]  [<c10c61f9>] ? rcu_process_callbacks+0x469/0x560
> >> [ 1634.167121]  [<c1039ce2>] warn_slowpath_null+0x22/0x30
> >> [ 1634.175725]  [<c10c61f9>] rcu_process_callbacks+0x469/0x560
> > 
> > Can't say I understand this warning ...
> >
> 
> At least we are on the same page then ;-)

It looks like some rcu head list corruption ... no idea really.

> The p2p device is already removed upon stopping wpa_supplicant through
> .del_virtual_intf() callback. Took a quick peek in
> net/mac80211/iface.c:ieee80211_if_remove() and wonder whether I should
> do cfg80211_unregister_wdev() in that code path as well. Guess so, right?

I think so, yes. Does the warning go away if you do? :)

johannes

