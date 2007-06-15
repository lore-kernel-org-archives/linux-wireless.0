Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbXFOSiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2007 14:38:08 -0400
Subject: Re: libertas (private) ioctls vs. nl80211
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <1181757483.29767.99.camel@johannes.berg>
References: <1181757483.29767.99.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 14:42:32 -0400
Message-Id: <1181932952.7676.17.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-06-13 at 19:58 +0200, Johannes Berg wrote:
> Hi,
> 
> With the recent activity around cfg/nl80211 I was wondering if the
> libertas people could offer some input on what configuration 802.11s
> requires, or even could start specifying some preliminary nl80211
> commands for 802.11s.

I only have a general idea of what sorts of configurables mesh
implementations would need, unfortunately.  I could probably figure that
out from people that would know though.  The standard is still draft
though, and changing pretty heavily recently.  Some things that are
useful are tuning the data rates of route requests, poking the
forwarding table, setting power management options etc.  On the debugfs
side, being able to add static mappings to the forwarding and blinding
tables are nice.  Looking towards 802.11s, we'll need methods to set up
encryption keys between pairs of nodes and dealing with whatever
authentication methods the committees come up with.

> The reason I'm saying this is that I'd really like to see a full-mac
> driver use cfg80211 unlike softmac drivers where only mac80211 is
> involved, just to try out the APIs a bit more. And libertas seemed to be
> a suitable candidate to me... Maybe some other driver would be better? I

I'd like to see if we can do this too.  Were I to convert some drivers,
I'd start first with libertas and then do airo.  They are both pretty
simple.  For the libertas case, the straight cfg80211 work should be
done first and then we can move on to mesh-specific stuff.

> personally have no full-mac hardware available nor much time/interested
> right now but I'm sure some form of full-mac hardware could be made
> available to interested hackers.

Yes, we can give out a few Libertas USB 8388 dongles to interested
parties; I've already personally given 2 to Luis to put in their testbed
and sent one to Holger Schurig who's working on the CF 8385 port.  We're
trying to work out a more formal run of USB 8388 dongles than the
"engineering samples" we're getting right now.  School servers need them
too, and we need something a lot more rugged than an un-canned bare
PCB :)

Dan


