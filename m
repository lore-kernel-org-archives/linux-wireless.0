Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:9719 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbYLIT6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 14:58:37 -0500
Received: by ug-out-1314.google.com with SMTP id 39so50674ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2008 11:58:35 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [Patch 2/2 v2] Add signal strength and bandwith to nl80211station info
Date: Tue, 9 Dec 2008 20:58:26 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <rogge@fgan.de>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812071917.07075.hrogge@googlemail.com> <1228765415.22164.107.camel@johannes.berg>
In-Reply-To: <1228765415.22164.107.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1528385.7Cir7t2ABT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812092058.32251.hrogge@googlemail.com> (sfid-20081209_205841_313770_FBA090AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1528385.7Cir7t2ABT
Content-Type: multipart/mixed;
  boundary="Boundary-01=_j3sPJm3j4bSFFs0"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_j3sPJm3j4bSFFs0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This patch adds the total transmission bitrate for adhoc station even for=20
802.11n transmissions. It must be applied after the first patch of this=20
series.

=2D-------------------------
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 56450b4..cc93e7a 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -431,14 +431,14 @@ enum nl80211_sta_flags {
  * when getting information about the bitrate of a station.
  *
  * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
=2D * @NL80211_RATE_INFO_LEGACY: bitrate for 802.11abg (u16, 100kbit/s)
+ * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
  * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
  * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
  * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
  */
 enum nl80211_rate_info {
 	__NL80211_RATE_INFO_INVALID,
=2D	NL80211_RATE_INFO_LEGACY,
+	NL80211_RATE_INFO_BITRATE,
 	NL80211_RATE_INFO_MCS,
 	NL80211_RATE_INFO_40_MHZ_WIDTH,
 	NL80211_RATE_INFO_SHORT_GI,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3f13928..63a4d08 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1079,6 +1079,35 @@ static int parse_station_flags(struct nlattr *nla, u=
32=20
*staflags)
 	return 0;
 }
=20
+static u16 nl80211_calculate_bitrate(struct rate_info *rate)
+{
+	int modulation, streams, bitrate;
+
+	if (!(rate->flags & RATE_INFO_FLAGS_MCS))
+		return rate->legacy;
+
+	modulation =3D rate->mcs & 7;
+	streams =3D (rate->mcs >> 3) + 1;
+
+	bitrate =3D (rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) ?
+			13500000 : 6500000;
+
+	if (modulation < 4)
+		bitrate *=3D (modulation + 1);
+	else if (modulation =3D=3D 4)
+		bitrate *=3D (modulation + 2);
+	else
+		bitrate *=3D (modulation + 3);
+
+	bitrate *=3D streams;
+
+	if (rate->flags & RATE_INFO_FLAGS_SHORT_GI)
+		bitrate =3D (bitrate / 9) * 10;
+
+	/* do NOT round down here */
+	return (bitrate + 50000) / 100000;
+}
+
 static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				int flags, struct net_device *dev,
 				u8 *mac_addr, struct station_info *sinfo)
@@ -1122,13 +1151,12 @@ static int nl80211_send_station(struct sk_buff *msg=
,=20
u32 pid, u32 seq,
 		if (!txrate)
 			goto nla_put_failure;
=20
=2D
=2D		if (!(sinfo->txrate.flags & RATE_INFO_FLAGS_MCS))
=2D			NLA_PUT_U16(msg, NL80211_RATE_INFO_LEGACY,
=2D				    sinfo->txrate.legacy);
=2D		else
+		NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE,
+				nl80211_calculate_bitrate(&sinfo->txrate));
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_MCS)
 			NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS,
 				    sinfo->txrate.mcs);
+
 		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
 			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_40_MHZ_WIDTH);
 		if (sinfo->txrate.flags & RATE_INFO_FLAGS_SHORT_GI)


--Boundary-01=_j3sPJm3j4bSFFs0
Content-Type: text/x-patch;
  charset="ISO-8859-15";
  name="nl80211ext_v9_2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nl80211ext_v9_2.patch"

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 56450b4..cc93e7a 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -431,14 +431,14 @@ enum nl80211_sta_flags {
  * when getting information about the bitrate of a station.
  *
  * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
=2D * @NL80211_RATE_INFO_LEGACY: bitrate for 802.11abg (u16, 100kbit/s)
+ * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
  * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
  * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
  * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
  */
 enum nl80211_rate_info {
 	__NL80211_RATE_INFO_INVALID,
=2D	NL80211_RATE_INFO_LEGACY,
+	NL80211_RATE_INFO_BITRATE,
 	NL80211_RATE_INFO_MCS,
 	NL80211_RATE_INFO_40_MHZ_WIDTH,
 	NL80211_RATE_INFO_SHORT_GI,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3f13928..63a4d08 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1079,6 +1079,35 @@ static int parse_station_flags(struct nlattr *nla, u=
32 *staflags)
 	return 0;
 }
=20
+static u16 nl80211_calculate_bitrate(struct rate_info *rate)
+{
+	int modulation, streams, bitrate;
+
+	if (!(rate->flags & RATE_INFO_FLAGS_MCS))
+		return rate->legacy;
+
+	modulation =3D rate->mcs & 7;
+	streams =3D (rate->mcs >> 3) + 1;
+
+	bitrate =3D (rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) ?
+			13500000 : 6500000;
+
+	if (modulation < 4)
+		bitrate *=3D (modulation + 1);
+	else if (modulation =3D=3D 4)
+		bitrate *=3D (modulation + 2);
+	else
+		bitrate *=3D (modulation + 3);
+
+	bitrate *=3D streams;
+
+	if (rate->flags & RATE_INFO_FLAGS_SHORT_GI)
+		bitrate =3D (bitrate / 9) * 10;
+
+	/* do NOT round down here */
+	return (bitrate + 50000) / 100000;
+}
+
 static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				int flags, struct net_device *dev,
 				u8 *mac_addr, struct station_info *sinfo)
@@ -1122,13 +1151,12 @@ static int nl80211_send_station(struct sk_buff *msg=
, u32 pid, u32 seq,
 		if (!txrate)
 			goto nla_put_failure;
=20
=2D
=2D		if (!(sinfo->txrate.flags & RATE_INFO_FLAGS_MCS))
=2D			NLA_PUT_U16(msg, NL80211_RATE_INFO_LEGACY,
=2D				    sinfo->txrate.legacy);
=2D		else
+		NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE,
+				nl80211_calculate_bitrate(&sinfo->txrate));
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_MCS)
 			NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS,
 				    sinfo->txrate.mcs);
+
 		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
 			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_40_MHZ_WIDTH);
 		if (sinfo->txrate.flags & RATE_INFO_FLAGS_SHORT_GI)

--Boundary-01=_j3sPJm3j4bSFFs0--

--nextPart1528385.7Cir7t2ABT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk+zegACgkQcenvcwAcHWcJVgCePxUL6CtedB6Nn6eoq1yEugJv
gEgAoIf2MJRGiSwc6jUT2CWaQZmCg7pI
=auiY
-----END PGP SIGNATURE-----

--nextPart1528385.7Cir7t2ABT--
