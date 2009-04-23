Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZDWRSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:18:20 -0400
Subject: Re: [RFC/RFT] mac80211: turn off radio when idle
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1240507096.27723.14.camel@rc-desk>
References: <1240446135.30082.170.camel@johannes.local>
	 <1240507096.27723.14.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JOdFY31zTf84wWhoO+yO"
Date: Thu, 23 Apr 2009 19:17:49 +0200
Message-Id: <1240507069.30082.242.camel@johannes.local> (sfid-20090423_191822_745306_6A0B875A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JOdFY31zTf84wWhoO+yO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Reinette,

> > This totally messes up iwlwifi: http://paste.pocoo.org/show/113789/
> >=20
> > You'll see:
> > [ 1455.006896] phy0: turning off radio - idle
> > ...
> > [ 1455.020180] phy0: turning on radio - scan
> > [ 1455.020202] ieee80211 phy0: U iwl_mac_config enter to channel 1 chan=
ged 0x1
> > [ 1455.031724] ieee80211 phy0: U iwl_mac_config leave - RF-KILL - waiti=
ng for uCode
> > [ 1455.031739] ieee80211 phy0: U iwl_mac_config leave
> > [ 1455.031752] ieee80211 phy0: U iwl_mac_hw_scan enter
> > [ 1455.031764] ieee80211 phy0: U iwl_mac_hw_scan leave - not ready or e=
xit pending
> > [ 1455.031798] phy0: turning off radio - idle
> >=20
> > at that point, things get so confused that you can't even scan any more
> > because something isn't properly reporting to cfg80211 that the scan
> > ended (but wasn't successful.)
>=20
> This seems related to the discussion about a patch we tried to submit.
> See
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/30196/focus=
=3D30280

Related, but a different situation. Also see the patch I sent to
iwlwifi. In the mail you quoted, mac80211 certainly handles an error if
it's returned directly, but if ->hw_scan() returns 0 (and only then) you
need to call the ieee80211_scan_completed() function at some point.

johannes

--=-JOdFY31zTf84wWhoO+yO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIbBAABAgAGBQJJ8KK6AAoJEKVg1VMiehFYsjAP+JnUp8XqpmdfVELf0AD/gvMe
wNe/wjGqCBPCIRrnywezJxGIl6hB3Oxi6b4VMfcFaz61/J+8Z5AidVJEDCfXkCTe
iEAft8rHymsT978AsbJ9E2acpOwrMqSDF1oQtCwCP4wVTDmvoXr5As1AuiJV+/NO
A1YbLRx3uyrCkRCcx4lHcRAohjKZjgL0t8Zcm9MWdtgEaP3AOTPuLNbjp/v6Rw4C
bRpoffKSfRSNDXyOYxllcI0QRLBNzSTB4IcxCfCPZGebZyA2VdvWyigv8c7bEZCo
YcgGwWRmpr9mthESZ90VW+ndfnUk87xjTKg3fYiy5Ha4C7RPDaXrmPX5NAl1jdn2
HXq7b06Z7IcgciPWT+ooRwksiqMMWcuwUFuJsVXmfLRZPcPA9ac6r0aujWRdJH86
0CkByM60hgvC1qu1zAN0SlDWlfAw+LyOmu56JZGEgSJfCm4Gzfg8iC2YryES1VEs
k744Id/HwLPKsAvYj+96RsgE4xb4k6786tbJpaUs4pmBW0FkeC/q0cdoIjjHQ6lo
ZH9noV3blz4ChMITS0mBV9b+LCkhtWwOkFaIWVnvX3h3YynT+WqfrtJfE1dHXPAD
7MnfXv/X0BXs8CzjBY6kr7gBquF5kWxlD4LUU8hjglTVzL1FzFvTOKjo67f4xuXN
ImcBnp8GaGO0crE6M8g=
=dzZo
-----END PGP SIGNATURE-----

--=-JOdFY31zTf84wWhoO+yO--

