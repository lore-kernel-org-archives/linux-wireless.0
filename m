Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:24406 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab2CAJCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 04:02:53 -0500
Date: Thu, 1 Mar 2012 10:02:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/4 v2] rndis_wlan: integer overflows in
 rndis_wlan_do_link_up_work()
Message-ID: <20120301070208.GH1003@mwanda> (sfid-20120301_100301_291077_04A98578)
References: <20120229063555.GC18031@elgon.mountain>
 <4F4DE009.7010808@bfs.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HuscSE0D68UGttcd"
In-Reply-To: <4F4DE009.7010808@bfs.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HuscSE0D68UGttcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

If "offset" is negative then we can get past this check:
	if (offset > CONTROL_BUFFER_SIZE)
Or if we pick a very high "req_ie_len" then we can get around the check:
	if (offset + req_ie_len > CONTROL_BUFFER_SIZE)

I made "resp_ie_len" and "req_ie_len" unsigned.  I don't know if it was
intentional that they were signed in the original.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Fixed a style issue for Walter Harms.  Changed > 0 to !=3D 0.

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis=
_wlan.c
index a330c69..dde45ef 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2755,9 +2755,10 @@ static void rndis_wlan_do_link_up_work(struct usbnet=
 *usbdev)
 	struct rndis_wlan_private *priv =3D get_rndis_wlan_priv(usbdev);
 	struct ndis_80211_assoc_info *info =3D NULL;
 	u8 bssid[ETH_ALEN];
-	int resp_ie_len, req_ie_len;
+	unsigned int resp_ie_len, req_ie_len;
+	unsigned int offset;
 	u8 *req_ie, *resp_ie;
-	int ret, offset;
+	int ret;
 	bool roamed =3D false;
 	bool match_bss;
=20
@@ -2785,7 +2786,9 @@ static void rndis_wlan_do_link_up_work(struct usbnet =
*usbdev)
 		ret =3D get_association_info(usbdev, info, CONTROL_BUFFER_SIZE);
 		if (!ret) {
 			req_ie_len =3D le32_to_cpu(info->req_ie_length);
-			if (req_ie_len > 0) {
+			if (req_ie_len > CONTROL_BUFFER_SIZE)
+				req_ie_len =3D CONTROL_BUFFER_SIZE;
+			if (req_ie_len !=3D 0) {
 				offset =3D le32_to_cpu(info->offset_req_ies);
=20
 				if (offset > CONTROL_BUFFER_SIZE)
@@ -2799,7 +2802,9 @@ static void rndis_wlan_do_link_up_work(struct usbnet =
*usbdev)
 			}
=20
 			resp_ie_len =3D le32_to_cpu(info->resp_ie_length);
-			if (resp_ie_len > 0) {
+			if (resp_ie_len > CONTROL_BUFFER_SIZE)
+				resp_ie_len =3D CONTROL_BUFFER_SIZE;
+			if (resp_ie_len !=3D 0) {
 				offset =3D le32_to_cpu(info->offset_resp_ies);
=20
 				if (offset > CONTROL_BUFFER_SIZE)

--HuscSE0D68UGttcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTx7vAAoJEOnZkXI/YHqRw6sQAKT8F1cZtO91pHip+YPPzN6M
qkXspplosHd4SeyOlsz7ZCuqc+lU83Vh2ePj6pO2fFswedqvN8x/TRiWtg94Zl3v
/1ptM7CbCi44iC/gLAx7Zg/OCpxSRYCcDC5ys288WnOkkuYVmwaJ+b7aaJMZOjNJ
pYyRlGs7rbcYiWaBcOh4CAp8GN3/HbEnCJ/PaberIBYO/PzHjqFHN4X6wz2KhIDE
eBUqw7dExbaXzLcvvmyrSFcWOAeYjgy076B7aDzq1Sp9Bu4OJexBHBHmf5+xxkOX
WUjP/q1ja+koHJt2zOQsXurqSrLu0gr8vn79TO5plisGcKiFZDrpRZCh+x+xd2OY
kXlYXbUCgV50nAPxjRIydCCuPiQTUkXKIXW8jk+W4SbcBzRWnoGe/j6jb40fj34I
vr6SrmoIzsuKCT8wEgoCplDfzr4gzKFJzSF2d3OKH6gsRWrflRhEA7AonOKFDT+s
i9i51B2nAtYcX8l66WA5GBjkXzrw31E0mH3sc9Bnc3uLDxu/v0VaI0N8ugKwriUP
sDI0p1SvIrk82PNMZMqLEZrd9tpy3Ta0bnqjDeOkQMynxNteL1JITqlgfYw4iaFt
JfaO8oAKRdYNPRBtrB8GtqVTNtHuaWB8FnO0ALiTTJrioIxJEHUY2BeRVhrjdVZf
/cPoTqG5hAU5abexvZ37
=nWls
-----END PGP SIGNATURE-----

--HuscSE0D68UGttcd--
