Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYDRWhj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 18:37:39 -0400
Subject: Re:  RE: iwl3945 problem with 2.6.25-rc9
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Morrison <bdm@fenrir.org.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080418232358.000fbdf7@peterson.fenrir.org.uk> (sfid-20080418_232413_255865_9BD07164)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org>
	 <1208376292.27708.3.camel@localhost.localdomain>
	 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
	 (sfid-20080418_232413_255865_9BD07164)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LhPk3DWFjBrBYKqugPYH"
Date: Sat, 19 Apr 2008 00:37:35 +0200
Message-Id: <1208558255.4848.60.camel@johannes.berg> (sfid-20080418_233741_985617_9465C786)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LhPk3DWFjBrBYKqugPYH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Not wishing to muddy the waters, but I've found that the iwlwifi driver
> with a 3945 card is only reliable for scanning and associating for
> my laptop (x86_64) with disable_hw_scan=3D1 set, this is with
> 2.4.24.4-64.fc8 kernel. Driver version is 1.2.26.
>=20
> Previous to the recent heavy driver development, with 2.6.23.15-137.fc8
> the opposite was the case. This was driver version 1.2.23.
>=20
> Currently with sw scanning *every* scan returns my own 2 APs, whereas
> using hw scanning I often receive "No scan results" and my 2 APs
> sometimes appear in the scan output and disappear frequently. It's
> equally unreliable when I can see my neighbours APs, the software scan
> is reliable when signals are strong enough to register at all.

What I've found (a long time ago with hostapd) is that some APs are slow
and the firmware-assisted scanning has a too small dwell period. Maybe
we should have a module option for that so we can ask people to change
that in such cases? You could try to change the IWL_ACTIVE_DWELL_TIME_24
(and/or IWL_ACTIVE_DWELL_TIME_52) to higher values and maybe setting
IWL_PLCP_QUIET_THRESH to 0.

johannes

--=-LhPk3DWFjBrBYKqugPYH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAkirqVg1VMiehFYAQIUjxAAl2geWSMLVnpSqiLswfiv4UjrpSfHfbSe
QjtGO/UddOh4eaxyV/kHNHbNw4C5TmEPSLdFchDQ58RNgwogkZoiwkgGVoxeBGQO
aBWTyu/roiXHuLfKhMIfu1sAQXCOcf2QHtdIL5Lq6Qxjhn2Y4b1OSwCJ8ba060op
NUJphIzUIhWd/eWVgk0m/Mwt4ZTacJMNw1qszwahF1028MBKCGnn8uaH34oKGP6Q
crcL3O6dZqJi4sunjcp33LFFFzyQWx+W3e/epuHPEOH/yASyymSSIDo/fFOyZr7N
/JdNY86VHxqvYXGG4Dm8P2oM78fZ2+9x5nopeGhJCuz24LQ2M3BPiOILd1aqm0PL
RSoDnd42oz3IUibQiaKhMu95bxh38pN5MCacUzzw/3LUTydetRfBI4rsWoiKg+up
MH5ax2FvivE1WGmEA5+kKvpSUZKC3zNVAcl6WDUHviFknxJQfDSjs21QnVNjWUab
AH8GwBE3WI40V0hxWQj9BV0N/uhe1MV04ScvmWJcsY6IMxvq6Q2nSN+gF9DbOtPD
eXNaDsMQ8xIoE8SEWyUhn/Roe2Ojz0oRopd7p+QzPALt88hrrjiQgVaFMORhXDbI
a1vqrKk4AZm4sLbWRuD5tulCvXn/tOPhXSxkFf63P2nKfd9xiaX3ews9hW4po/DS
jilWUPwTWgI=
=6nxZ
-----END PGP SIGNATURE-----

--=-LhPk3DWFjBrBYKqugPYH--

