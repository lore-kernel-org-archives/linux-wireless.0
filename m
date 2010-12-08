Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:15510 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753795Ab0LHDqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 22:46:12 -0500
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-05649970
	for <linux-wireless@vger.kernel.org>; Wed,  8 Dec 2010 12:46:10 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/3] nl80211: Export available antennas
Date: Wed, 8 Dec 2010 12:45:42 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20101206034529.11462.48097.stgit@localhost6.localdomain6> <201012071117.19067.br1@einfach.org> <1291714540.3607.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291714540.3607.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201012081245.42744.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue December 7 2010 18:35:40 Johannes Berg wrote:
> On Tue, 2010-12-07 at 11:17 +0900, Bruno Randolf wrote:
> > On Mon December 6 2010 17:33:20 Johannes Berg wrote:
> > > > > Finally, you should check for nl80211 that the given tx/rx masks
> > > > > fall into the available antennas mask.
> > > > 
> > > > Allright, I can do that. Would you prefer to reject the command in
> > > > this case or just apply the available mask?
> > > 
> > > I'd reject it, since userspace could have checked whether it was valid.
> > 
> > Hmm, been thinking about it: the "iw phyX set antenna all" will not work
> > in that case. Unless we get the available antennas before setting "all"
> > in iw, which seems like a lot of overhead...
> > 
> > Alternatively we can either apply the mask in mac80211 or just hand the
> > antenna masks as they are to the driver, which is what we do now.
> 
> I think I'd be more happy with treating ~0 as special (which it is
> anyway, apply the mask to it) and allowing that to not match the mask.
> That way, the most common errors still don't have to be handled in the
> driver.

Allright. Sent a patch for this.

bruno
