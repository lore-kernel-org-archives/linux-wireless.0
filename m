Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763541AbZDBPCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 11:02:42 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49D4CF50.2060100@lwfinger.net>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oIowGumMasmKjuBKZnhC"
Date: Thu, 02 Apr 2009 17:02:07 +0200
Message-Id: <1238684527.4141.63.camel@johannes.local> (sfid-20090402_170309_941471_1472BFB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oIowGumMasmKjuBKZnhC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 09:44 -0500, Larry Finger wrote:

> > Can you check the contents of
> > 	/sys/class/leds/b43legacy-...::radio/trigger
> > please?
>=20
> The first thing I noticed is that "radio" gets truncated to "rad", thus t=
he file
> is /sys/class/leds/b43legacy-phy0\:\:rad/trigger,

Cute. Must be that the limit is 20 bytes (19+NUL) in the buffer it uses
in led core code.

>  with contents "none ide-disk
> ADP1-online BAT0-charging-or-full BAT0-charging BAT0-full phy0rx phy0tx
> phy0assoc phy0radio [(]". I unloaded and reloaded the driver and found th=
at the
> "[(]" characters changed to "[=EF=BF=BDW[=EF=BF=BD]". It appears that som=
ething is putting
> garbage in that file.

Ouch. That's bad. I'll try to figure it out. I don't see how my patch
changes this -- does this happen without my patch too?

johannes

--=-oIowGumMasmKjuBKZnhC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1NNsAAoJEKVg1VMiehFYbbAP/3hgUXqWHWjE6NCPKrNRqw1b
bUxBQ0VEbT0JOEchRp8wTL9ZwaZLLbtmRBwHzNdy5OqSWr8soJW9BFIMn7HQzuvU
h3ilJZg1ggEqdNhttj4T4bpdnGYqrUOW2PXEjx1VRlSMJdc5ECuMiReAwKPBUAME
2+jZVSHi9WsLpCs7UlNxTYb8S8mcNzs06q/1czy7VQX4+6OKodzKm3oJ4hMNJ4rO
E1SfUN/w37cfMXuiezhrapGUFFphKC9Gk/Sm0nMyW7VxsDGZH+hiw39XOE51JWmA
YrHGuuluAr9eFu/psK4PhaxkWgrTQvjeoHcgRoCvxE+XRovhgDX9ClKZ+gk7L3XG
JPI+Tmfvss6FCyT5U23OnJU+WTL/Ne+6C6vICulrpoRL2pdoD+CJE9YV+ewQOrI0
Js9RGs4FcB74z0X7bFekSnkHxjZrWnNFKXlxuxNDSPaxHdbodOEa2ZqT2jtpdDQB
UAWV/jb1uIOjSrt9aCEQBLqGGAJLX60tdsPattRmxBizSjZLRMye13yJ6CwIn/58
JTTPKa70WcMYuCIGaAng2pbHukW4ahPLR4OQSmOGjg28nYbPeYkT7dQHA9gG1XeG
uVL3HnQn1TtGGvMYeipp/KBvSAGmgRBL9LQUsdbThefe5O8vNTO6i0P9fhomxxxT
C18TH+mTVFfu+R2J7bXt
=jMmV
-----END PGP SIGNATURE-----

--=-oIowGumMasmKjuBKZnhC--

