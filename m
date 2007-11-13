Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760000AbXKMUmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 15:42:25 -0500
Subject: Re: [PATCH 3/4] o80211s: (mac80211s) basic mesh interface support
From: Dan Williams <dcbw@redhat.com>
To: Javier Cardona <javier@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org, hiertz@ieee.org
In-Reply-To: <445f43ac0711131231s5bfd173v1c9105e9f23d83b2@mail.gmail.com>
References: <473516ee.26d7720a.3f57.ffff8233@mx.google.com>
	 <1194689500.7258.61.camel@johannes.berg>
	 <445f43ac0711101603s18cd70a7lb70dedea8cc5c3c0@mail.gmail.com>
	 <1194866072.5229.8.camel@johannes.berg>
	 <445f43ac0711131231s5bfd173v1c9105e9f23d83b2@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 15:36:53 -0500
Message-Id: <1194986213.28937.10.camel@localhost.localdomain> (sfid-20071113_204255_189785_C96DC2DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-11-13 at 15:31 -0500, Javier Cardona wrote:
> On 11/12/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > As far as I understand the specification, this
> > [different MAC address for the mesh interface] is not required. Since we
> > currently have no drivers supporting multi-MAC operation, this is quite
> > a severe limitation and the draft seems to allow MAP operation with a
> > single address, cf. the description of the SSID element in 7.2.3.1
> > (Beacon frame format). ("Note: the SSID is a required IE in beacon
> > frames. To avoid having non-mesh STAs [...]")
> >
> > Therefore, I think that having a separate MAP type device would be
> > beneficial because that allows hostapd to generate a beacon including an
> > SSID, respond to probe requests and still be a mesh point on the same
> > interface. The only way hostapd would have to be aware of this is that
> > it needs to create a different type of interface and include the mesh
> > information in the beacon.
> >
> > Do you see anything precluding such operation? Some more logic would
> > have to be provided to achieve the appropriate mesh broad/multicast vs.
> > AP broad/multicast behaviour, of course, as described elsewhere wrt.
> > mesh broad/multicast frames being broad/multicast to associated STAs.
> 
> The issue of mesh beacons is an open discussion at TGs right now (and
> by now I mean this week, in the IEEE 802.11 plenary in Atlanta).  It
> looks like a different mac address will be needed for the mesh
> interface if collocated with an AP.  That will be necessary for
> security and to avoid conflicts with legacy equipment.  In that case,
> the stack should generate the mesh beacons and hostapd generate the
> infrastructure beacons.
> 
> Anyway, I see no problem in renaming this IEEE80211_IF_TYPE_MESH_POINT
> (even though I just heard of a proposal to rename Mesh Points as Mesh
> Stations... )

How concrete is that?  It could obviously be changed later but best to
keep the code terminology consistent with the standards terminology
unless the standards terminology is completely wack.

Dan

