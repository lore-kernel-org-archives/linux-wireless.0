Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:56058 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1KRMbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 07:31:00 -0500
Date: Fri, 18 Nov 2011 13:30:54 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCHv3 3/3] mac80211: Add NoAck per tid Support
Message-ID: <20111118123054.GA32175@pandem0nium> (sfid-20111118_133104_866621_E61ED731)
References: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1321614110-32392-4-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1321614744.10266.37.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
In-Reply-To: <1321614744.10266.37.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18, 2011 at 12:12:24PM +0100, Johannes Berg wrote:
> On Fri, 2011-11-18 at 12:01 +0100, Simon Wunderlich wrote:
>=20
> > -		if (is_multicast_ether_addr(hdr->addr1))
> > +		if (is_multicast_ether_addr(hdr->addr1) ||
> > +			(sdata->noack_map & 1 << tid)) {
>=20
> I'd prefer this:
>=20
> 		if (is_multicast_ether_addr(...) ||
> 		    sdata->noack_map & BIT(tid))
>=20
> (Note indentation & use of BIT())

OK

>=20
> Isn't this missing an update to ieee80211_duration() now?

Yep, I silently dropped that modification - I rather don't mess with stuff I
don't completly understand. Keeping the duration too long shouldn't hurt
(only performance), having it too short will have much worse effects ...

Thanks,
	Simon

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7GT/4ACgkQrzg/fFk7axZ0ZwCghsdnlRb1omYU+htHpTdco7yl
lVoAoN1wYaqwPDs8VW2JfFlZhBXG/326
=Z824
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
