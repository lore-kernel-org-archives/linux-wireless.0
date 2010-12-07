Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab0LGJfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 04:35:44 -0500
Subject: Re: [PATCH 2/3] nl80211: Export available antennas
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <201012071117.19067.br1@einfach.org>
References: <20101206034529.11462.48097.stgit@localhost6.localdomain6>
	 <201012061730.16102.br1@einfach.org>
	 <1291624400.3506.3.camel@jlt3.sipsolutions.net>
	 <201012071117.19067.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 10:35:40 +0100
Message-ID: <1291714540.3607.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 11:17 +0900, Bruno Randolf wrote:
> On Mon December 6 2010 17:33:20 Johannes Berg wrote:
> > > > Finally, you should check for nl80211 that the given tx/rx masks fall
> > > > into the available antennas mask.
> > > 
> > > Allright, I can do that. Would you prefer to reject the command in this
> > > case or just apply the available mask?
> > 
> > I'd reject it, since userspace could have checked whether it was valid.
> 
> Hmm, been thinking about it: the "iw phyX set antenna all" will not work in 
> that case. Unless we get the available antennas before setting "all" in iw, 
> which seems like a lot of overhead...
> 
> Alternatively we can either apply the mask in mac80211 or just hand the 
> antenna masks as they are to the driver, which is what we do now.

I think I'd be more happy with treating ~0 as special (which it is
anyway, apply the mask to it) and allowing that to not match the mask.
That way, the most common errors still don't have to be handled in the
driver.

johannes

