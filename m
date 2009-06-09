Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbZFIOD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 10:03:29 -0400
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906071449u4ae8832bu168322ae4a7cd2a3@mail.gmail.com>
	 <1244442549.11006.2.camel@johannes.local>
	 <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-j2tyKnB/vHY1sAowe2Nx"
Date: Tue, 09 Jun 2009 16:02:59 +0200
Message-Id: <1244556179.4672.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j2tyKnB/vHY1sAowe2Nx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-08 at 19:51 +0200, gregor kowski wrote:

> > There's a quite obvious disconnect between what your patch does and wha=
t
> > your description says, please fix one of them. As it is, the patch only
> > skips the IV rollover which is *completely* wrong because it will call
> > the function for *every* packet.

> I don't understand what you mean : the callback will be called for
> every packet the hardware doesn't decrypted. If the hardware decrypt
> the packet, only_iv is set and we don't go here.

Right. But drivers are free to even only _encrypt_ tkip frames and never
_decrypt_ them after having accepted a hardware key, iow that is
perfectly valid behaviour and I don't think we should keep uploading the
key to the driver. Worst case is that the proper upload fails and we
decrypt all frames in software until the next rollover.

johannes

--=-j2tyKnB/vHY1sAowe2Nx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLmuQAAoJEODzc/N7+QmaLKsQALHRx/xG7LZw2JyysGSl0BqO
lS/ZATjCIyVgtGq08sjaO5SWOKgcf0a0R+hRMzEbUXItpxeeUaRIxI4m4M74PVWN
lL6eK0ENcanB5YqTj6HzPJUGPmRcmVxDGoFiPn7Uhc5QPDr9FxnN9BT5ADEmhqrd
dOvvlbPN8HDdjpvxyZhclAocDeC03WDpnXte7TV8nOatOG9Wq4ZhlPglIYdmKIin
CCLLV8fU8PDbYARhqFwsW4b+pZhaARug8R2l+6FJ9KtrbaJkGm4ve4NY4fyDYqpP
9aLY4aX1YbEMWqXjjCHPY95NMCBhHICIDjg4q9OlD2GCpX4QYzojQm3wlphunj/4
xE2s08IYcit/kE+BTh/m7z5g09QlWRoIahqm5HDeJnZmmDVpD2/opyfNXFwjJb4y
xfqhObDseU10Ss6ck5NVIlmV7cva4etkjmDIw/tAbqXelLWgzZDakje/Pb6b4GPx
zZcxnSBf0IHCQ/xDXGquUYj1eqx3OQECmlSigk4vjbJ1bq6x1TBBraX8ZaHm6E/Q
6XvH3bKxXsW0SLbLvayjaNoadY+kcMsIEIyskgcIcuu35t9IVzInoZCO+w1xcQ4m
MyVcLVOxmpcI8/4zUjpNPTdFc2uiMiDjdlOd5pQf0auFXcPHc560I07S8brY9pWc
jBhywTwCnD1W8a1rDAWE
=3Pbj
-----END PGP SIGNATURE-----

--=-j2tyKnB/vHY1sAowe2Nx--

