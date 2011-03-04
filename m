Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759886Ab1CDTOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 14:14:30 -0500
Subject: Re: [PATCH 5/7] nl80211: Let userspace set the authenticated flag
 for a mesh peer
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
In-Reply-To: <AANLkTintngisxbaP1P+fJo4_jhWtrzJhSXmLHMGfMotH@mail.gmail.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
	 <1299208307-9428-6-git-send-email-thomas@cozybit.com>
	 <1299238580.4348.5.camel@jlt3.sipsolutions.net>
	 <AANLkTintngisxbaP1P+fJo4_jhWtrzJhSXmLHMGfMotH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 20:14:28 +0100
Message-ID: <1299266068.3742.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-04 at 11:01 -0800, Javier Cardona wrote:
> On Fri, Mar 4, 2011 at 3:36 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:
> >> From: Javier Cardona <javier@cozybit.com>
> >
> > [snip (maybe more changelog would be nice)]
> >
> > So .. a more "traditional" approach, like we do in AP, would be to let
> > userspace manage the lifetime of STA entries in this case. In managed
> > mode, we don't, but there mac80211 currently handles the authentication.
> >
> > I think you should explore doing mesh more like the AP case. OTOH, I
> > don't know how the managed case with SAE would work.
> 
> I see.  Instead of setting the AUTH flag, just create the station.  We
> would like to do this only for secure meshes, and continue letting the
> kernel manage mesh peers for "open" meshes without the need of
> userspace intervention.

Sure. I might argue that even in the "open" mesh case sometimes
userspace would like to manage it, so I wouldn't make it depend on a
"secure mesh" flag but rather on a "userspace manages peers" flag, but
from a programming POV those would be the same, just a bit differently
semantically.

OTOH, that might not work when the mesh isn't secure since then there's
no clear point like the auth handshake when the station needs to be
added? Not quite sure here.

johannes

