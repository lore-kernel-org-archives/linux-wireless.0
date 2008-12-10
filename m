Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:23776 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbYLJU7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 15:59:01 -0500
Received: by ey-out-2122.google.com with SMTP id 6so129137eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 12:58:59 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] Add signal strength and bandwith to nl80211station info
Date: Wed, 10 Dec 2008 21:58:45 +0100
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812101840.32146.hrogge@googlemail.com> <1228941937.15837.71.camel@johannes.berg>
In-Reply-To: <1228941937.15837.71.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4919527.M2vXApMrRk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812102158.56201.hrogge@googlemail.com> (sfid-20081210_215908_120130_212824F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4919527.M2vXApMrRk
Content-Type: multipart/mixed;
  boundary="Boundary-01=_F2CQJijybwQnPTR"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_F2CQJijybwQnPTR
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 10 December 2008 21:45:37 Johannes Berg wrote:
> On Wed, 2008-12-10 at 18:40 +0100, Henning Rogge wrote:
> Can you do what I asked for instead and not include the attribute when
> it has a bogus value?
I agree, that was a stupid thing...

Henning
=2D------------------------------
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
index 3f13928..4797b47 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1079,12 +1079,46 @@ static int parse_station_flags(struct nlattr *nla, =
u32=20
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
+	/* the formula below does only work for MCS values smaller than 32 */
+	if (rate->mcs >=3D 32)
+		return 0;
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
 {
 	void *hdr;
 	struct nlattr *sinfoattr, *txrate;
+	u16 bitrate;
=20
 	hdr =3D nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
 	if (!hdr)
@@ -1122,11 +1156,12 @@ static int nl80211_send_station(struct sk_buff *msg=
,=20
u32 pid, u32 seq,
 		if (!txrate)
 			goto nla_put_failure;
=20
+		/* nl80211_calculate_bitrate will return 0 for mcs >=3D 32 */
+		bitrate =3D nl80211_calculate_bitrate(&sinfo->txrate);
+		if (bitrate > 0)
+			NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE, bitrate);
=20
=2D		if (!(sinfo->txrate.flags & RATE_INFO_FLAGS_MCS))
=2D			NLA_PUT_U16(msg, NL80211_RATE_INFO_LEGACY,
=2D				    sinfo->txrate.legacy);
=2D		else
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_MCS)
 			NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS,
 				    sinfo->txrate.mcs);
 		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)


--Boundary-01=_F2CQJijybwQnPTR
Content-Type: text/x-patch;
  charset="ISO-8859-15";
  name="nl80211ext_v11_2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nl80211ext_v11_2.patch"

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
index 3f13928..4797b47 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1079,12 +1079,46 @@ static int parse_station_flags(struct nlattr *nla, =
u32 *staflags)
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
+	/* the formula below does only work for MCS values smaller than 32 */
+	if (rate->mcs >=3D 32)
+		return 0;
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
 {
 	void *hdr;
 	struct nlattr *sinfoattr, *txrate;
+	u16 bitrate;
=20
 	hdr =3D nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
 	if (!hdr)
@@ -1122,11 +1156,12 @@ static int nl80211_send_station(struct sk_buff *msg=
, u32 pid, u32 seq,
 		if (!txrate)
 			goto nla_put_failure;
=20
+		/* nl80211_calculate_bitrate will return 0 for mcs >=3D 32 */
+		bitrate =3D nl80211_calculate_bitrate(&sinfo->txrate);
+		if (bitrate > 0)
+			NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE, bitrate);
=20
=2D		if (!(sinfo->txrate.flags & RATE_INFO_FLAGS_MCS))
=2D			NLA_PUT_U16(msg, NL80211_RATE_INFO_LEGACY,
=2D				    sinfo->txrate.legacy);
=2D		else
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_MCS)
 			NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS,
 				    sinfo->txrate.mcs);
 		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)

--Boundary-01=_F2CQJijybwQnPTR--

--nextPart4919527.M2vXApMrRk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAklALZAACgkQcenvcwAcHWfNDgCghFCYZ/gsNpoPhOtgcTU0n1o/
gW4AnjjaSJfxQGsaym0Iny6r2fjEmV9T
=jQu6
-----END PGP SIGNATURE-----

--nextPart4919527.M2vXApMrRk--
