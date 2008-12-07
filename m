Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:1422 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbYLGSVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 13:21:46 -0500
Received: by nf-out-0910.google.com with SMTP id d3so380210nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 10:21:44 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/2] Add signal strength and bandwith to nl80211station info
Date: Sun, 7 Dec 2008 19:19:01 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <rogge@fgan.de>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812071832.20533.hrogge@googlemail.com> <1228671578.22164.48.camel@johannes.berg>
In-Reply-To: <1228671578.22164.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1912631.2fcsvss6Cj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812071919.07680.hrogge@googlemail.com> (sfid-20081207_192157_837395_FB0672A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1912631.2fcsvss6Cj
Content-Type: multipart/mixed;
  boundary="Boundary-01=_WOBPJzwEa3QnK8k"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_WOBPJzwEa3QnK8k
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This patch adds the total transmission bitrate for adhoc station even for=20
802.11n transmissions. It must be applied after the first patch of this=20
series.

=2D------------------------
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 56450b4..b5abe36 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -431,14 +431,14 @@ enum nl80211_sta_flags {
  * when getting information about the bitrate of a station.
  *
  * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
=2D * @NL80211_RATE_INFO_LEGACY: bitrate for 802.11abg (u16, 100kbit/s)
+ * @NL80211_RATE_INFO_TOTAL: total bitrate (u16, 100kbit/s)
  * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
  * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
  * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
  */
 enum nl80211_rate_info {
 	__NL80211_RATE_INFO_INVALID,
=2D	NL80211_RATE_INFO_LEGACY,
+	NL80211_RATE_INFO_TOTAL,
 	NL80211_RATE_INFO_MCS,
 	NL80211_RATE_INFO_40_MHZ_WIDTH,
 	NL80211_RATE_INFO_SHORT_GI,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c9268b2..8689744 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1080,6 +1080,35 @@ static int parse_station_flags(struct nlattr *nla, u=
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
+	streams =3D rate->mcs >> 3;
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
+		bitrate =3D (bitrate * 10) / 9;
+
+	/* do NOT round down here */
+	return (bitrate + 50000) / 100000;
+}
+
 static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				int flags, struct net_device *dev,
 				u8 *mac_addr, struct station_info *sinfo)
@@ -1123,13 +1152,12 @@ static int nl80211_send_station(struct sk_buff *msg=
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
+		NLA_PUT_U16(msg, NL80211_RATE_INFO_TOTAL,
+				nl80211_calculate_bitrate(&sinfo->txrate));
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_MCS)
 			NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS,
 				    sinfo->txrate.mcs);
+
 		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
 			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_40_MHZ_WIDTH);
 		if (sinfo->txrate.flags & RATE_INFO_FLAGS_SHORT_GI)


--Boundary-01=_WOBPJzwEa3QnK8k
Content-Type: text/x-patch;
  charset="ISO-8859-15";
  name="nl80211ext_v8_2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nl80211ext_v8_2.patch"

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 56450b4..b5abe36 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -431,14 +431,14 @@ enum nl80211_sta_flags {
  * when getting information about the bitrate of a station.
  *
  * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
=2D * @NL80211_RATE_INFO_LEGACY: bitrate for 802.11abg (u16, 100kbit/s)
+ * @NL80211_RATE_INFO_TOTAL: total bitrate (u16, 100kbit/s)
  * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
  * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
  * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
  */
 enum nl80211_rate_info {
 	__NL80211_RATE_INFO_INVALID,
=2D	NL80211_RATE_INFO_LEGACY,
+	NL80211_RATE_INFO_TOTAL,
 	NL80211_RATE_INFO_MCS,
 	NL80211_RATE_INFO_40_MHZ_WIDTH,
 	NL80211_RATE_INFO_SHORT_GI,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c9268b2..8689744 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1080,6 +1080,35 @@ static int parse_station_flags(struct nlattr *nla, u=
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
+	streams =3D rate->mcs >> 3;
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
+		bitrate =3D (bitrate * 10) / 9;
+
+	/* do NOT round down here */
+	return (bitrate + 50000) / 100000;
+}
+
 static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				int flags, struct net_device *dev,
 				u8 *mac_addr, struct station_info *sinfo)
@@ -1123,13 +1152,12 @@ static int nl80211_send_station(struct sk_buff *msg=
, u32 pid, u32 seq,
 		if (!txrate)
 			goto nla_put_failure;
=20
=2D
=2D		if (!(sinfo->txrate.flags & RATE_INFO_FLAGS_MCS))
=2D			NLA_PUT_U16(msg, NL80211_RATE_INFO_LEGACY,
=2D				    sinfo->txrate.legacy);
=2D		else
+		NLA_PUT_U16(msg, NL80211_RATE_INFO_TOTAL,
+				nl80211_calculate_bitrate(&sinfo->txrate));
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_MCS)
 			NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS,
 				    sinfo->txrate.mcs);
+
 		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
 			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_40_MHZ_WIDTH);
 		if (sinfo->txrate.flags & RATE_INFO_FLAGS_SHORT_GI)

--Boundary-01=_WOBPJzwEa3QnK8k--

--nextPart1912631.2fcsvss6Cj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk8E5sACgkQcenvcwAcHWcV8ACfQJN+bMAv5u2kNUsci6JzFfiD
w94AoIUmpgvVBUtgxiyXyj5vrC06pKo3
=4Twl
-----END PGP SIGNATURE-----

--nextPart1912631.2fcsvss6Cj--
