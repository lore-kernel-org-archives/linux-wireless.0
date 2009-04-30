Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbZD3N4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 09:56:14 -0400
Subject: Re: rt73usb Access point status
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <557754.25367.qm@web51403.mail.re2.yahoo.com>
References: <557754.25367.qm@web51403.mail.re2.yahoo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1guS6h3QwpnMLTtdFl1/"
Date: Thu, 30 Apr 2009 15:55:41 +0200
Message-Id: <1241099741.29878.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1guS6h3QwpnMLTtdFl1/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-30 at 06:41 -0700, Joerg Pommnitz wrote:
> > Based on that information, I have removed the "Yes (under development)"
> > note from the driver page since it doesn't really support it... In fact=
,
> > I'm surprised it works even with that hack since hostapd usually polls
> > the station with nullfunc frames and waits for an ack.
>=20
> Reading the mail from Ivo (http://sourceforge.net/mailarchive/message.php=
?msg_id=3D200808082059.11968.IvDoorn%40gmail.com)
> I gather that the ACK in question is not from the peer but from the local
> hardware indicating that the frame was actually sent and not lost due to
> some local error.=20

No, the ACK in question is this one:

local			remote
   --- nullfunc frame --->
   <------- ACK ----------

Apparently rt73usb is incapable of telling the driver that it got this
ACK frame, and as such hostapd will not be informed about that, and then
it will expire the station if it's otherwise idle.

johannes


--=-1guS6h3QwpnMLTtdFl1/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+a3XAAoJEKVg1VMiehFYrkEQAJk+ZG+VTF6FanC3b5MYfk6I
cZAycRFX32pfwGp0L9/inwCCejT8NzjKSX/UFHazBdyQgR/nLvMkP+FuH+a/UWFV
fseGwQrQA7ycaw3K3HNFUE1iFvtMJuxxekHoa8qcUTinh9ILtZdMc7r0RrwlnRJ0
UjTTobRCovJ2iWJ36CvBb16Uexjgzn60zOzC3R658cF+5iKPEonVTaqAiRZZuvHk
p3bWaItjnWpV0FooHWjshDyHSJyfpPMT3fM92pfzG78sAlNiCpUfosNjaR0uKqs2
th/gYKBsKyH/mbIvTXSHyNtIovqfTLbJfWWfZqvNO7kmjfCH0eyhkapS+bWP/b6+
PYK0L547U+eYypUpPgKu0Y91NIxNcJwVU4yTBnRi0/l0BJ8whnxUmr0/6N68hrhA
vhKzhyaKj1vgXDGpHSbFxhWWgmJw/WGvrKD8mwrCykk3wLjmCFi8KPbTVNFTLNvn
6xBMH3mhUeL+E1zX7rsA0q44krwIEO2dl1fCTdYkLjxBIKhJAde9af/DRjGmm4AR
cSqEPoldlVp0TwSX21veVzdokOHAKXhTFtVFW+0TplCOwVZHqbHlMXCy33Fruh6A
o18VwgNgm5NZ2JBGzU4scgJ2eSC8TT/04CyLaWiaxpP5EQWl4zeA6lkJRejxY4QF
MxDb9GuXnwo/tHlIskcd
=erRu
-----END PGP SIGNATURE-----

--=-1guS6h3QwpnMLTtdFl1/--

