Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36213 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbYIQLS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 07:18:58 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: "\"Adam" =?ISO-8859-1?Q?C=E9cile?= "(Le_Vert)\""
	<gandalf@le-vert.net>
Cc: Jochen Friedrich <jochen@scram.de>, linux-wireless@vger.kernel.org,
	Thomas d'Otreppe <tdotreppe@aircrack-ng.org>
In-Reply-To: <48D0E5CE.8050401@le-vert.net>
References: <1221596962.9262.12.camel@johannes.berg>
	 <48D0DEF0.2060407@scram.de> <1221648205.9262.48.camel@johannes.berg>
	 <48D0E463.70008@le-vert.net> <1221649638.9262.50.camel@johannes.berg>
	 <48D0E5CE.8050401@le-vert.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nQoJl5VatQUhUYEVt83V"
Date: Wed, 17 Sep 2008 13:18:06 +0200
Message-Id: <1221650286.9262.57.camel@johannes.berg> (sfid-20080917_131902_131893_ED5266A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nQoJl5VatQUhUYEVt83V
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-17 at 13:11 +0200, "Adam C=C3=A9cile (Le_Vert)" wrote:

> Why not having a talk with aircrack-ng main developper ?
> I'm sure he would be happy to work with you and avoid having a patched=20
> version of iw.

Because I have no idea who to contact and figured that they'd notice
quickly enough? :)


Thomas, since people seem to be relying on iw more and more (I had been
hoping somebody else would take it and transform it into something
usable) I have gone ahead and cleaned up the code, made a few
modifications to it and released it as version 0.9 (and a few 0.9.x
fixes, my bad).

There are two changes that might interest you:
 * removing interfaces now works like this:
     iw dev monitor0 del
   I didn't feel inclined to keep the old syntax because it's rather
   ugly but if this is a big problem for you I can add a hidden command
   so you can continue doing "iw dev monitor0 interface del".
 * if you've been using
     iw dev wmaster0 interface add monitor0 type monitor
   this will stop working in future kernel releases, the master
   interface really is no good for actually configuring wireless and we
   want to get rid of it completely in the medium term. I suspect you
   have been using
     iw dev wlan0 interface add monitor0 type monitor
   which will continue to work.

johannes

--=-nQoJl5VatQUhUYEVt83V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0OdqAAoJEKVg1VMiehFYpsgQAKOwxE1IhnfkCh0prIaDD0WC
VivXYq2jU6pOINe30ccYnAxyZmbaxKYVvD05LMq+Q9IuNzLVdNsL0HUccEsPdkQe
V1rQALzTPkaLE6OLFi1pC8S1lthIKrWkNJbygaBk3eqT3thXVPr7q5W90SZLSTnS
WxhoXFbc1jeYz6m2WVywej3OpN6kBaMcsz19KOQJHZQVS771Fme95TN7ED1JwzZb
hb7Pt+OOKf93vrc7dKbbl91PEctxOtPrag8PveLYUztA+eqi3207bbq5649UI+fv
wiR/Ab8vChbzB7MluDHcyJsDaoYkeKXQu+gZc74UISJ3TI5AnvP8gdI4P2mv8SxS
+x8uIIn6/rp6DyMJUaTtKBiX9qQD94n7V/PCWLLUImXkiOhEefHqE2v3E9P7pboP
V52LDBzf9ub9Igl3wq/tqzPminQGCCqtZVIcd+yYDPrMUyaR3swEweK7nZI6sivx
H/CJAjnotXUMBb5wtBJ5tEi3ztIvtPpcLaxs1AH9Uca0D+5bJAS/4W60vB632tmW
pZGbbPcGGSVr3yVBGmTKZLrJr5M1ZyLFCO/B9xKD5vyW2zvBOHoTynYl25sGGhK6
XXt9qlvAyggGjWVV54OKG8Z80dbBRGlmy0NTNvdxQol5MaaHygMXHSXHaC0espgS
VhXtmyCzSU65OPikaVkH
=a6jb
-----END PGP SIGNATURE-----

--=-nQoJl5VatQUhUYEVt83V--

