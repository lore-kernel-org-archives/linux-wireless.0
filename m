Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-us.gmx.com ([74.208.5.67]:46193 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751818Ab0EHOfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 10:35:33 -0400
Date: Sat, 8 May 2010 09:34:45 -0500
From: pigiron <pigiron@gmx.com>
To: Javier Cardona <javier@cozybit.com>, linux-wireless@vger.kernel.org
Subject: Re: The case of the bogus SSID
Message-ID: <20100508093445.581e180e@atom.pigiron.org>
In-Reply-To: <w2r445f43ac1005070929uacb5472dj231ff72ef0343860@mail.gmail.com>
References: <20100505120131.2b9f4e06@atom.pigiron.org>
	<t2j446ae9281005061112z6eee4126z673947eb02dc4f12@mail.gmail.com>
	<20100506215613.43477434@atom.pigiron.org>
	<w2r445f43ac1005070929uacb5472dj231ff72ef0343860@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 7 May 2010 09:29:18 -0700 Javier Cardona <javier@cozybit.com> wrote:

> Hi,
> 
> On Thu, May 6, 2010 at 7:56 PM, pigiron <pigiron@gmx.com> wrote:
> > On Thu, 6 May 2010 11:12:15 -0700 Steve deRosier <steve@cozybit.com> wrote:
> >
> >> On Wed, May 5, 2010 at 10:01 AM, pigiron <pigiron@gmx.com> wrote:
> >> > I noticed that decimal 52 is assigned to WLAN_EID_MESH_ID in the
> >> > ieee80211.h file, and recently the same 52 was also assigned to
> >> > WLAN_EID_NEIGHBOR_REPORT in the same enumerated ieee80211_eid{}
> >> > structure.
> >> >
> >>
> >> I can't answer the rest of your question, but AFAIK, the element IDs
> >> for 802.11s mesh haven't been approved yet as the 802.11s draft
> >> contains a note to that effect.  The current ANA database sheet I
> >> could find (Feb 2010) does have 52 assigned to Neighbor Report, and
> >> the mesh element IDs are nowhere to be found.
> >>
> > I agree. The 802.11k-2008 standard has already been approved with Element ID
> > 52 = Neighbor Report, so it's probably almost a guarantee that 802.11s
> > won't be assigning 52 to anything in the future.
> >
> > I'm kind of stuck on this problem. I could probably find out what's causing
> > the failure and create a patch... but the patch wouldn't be "The Right
> > Thing To Do(tm)" if the router isn't supposed to be spewing that data to
> > begin with.
> 
> I don't know about the router, nor if the IE ID clash is causing your
> problem, but moving the mesh codes somewhere else in the unassigned ID
> space would be a "A Good Thing To Do (tm)".
> 
> Cheers,
> 
> Javier

Really?

Wouldn't that cause a problem for the kids running OLPC? For instance, where
some of the laptops are running an old level of code where WLAN_EID_MESH_ID=52
and others are running new code where WLAN_EID_MESH_ID=X.

Especially, since as far as I can tell with my untrained eye, this Neighbor
Report that I've been fretting about should only be coming over the air when
specifically asked for... and we don't have any code (yet) to do that?

peace,
Bob
