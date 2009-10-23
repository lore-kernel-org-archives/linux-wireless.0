Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbZJWQm7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 12:42:59 -0400
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1256315972.12174.168.camel@johannes.local>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <20091022133425.317619132@mail.mn-solutions.de>
	 <1256307572.12174.33.camel@johannes.local>
	 <1256312995.2164.7.camel@localhost.localdomain>
	 <1256313851.12174.131.camel@johannes.local>
	 <1256315335.2164.44.camel@localhost.localdomain>
	 <1256315496.2164.47.camel@localhost.localdomain>
	 <1256315972.12174.168.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 23 Oct 2009 09:42:59 -0700
Message-Id: <1256316179.2164.53.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-10-23 at 18:39 +0200, Johannes Berg wrote:
> On Fri, 2009-10-23 at 09:31 -0700, Dan Williams wrote:
> 
> > > > I just don't understand why he thinks that wext and cfg80211 need to be
> > > > mutually exclusive. cfg80211 has exported its handlers for exactly this
> > > > purpose, so that you could have everything that cfg80211 supports via
> > > > it, and everything else directly.
> > > 
> > > I thought about it more, and I think we can go all cfg80211 with a small
> > > WEXT handler for the mesh bits (it only cares about 4 of the WEXT
> > > operations and redirected the rest to the STA interface handlers).  The
> > > mesh stuff is actually quite simple operationally.
> > 
> > Which should allow us to use cfg80211 by default, and then have only the
> > LIBERTAS_MESH Kconfig option depend on WEXT.  Maybe?
> 
> Well if you want to push the mesh wext bits through to cfg80211
> (temporarily) you wouldn't even need to depend on WEXT. I'd prefer,
> however, to not do this, and just use the cfg80211 wext handlers in
> libertas and depend on WEXT for now.

Yeah, I think it's best to handle the mesh WEXT ioctls separately for
now.  There are really only 4 of them (get/set SSID, set channel, get
mode) that matter for mesh.  The rest of the ioctls that the mesh
interface supports get redirected to the cfg80211 handlers because they
aren't specific to mesh.

Dan


