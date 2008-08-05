Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773AbYHEJJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 05:09:58 -0400
Subject: Re: [PATCH 1/1] mac80211: filter probes in
	ieee80211_rx_mgmt_probe_resp
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240808050014t6e315fe5s607aff1656c1f8d1@mail.gmail.com> (sfid-20080805_091410_511567_4BA0F990)
References: <1217763121-9057-1-git-send-email-tomas.winkler@intel.com>
	 <1217787259.4721.18.camel@johannes.berg>
	 <1ba2fa240808050014t6e315fe5s607aff1656c1f8d1@mail.gmail.com>
	 (sfid-20080805_091410_511567_4BA0F990)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wFD4gHWAZDIxF78TvWSV"
Date: Tue, 05 Aug 2008 11:09:08 +0200
Message-Id: <1217927348.3603.29.camel@johannes.berg> (sfid-20080805_111002_620607_E1D3FFF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wFD4gHWAZDIxF78TvWSV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 10:14 +0300, Tomas Winkler wrote:
> On Sun, Aug 3, 2008 at 9:14 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Sun, 2008-08-03 at 14:32 +0300, Tomas Winkler wrote:
> >> This patch moves filtering statement from ieee80211_rx_bss_info
> >> which is called for both beacon and probe to ieee80211_rx_mgmt_probe_r=
esp
> >> and save few cycles in beacon parsing.
> >
> > Sounds alright to me, but maybe we should then document that
> > rx_bss_info() only expects data for the right BSSID?
>=20
> Probes are filtered on destination address not on BSSID, to exclude
> probe responses not directed to the station.
> bss_info treats any BSSID this is what creates the bss list after all
> if I'm not mistaken.

Eh, right, of course, not sure why I got confused there. Still though,
adding a few lines of comments would be nice. If we did that every time
we changed a function, we'd have documentation for all functions in no
time ;) Oh well...

johannes

--=-wFD4gHWAZDIxF78TvWSV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImBiwAAoJEKVg1VMiehFYsmUP/iO2uXhEBb/7wIKk0nkllbx3
wVDCUeg6QH+bXcpSMV74JzB0zpgzL7Xn9T0nn3Hq0WNaCgJZPXgjHFGV6kNaBk1J
Bkg3W3Y/wAusP1C2QTIcTu2waZplbSMjg3bm55a1ak4skeBtBTLXgIF24CEMUB2R
imrn7P6GhCMa/a5YV1pvUBvkWnIOBLnEIbLt1BYh7VoGQq2HXuuo/sNEU0UWkvdd
vn/Ydi5ngDuK0aB5245XstTMUbpzfNKcSBSoQL2Vq5Wl9jV/wmuCNwEBEYJoKRgb
R2w40xWsb8RddlH6vQOy514/RXoIh5b2GfjR+r6LIXFUJxobp2sMcSw77R1dfBer
F5Pmo1MfVghSXTDnjwXfCelkuEp4y6rZkmyKwf8DG6R1H2RWQjAU6mX0S1a6DSVM
zv7a5ALyT/fS6FiXKx7D0Zp/Npgvl+I4YSlE/MWKbwHM4AUdZl+VD+X3VJLE6F+p
OJgyti7cDOSbgzjkFTN+8JR3WCpgRL3eFU461ctOGVNrzlIY4xchXTQZ0+BXj8H2
n/5X6oxBG/mLogZI6uZqu+LQ/8eaGuHaHOm1mXV/PKmUSb1iYeFKUOeFg4Haw5A/
LxbdM2Zbm0z4F8yUxHKCdf5tlqMa/qnKgpSd9jspzVHKDRgYzTzLn+/QkQdqeFPd
j/tnRJPVwHGUAIMCJBJ1
=4AKO
-----END PGP SIGNATURE-----

--=-wFD4gHWAZDIxF78TvWSV--

