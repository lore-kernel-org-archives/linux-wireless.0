Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:41287 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbYDAQlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 12:41:19 -0400
Received: by rn-out-0910.google.com with SMTP id e24so1146735rng.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2008 09:41:17 -0700 (PDT)
Subject: Re: [PATCH] mac80211: use recent multicast table for all mesh
	multicast frames, not only broadcast
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1207051222.5143.52.camel@johannes.berg>
References: <47f189af.09038e0a.2eb1.ffffb304@mx.google.com>
	 (sfid-20080401_020242_031816_0B005E21)  <1207051222.5143.52.camel@johannes.berg>
Content-Type: text/plain; charset=utf-8
Date: Tue, 01 Apr 2008 09:41:13 -0700
Message-Id: <1207068073.6388.10.camel@localhost> (sfid-20080401_174129_088172_2BBBE14C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-04-01 at 14:00 +0200, Johannes Berg wrote:
> Seems appropriate but I haven't checked the spec.

=EF=BB=BFThis was a bug, it was meant to be multicast from the begginin=
g.
Otherwise if a mesh node transmits a multicast (non-broadcast) frame an=
d
there are N mesh peers around it, it is going to be retransmitted
N^MESH_TTL times.


> On Mon, 2008-03-31 at 15:33 -0700, Luis Carlos Cobo wrote:
> > Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
> > ---
> >  net/mac80211/rx.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > index d9c6ed5..0ac6db5 100644
> > --- a/net/mac80211/rx.c
> > +++ b/net/mac80211/rx.c
> > @@ -433,7 +433,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_dat=
a *rx)
> >  		}
> > =20
> >  	 } else if ((rx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYP=
E_DATA &&
> > -		    is_broadcast_ether_addr(hdr->addr1) &&
> > +		    is_multicast_ether_addr(hdr->addr1) &&
> >  		    mesh_rmc_check(hdr->addr4, msh_h_get(hdr, hdrlen), rx->dev))
> >  		return RX_DROP_MONITOR;
> >  #undef msh_h_get

--=20
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
