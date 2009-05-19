Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZESJKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 05:10:05 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com, Gaurav.Jauhar@atheros.com,
	David Miller <davem@davemloft.net>, Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890905181106j78367219mf16eadf4276f709c@mail.gmail.com>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <1242327298.4227.25.camel@localhost.localdomain>
	 <43e72e890905141207m3c27588ex13190b2ed6010e30@mail.gmail.com>
	 <1242334636.4227.134.camel@localhost.localdomain>
	 <43e72e890905141426k479e6707xb4f3d07d7420e7ea@mail.gmail.com>
	 <43e72e890905152312m2077cc1dqd743cf7f625e9a49@mail.gmail.com>
	 <1242478657.10005.72.camel@johannes.local>
	 <43e72e890905181106j78367219mf16eadf4276f709c@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6RZt72gXf4ng0+NBT0Bo"
Date: Tue, 19 May 2009 11:09:58 +0200
Message-Id: <1242724198.17164.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6RZt72gXf4ng0+NBT0Bo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-18 at 11:06 -0700, Luis R. Rodriguez wrote:

> > No, I just think we should, if associated, spread out the scan a little
> > more, and not change anything in the userspace API at all, just change
> > the time it takes to do the scan and allow data to pass by going back t=
o
> > the operational channel.
>=20
>  If we enhance scanning in mac80211 while your associated by relying
> on some metrics we're leaving userspace out of the decision. It would
> seem nicer to expose these metrics to userspace so it can take a
> better informed decision. The issue still remains with old wext unless
> are OK with some defaults. Which is why I was suggesting a SMART_WEXT.
> But it seems we are OK with penalizing a userspace wext scan by
> delaying it quite a bit when associated at the expense of doing
> scattered scan.

We would also do that with a nl80211 scan, if it was requested for all
channels. I don't see how we are leaving userspace out of the decision
either. Yes, we're not asking userspace in which order to scan (actually
nl80211 order is used but we don't guarantee that) or how many channels
to scan between traffic etc.

However, all this information doesn't belong into the scan command. That
would mean applications would not only have to register their
requirements with the kernel but also with the scanning applications!
Which would be a completely hopeless approach! Yes, having userspace
influence policy on these things is great, but it also needs to have a
chance to do something sane!

> Hm, yeah I just noticed we don't rx flush on channel change... I do
> see this notice on ath_set_channel()
>=20
>         /* XXX: do not flush receive queue here. We don't want
>          * to flush data frames already in queue because of
>          * changing channel. */
>=20
> I forget why we added that now.. Anyway I guess we can test something lik=
e this:
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/main.c
> b/drivers/net/wireless/ath/ath9k/main.c
> index bbbfdcd..a5db284 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -261,6 +261,11 @@ int ath_set_channel(struct ath_softc *sc, struct
> ieee80211_hw *hw,
>         ath9k_hw_set_interrupts(ah, 0);
>         ath_drain_all_txq(sc, false);
>         stopped =3D ath_stoprecv(sc);
> +       ath_flushrecv(sc);
> +
> +       spin_lock_bh(&sc->rx.rxflushlock);
> +       ath_rx_tasklet(sc, 0);
> +       spin_unlock_bh(&sc->rx.rxflushlock);
>=20
>         /* XXX: do not flush receive queue here. We don't want
>          * to flush data frames already in queue because of
>=20
>=20
>=20
> But not quite sure if this would resolve that race you mention of.

I don't think so, no.

> > Then again I don't quite see why we discard frames received during a
> > scan even if they were for us.
>=20
> We do discard them?

Yes.

johannes

--=-6RZt72gXf4ng0+NBT0Bo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEndiAAoJEODzc/N7+QmaYRgP/34l/2tP9+9TRZdLDOYyLSxQ
E20sSTu6E6NtigCl4tHaEsY6z4o4tQwl26dX4v78mi98UhVjV6ZXCA0YDZsY+zh9
VpAgmZjHBj1t9yISWKHF25wT/WCDyqR1dSGEsitpEl6BBWBtSMlG3NVkg7sJwAjF
xSYCYJ/DvdTTIRFsTG1vno9jq7T7M2ebsTUrBuC8cL01CRi8KSNgQAal5scoj9fB
99c41CfWc1itDfCh14w7Hd5przHnJh/d2GJyl52ca8n9JRiHh+NXSNLF642hq75Y
I8RSy0cpjOGJqkylALu064pvwXwaEEXmGf9y1OgfykeYy23rkJI7kY8vQy+ZqzGf
EQKJpAc6GmhAqgc4YKLgqgfjq0O3U40UxdKzQ+elSidOEMTyuToAs6HbBycQlfGH
Hg7MMwNYhDWYKTX9dqhnvmEihmAFCmEqHfFgxfrwGar3j99cF1c4ljKbB24M4Mxk
OTGnK73q5uJReo5/c8Dgif/B9ygssM47EVmrsHXp73ULxKSUCBLULX+oK/n8+2Sj
DS5TxFYuE6vgEA7wbpwEWv2AUNGMpHRLCH/+W/szIDx4Twbztldt5RkdpHIVBAB0
bM2MBPhFsiDeoilt8V7Dr2kJFn0y5iqOP8JyhdSex4LSixIk63fupn38InHqWPhV
GBqe3fnVVK0MGtO1Er3Y
=7ffB
-----END PGP SIGNATURE-----

--=-6RZt72gXf4ng0+NBT0Bo--

