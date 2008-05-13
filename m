Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013AbYEMInC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 04:43:02 -0400
Subject: Re: mac80211: Set IEEE80211_TXPD_REQ_TX_STATUS for all TX frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200805111434.19071.IvDoorn@gmail.com> (sfid-20080511_142412_637229_86D61583)
References: <200805111434.19071.IvDoorn@gmail.com>
	 (sfid-20080511_142412_637229_86D61583)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wgR77lKuk6Hdev/Bsn6B"
Date: Tue, 13 May 2008 10:42:51 +0200
Message-Id: <1210668171.3646.41.camel@johannes.berg> (sfid-20080513_104307_501535_B1111C41)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wgR77lKuk6Hdev/Bsn6B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-05-11 at 14:34 +0200, Ivo van Doorn wrote:
> All interfaces should set the IEEE80211_TXPD_REQ_TX_STATUS flag for all T=
X frames
> which will force the master interface to set the IEEE80211_TX_CTL_REQ_TX_=
STATUS
> flag. This in turn will allow drivers to check for that flag before repor=
ting
> the TX status to mac80211.
>=20
> This is very usefull when frames (like beacons, RTS and CTS-to-self) shou=
ld not
> be reported back to mac80211. Later we could add more extensive checks to
> exclude more frames from being reported, or let mac80211 decide if it wan=
ts
> the frame for status reporting or not.
>=20
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index f35eaea..0024892 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1617,6 +1617,9 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	if (ethertype =3D=3D ETH_P_PAE)
>  		pkt_data->flags |=3D IEEE80211_TXPD_EAPOL_FRAME;
> =20
> +	/* Interfaces should always request a status report */
> +	pkt_data->flags |=3D IEEE80211_TXPD_REQ_TX_STATUS;
> +

What about monitor interfaces/injection? Do they already set it?

Other than that, looks good to me, as long as you're aware that in the
future this might be more dynamic and don't rely on it too much for
internal housekeeping (but you seem to be according to your changelog
entry) :)

johannes

--=-wgR77lKuk6Hdev/Bsn6B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASClUiqVg1VMiehFYAQIMfg/9Fw/TJ5sdblPIxbyMabFV4LkMO96JAiSF
RnEcyp7hlODQXLf7Ze2y1YAYmU3fPzjzeliQtutU8ccC4xhBANumnhS0vzSzffbN
WyCzrGa5Qn6Sf/UgtnHzpUoDtie8547YQcmJdN31qAMNZQApApIFNRK/IQzs4xa2
upw8u1gQxk4UAGNM9G7l8gQbcY2wLBUiUoseGRAZFEd0LvcdqhPRRib3XiPaEjqR
cc/3ePM6QqTgPwabRSH6xyuxyv5oW755TQ3G5ptfefyyHRyCG/qk99d7U1RgG+Sn
86WhZ6mmKXSAs/Bae3PO0WNbOPY8lFQuiwksHDd8P1r8MAKW2YABCt1wHdEMYZkS
Js7pK7lrsD9YjhPPAgeFvbAXqJz39lK8DtgAepfOIgI3pXmMkUtnKgZkc+wcsaqw
Zp3tLDopmxno3wX3UHkITjuyuoIf6AGpOQlCdd+I1pDmuxhUG7IoAVrH7cLDWL/h
JEvQNzExrA9odmkbxAkcinazZXllSIEQRNzRlLkyXluqcOT6wlRpJEePIZI3g4PQ
T/5KB2Dizqy0wdRZJlR0NP0iE3H5WNo/4+idkMb1br8DGtaced+zONRqhXcnnRma
SrdPqce27RwzdJz8mYmfQzFzSukAgclXG5kXlbyJou2K5YB/wwzU5NvpQKifQyWl
9dXNbOUixGg=
=ujuP
-----END PGP SIGNATURE-----

--=-wgR77lKuk6Hdev/Bsn6B--

