Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbZJCFwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2009 01:52:49 -0400
Subject: Re: driver_nl80211 broken again
From: Johannes Berg <johannes@sipsolutions.net>
To: Trepak Vilmos <trepo@netcomga.sk>
Cc: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4AC67144.5060508@netcomga.sk>
References: <1251117161.22951.4.camel@maxim-laptop>
	 <1251122885.12007.12.camel@johannes.local>
	 <1251144381.9374.4.camel@maxim-laptop>
	 <1251147515.20161.3.camel@johannes.local>
	 <1252116503.2398.26.camel@maxim-laptop>
	 <1252423769.3806.4.camel@johannes.local>
	 <1252443260.16422.5.camel@maxim-laptop>
	 <1254273569.4499.8.camel@maxim-laptop>	<20090930221353.GB11052@jm.kir.nu>
	 <1254386786.3959.18.camel@johannes.local>  <4AC67144.5060508@netcomga.sk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8/FoOyLja1T7v0ft0szv"
Date: Sat, 03 Oct 2009 07:52:42 +0200
Message-Id: <1254549162.3959.77.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8/FoOyLja1T7v0ft0szv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-02 at 23:31 +0200, Trepak Vilmos wrote:
> Johannes Berg wrote:
> > On Thu, 2009-10-01 at 01:13 +0300, Jouni Malinen wrote:
> >> To me, this looks broken. When wpa_supplicant requests a
> >> disassociastion, it is _only_ asking for disassociation, not
> >> deauthentication. cfg80211/mac80211 may not currently handle that, but
> >> as far as I can tell, it sounds like an issue there and not in
> >> wpa_supplicant. Johannes may disagree with this, though.
> >
> > cfg80211/mac80211 _do_ handle that. If you ask for disassociation, it
> > stays authenticated, and later expects you to still remember that and
> > refuses authentication since you're already authenticated.
> >
> >> I don't think either of those options would be acceptable for
> >> wpa_supplicant and the correct fix is to make cfg80211/mac80211 be abl=
e
> >> to handle authentication to a STA that is already authenticated. If
> >> that is not acceptable, this hack needs to be hidden in driver_nl80211=
.c
> >> instead of polluting core wpa_supplicant code which is supposed to be
> >> driver independent. In other words, make driver_nl80211.c deauth if au=
th
> >> fails and then try auth again. I don't really like that much, but if
> >> this needs to be worked around in wpa_supplicant, that is the most
> >> likely place where such a change could be considered.
> >
> > I still don't see how it makes sense to authenticate while still being
> > authenticated.
>=20
> The client might have lost state info (rebooted, etc.). Let it redo the
> auth if it wants to, deauth if it fails.

In case you haven't noticed, we're talking about the client
(wpa_supplicant) :)

johannes

--=-8/FoOyLja1T7v0ft0szv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKxuamAAoJEODzc/N7+QmaU1UQAMTpUEBi1fyYRAk5Z9wdSd8t
YyRHsh3L8DlBrhR0g72ofW2Wi2+5br+wrCjfmkqi5VRd5DzhnKqxBw/EiUTbJBFE
RXRANRupA1slW8+6cXeLwJ6uVso+bpYNLjPBDgtHwcm2azH4Ujoel7gDMmfIRal6
85eMA7+agAcZAuN1tKvhbF4bUKD40SvdZvGuyR3UBL7JPPOs5UALP1+xQ7wrvZWG
rkxYCoAyFM0S+XAnmrs4c88IKy6GVAnlSFwW5hn2oohB4drEI+5M2D7lm+RZ1e6i
S8oaPseHDJeUAGjTBpmYSyXoAef/XAF+teL/rupErq+M3NHaPN6uJuqYXaZEUekz
gSWS/eMYEu4j/2aeTtd/Erafgig38KF4EufmE28pI+dy3iZ5hhcgYt+Gxs4areKu
+rP55G3wCvSnPVSiU5Fn/6mJlLGS3vNeRlcQZ8bXmYVns+zttPBD8UYtqJ4SqFDb
3B+3rOpYcqoqSpsBRb1GJ0JOKo45/kT+CSbvD2IrJmc6j4Qb8waQRR5lIwcsavR0
AdfHAJLhMnnTObVcvrdcrZc+D1oFjBUYfm4KSJcJX7SFoAmzzgTGgoyDxCrkXqTv
/KvLinuzu9fpEjgyFN5f70L7r7+IP1ak1pmMtQDXgumJIlpwplDsiMmGEJIyGKCq
o3cb1AAlQ+zwB8hEEkKI
=bKbI
-----END PGP SIGNATURE-----

--=-8/FoOyLja1T7v0ft0szv--

