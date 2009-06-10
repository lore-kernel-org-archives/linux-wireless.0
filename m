Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42959 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082AbZFJPcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 11:32:17 -0400
Subject: Re: [RFT 2/3] ath9k: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@gmail.com>
In-Reply-To: <20090610132015.GA10126@vasanth-laptop>
References: <20090602111027.460530075@sipsolutions.net>
	 <20090602111112.191915040@sipsolutions.net>
	 <20090610132015.GA10126@vasanth-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LUnzWDseE/OC0HHhT+wM"
Date: Wed, 10 Jun 2009 16:38:32 +0200
Message-Id: <1244644712.26814.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LUnzWDseE/OC0HHhT+wM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-10 at 18:50 +0530, Vasanthakumar Thiagarajan wrote:
> On Tue, Jun 02, 2009 at 04:40:29PM +0530, Johannes Berg wrote:
> > This ports the ath9k rfkill code to the new API offered by
> > cfg80211 and thus removes a lot of useless stuff.
> >=20
>=20
> I get the following lockdep warning few times when tried to scan
> after rfkill on/off.=20

Thanks, will fix, this doesn't seem to be ath9k specific. It's the
dreaded locking in rfkill. I can work around it easily in cfg80211, or
fix rfkill, will see what's easier.

> One more issue is, when rfkill is enabled before
> reboot, I could not bring up the interface when the rfkill is turned
> off after reboot.=20

Sounds like the driver doesn't initialise properly. Hmm, maybe we just
need to move ath_start_rfkill_poll() to ath_attach(), could you please
try that?

> Apart from this it looks good, fixes a panic which
> used to happen during module unload.

Heh.

Thanks,
johannes

--=-LUnzWDseE/OC0HHhT+wM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKL8VhAAoJEODzc/N7+QmaZB0P/230nNarCL3AYdVR4TAumZIO
SKzEOjb/vagJHByGOB9GL+M8QW96qrZbkVzRR0HRpR/UURiHkNguGUglTt6/ehoJ
VIn+otclAXsfhpB38avM1tkNJ5V1mwSopG6WQ/0QOiaD1ZJuwT67HV+HKQqV2bUj
V/2kX6nTqtKRmg3f1Ug2X4mhCaCCfRqlGGQffJBc2b8pjI5rgnOT1FBaFwhhyFyh
WN9k+DEAAIx1DS6LGtxzSLfqKHjtpGjSjHhx3BjCK22T5cre4mRNMDR2ffRSEc+3
SXIqi1EE17G0z8v8ZCnOs3pHbLm/e00Zx8/aaz/082eylnI2NDqxFcQgPKvzy+Yh
oaBvwSYm4dls6h5doqAVQyfsFTUyy8JZ0ON1n+01CQG8HaBYF/8nmclVLTk26EwK
rQg2SoQZjrylE+c6nV5ldp4s/S8uztjjDcS5V2pQg4p1SpMEX/xx34AK3xlSEsrk
ExkGfd57NtjjjBq3a826f//UmTZJMpgFEAOpdgnHjn9izEUNa46IPtzdQffNyoP9
8OVwJhWZwbkhhhdsoO7Zk7iN+XJggalGwGfYiu0LLui3ZkHhHGloNvHdczYFsCya
u5OOEBnYMNv4u8/sbpHY1BkeB19BzBSI0IdMJr8BRqbkLqBAmVkSQcpMi700JoiF
YXnQRbKqlqszJoUjsqQb
=8eyL
-----END PGP SIGNATURE-----

--=-LUnzWDseE/OC0HHhT+wM--

