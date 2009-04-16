Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZDPJnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 05:43:37 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1239873166.9737.4.camel@johannes.local> (sfid-20090416_111325_836393_8280C8A7)
References: <1239837672.11795.46.camel@violet>
	 <1239841291.25334.18.camel@johannes.local>  <87ocuxf7kv.fsf@litku.valot.fi>
	 (sfid-20090416_081529_723461_015362DA)  <1239873166.9737.4.camel@johannes.local>
	 (sfid-20090416_111325_836393_8280C8A7)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-15mKqozRBLemvdJvEFI2"
Date: Thu, 16 Apr 2009 11:43:02 +0200
Message-Id: <1239874982.9737.7.camel@johannes.local> (sfid-20090416_114341_529269_B3B5176E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-15mKqozRBLemvdJvEFI2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 11:12 +0200, Johannes Berg wrote:

> > I have been thinking two ways to fix this, either disabling the timer
> > for the duration of the scan or add a check for scan scan in
> > ieee80211_associated(). I started implementing the former but haven't
> > finished it yet. It would be great if someone else can fix it.
>=20
> But that doesn't make sense to me now. ieee80211_associated() is only
> run from the station work (ieee80211_sta_work) which doesn't do anything
> when we're scanning (and gets restarted on scan end). So even if last_rx
> or last_beacon isn't updated we should only run the evaluation of that
> after the scan finishes.
>=20
> I'll try to reproduce this.

Can't. Scanning here, with 4965, takes almost 7 seconds, but all I see
is, _after_ the scan, a probe:

[ 1534.592164] wlan0: beacon loss from AP 00:1d:7e:4a:a1:ab - sending probe=
 request

In a noisy environment I guess that probe or the reply could get lost,
but that seems unlikely to happen _every_ time.

Marcel, you will have to provide more information -- like kernel logs
for example, and maybe packet captures.

johannes

--=-15mKqozRBLemvdJvEFI2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5v2hAAoJEKVg1VMiehFYRnUQALMbrJnKSAU1xHyPelwW+J0r
fqM6xrGCzdfFJoHqnnNeUP2tEc00wcpxpgG9DAndYf8uV/T/MXFCxcgP5kx3c1ot
racTGXDBETPndray69EMzOD75vz7GOUQFfiDkFIqYpLey2kpMqQkbYSIDB1852jb
e6+TliWE/zO2TGMQCi/1RKM4f2nazyU3OolVFxJn3bn9+2k5AIjofCm15WFwVCS5
3k5/l+/2jUH4LhrHiK1VCgFCGQsTbJIX4Cda0C80K7Eyg6tHfnOKgO6dnkEXgwWU
dTzHxiWgzICtdf/9qnRQcyCLDt3s5bJCgQ/+RCXucS2TClLp2uFAfCpxcDCiXpMa
1gjiDihuRgUmVAXDpCJDIRnOgA7EXFz+eBATSG8Fl83rpwxg1/sCKXbx51qnWdpa
UDFwBMHeMirzbR8tt15pkK/k2zzPj205bkKBRXpaMbzkmiwW0LmWEH85oxqd3CaA
nlmHfl0ug953qHm8COBC+TNlqEIUu3PNFGjCh/Fc0vYxjMH0BJ1aCPCGaQMFJvOE
lZln1Cd0Hnogs+Ri5HnoognQrpzKMTFP64peQTgnT2Eekvx/LrsvScmADkCfbVUR
70L4R6rXqSQTfaaKW/1S25dqUupULmhJotSfBsmjuOYsQPt0Awl/QeIgvu6HfiLg
Gut6X9wgSfjICVslizzb
=NSLZ
-----END PGP SIGNATURE-----

--=-15mKqozRBLemvdJvEFI2--

