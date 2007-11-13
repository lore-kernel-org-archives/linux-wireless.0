Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37489 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXKMNQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 08:16:46 -0500
Subject: Re: [PATCH 3/4] o80211s: (mac80211s) basic mesh interface support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1194909449.6980.89.camel@localhost> (sfid-20071112_231752_807760_71B959A3)
References: <473516ee.26d7720a.3f57.ffff8233@mx.google.com>
	 (sfid-20071110_022658_985099_309C7497)  <1194689500.7258.61.camel@johannes.berg>
	 <1194909449.6980.89.camel@localhost> (sfid-20071112_231752_807760_71B959A3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0C5hr6IK5Ngo7fK7pgAn"
Date: Tue, 13 Nov 2007 14:18:07 +0100
Message-Id: <1194959887.9116.51.camel@johannes.berg> (sfid-20071113_131649_697946_B0B7F0CC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0C5hr6IK5Ngo7fK7pgAn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> There wasn't such suggestion, we were talking about renaming interface
> state from IEEE80211_MESH to something more specific. I suggested
> _ACTIVE, _ON or something like that... any preferences? As for the
> interface name, we have discussed about how MAP would be a different
> interface type, so it would be a good idea to be more precise with the
> it. I would go for MESH_POINT though, to follow the nomenclature in the
> standard.

Hah, ok, I misunderstood the thread then. Sorry. MESH_POINT does sound
better than just MESH though.

> > >  	/* FIX: what would be proper limits for MTU?
> > >  	 * This interface uses 802.3 frames. */
> > > -	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6) {
> > > +	if (new_mtu < 256 ||
> > > +		new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
> > >  		printk(KERN_WARNING "%s: invalid MTU %d\n",
> > >  		       dev->name, new_mtu);
> > >  		return -EINVAL;
> >=20
> > Are you sure this is appropriate? As the comment says, interface is
> > 802.3 framed. Don't the 802.11 specifications usually keep the frame
> > payload length and require the device to handle longer frames?
>=20
> 802.11s does not modify the PHY at all, and AFAIK does not impose any
> additional requirement on the devices. So regardless if the code already
> there was needed, it is necessary to decrease the MTU by meshhdrlen
> bytes. Another problem is that mesh headers do not always have the same
> length, but that will be dealt with when support for different length
> headers is added.

Ok, thanks for the explanation.

> > > +	/* TODO: check for expired neighbors, paths and frames to non resol=
ved
> > > +	 * hw addresses
> > > +	 */
> >=20
> > Seems dangerous to actually run the code w/o this, no?
>=20
> No, right now we only add paths by manually from user space.

Oh ok. Never bothered to read that long part of the draft copy I have :)

> > > +static int o80211s_getmeshpath(struct sk_buff *skb, struct nlmsghdr =
*nlh,
> > > +		void *arg)
> > > +{
> > > +	return 0;
> > > +}
> >=20
> > Uh huh. Why is this here? Should it be filled?
>=20
> Of course. Please note this is work in progress. I guess I should return
> a ENOTSUPP instead.

That'd indeed be better.

> > > @@ -230,6 +231,9 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_=
data *tx)
> > >  	     (tx->fc & IEEE80211_FCTL_STYPE) !=3D IEEE80211_STYPE_PROBE_REQ=
))
> > >  		return TXRX_DROP;
> > > =20
> > > +	if (tx->sdata->type =3D=3D IEEE80211_IF_TYPE_MESH)
> > > +		return TXRX_CONTINUE;
> >=20
> > Is this right or should there be some other "is forwarded frame" check
> > to go with this? I'm not sure but it seems that frames we send via the
> > netdev need to be still checked? Or not because they're just injected
> > into the mesh? I think I'm confused.
>=20
> I'm confused too. ieee80211_subif_start_xmit checks if the frame is
> forwarded, ieee80211_tx_h_check_assoc does not care about if the frame
> is forwarded or not. Since there is no interface-wide "association
> state" in mesh, the association check would always be true.

Ok.

> > I think you should use RCU for the locking in the neighbour table. This
> > code should (IIRC) be under rcu read-side lock already so the neighbour
> > table reading would be lockless. Since updates are infrequent, RCU is a
> > good tradeoff.
>=20
> Updates are not that infrequent, every mesh path might be updated every
> few seconds (about 5 or 10). Would RCU be a good trade off in this
> situation?

I think so, yes. After all, a few seconds is nothing compared to how
many frames could be going through (many per second). In fact, the path
update might lock out the tx/rx paths for quite a while which is highly
undesirable.

johannes

--=-0C5hr6IK5Ngo7fK7pgAn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzmkDqVg1VMiehFYAQIfeg//T0dC12NUyD0QZXCfdZAiOpa83LiKLyLH
DGxmZ9qzN/r+tEte9NOYme4e7HJzjopUKCYNsT4aKd9avk1SVSpA4P0995Ex54Es
AA8T04EOI4YljAhNvEnpVYIE9Z+U5vEPtmYsfmJQG9BRKkchYYm9ICcdoey7EDNR
PCS4OhMYbf8weK8K0tt7QkqqCM2wHC19OrSDNOeGsxDHy7JnFQ3NeqMXlAILGl6g
gKMtrsN1HRYfJAGExe2vjfeuGQ0r9dxlXt9399hbLujxIPa2bpXX1j3phd0NBEFO
bggOUAhRUdaeSeDHq4vVBDf1pyYpofBJLE8WNfXW7r1rXFiZ+TvvJDB4iJWmrUS/
UF2xtboxUnCd1GN2FoHgNixxQsI3rnVcn42S9UnER+vowc0kdvcPE+dsZZH9vD94
+PCWYWFhkjoe4k48HbqjTT4lv8L/8kUvB1gzKmatnNvpDCq5tW7VxjupfETTh7nY
96UARV3b0zPQ4GiC1MTw1FBchQaD7xOViXkyslqUn6b4KwoB1m7tQQ9EgLmotKcT
hGmjkxzo8Vs1BqgNk+esmkL4tmd33gJ0KaD8uUMEm2iKe2DShfhPSsgflta7qKIB
TvNQ3pZCJPkqMlcqK9gkf3mN7+YjR/Mkt2zWCRgYHU2FF3AHmRoOSNza+EVVY8BP
RUdpUfJ866M=
=R3rq
-----END PGP SIGNATURE-----

--=-0C5hr6IK5Ngo7fK7pgAn--

