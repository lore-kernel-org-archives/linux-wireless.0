Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:51386 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3ABOo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:44:29 -0500
Date: Wed, 2 Jan 2013 15:44:16 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv5 0/8] Add DFS master ability
Message-ID: <20130102144416.GA7794@pandem0nium> (sfid-20130102_154433_473281_19F9480D)
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357134823.9839.41.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
In-Reply-To: <1357134823.9839.41.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Johannes,

thank you very much for the review!

On Wed, Jan 02, 2013 at 02:53:43PM +0100, Johannes Berg wrote:
>=20
> > I'm sending this as patch to keep the versioning, although it can be
> > considered as RFC, I would be suprised if all single channel/single
> > interface aspects were considered correctly. :)
>=20
> :)
>=20
> I think we need a bit more "design review" first.

Good idea. :D

>=20
> To me, the open questions are:
>  * Should switching to a DFS channel be allowed at all? How so, if radar
>    can't be tested before? You just stop the AP instead but userspace
>    can do that just as well.

The idea was to allow counting down the TBTT/count field of the CSA IE with=
in
the driver - this can't be done properly by userspace.

Also, the transmission must be stopped on the new channel, so the idea was
to do this in kernel space right after the counting is finished. The idea
was to skip the additional enable_tx call which was originally proposed,
but it seems to create more troubles than it saves.

So maybe we should go back to enable_tx to re-enable the AP after a
switch into a DFS channel (with block-tx on).

Unlike Victors proposal, I'd suggest to skip enable_tx when starting the
AP the first time - just doing cac/radar_detect and start_ap should be enou=
gh.

>  * What happens with multiple virtual interfaces? You allow a single
>    channel context only which makes sense, but that doesn't disallow
>    things like having a client + AP, and then the client switching away
>    because the P2P GO it was connected to randomly decided to switch.
>    This would break radar detection. (1) What should happen in this
>    case?

Actually I thought I had succesfully disabled multiple interfaces in general
when DFS channels are used. Maybe I missed something?

For now, I'd prefer having only a single interface when doing DFS.

>  * To avoid that problem, could restrict to a single virtual interface.
>    However, that's unlikely to be sufficient -- you'd want to still be
>    able to implement multi-BSSID APs which then switch together etc.

Agreed. In the first step, we could allow multi-BSSID APs. When one hostapd
instance controls these APs, it should have enough information to coordinate
the CSAs on all APs.=20

>  * That raises another interesting question -- should multiple BSSIDs on
>    the same channel really *all* call the driver's ap_channel_switch()
>    callback? That seems ... strange!

Hmm, the channel should only be switched once, that's right.

What about:
 * set CSA IEs in the beacons of all APs
 * call ap_channel_switch once for all APs on the phy
 * report switched channel back for all APs
 * remove CSA IEs

>  * Do we need any software channel switch handling?

Don't know what you specifically mean.

A more interesting case will be CSAs for IBSS (later), as the beacons are
handled by the drivers/mac80211 only.
>=20
> Generally the biggest issue is around multi-channel channel switch
> behaviour I think. Any good ideas?

For the MultiSSID-APs I think it's possible as roughly described above.
However mixed cases like AP+Client or AP+IBSS will be more interesting,
and I don't have any good idea for this yet...

>=20
> johannes
>=20
> (1) Actually today it would either break the AP (channel contexts NOT
> supported by the driver) or disconnect the client (otherwise)
>=20

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDkR8AACgkQrzg/fFk7axZXcgCguA645kTOGGQJHJTrcip9Afmo
p9EAn2BVcs2TCWqJ/Y41ICvxnL/YXwwb
=CNEy
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
