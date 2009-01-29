Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZA2Sc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 13:32:27 -0500
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic
	power	save mode is disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "vivek.natraj@gmail.com" <vivek.natraj@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4981F232.5000801@nokia.com>
References: <20090122114240.31443.18218.stgit@tikku>
	 <20090122114546.31443.79387.stgit@tikku>
	 <1232643729.5819.3.camel@johannes.local>  <87hc3jgyu9.fsf@nokia.com>
	 <1233168737.4811.18.camel@johannes.local>  <4981F232.5000801@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FgO8b4/cwfHxLsztB2Vl"
Date: Thu, 29 Jan 2009 19:32:21 +0100
Message-Id: <1233253941.4067.2.camel@johannes.local> (sfid-20090129_193230_748454_C5D859F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FgO8b4/cwfHxLsztB2Vl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-29 at 20:15 +0200, Kalle Valo wrote:

> > No, I mean in the timeout > 0 case, what vivek mentioned too. We never
> > go back to sleep unless we send a packet.
>=20
> First of all, this patchset doesn't change the logic for timeout > 0=20
> case. But that case was working already earlier, here's my analysis:
>=20
> 1. tim bit is set
> 2. if timeout > 0 disable power save and send null frame
> 3. null frame enables dynamic_ps_timer in ieee80211_master_start_xmit()
> 4. after dynamic_ps_timer triggers, power save is enabled again
>=20
> I understood that this was the reason why Vivek moved the running of=20
> dynamic_ps_timer from subif to the master interface. Or did I miss=20
> something?

Hah, no, you're right, sorry, I got confused.

johannes

--=-FgO8b4/cwfHxLsztB2Vl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgfYzAAoJEKVg1VMiehFYmd0P/RgzZAPm+iQnWd6d40Y0Kio5
JztJutFDCtrhIw+z257sY2eaD9nesrY0Pj2+VRR0gvAbBfEd36m93H2y3oKlhhuN
uS4yd0Akfq08fW9XuTivjUHBXyWqcCsKNlhhG7CwswPgCQXkSYFwsG0h2CF0yQGq
JNeCF7cPdZloPqPvFVV5Lp0eeM5T5R48MXJvi7o+/zbRHbwKtpyAyF/igUE+sbLS
i7kD2TPN+4VSiIYoaYalOTpudtJlPCtb4EyJ6qxQ7GNyxrK0goA8eVswH2tGHoJt
Lq9HiB3D9qHkfP2KsSU3ebhIm3OPBFI8ENv3LuQsu2JzfjMSp4dyEonHYoK1aUA7
OLBzqEDFo5fe/0uLc0TIUicRHL88zRi8pWqO50B71hqZDp5+/wBUg7ND+dFzzHKd
22+3VlkE/mcZRba3Rd6rcVWJ8A3S/efDMic2nkXxdfZgqtHUIhUI6gHgpRRuxDAY
SRDAuEg4UQ0nvl2F6wk+kmDSnKtA87Nt014wk3JFsLK+geoRXJn5lh2mu+WDb6cI
wr2SlzXiwRmyTs4hMW8BhQGBgkE5F8H6CwVBJTGy/UcK8hQn7DDLbnY+HeIwtq3y
QwE8SX2DeGGMyGcZYEEanICWVNSo1UAaGZoshhUPaFpR++cXZPb4uKMzKurSVcP+
MxyYpycg8SKa6/6FpKx6
=pdYd
-----END PGP SIGNATURE-----

--=-FgO8b4/cwfHxLsztB2Vl--

