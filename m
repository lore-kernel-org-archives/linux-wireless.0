Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:22165 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030319AbXDJCs2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 22:48:28 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: make mode change to same mode always successful
Date: Mon, 9 Apr 2007 22:45:45 -0400
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4689356.uBjqX5YZTE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704092245.49798.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4689356.uBjqX5YZTE
Content-Type: multipart/mixed;
  boundary="Boundary-01=_ZpvGGOmWnUs+fA6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_ZpvGGOmWnUs+fA6
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I suspect wireless mode change failure is the cause of many wpa_supplicant =
and=20
NM problems. Anyone who is having issues with wpa_supplicant and/or NM -=20
please try this patch.

Thanks,
=2DMichael Wu

--Boundary-01=_ZpvGGOmWnUs+fA6
Content-Type: text/x-diff;
  charset="us-ascii";
  name="friendly-siwmode.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="friendly-siwmode.diff"

mac80211: make mode change to same mode always successful

=46rom: Michael Wu <flamingice@sourmilk.net>

This patch makes ieee80211_ioctl_siwmode always return success if the new
mode is the same as the current mode.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/mac80211/ieee80211_ioctl.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index d139d97..bb3852c 100644
=2D-- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1738,8 +1738,6 @@ static int ieee80211_ioctl_siwmode(struct net_device =
*dev,
=20
 	if (sdata->type =3D=3D IEEE80211_IF_TYPE_VLAN)
 		return -EOPNOTSUPP;
=2D	if (netif_running(dev))
=2D		return -EBUSY;
=20
 	switch (*mode) {
 	case IW_MODE_MASTER:
@@ -1761,10 +1759,14 @@ static int ieee80211_ioctl_siwmode(struct net_devic=
e *dev,
 		return -EINVAL;
 	}
=20
=2D	if (type !=3D sdata->type) {
=2D		ieee80211_if_reinit(dev);
=2D		ieee80211_if_set_type(dev, type);
=2D	}
+	if (type =3D=3D sdata->type)
+		return 0;
+	if (netif_running(dev))
+		return -EBUSY;
+
+	ieee80211_if_reinit(dev);
+	ieee80211_if_set_type(dev, type);
+
 	return 0;
 }
=20

--Boundary-01=_ZpvGGOmWnUs+fA6--

--nextPart4689356.uBjqX5YZTE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGGvpdT3Oqt9AH4aERArtIAJ9aCyk4X5544q8r/jxaUc9oNClhdgCfTCks
K2JquW8gsqDhRiSNu73p0uM=
=l0pS
-----END PGP SIGNATURE-----

--nextPart4689356.uBjqX5YZTE--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
