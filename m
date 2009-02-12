Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012AbZBLNSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 08:18:08 -0500
Subject: Re: soft-safe -> soft-unsafe lock order detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49941C7D.6090600@openwrt.org>
References: <4991AC67.90104@openwrt.org>
	 (sfid-20090210_173417_726855_7504F887)  <1234433807.16004.88.camel@johannes.local>
	 (sfid-20090212_111736_123131_223B74EE) <1234434246.16004.90.camel@johannes.local>
	 <49941C7D.6090600@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NxNQ+SQDvvNwIRLSEujW"
Date: Thu, 12 Feb 2009 14:17:35 +0100
Message-Id: <1234444655.1327.3.camel@johannes.local> (sfid-20090212_141812_910235_A1D4D25B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NxNQ+SQDvvNwIRLSEujW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 13:56 +0100, Gabor Juhos wrote:
> Johannes Berg =C3=ADrta:
> > On Thu, 2009-02-12 at 11:16 +0100, Johannes Berg wrote:
> >>> to a soft-irq-unsafe lock:
> >>>  (todo_lock){--..}
> >>> ... which became soft-irq-unsafe at:
> >>> ...  [<800b2248>] __lock_acquire+0x624/0x844
> >>>   [<800b24c4>] lock_acquire+0x5c/0x84
> >>>   [<8006b8c4>] _spin_lock+0x34/0x48
> >>>   [<c0206d9c>] ieee80211_set_default_key+0x4b8/0x4f0 [mac80211]
> >> That seems to be incorrect. ieee80211_set_default_key will have
> >> _irqsave-locked the key lock, so the todo lock is here always locked i=
n
> >> an irq-excluded section.
>=20
> Yes, seems to be incorrect.
>=20
> >>
> >> The lock is, however, possibly used that way in ieee80211_key_link,
> >> which can be fixed easily and we can remove the todo lock too.
> >=20
> > Not true, but the todo_lock should be made to _irqsave in some places,
> > it seems.

Actually that doesn't seem to be true either...

> Should we handle this as a false positive for now, because I have seen th=
is only
> once, and the transfer has not been interrupted? I will do more tests on
> different platforms, and i will come back if this happens again.

Yes, I think we should, something seems to be messed up with this
report. All code paths are regularly executed on all platforms, so we
should be seeing this a lot more if there was a problem.

johannes

--=-NxNQ+SQDvvNwIRLSEujW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlCFsAAoJEKVg1VMiehFY3P4P/3saKz1zLrgXoi6KH1gE3ES4
gyayqMQOLOQJJX8A83AfASpsscBuK+iwASqdwNCRKnmrh+HcFCHZ3M+sSJQqN2ix
wt9AIkiGTCKoGw6MuYJqiFJk1C+PtSwK1iYYHRS7OhriTxLJoEkh03TQ/6IohINz
O5GFMRy4DCDwYtw6pvLIr6hMQKz/cjZ3nwfySxs8woOp7LfWtnL7YupCis2TH/ix
hj4JZwL3rkBbzWbMRbN1dLmb9IJPlFJNHxFJqymU5ZXyL/YKjAvTKq95gsRJFMI4
rjSxRc91rCxO6qcTn3dtSQ5GruC3j1Il+1zk2GrVbytQwv13PprMNK47avtW8coV
L9uivXURrAU1BfwkkN0w5CIM3ooexAcnmJyWsklcaM0AJSrEfWaeNvmLjBxh7mOB
5NlEhioqD4zfp/GwHVLYtfUe3rHj+MkFZly537sg1r2CN8A6Nw6Mlhpp3+s6PEdM
4LKGUvuqJnscD5NYGpdkSCLMGtwBig8v3yfnEuU6UZi6BHLMLoM0tB8OX1Xh0xC1
kh/QEOjLhaBWv2KK9l4jbIM6cLrvyMwlxTW975ZJ/uwWYB9tI4OYKZUVL41fGCWU
7cT6+o2P0SRzfhivOWQFmzCBDvsPjQ6/+GNyWwd1n+2WVtQ6lMtgx8TJR5veVoft
kXVyjYHiHzV59zwwE169
=3oLk
-----END PGP SIGNATURE-----

--=-NxNQ+SQDvvNwIRLSEujW--

