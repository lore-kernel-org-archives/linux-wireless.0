Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbZJ2V3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 17:29:00 -0400
Subject: Re: odd state reached when AP deauths you after assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
In-Reply-To: <43e72e890910291419j7feb7a3dg33cd5b02e064eeee@mail.gmail.com>
References: <20091028183726.GA4952@tux>
	 <1256761485.4237.260.camel@johannes.local>
	 <43e72e890910291355l5fc4ec2ctb9a777b6e8b07baa@mail.gmail.com>
	 <43e72e890910291419j7feb7a3dg33cd5b02e064eeee@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5C7TIOamA6IYjVtvdRGH"
Date: Thu, 29 Oct 2009 22:28:58 +0100
Message-ID: <1256851738.3865.149.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5C7TIOamA6IYjVtvdRGH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-29 at 14:19 -0700, Luis R. Rodriguez wrote:
> On Thu, Oct 29, 2009 at 1:55 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Wed, Oct 28, 2009 at 1:24 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >> On Wed, 2009-10-28 at 11:37 -0700, Luis R. Rodriguez wrote:
> >>> I ran into this when ath5k with wpa_supplicant with config file with
> >>> a wrong password against a Cisco AP. It seems the Cisco AP auths you
> >>> and lets you assoc but later it deauths you -- I guess after it
> >>> determines you are auth credentials failed. When this happens I get:
> >>>
> >>> mcgrof@tux ~ $ iw dev wlan0 link
> >>> Authenticated with 00:0b:85:5b:8d:6c (on wlan0)
> >>> Not connected.
> >>
> >> I'm guessing that you're using -Dnl80211. You need this patch, or
> >> equivalent:
> >> http://johannes.sipsolutions.net/patches/hostap/all/2009-10-26-12%3a59=
/deauth-on-disassoc.patch
> >
> > Indeed, it fixes my woes, thanks.
>=20
> Well almost, after a while of being connected it then does this:
>=20
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> CTRL-EVENT-SCAN-RESULTS
> Trying to authenticate with 00:0b:85:5b:8d:6c (SSID=3D'ATH-GLOBAL' freq=
=3D2462 MHz)
> Trying to associate with 00:0b:85:5b:8d:6c (SSID=3D'ATH-GLOBAL' freq=3D24=
62 MHz)
> Associated with 00:0b:85:5b:8d:6c
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> CTRL-EVENT-SCAN-RESULTS
> Trying to authenticate with 00:0b:85:5b:9a:bc (SSID=3D'ATH-GLOBAL' freq=
=3D2412 MHz)
> Trying to associate with 00:0b:85:5b:9a:bc (SSID=3D'ATH-GLOBAL' freq=3D24=
12 MHz)
> Associated with 00:0b:85:5b:9a:bc
> CTRL-EVENT-EAP-STARTED EAP authentication started
> CTRL-EVENT-EAP-STARTED EAP authentication started
> CTRL-EVENT-EAP-METHOD EAP vendor 0 method 25 (PEAP) selected
> OpenSSL: tls_connection_handshake - Failed to read possible
> Application Data error:00000000:lib(0):func(0):reason(0)
>=20
> And I then end up with the same:
>=20
> >>> mcgrof@tux ~ $ iw dev wlan0 link
> >>> Authenticated with 00:0b:85:5b:8d:6c (on wlan0)
> >>> Not connected.

Might be due to that bssid_changed check I was unsure about -- try
removing that.

johannes

--=-5C7TIOamA6IYjVtvdRGH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK6gkXAAoJEODzc/N7+Qma2nEP/3ZJW5XWwwcnCoyc8yHT/BnR
ofduRJTecAV4DBeY6mTpeKkrFGAJebDKuRGH2N1wQR42TZiCVlt+qEg0+SB6Gsoe
MvRwYlmLxPTPzyeL5iscFHPq+qKt75gq347VbL06PyjbDingtQ6CEpvOa+TjyYeY
iJBDHh75bD0xtIoZOm8Wn+0NDrQ8KyoB7551AAjLfpuJyYLU+EFRnWZIabtFqEcM
s87HL34DwnWGoE5n/q8kstpa68CBo9zLvJ3MkiHtUUl39Nrtp3ZAKcMTFQo7FFdh
6FOt9CP9s7HMCFl+ccWXtbf4wkBielNY+cL4BSLcrE2Rx/Mmj3Ui/d+LEqn0jivk
zsu7t9gqoS4uMILHvKc5iptKKdZCWEvrUTFTR1snle74FhwVemRno0PKqpeJgFy7
RunuOQWFve6JJq8cuNzUzSmhoXyN7JMh0mLC/79BW09l59GR26wRpXgQUHKDxDoG
izQDrTm7jZgTa7Ype8ZbQEP37UVo1g6d88h9J8mVYGRGUYRehSQbmw0uExRqSFRA
MvgpdvW5tJsXA/yMjTAn04UfVvdjm4uX+duFkrJl2qT0naVdH6FoR+xI31OY5Hpd
XvfR3zWlfu42vUeN6zyJqZITnthqwjbwAhNack4XJ4Xwlox/tfAz1JXpP8bAGQVx
ZaQnXrBSnpaTzSH9273P
=9kE6
-----END PGP SIGNATURE-----

--=-5C7TIOamA6IYjVtvdRGH--

