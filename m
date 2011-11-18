Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1KRRfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 12:35:25 -0500
Subject: Re: [PATCH v9 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EC69658.8000309@candelatech.com>
References: <1321566884-31757-1-git-send-email-greearb@candelatech.com>
	 <1321566884-31757-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111117_225512_858995_688665F5) <1321611355.10266.30.camel@jlt3.sipsolutions.net>
	 <4EC69155.4060306@candelatech.com>
	 <1321637322.10266.70.camel@jlt3.sipsolutions.net>
	 <4EC69658.8000309@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 18:35:21 +0100
Message-ID: <1321637721.10266.72.camel@jlt3.sipsolutions.net> (sfid-20111118_183528_928231_E3E070D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 09:31 -0800, Ben Greear wrote:

> >>> This looks like it has endian bugs. Note that sband->ht_cap is
> >>> ieee80211_sta_ht_cap, whereas sdata->u.mgd.ht_capa[_mask] is
> >>> ieee80211_ht_cap -- the latter is in IEEE format (LE) while the former
> >>> is in a complete different format that's easier to digest for the
> >>> CPU :-)
> >>
> >> So, the ht-caps&  mask data coming from user-space via netlink
> >> should be in network-byte order?
> >
> > It is that way right now, and that makes sense.
> 
> Ok, I think I am using host-byte-order currently in my iw
> and hostap patches, which is why everything works for me.
> 
> But, I'll flip that all around....

You're using x86 so 802.11 byte order == CPU byte order...

Be careful: "network byte order" usually means big endian...

johannes

