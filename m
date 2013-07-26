Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3GZIxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:53:06 -0400
Message-ID: <1374828780.8248.24.camel@jlt4.sipsolutions.net> (sfid-20130726_105312_038342_F13D0CE3)
Subject: Re: [WT PATCH 4/6] mac80211: Add per-sdata station hash, and sdata
 hash.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 26 Jul 2013 10:53:00 +0200
In-Reply-To: <51DECF5B.7040002@candelatech.com>
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
	  <1372546738-25827-4-git-send-email-greearb@candelatech.com>
	  (sfid-20130630_005944_514926_D21D8724) <1373532936.8201.5.camel@jlt4.sipsolutions.net>
	 <51DECF5B.7040002@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-11 at 08:29 -0700, Ben Greear wrote:

> > I also don't like maintaining two separate hash tables and all that.
> >
> > I'd reconsider if you actually remove the hash entirely, but that'll be
> > tricky to walk the station list and will quite possibly make the RX path
> > there more expensive?
> 
> Remove local->sta_hash ?

To be honest, I'm undecided. Yes, I was thinking that, but I also think
having a huge hashtable like that for each virtual interface is way
overkill, in particular for station interfaces that usually have one
peer (the AP) and maybe a few TDLS peers. Or P2P-Device interfaces that
have no peers at all ...

I don't see a good way to improve the hash either, since we don't always
(e.g. in RX path) have the interface address.

The basic problem really is that the hash now is designed to work well
for more regular use cases than yours, where you talk to any number of
different stations but degrades really badly when you talk only to a
single one many times. That use case is really special, and I don't want
to 'fix' that in a way that would make the other use case significantly
worse in memory consumption or CPU utilisation.

johannes

