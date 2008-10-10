Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58326 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487AbYJJN2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 09:28:03 -0400
Subject: Re: iwlwifi TX reply bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810100545o79b70feay9c2da4fa6aa48a6b@mail.gmail.com> (sfid-20081010_144540_672961_64CD3D4A)
References: <1223629897.3930.69.camel@johannes.berg>
	 <1ba2fa240810100545o79b70feay9c2da4fa6aa48a6b@mail.gmail.com>
	 (sfid-20081010_144540_672961_64CD3D4A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ORugnP7L3cmh9QmieP9P"
Date: Fri, 10 Oct 2008 15:28:03 +0200
Message-Id: <1223645283.3748.2.camel@johannes.berg> (sfid-20081010_152809_768587_945185CC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ORugnP7L3cmh9QmieP9P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 14:45 +0200, Tomas Winkler wrote:
> On Fri, Oct 10, 2008 at 11:11 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >        sta_id =3D iwl_get_ra_sta_id(priv, hdr);
> >        if (txq->sched_retry && unlikely(sta_id =3D=3D IWL_INVALID_STATI=
ON)) {
> >                IWL_ERROR("Station not known\n");
> >                return;
> >        }
> >
> >        if (txq->sched_retry) {
> > [...]
> >        } else {
> > [...]
> >                if (index !=3D -1) {
> >                    int freed =3D iwl_tx_queue_reclaim(priv, txq_id, ind=
ex);
> >                    if (tid !=3D MAX_TID_COUNT)
> >                        priv->stations[sta_id].tid[tid].tfds_in_queue -=
=3D freed;
> > [...]
> >
> >
> > priv->stations has 32 entries, IWL_INVALID_STATION is 255.
>=20
> Don't see a problem this is what iwl_find_station returns if it cannot fi=
nd

The last line I quoted uses the sta_id regardless of what was returned.

johannes

--=-ORugnP7L3cmh9QmieP9P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI71hfAAoJEKVg1VMiehFYg14QAKeAU8S11zSWZ+4Y3aJRFBMa
DMi1IOTRNx9mQvrzrNQtm094JCg1EayeazhQqFGXc7U2vxBVJuFHyiqIIJeN6AFg
JhFC+wBPHDsAQJ7Kavg0zpr66ubgc882myXe5STyZjpFNsGTTQN6LE+wxi1WZXFc
4qaTVez5xd4DxeBoeqTc8dEKU+mYN+hwM7aNfxTRAUvUx+bq3K93w0RfHQa80OFC
UbpFSnBVKZQU/K9O3AUlHqOrwjBXCouS5mnQQoD2hPWPgjsBM7StgPCtsbUrpJWX
ZBKyzPZ13OgoH2ECEB3zj9ex2WbZU87cLm96YTN0Dgw8/UX0hIFWYTTCXJcaUuye
7pRRnjBskI6j0gBXhbG2X2+s9QSrt5QzhI5JAJVZtrNyyQ0sjSS5NnGQ3BTslYhc
295GHKQg3YEc/UE4qZuXFMPq8WVKnJ8sagv4hO5iFDHUrE/zQ2wHV6+QjcfutFzs
3lzJU23FjZlIkl9ehykdw14RmFXVIMhZE1Oq2JptaZNcJ1VK4BDjhgvd8qru/Gns
Lq/AfMNTqlC6h9jSfFKQPu7xINhprqoVKHLmfknqrL2eS74t+MJ/ib+B2pPelrcS
QlcjIdxz35ZLEUXWhjnJuQYdTvv1OZjmBTel3mFwLmFS6R9XPX0pqabUDHC4O5Uy
0zmcHSD5GFMqtgepvqcW
=DzGl
-----END PGP SIGNATURE-----

--=-ORugnP7L3cmh9QmieP9P--

