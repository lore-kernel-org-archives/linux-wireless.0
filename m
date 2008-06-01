Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:1454 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755011AbYFAV7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2008 17:59:39 -0400
Received: from deadeye.i.decadent.org.uk ([192.168.4.177])
	by shadbolt.decadent.org.uk with esmtp (Exim 4.63)
	(envelope-from <ben@decadent.org.uk>)
	id 1K2utm-0003xr-Nl
	for linux-wireless@vger.kernel.org; Sun, 01 Jun 2008 22:15:39 +0100
Received: from womble by deadeye.i.decadent.org.uk with local (Exim 4.69)
	(envelope-from <ben@decadent.org.uk>)
	id 1K2ut2-0001yb-9E
	for linux-wireless@vger.kernel.org; Sun, 01 Jun 2008 22:14:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NHB6gLZtW3p7s2qoU2+w"
Date: Sun, 01 Jun 2008 22:14:44 +0100
Message-Id: <1212354884.4722.26.camel@deadeye.i.decadent.org.uk> (sfid-20080601_235957_766328_0713F24F)
Mime-Version: 1.0
Subject: IW_SCAN_CAPA_ESSID vs hidden ESSID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NHB6gLZtW3p7s2qoU2+w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Since upgrading from Linux 2.6.24 to .25, I have found that
NetworkManager cannot associate my Intel wireless card, handled by the
ipw2200 driver, with my AP, which has a hidden SSID.

NetworkManager thinks that wpa_supplicant should be able to scan for
specific hidden SSIDs if the underlying driver advertises
IW_SCAN_CAPA_ESSID, which ipw2200 does since 2.6.25:

	/* Use "AP_SCAN 2" if:
	 * - The wireless network is non-broadcast and the driver doesn't support
	 *     scanning specific SSIDs
	 * - The wireless network is Ad-Hoc
	 * - The wireless driver does not support WPA (stupid drivers...)
	 */
	is_adhoc =3D (nm_ap_get_mode(ap) =3D=3D IW_MODE_ADHOC);
	if (is_adhoc || !supports_wpa)
		ap_scan =3D "AP_SCAN 2";
	else if (!nm_ap_get_broadcast (ap))
		ap_scan =3D self->priv->has_scan_capa_ssid ? "AP_SCAN 1" : "AP_SCAN 2";

However, this doesn't work because the scan results just have an empty
string or "<hidden>" (not consistently, which is weird).

So one of these components is doing the wrong thing.  Is it that:

1. ipw2200 or ieee80211 should copy the selected ESSID into scan results
2. wpa_supplicant should not check the ESSID of scan results if it has
already selected an ESSId
3. NetworkManager should not expect IW_SCAN_CAPA_ESSID to mean that this
will work

?

Ben.

--=20
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camu=
s

--=-NHB6gLZtW3p7s2qoU2+w
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIQxFE79ZNCRIGYgcRAmGuAKCLUiu3SoEJ7CbNHHeKUaAHy3zInwCfWijt
opYvIOXV+Xb+y0FAydMZ79I=
=bFUo
-----END PGP SIGNATURE-----

--=-NHB6gLZtW3p7s2qoU2+w--
