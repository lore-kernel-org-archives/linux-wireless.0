Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZJAIqe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 04:46:34 -0400
Subject: Re: driver_nl80211 broken again
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090930221353.GB11052@jm.kir.nu>
References: <1251117161.22951.4.camel@maxim-laptop>
	 <1251122885.12007.12.camel@johannes.local>
	 <1251144381.9374.4.camel@maxim-laptop>
	 <1251147515.20161.3.camel@johannes.local>
	 <1252116503.2398.26.camel@maxim-laptop>
	 <1252423769.3806.4.camel@johannes.local>
	 <1252443260.16422.5.camel@maxim-laptop>
	 <1254273569.4499.8.camel@maxim-laptop>  <20090930221353.GB11052@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8pVDPkQx3vXYe64LsLlN"
Date: Thu, 01 Oct 2009 10:46:26 +0200
Message-Id: <1254386786.3959.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8pVDPkQx3vXYe64LsLlN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-01 at 01:13 +0300, Jouni Malinen wrote:

> > @@ -1302,8 +1302,10 @@ void wpa_supplicant_disassociate(struct wpa_supp=
licant *wpa_s,
> >                         wpa_drv_disassociate(wpa_s, wpa_s->bssid, reaso=
n_code);
> > +                       wpa_drv_deauthenticate(wpa_s, wpa_s->bssid, rea=
son_code);
>=20
> To me, this looks broken. When wpa_supplicant requests a
> disassociastion, it is _only_ asking for disassociation, not
> deauthentication. cfg80211/mac80211 may not currently handle that, but
> as far as I can tell, it sounds like an issue there and not in
> wpa_supplicant. Johannes may disagree with this, though.

cfg80211/mac80211 _do_ handle that. If you ask for disassociation, it
stays authenticated, and later expects you to still remember that and
refuses authentication since you're already authenticated.

> I don't think either of those options would be acceptable for
> wpa_supplicant and the correct fix is to make cfg80211/mac80211 be able
> to handle authentication to a STA that is already authenticated. If
> that is not acceptable, this hack needs to be hidden in driver_nl80211.c
> instead of polluting core wpa_supplicant code which is supposed to be
> driver independent. In other words, make driver_nl80211.c deauth if auth
> fails and then try auth again. I don't really like that much, but if
> this needs to be worked around in wpa_supplicant, that is the most
> likely place where such a change could be considered.

I still don't see how it makes sense to authenticate while still being
authenticated.

johannes

--=-8pVDPkQx3vXYe64LsLlN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKxGxdAAoJEODzc/N7+Qma21EQAMXNsvnZwDv4mzwj/6g8FLle
QxmQ6TmuW7ekuAzER+tTnARgVIkuSp/jkjX1fyIBUyTk5ji/t3QPHcipwaw9n/LL
ks8ho6huwlIA5A1QL82a3mKpHKSK5/3QRgeNjkd7GJ3jZbNSCBDpIXJNrXmRaD0Z
FXIpH+yBg6dnvHbZZo/r1MqMCz5zwJ+zczLKMZNZKp3tSzDzS6zRfiBtEPYYjY2q
mwmCJfZZcjiV/1Qak7tzEt3YYEIKXa91Q4towrD76/UvoNprfQmjZ4EdFRL/gq5q
wDrHM+6NPjCui/T0K6hjp4kjg7T0lvkp60JsqeLqPftPfxyo0SyY0+OxaZpaUiJ5
sepEvS44qitwvd+ZE6i1eZ6bI5v6YSOJFUZuwD0qj8swKa97qikk+5nnujgdjyzz
lQmgKnUQS7bCGOhrZI+C1pilAvAFdrcFBYr2ymMLy+C8/BHb4uV8VKGvy18Y1zqT
fDzhFqLnPLynxnjNnlgSCrZCujpXLrQyVySJvM3rY4bM2aZDP5jVOkAiGjeO1xmL
9crljDj/Z6P9Tk6CgSkVQbWhghjZ4luR8nbXSNWAlKcRUP4L91aYa2iQVJ7Q01+3
tXxNeuIW1AwwUV+GSqc50qy77sFRwBYd9lBAWm9y+BratvthUVbU94PcqmPBDgTs
VCrNzZ5vwoGYoT4W5EXI
=IqCQ
-----END PGP SIGNATURE-----

--=-8pVDPkQx3vXYe64LsLlN--

