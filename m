Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:59966 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab2AJR2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 12:28:36 -0500
Date: Tue, 10 Jan 2012 18:28:32 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCHv2 2/2] mac80211: add support for mcs masks
Message-ID: <20120110172832.GA19790@pandem0nium> (sfid-20120110_182840_143744_91785B3C)
References: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1325793490-21501-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1326114294.3451.25.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
In-Reply-To: <1326114294.3451.25.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Johannes,

On Mon, Jan 09, 2012 at 02:04:54PM +0100, Johannes Berg wrote:
> On Thu, 2012-01-05 at 20:58 +0100, Simon Wunderlich wrote:
>=20
> > +static bool rate_idx_match_mcs_mask(struct ieee80211_tx_rate *rate,
> > +				    u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
> > +{
> > +	int i, j;
> > +	int ridx, rbit;
> > +
> > +	ridx =3D rate->idx / 8;
> > +	rbit =3D rate->idx % 8;
> > +
> > +	/* sanity check */
> > +	if (ridx < 0 || ridx > IEEE80211_HT_MCS_MASK_LEN)
> > +		return false;
> > +
> > +	/* See whether the selected rate or anything below it is allowed. */
> > +	for (i =3D ridx; i >=3D 0; i--) {
> > +		for (j =3D rbit; j >=3D 0; j--)
> > +			if (mcs_mask[i] & BIT(j)) {
> > +				rate->idx =3D i * 8 + j;
> > +				return true;
> > +			}
> > +		rbit =3D 7;
> > +	}
> > +
> > +	/* Try to find a higher rate that would be allowed */
> > +	ridx =3D (rate->idx + 1) / 8;
> > +	rbit =3D (rate->idx + 1) % 8;
> > +
> > +	for (i =3D ridx; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
> > +		for (j =3D rbit; j < 8; j++)
> > +			if (mcs_mask[i] & BIT(j)) {
> > +				rate->idx =3D i * 8 + j;
> > +				return true;
> > +			}
> > +		rbit =3D 0;
> > +	}
> > +	return false;
>=20
> All this logic is pretty complex, maybe we could translate the bitmap to
> an array of unsigned longs and use test_bit() instead of open-coding it
> for 8-bit words?

Mhm, I would rather not add further copies into this fast path function, and
simply casting will result in bad behaviour (alignment, endianess). General=
ly
changing the mcs_mask to u32 is possible, but then we have inconsistent mcs
fields (rx_mask and others are u8 arrays too) - do we want this? Or am I mi=
ssing
something obvious right now? :)

Maybe we can simplify it to something like this:

for (i =3D rate->idx + 1; i < IEEE80211_HT_MCS_MASK_LEN * 8; i++) {
	ridx =3D i / 8;
	rbit =3D i % 8;
	if (mcs_mask[ridx] & BIT(rbit))) {
		rate->idx =3D i;
		return true;
	}
}

What do you think?

Cheers,
	Simon

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8MdUAACgkQrzg/fFk7axYxyACePLRhAIijy/GPSp7awBHGR6AQ
RHIAnAp/J2aDKmIFz6STNC0psFwxrPjQ
=FiR6
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
