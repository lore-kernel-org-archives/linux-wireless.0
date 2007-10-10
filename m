Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbXJJIpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 04:45:15 -0400
Subject: Re: wext 64-bit: network manager and wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: jt@hpl.hp.com, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071010022041.GL14401@jm.kir.nu>
References: <1190292526.18521.52.camel@johannes.berg>
	 <20070920165545.GA29452@bougret.hpl.hp.com>
	 <1190307669.18521.94.camel@johannes.berg>
	 <20070920205602.GA15373@bougret.hpl.hp.com>
	 <1190385414.18521.148.camel@johannes.berg>
	 <20070926235135.GA16051@bougret.hpl.hp.com>
	 <1191921316.4013.5.camel@johannes.berg>  <20071010022041.GL14401@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SCcKeDJbKQOrvohCWCiA"
Date: Wed, 10 Oct 2007 10:46:03 +0200
Message-Id: <1192005963.4013.66.camel@johannes.berg> (sfid-20071010_094521_032370_D646E2B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SCcKeDJbKQOrvohCWCiA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-09 at 19:20 -0700, Jouni Malinen wrote:

> Unfortunately, I do not have a device that would show the 64-bit issue.
> Could you please remind me which devices are affected and how common
> they are? So far, not very many people have complained about the issues
> with wpa_supplicant on 64-bit systems.

Every time you run a 32-bit wpa_supplicant on a 64-bit system.

> > Could you try wpa_supplicant with kernel patch below on your 32-bit
> > machine? I think this should make the problem show up on 32-bit
> > machines. Not having a 64-bit machine needn't stop you from fixing the
> > alignment problems :) I can then verify that it works and didn't break
> > 64/64 setups if you want.
>=20
> This sounds like an interesting way of resolving the lack of hardware
> part of the problem.. ;-)  If this approach is confirmed to work, I
> would be quite a bit more likely to actually find time to take a closer
> look at the problem.

I think this should reproduce the problem since the actual problem is
that on a 64-bit kernel you have more padding that 32-bit userspace
needs to work around.

johannes

--=-SCcKeDJbKQOrvohCWCiA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwyRSqVg1VMiehFYAQLPDA//YbvF+SjROPlPc71sLws441EK6ymFoZaV
pdpEYniBUVQPXg5pOB3etFDG1yUaXUPsDVAKHWm4Gr4uxadSTCizQ9b/KuEkBcwm
F9XcyYdKNTYEk5oNZ7Zn3JABuBheSjZMgJz4scz289TCdaRrsEFF5+14MZ61jKo6
48XHtA4fdzqc7G08obMdqY7K9sJIda2Xk3/au7IZGZ+4D4l5wx5ED0sJNM+xmRRv
gOw/inkP/QtlptYhzwJUBGtwok6e5hCNDnxz6yGfhsFqqQQdmaCiW2VAHpI6Ya+u
z/P441EvEqz0BwDwfKy2x/PGrPs4D9bQqzLZ1wjF7iHrW4hzs4so53Ez2TEHLL2s
5rV54iWXL9ew/l9rj1UguEI8qIs2EO9MFp3UqRyx6puO8VgbrAjrPtbpXyUvjAoR
ng0Nvt4uh7xQNbHJpkY/TYvxnbx73KIOfIFz4AXABae3xVQaeDmQWu2Qc7I2V/PW
eCDzmVAUY69rYrqYHUvrX7S55A54G6rJZjSfH0yYwNHLb+IcN+CcxdyDAoXXUs49
4twcuYjCHpn8+LpLjXFYgyc5jVBpaxCRbuWkxppLXbNg0Ny0dgrkdMRF+fbkQCA8
KGZXLHLoLRDY65+/HLtqQOLJMLkzT7lY6wfFI2Qxpe9k59suINcR27qiZPwgvz6r
Ch6Z/2s8ciQ=
=IqFT
-----END PGP SIGNATURE-----

--=-SCcKeDJbKQOrvohCWCiA--

