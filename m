Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43732 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYEAKpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 06:45:53 -0400
Subject: Re: mac80211 truesize bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080501.033221.193705040.davem@davemloft.net>
References: <1209635299.4008.21.camel@johannes.berg>
	 <20080501.025635.216053297.davem@davemloft.net>
	 <1209636494.4008.24.camel@johannes.berg>
	 <20080501.033221.193705040.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gmfiKpb7HG1wU42IwC2F"
Date: Thu, 01 May 2008 12:45:13 +0200
Message-Id: <1209638713.4008.32.camel@johannes.berg> (sfid-20080501_124541_234907_E0328AFC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gmfiKpb7HG1wU42IwC2F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-01 at 03:32 -0700, David Miller wrote:

> Right you are.
>=20
> So, I wonder what's causing the problem...  Could you "remember" the
> length and truesize at the skb_orphan() point in mac80211, right
> after the skb_push(), then in the truesize warning, print those
> "remembered" values as well as the current ones.

I was just playing with af_packet and added some debugging there that
prints out the len of all packets it gets (for a certain ifidx)

That's confusing me even more now. I get

[ 7650.792004] packet_recv eda9e8c0 (len=3D137)
[ 7650.792015] snaplen(eda9e8c0)=3D137
[ 7650.792027] free eda9e8c0, len =3D 137
[ 7650.792031] new skb: eda9e540
[ 7650.792039] packet_recv eda9e8c0 (len=3D137)
[ 7650.792044] snaplen(eda9e8c0)=3D137
[ 7650.792048] new skb: eda9e8c0
[ 7650.819464] packet_recv d1f4e9a0 (len=3D124)
[ 7650.819478] snaplen(d1f4e9a0)=3D124
[ 7650.819489] free d1f4e9a0, len =3D 124
[ 7650.819493] new skb: d1f4e8c0
[ 7650.819502] packet_recv d1f4e9a0 (len=3D124)
[ 7650.819507] snaplen(d1f4e9a0)=3D124
[ 7650.819511] new skb: d1f4e9a0
[ 7651.215631] packet_recv e9ecc2a0 (len=3D376)
[ 7651.215645] snaplen(e9ecc2a0)=3D376
[ 7651.215657] free e9ecc2a0, len =3D 376
[ 7651.215662] new skb: ede04b60
[ 7651.215671] packet_recv e9ecc2a0 (len=3D376)
[ 7651.215675] snaplen(e9ecc2a0)=3D376
[ 7651.215680] new skb: e9ecc2a0

[ 7651.760751] SKB BUG: Invalid truesize (528) len=3D357, sizeof(sk_buff)=
=3D176


528-176 is 352 which doesn't occur in that list... Maybe I should print
it in mac80211.


johannes

--=-gmfiKpb7HG1wU42IwC2F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBmfOKVg1VMiehFYAQKQpg//Z9t1bgHdH1mIqnDO8X+fBbCoZX4WMIhz
jsKFvc1EYuNeI9Rsg06/aY5iMmwTra+6rBiBhdTPE0gEyOa04cipXrvZnLm/jLD6
/cTXS1hw+tgtxYt2hzu1LBSBY7ksUQdWLZ9xJZ7VLbLjHrbDIyRcHchM5C2Qbv+S
3PdeEAukm+1xiRwtZUu2s+44dYMpIqii01E/vhmVACBJ3ZoePOxmuGdyat4D0YCv
Vxn6KaQeXgnvN5GkAwUnBOpCZint73bnlKBWr66yXJIxKRDTq4oaB3dReuTT8KsZ
pePV4XKDfgyNu8i5NibLZfg+ihaYHsMBBQRus18HybLrgn54tyBh6ck5hJdlS0BO
vG66PmzYXRDsQzamajKilaBBt1s3Yqn3zp87cgqYFu6Obx6M9G7tgkZn8957Wuz/
3TCRGmeG62KdwSCg21nr+nBlkXia3ZDJypI/EcwEMykDsQMH1vysWzSanpnXppJI
YYkDbF1Et/ncWpza0mpchJF06ZLaE5JVvdTPPqCXWF+JRv0yggQy0RUCHB+NEAL8
Oc6z97s5NdQmOacTWQ3cUxAFoPQKPBR3MxbPODUN9OE4USLSzlZScx+75YUiHth2
UiFhyneNa6E4hOXRegDCfjzLHHQXE518nqWlRaC1bZNSGI4tMW3MhZSaz3lhKakp
pZeMBEFMMyc=
=Apgk
-----END PGP SIGNATURE-----

--=-gmfiKpb7HG1wU42IwC2F--

