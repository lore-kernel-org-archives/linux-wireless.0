Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759886Ab1CDTS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 14:18:29 -0500
Subject: Re: [PATCH 6/7] mac80211: Parse RSN information element to
 determine if a peer needs authentication
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
In-Reply-To: <AANLkTim-cdTV6dsZg9MmMFMejkN8SpNYr=RBY-s8kiF=@mail.gmail.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
	 <1299208307-9428-7-git-send-email-thomas@cozybit.com>
	 <1299238635.4348.6.camel@jlt3.sipsolutions.net>
	 <AANLkTim-cdTV6dsZg9MmMFMejkN8SpNYr=RBY-s8kiF=@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 20:18:27 +0100
Message-ID: <1299266307.3742.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-04 at 11:06 -0800, Javier Cardona wrote:
> On Fri, Mar 4, 2011 at 3:37 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:
> >> From: Javier Cardona <javier@cozybit.com>
> >
> > [...]
> >
> > If you manage stations in userspace, then this code is unnecessary.
> > That'd be a big win in my eyes. The only thing the kernel would need to
> > know is not to create station entries, right?
> 
> If userspace manages only rsn mesh stations then we do still need
> this.  That would be my preference:  only require an authentication
> daemon if you intend to join a secure mesh.  In the same way that you
> can connect to an open AP without a daemon.
> Would you object to this approach?

No, I wouldn't, but I don't see why you'd still need this? I'm not sure
exactly how all this works, but conceptually, is there anything wrong
with this:
 * when creating the mesh, you'd say "this is a secure mesh"
 * when an auth frame is received, you just pass it to userspace, as you
   already have
 * userspace is responsible for adding/removing stations
 * the kernel doesn't need to parse RSN since if it's a secure mesh it
   will know because userspace said it was


Actually, looking at your patch in more detail, it would seem like it
allows somebody to hijack the mesh by pretending it is an open network.
If the RSN IE isn't present, mesh_neighbour_update() gets passed false
for the rsn_enabled parameter -- even if the mesh should be secure --
and then the peer would be allowed to join just because it said it
didn't support RSN. Surely in that case it shouldn't be allowed to join?
Maybe I'm not reading this correctly.

johannes

