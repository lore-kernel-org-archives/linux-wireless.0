Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sipsolutions.net ([144.76.43.152]:50095 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab3DXLIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 07:08:24 -0400
Message-ID: <1366801278.11111.23.camel@jlt4.sipsolutions.net> (sfid-20130424_130828_072984_F618248B)
Subject: Re: [RFC 1/2] mac80211:  Add vif hash for multi-station RX
 performance.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <517705E0.4070304@candelatech.com>
References: <1365007698-25295-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130403_184908_772897_29241D1E) <1365501478.8465.17.camel@jlt4.sipsolutions.net>
	 <516455CA.6070504@candelatech.com>
	 <1365671968.8272.35.camel@jlt4.sipsolutions.net>
	 <5176E442.7070907@candelatech.com> <517705E0.4070304@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Apr 2013 13:01:18 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-23 at 15:06 -0700, Ben Greear wrote:

> > This idea suddenly looks a lot more interesting.  The ieee80211_tx_status method needs
> > to find the remote station & sdata, but in the AP case, the station hash works best,
> > and in my many-sta-vif case, the VIF hash works best.  I don't see any way to guess
> > which hash to use in this case.

Indeed, that'd be tricky.

> > But, if we first hashed to find sdata, and then had a vif hash in the sdata
> > object, the lookup should be fast for cases where the hash function works
> > well.
> >
> > I'll give this a try...
> 
> Seems to mostly be working, but I've a few questions.
> 
> First, if we are hashing sdata on sdata->vif.addr, then we must
> assume that everything in that hash has a unique MAC.  I'm
> thinking that I would just never put monitor devices in
> the hash.  Is there anything else that would cause problems
> with this?

Monitor interfaces won't have stations, so they're not needed anyway.

> Second, the sta_info_get_bss call is found fairly often.  It
> talks about finding a station on sdata or associated vlan.
> Does this indicate that the there are VLAN sdata objects
> with duplicate MACs?

Yes. See net/mac80211/iface.c identical_mac_addr_allowed().

> I was hoping I could replace at least most calls to sta_info_get_bss
> with one that just searched the new sdata->sta_hash hash table...

I have no idea how my answer affects this :)

johannes

