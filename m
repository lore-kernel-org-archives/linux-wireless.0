Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003AbZJZUM7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 16:12:59 -0400
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200910260859.39002.hs4233@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <1256315972.12174.168.camel@johannes.local>
	 <1256316179.2164.53.camel@localhost.localdomain>
	 <200910260859.39002.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 13:12:46 -0700
Message-Id: <1256587966.2110.28.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-10-26 at 08:59 +0100, Holger Schurig wrote:
> > > Well if you want to push the mesh wext bits through to cfg80211
> > > (temporarily) you wouldn't even need to depend on WEXT. I'd prefer,
> > > however, to not do this, and just use the cfg80211 wext handlers in
> > > libertas and depend on WEXT for now.
> > 
> > Yeah, I think it's best to handle the mesh WEXT ioctls separately for
> > now.  There are really only 4 of them (get/set SSID, set channel, get
> > mode) that matter for mesh.  The rest of the ioctls that the mesh
> > interface supports get redirected to the cfg80211 handlers because they
> > aren't specific to mesh.
> 
> We can reduce this to 3, because get/set channel could
> simply go via cfg80211.
> 
> I'm unsure if we still need an GIWRANGE for mesh, but probably not.

Hmm, probably not.  I think everything is the same between the mesh
interface and STA here, but not sure.

In any case, the code for the mesh channel change was different than the
code for the STA channel change, we have to be a bit careful here.  The
sequences were:

STA:

1) get current channel #
2) issue a MESH_STOP command with the old channel
3) change the channel
4) resend WEP keys to firmware if any
5) restart adhoc if adhoc is enabled

mesh:

1) if STA is active and in infrastructure, deauth from AP
2) if STA is active and in adhoc, issue ADHOC_STOP
3) issue MESH_START with new channel

There are a few holes in the current implementation since desired
behavior is somewhat undefined; for example, if you change the mesh
channel, should an active adhoc network on the STA interface *restart*
on the new channel, or should the adhoc network on the old channel just
be torn down?  If you change the mesh channel and the STA interface is
associated to an AP, should the STA interface try to re-associate to
that SSID on the new channel, or should it just stop?

In the end, we decided to keep it simple and require userspace to know a
bit about what was going on, which is reasonable, and thus if userspace
makes the choice to change mesh channel, userspace would also be
responsible for figuring out what happens with the STA interface next.

Dan

> 
> Dan, you once said that you converted the MESH firmware
> calls to new style commands. Do you have those around?  Maybe
> I can re-work them if they don't apply anymore.
> 

