Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab0A3Va3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 16:30:29 -0500
Subject: Re: Regression in b43 with BCM4311/2
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4B64A2F2.6060608@lwfinger.net>
References: <4B64A2F2.6060608@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-C6FkckHCcwMCbF6XyPMY"
Date: Sat, 30 Jan 2010 22:30:27 +0100
Message-ID: <1264887027.3546.207.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C6FkckHCcwMCbF6XyPMY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Larry,

> commit c7ab5ef9bcd281135c21b4732c9be779585181be
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Wed Oct 29 20:02:12 2008 +0100
>=20
>     b43: implement short slot and basic rate handling

> It seemed unlikely that the short slot handling was the cause, thus I hav=
e
> concentrated on the basic rate handling. I found that the returns from
> ieee80211_get_response_rate() were not what I expected. I'm not sure the =
routine
> is correct; however, the value for "brates" at entry to b43_update_basic_=
rates()
> is 0xF, thus only the CCK rates are enabled, but sband->n_bitrates is 12,=
 which
> includes all the 802.11g rates.

It doesn't really depend on your supported rates, if your AP says that
only CCK rates are basic rates (you can see that in iw scan output, they
are marked with a *) then they need to be used for response frames, as
per 802.11-2007 9.6 paragraph 7:

        To allow the transmitting STA to calculate the contents of the
        Duration/ID field, a STA responding to a received frame shall
        transmit its Control Response frame (either CTS or ACK), other
        than the BlockAck control frame, at the highest rate in the
        BSSBasicRateSet parameter that is less than or equal to the rate
        of the immediately previous frame in the frame exchange sequence
        (as defined in 9.12) and that is of the same modulation class
        (see 9.6.1) as the received frame. If no rate contained in the
        BSSBasicRateSet parameter meets these conditions, then the
        control frame sent in response to a received frame shall be
        transmitted at the highest mandatory rate of the PHY that is
        less than or equal to the rate of the received frame, and that
        is of the same modulation class as the received frame. In
        addition, the Control Response frame shall be sent using the
        same PHY options as the received frame, unless they conflict
        with the requirement to use the BSSBasicRateSet parameter.
       =20

Then again, if I read that correctly, we should be checking the
modulation classes, will have to take a closer look at 9.6.1.

> Is b43 missing something needed to set the basic_rates member of struct
> ieee80211_bxx_conf to a more reasonable value when b43_op_bss_info_change=
d() is
> entered? I think it should be 0xFFF, not 0xF. I have tested with the larg=
er
> value and found that this change did not improve transmit rates.

So you're saying it doesn't help anyway?

johannes

--=-C6FkckHCcwMCbF6XyPMY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLZKTwAAoJEODzc/N7+QmauAYQAJd8uuNFBheHwM3c9uZTLcVI
+uxag0svNmnvqqGFEIPQRK/zVFpsuGURXSj4Ed+hsG3jOiK+dvb11W0czB86SBDA
L0CQdEgnc8ro0im6Ct2vDGhKsaDjSRP/Ph/G0Pq3D3NlYREw5fxQ7l5frSJ0QR8T
ROw/V/FtP3/m9cx3HRBt2bUzLGpkz/hsHNAApZQbdLKrS+bRXtcf+5v7XFipUbbW
ctXaSyd95yPwuIwuLMdYfQ/hEjJgK/zhAS0WWfsGXuB0Sv0JpcG1kSL6oECGwj1a
G1BluFoFatjSZRhEKNVuidNdvQ6ZeTpRdo4+EN+lM3sEuAeB87d6GqZkgFnutXhA
gDhhNrNwx/6h7ANH1j6tOiiSiIhDfSb2UzndoRVZ3snytEIBJQUjXWL/IqiY6Uiw
JUa4CGbbDoPwBncvDjhfYoxiiIKV7clu4WDAR2uRJzlapkodKZnD0pLgiYxTsUOU
YmrWqqyWM629/uJrVgH7CQ1xRxeL2Rl1dW4u3A4poiOacUcCYO4Hx5vd75sVFp2H
iUBwk9xuwz4MJgGYrav2FT59gOeETq84BbhTkMuoLQAvJtuxWy18Jg2nMy3euPgx
rSwfAA7zFmtHFJ0ghKx3VlblbVfYGn4KI0p8wkJTFwcmvOsd/U397C+i+et5P2oQ
0e5IYlSAnndKBKD+8uNq
=ZZcB
-----END PGP SIGNATURE-----

--=-C6FkckHCcwMCbF6XyPMY--

