Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-us.gmx.com ([74.208.5.67]:47771 "HELO
	mailout-us.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750874Ab0EGC4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 22:56:49 -0400
Date: Thu, 6 May 2010 21:56:13 -0500
From: pigiron <pigiron@gmx.com>
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: The case of the bogus SSID
Message-ID: <20100506215613.43477434@atom.pigiron.org>
In-Reply-To: <t2j446ae9281005061112z6eee4126z673947eb02dc4f12@mail.gmail.com>
References: <20100505120131.2b9f4e06@atom.pigiron.org>
	<t2j446ae9281005061112z6eee4126z673947eb02dc4f12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 6 May 2010 11:12:15 -0700 Steve deRosier <steve@cozybit.com> wrote:

> On Wed, May 5, 2010 at 10:01 AM, pigiron <pigiron@gmx.com> wrote:
> > I noticed that decimal 52 is assigned to WLAN_EID_MESH_ID in the
> > ieee80211.h file, and recently the same 52 was also assigned to
> > WLAN_EID_NEIGHBOR_REPORT in the same enumerated ieee80211_eid{} structure.
> >
> 
> I can't answer the rest of your question, but AFAIK, the element IDs
> for 802.11s mesh haven't been approved yet as the 802.11s draft
> contains a note to that effect.  The current ANA database sheet I
> could find (Feb 2010) does have 52 assigned to Neighbor Report, and
> the mesh element IDs are nowhere to be found.
> 
> - Steve

I agree. The 802.11k-2008 standard has already been approved with Element ID
52 = Neighbor Report, so it's probably almost a guarantee that 802.11s won't be
assigning 52 to anything in the future.

I'm kind of stuck on this problem. I could probably find out what's causing the
failure and create a patch... but the patch wouldn't be "The Right Thing To
Do(tm)" if the router isn't supposed to be spewing that data to begin with.

And at this point I've sort of convinced myself that the router is misbehaving.
When I combine Table 7-15 in the 802.11k-2008 standard with the same table in
the 802.11-2007 standard (Table 7-15 describes a "Probe Response frame body"), I
just can't find a way for it to contain a Neighbor Report.

I've had to code to a lot of standards/specifications over the years, but this
is my first trip into the 802.11 world... so I guess I'm just looking for some
confirmation from someone who has been living in the wireless world for awhile.
That, and I'd have to do a *bunch* of war driving to prove that no other routers
spew a Neighbor Report.
