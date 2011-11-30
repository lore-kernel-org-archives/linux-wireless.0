Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:55181 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab1K3M1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 07:27:36 -0500
Date: Wed, 30 Nov 2011 13:27:31 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH 2/4] nl80211: Parse channel type attribute in an ibss
 join request
Message-ID: <20111130122731.GA14283@pandem0nium> (sfid-20111130_132739_726474_4FA09113)
References: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1322502917-28205-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1322655406.3982.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
In-Reply-To: <1322655406.3982.12.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Johannes,

On Wed, Nov 30, 2011 at 01:16:46PM +0100, Johannes Berg wrote:
> On Mon, 2011-11-28 at 18:55 +0100, Simon Wunderlich wrote:
> > Prepare cfg80211 for IBSS HT:
> >  * extend cfg80211 ibss struct with channel_type
> >  * Check if extension channel can be used
> >  * Export can_beacon_sec_chan for use in mac80211 (will be called
> >    from ibss.c later).
>=20
> I'm thinking there should be a "driver supports HT IBSS" flag, and we
> reject the config otherwise?

There is already an implicit check for this - rdev_freq_to_chan() checks
if the channel_type is supported, and -EINVAL otherwise. So if I call=20
ibss_join with HT20 or HT40 on ath5k, it gets rejected already.

If this is not enough and we need a further flag, could you please give
me a hint how/where to implement it?

regards,
	Simon

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7WITMACgkQrzg/fFk7axYhpwCfQ3q2qvWqB8rP8XashyiSGwhq
hIoAnRxzYeeEvIpur7AasqSfZY8jp4ds
=prR8
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
