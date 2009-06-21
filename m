Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZFUJVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2009 05:21:22 -0400
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <83a869cd0906191237j7d727a4ekd6dbb9fc35d60b78@mail.gmail.com>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
	 <1244556179.4672.11.camel@johannes.local>
	 <83a869cd0906091048k68616c11k16fa98403aa770b@mail.gmail.com>
	 <1244569926.18481.27.camel@johannes.local>
	 <83a869cd0906101242w2ae8480cle69abd19a9d87112@mail.gmail.com>
	 <1244750836.29447.5.camel@johannes.local>
	 <83a869cd0906121341k3b58b80fvefdb74c2fca9449d@mail.gmail.com>
	 <1244839645.11782.5.camel@johannes.local>
	 <83a869cd0906191233g507fea1cg238d14b57ace0466@mail.gmail.com>
	 <83a869cd0906191237j7d727a4ekd6dbb9fc35d60b78@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ecx5HRxQSwGjZsYQVM/z"
Date: Sun, 21 Jun 2009 11:21:19 +0200
Message-Id: <1245576079.16399.31.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ecx5HRxQSwGjZsYQVM/z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-19 at 21:37 +0200, gregor kowski wrote:
> Update : I changed the logic. There is a single flag per key, tracking
> if we send the key instead of a flag per rx queue.
>=20
> The mac80211 tkip code won't call update_tkip_key, if some rx packets
> get received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
> first packet because the hardware key stuff is called asynchronously with
> todo workqueue.
>=20
> This patch workaround that by tracking if we send the key to hardware.

What was wrong with using an enum, in the existing variable?

johannes

--=-ecx5HRxQSwGjZsYQVM/z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKPfuKAAoJEODzc/N7+Qma6OYP/A5DPnTO6JZAn3w8lwDXYYJX
BrsmoE1ylNLah8lj3pYcOmenP94p+LbsyFq/UsCGAV5g+NXn9z6P2oDNy7Lp0hve
hOmDrZy9B32rNjDLImR2ysuQ9yu6vn9Wzfa/Yk2xBeE9N0uccDAeqrgi1dQytVEE
GBmEBIayVmIe++5nXepW66akSs4J4O1i+SSC4R2o4uOZ1SKi4jT13FuGc1ckwoVW
yDEnv+o8N751gizqZ7gBfv5KbaMhRQKTmgesNY/KxeaogmTumW2bX7I5Q8Lexq/T
dvMtl8HIREUGO5idh7290LrnUgWr6N734BDmy8WHeHZXYYfv/PEPJIIASqBbINJI
bTYivJOVme1gGr6D4h1yLdIqjbFuWtmAnn1Jjq5iB32VabZc2xGoSQCoH0XsiJ2D
VX0IPo0AjuDaGmpwZCscN8SVqPbZpZyG99htqFPLjXYPxcDcwspneLGsh1NvpZpa
9Nngpmp5bW7mcGDquHk2lYjIPIr0eSrJciaAo0DTR608ezDFvMsALu1ZcW0VYP6m
qiedwIxdEMHxVz46xRcc0zV1np2BO/o1/ZTGgAEiOLtznKe073yxt5qjpAqcjn2v
6d2Cz4qZxwNDKMG/SSiGI0lPBUAJGU7xUkVLKbsWAWY1OevEo9KTevp0QRu0TtU8
HYNr34YzK3EB/mOmwiNX
=F1BS
-----END PGP SIGNATURE-----

--=-ecx5HRxQSwGjZsYQVM/z--

