Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:56529 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBDMHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 07:07:04 -0500
Message-ID: <1391515621.26522.99.camel@porter.coelho.fi> (sfid-20140204_130707_589008_B9365122)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>
Date: Tue, 04 Feb 2014 14:07:01 +0200
In-Reply-To: <1391515050.4134.6.camel@jlt4.sipsolutions.net>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140203_110356_335827_0A67B036) <1391434913.4488.24.camel@jlt4.sipsolutions.net>
	 <1391508433.26522.61.camel@porter.coelho.fi>
	 <1391509992.4134.1.camel@jlt4.sipsolutions.net>
	 <1391512311.26522.75.camel@porter.coelho.fi>
	 <1391513092.4134.4.camel@jlt4.sipsolutions.net>
	 <1391514164.26522.89.camel@porter.coelho.fi>
	 <1391515050.4134.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 12:57 +0100, Johannes Berg wrote:
> On Tue, 2014-02-04 at 13:42 +0200, Luca Coelho wrote:
> > > Nothing! As far as that's permissible. Ilan's patchset might change
> > > that, but that's mostly a regulatory thing, rather than a CSA thing.
> > 
> > Ah, you have some insider information! :P
> 
> Not really, he posted those patches ... :)

Heh, I should read the mailing list more carefully instead of marking
everything as read without reading. ;)


> > Sure, but how does the userspace know that the other interface *needs*
> > to be moved, regardless of regulatory problems? It needs to know that
> > there are not enough contexts to keep the interfaces in different
> > channels...
> 
> It has all that information, it can know the channels, channel contexts,
> etc.

Okay, so I assume it also knows how many vifs can be in the same context
and all the possible vif type combinations.  And do the same checks that
cfg80211 already does...


> > > > ...and, if the userspace doesn't react, we disconnect the GO.  I think
> > > > it's safer this way for the GO-follows-STA case.
> > > 
> > > That would be a consequence of Ilan's work, yes.
> > 
> > Okay, if that's going to be guaranteed, I'm fine with it.
> 
> Not yet, but Ilan probably needs to take care of that.
> 
> > > This typically won't happen, since userspace will do something else, but
> > > we need to have some default policy. I don't think anything else makes
> > > much sense?
> > 
> > My point was that a CSA could have been triggered due to regulatory
> > (which the AP/GO is monitoring), so the safest would be to move everyone
> > out of the channel by default.
> 
> But the kernel can't do that, it needs userspace to do it.

Right, but by "moving out of the channel by default" I meant
disconnecting those who don't so we are sure there's no one left.


>  And if the
> CSA was triggered due to regulatory, then the GO that follow the client
> can only be on this channel with Ilan's work, otherwise it's allowed to
> be standalone there.

Okay, I'll check Ilan's patches.

--
Luca.



