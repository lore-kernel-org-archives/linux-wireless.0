Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYA2Rqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 12:46:49 -0500
Subject: Re: RFC: unified BSS configuration approach
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, mb@bu3sch.de,
	dsd@gentoo.org, linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <c85cb4470801270333r618e53a1yf1fdf118d48b93a8@mail.gmail.com> (sfid-20080127_113403_141479_3B03D89F)
References: <c85cb4470801270333r618e53a1yf1fdf118d48b93a8@mail.gmail.com>
	 (sfid-20080127_113403_141479_3B03D89F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cqpx16ehe0/sHNdKccQ0"
Date: Tue, 29 Jan 2008 17:25:43 +0100
Message-Id: <1201623943.4394.49.camel@johannes.berg> (sfid-20080129_174655_794998_B8577825)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cqpx16ehe0/sHNdKccQ0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ron,

> few weeks ago Johannes published a patch based on my RFC "mac80211:
> add unified BSS configuration", introducing a new op from mac80211 to
> low-level driver "bss_info_changed", that delivers BSS IE changes and
> assoc status information.

That was actually merged too.

> What we had originally in mind was that this op should eventually
> replace previous ops calls for erp (uses "erp_ie_changed") ,wmm (uses
> "conf_tx") and ht (uses "conf_ht"), all of them doing the same -

erp_ie_changed should be gone now too.

> * @bss_info_changed: Handler for configuration requests related to BSS
> * parameters that may vary during BSS's lifespan, and may affect low
> * level driver (e.g. assoc/disassoc status, erp parameters).
> * This function should not be used if no BSS has been set, unless
> * for association indication. The @changed parameter indicates which
> * of the bss parameters has changed when a call is made. This callback
> * has to be atomic.
>=20
> Now, there are several issues that I want to address regarding current st=
atus:
>=20
> A)  erp_ie_changed and conf_tx were used not only to inform about BSS
> changes, but in init flows as well, in order to config low-level
> driver for an initial configuration, for instance in
> "ieee80211_reset_erp_info", that is called both in
> "ieee80211_set_associated" (assoc flow), and in "ieee80211_open" (init
> flow)

Good point. When writing that, I missed that it was called from
ieee80211_reset_erp_info().

> B) If we decide to skip this initial sync problems may occur, as
> initial status of mac80211 and low-level driver may be different.

Hm, true, that could happen. Does it happen in practice though? I can't
see why a low level driver would decide that it should have short
preamble or CTS protection on by default. Maybe we should just document
initial state? Or we can keep the initial call and remove that "don't
call w/o BSS" restriction instead, which seems saner. We should then
probably rename reset_erp_info() to reset_bss_info() though.

> C) yet, there is no need to make changes from beacons when we are not
> associated, as our association may influence the beacons.

Huh, yes, do we do that though? I didn't think we did. Well, we do in
one way, we set our initial status to whatever we "predict" the settings
will be when we join the BSS, if that changes we follow all changes. Are
there any problems with that?

> D) also, configuration should not be applied to low-level driver while
> scanning as well, even though beacons/probe responses are inspected.

Hm, good point. But we don't really react to things in other BSSes so
does it really matter whether we're scanning or not while receiving a
beacon from our own BSS?

> E) support to user space configuration is needed, e.g. AP mode
> (although here we may use the fact that AP mode is always in a kind of
> "associated" mode)

Yup, so far it's required only in AP mode, is there anything that will
need this when not in AP mode?

> 1 - change the original intention of bss_info_changed so mac80211 will
> be able to set low-level driver in the "init" or "configure" flows as
> well, not only as BSS is formed or changes
> 2 - maintain original intention, use "bss_info_changed" only when we
> want to deliver BSS configuration when we get associate or during
> association state,  and deliver all initial configuration info through
> different ops

I prefer the first option since that's essentially just a small
documentation change and it makes sense. We just should make sure that
it's called only when the device is started (through ->start()).

johannes

--=-cqpx16ehe0/sHNdKccQ0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR59ThqVg1VMiehFYAQKrpA//e//mZvTXPnv6T249NTVZCEL/iETwktz9
nSmtiyA6T0r92wWTkTasnzkOFYKeIfcszHjCAE9sqO9HbjbQU+1O7rP0KZx2ZSPT
1lJ39tQGQ9iuhVSkhKduuNt0KURUdoTld+9DMpIQKeQ1890NHVikk4n7QdHXB9fc
M/k4NeBfucZanSU/j5sfkYCWdgq/d1shUkkK7DH5UTx6Pd4sDLqfPZCqvK+cDznt
QL8Bh46g9eDjZTIVB4xBijciIV7UsgoAJcvKUWCn84zyVcbeXTDEobnJ83f4aWal
ta6jMk8PhlMne7unGcEH6X4PtcmgzbCn5Fp9xEZmFmu36swIddBjXcOpcW40bFF8
N+wH1I8/5lk7jGVmVD+YpgEz2f5XzllkV9PvUEhB9hD43Km3Yi8oe9/Dw53VhViB
Wyux6Pn7Y1VSfpHhE/tNi4mDFi2/Z3sTexSxJTU8iRiG7THOjT8lrt92r8ONu0Yq
F9cnUaKGaKSpjq24BrHo6Qz7rC0AjWHm+RDC7B0AJzDPaKefdoYtAeiMmT+bnZEP
XU3uOhiWsgOz4pzqi3xnW2RCm8xYwqcX8s2/HUnEX75kWaJ30g9HkT+u36pDpVRv
RNgvDjg96QDIWItn+bZ/5/rL9AbQWpZldET0/8Ir16OdsPU8WLC6PcrxkOunMiUD
mcgp5QAsT7Q=
=zVs2
-----END PGP SIGNATURE-----

--=-cqpx16ehe0/sHNdKccQ0--

