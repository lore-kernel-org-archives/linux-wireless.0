Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48422 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbZEUOvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 10:51:18 -0400
Date: Thu, 21 May 2009 10:41:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, drago01 <drago01@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>
Subject: Re: [PATCH 1/2] wireless: move some utility functions from
	mac80211 to cfg80211
Message-ID: <20090521144115.GB2744@tuxdriver.com>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com> <1242872340-27417-2-git-send-email-yi.zhu@intel.com> <f6ca9fed0905210012t2b494db5w3169ef2e8db2b04b@mail.gmail.com> <1242889781.24825.611.camel@debian> <1242897719.5471.1.camel@johannes.local> <20090521133839.GA2744@tuxdriver.com> <1242914188.4212.7.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242914188.4212.7.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2009 at 03:56:28PM +0200, Johannes Berg wrote:
> On Thu, 2009-05-21 at 09:38 -0400, John W. Linville wrote:
> > On Thu, May 21, 2009 at 11:21:59AM +0200, Johannes Berg wrote:
> > > On Thu, 2009-05-21 at 15:09 +0800, Zhu Yi wrote:
> > > 
> > > > > Isn't lib80211 a better place for those ?
> > > > > Its purpose is sharing code between fullmac and softmac drivers.
> > > > 
> > > > These functions are moved from mac80211 which currently doesn't link
> > > > with lib80211. Johannes might have more to comment.
> > > 
> > > Yeah, lib80211's stated purpose is to share code, but on the other hand
> > > code that mac80211 and fullmac drivers may need seems better suited in
> > > cfg80211 since lib80211 also ships a large code bit of crypto routines
> > > etc. that are just useless for this and mac80211.
> > 
> > The crypto stuff is mostly in separate modules.
> > 
> > I would rather see these in lib80211, but I'll work that out myself.
> 
> Heh. And I asked them to put it here... Then again, lib80211_crypt_*
> only exists for hostap and ipw2x00, so maybe we should separate that out
> into a separate lib80211_crypt module? That would leave lib80211 only
> with print_ssid, of course...
> 
> Basically I still think having lib80211 is pretty much pointless since
> all future fullmac drivers and mac80211 all need to use cfg80211.

I like the logical separation for now.  At some point they can probably
be viewed as a single unit, but even then I think lib80211 will be
a better name for the amalgamation... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
