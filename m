Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:56448 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3ACHrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 02:47:40 -0500
Date: Thu, 3 Jan 2013 08:47:32 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv5 7/8] mac80211: add ap channel switch command/event
Message-ID: <20130103074732.GD20780@pandem0nium> (sfid-20130103_084744_176896_D48581F6)
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1355407113-27006-8-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357134469.9839.35.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d01dLTUuW90fS44H"
In-Reply-To: <1357134469.9839.35.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--d01dLTUuW90fS44H
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 02, 2013 at 02:47:49PM +0100, Johannes Berg wrote:
> On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:
>=20
> > +	mutex_lock(&local->mtx);
> > +	if (local->ap_cs_chandef.chan->flags & IEEE80211_CHAN_RADAR) {
> > +		sdata_info(sdata, "changing to DFS channel\n");
> > +		/* when changing to a DFS channel, stop AP. Userspace must
> > +		 * restart AP or do start radar detection first.
> > +		 */
> > +		stop_ap =3D true;
>=20
> I don't see any value in this. You might just as well simply forbid
> requesting a channel change to a DFS channel, hostapd could then stop
> instead of doing the switch.
>=20

We explicitly want the channel switch, this was the original idea in 802.11h
- announce the next channel, then switch. To announce the next channel, we
need to allow this.

As discussed before, doing stop_ap here is probably not a good idea. We
can change that back to let the driver disable transmissions and expect
an explicit enable_tx call from userspace after CAC on the new channel.

> > +	} else {
> > +		/* update the device channel directly */
> > +		sdata_info(sdata, "changing to non-DFS channel\n");
> > +
> > +		/* TODO: _oper_channel is deprecated ... use
> > +		 * vif_release/use_channel instead? In this case, we must make
> > +		 * sure that interface is down first ...
> > +		 */
>=20
> Well, most likely need to modify the existing channel context instead.
> However, that's tricky, and what if there are other interfaces, what
> happens to those?

That's a fair question ... for the current DFS implementation, I except to
only have one interface (single only context) - for now. We have the same
discussion in the other thread (general design questions), so let's discuss
it there.

Cheers,
	Simon

--d01dLTUuW90fS44H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDlN5QACgkQrzg/fFk7axYdBgCeOjoA3q2b1GuBrxIt8OqRuEt/
f8oAn17Mz042A6WnBlqFRnDt2kDWeesb
=uNy+
-----END PGP SIGNATURE-----

--d01dLTUuW90fS44H--
