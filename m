Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbZDPJ6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 05:58:52 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <87ocux9bct.fsf@litku.valot.fi> (sfid-20090416_115027_810208_7945B47A)
References: <1239837672.11795.46.camel@violet>
	 <1239841291.25334.18.camel@johannes.local> <87ocuxf7kv.fsf@litku.valot.fi>
	 <1239873166.9737.4.camel@johannes.local>
	 <1239874982.9737.7.camel@johannes.local>  <87ocux9bct.fsf@litku.valot.fi>
	 (sfid-20090416_115027_810208_7945B47A)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WcoQxGNzjcyCe5J5aoqX"
Date: Thu, 16 Apr 2009 11:58:17 +0200
Message-Id: <1239875897.9737.11.camel@johannes.local> (sfid-20090416_115856_751433_E75DFF19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WcoQxGNzjcyCe5J5aoqX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 12:49 +0300, Kalle Valo wrote:

> >> But that doesn't make sense to me now. ieee80211_associated() is only
> >> run from the station work (ieee80211_sta_work) which doesn't do anythi=
ng
> >> when we're scanning (and gets restarted on scan end). So even if last_=
rx
> >> or last_beacon isn't updated we should only run the evaluation of that
> >> after the scan finishes.
> >>=20
> >> I'll try to reproduce this.
> >
> > Can't. Scanning here, with 4965, takes almost 7 seconds, but all I see
> > is, _after_ the scan, a probe:
> >
> > [ 1534.592164] wlan0: beacon loss from AP 00:1d:7e:4a:a1:ab - sending p=
robe request
> >
>=20
> How many APs can your 4965 see? You need to have at least 4 second
> silence period to see the disassication (2 seconds for beacon loss
> detection, other two seconds for waiting probe response).
>=20
> Try artificially dropping received frames during scan or something like
> that.

But that doesn't make sense. We don't run ieee80211_associated() during
scanning, so how would the state machine ever proceed?

johannes

--=-WcoQxGNzjcyCe5J5aoqX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5wE3AAoJEKVg1VMiehFYRfEP/2TFgukxwlrxQ+3RTP6INtq1
ulEOGYEMf9eu6BEfi7vHnPS6LK2wBhjlKnzB32WdQ0v7/jO8ScMPa4tkAzjbyqwZ
lfyAohpnudNG1Y2u3KYAVs6Xw2Mw6q+xbFWPQ74rLym15K0sCmFtHwg93g5/EziF
OiVPLXDQm/BRFmxC8tYfDCFkOgz4VUcrLwYfV5ROiOQ3rXCUWTBLQKPX08DI1dv/
q2ItkoeEWG08hN9dfi66noaYs/GPUYoW501AFP9xUwD3OSayFnVZMyULjCbNMjSm
4MDcDlD4Inesum/Qb4BgSVC36ZFoNv6hHKH/eWdy8nn0BA43DIgXQtjhLX3Nyh1z
Z/15l+L1Ta/EJNZZJaE/1qn7mO5ALSejj2sL1la7fg05+X4etsc/pAD8dV3y/7I0
LA2GHRw+WTcSKYDO9ChTo8I50k5nCv3xBlfD69OTHn/hENuJexFIZzo/XmxM+o6Y
0tQDXX1CQzje1edSSWvsMUzECmWWTCcGk3ldkACAVsojlp3XG1DWIfB2Pd56XMde
BdIO3gk1HPbkY8jTib8+xu0u/BCYjsBLLH92kVb7mU8DjBBFlrRWqXuwhXGfivBT
dsrcWeRtM0xX/YMPFePW/G/ViDIPUsoiOBoY4xIm4fGzO74dnoyDFxBvRAUm5uyK
ZlUC+wAnO0Mhn8xFCgZ7
=Ym4/
-----END PGP SIGNATURE-----

--=-WcoQxGNzjcyCe5J5aoqX--

