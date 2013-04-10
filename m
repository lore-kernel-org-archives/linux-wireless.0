Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3DJNVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 09:21:09 -0400
Message-ID: <1365600063.4235.3.camel@jlt4.sipsolutions.net> (sfid-20130410_152113_065543_7AE819B6)
Subject: Re: [PATCH] cfg80211: introduce critical protocol indication from
 user-space
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 10 Apr 2013 15:21:03 +0200
In-Reply-To: <516551D7.30302@broadcom.com>
References: <1365412173-7428-1-git-send-email-arend@broadcom.com>
	 <1365501997.8465.23.camel@jlt4.sipsolutions.net>
	 <516471FC.6000209@broadcom.com>
	 <1365540154.8465.51.camel@jlt4.sipsolutions.net>
	 <516551D7.30302@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-10 at 13:49 +0200, Arend van Spriel wrote:

> >> I am a dark-ages guy :-p I think I will rename the BOOTP one and
> >> indicate it should be used for BOOTP and DHCPv6.
> >
> > Might also be worth it to rename ARP to APIPA since ARP is ... well
> > often done :-)
> 
> I chose ARP because APIPA is essentially not a protocol. As far as I 
> understand it makes use of ARP to make sure the address in unique. I see 
> your point and will change it. Then again it all may go away :-)

I see your point too, but I'd argue that APIPA is really more of a
higher-level protocol that uses ARP for its implementation?

> > Well you have to store the nlportid (rather than crit_proto_started) and
> > then check it.
> 
> Yeah, I surmised that already. If I would drop crit_proto_started and 
> use the portid as a flag as well, I need an invalid portid. Is there a 
> definition for that?

I'm pretty sure 0 is invalid for userspace because it means "kernel".

johannes

