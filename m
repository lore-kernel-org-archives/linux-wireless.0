Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:18105 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbYLKULF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 15:11:05 -0500
Received: by fk-out-0910.google.com with SMTP id 18so691723fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 12:11:03 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Patch] nl80211: Add signal strength and bandwith to nl80211station info
Date: Thu, 11 Dec 2008 21:10:48 +0100
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812111922.49439.hrogge@googlemail.com> <1229020101.8081.55.camel@johannes.berg>
In-Reply-To: <1229020101.8081.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8845675.195NBtcVJk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812112110.59679.hrogge@googlemail.com> (sfid-20081211_211112_334904_BE4D3902)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8845675.195NBtcVJk
Content-Type: multipart/mixed;
  boundary="Boundary-01=_JPXQJCeIWsIanbd"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_JPXQJCeIWsIanbd
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I noticed the MAX/AFTER_LAST comments are missing for most nl80211 enums. ;)

But I get this output on my local (2 card) ad-hoc network:
# ./iw dev wlan0 station dump
Station 00:1b:fc:91:7d:d2 (on wlan0)
        inactive time:  52 ms
        rx bytes:       207220
        tx bytes:       1396
        signal:         -66 dBm
        tx bitrate:     18.0 MBit/s

Patch for iw attached (based on git tree an hour ago). Of course the 802.11=
n=20
output part is only compile tested. Most of the patch is to put the new cop=
y=20
of nl80211.h into iw (why does iw carry a copy of this file ?)

Henning
=2D-----------
diff --git a/nl80211.h b/nl80211.h
index 04d4516..cc93e7a 100644
=2D-- a/nl80211.h
+++ b/nl80211.h
@@ -425,6 +425,30 @@ enum nl80211_sta_flags {
 };
=20
 /**
+ * enum nl80211_rate_info - bitrate information
+ *
+ * These attribute types are used with %NL80211_STA_INFO_TXRATE
+ * when getting information about the bitrate of a station.
+ *
+ * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
+ * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
+ * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
+ * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
+ * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
+ */
+enum nl80211_rate_info {
+	__NL80211_RATE_INFO_INVALID,
+	NL80211_RATE_INFO_BITRATE,
+	NL80211_RATE_INFO_MCS,
+	NL80211_RATE_INFO_40_MHZ_WIDTH,
+	NL80211_RATE_INFO_SHORT_GI,
+
+	/* keep last */
+	__NL80211_RATE_INFO_AFTER_LAST,
+	NL80211_RATE_INFO_MAX =3D __NL80211_RATE_INFO_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_sta_info - station information
  *
  * These attribute types are used with %NL80211_ATTR_STA_INFO
@@ -436,6 +460,9 @@ enum nl80211_sta_flags {
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this stati=
on)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
+ * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dB=
m)
+ * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
+ * 	containing info as possible, see &enum nl80211_sta_info_txrate.
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -445,6 +472,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_TX_BITRATE,
=20
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/station.c b/station.c
index 6503574..cf13f61 100644
=2D-- a/station.c
+++ b/station.c
@@ -27,22 +27,31 @@ enum plink_actions {
 	PLINK_ACTION_BLOCK,
 };
=20
=2D
 static int print_sta_handler(struct nl_msg *msg, void *arg)
 {
 	struct nlattr *tb[NL80211_ATTR_MAX + 1];
 	struct genlmsghdr *gnlh =3D nlmsg_data(nlmsg_hdr(msg));
 	struct nlattr *sinfo[NL80211_STA_INFO_MAX + 1];
+	struct nlattr *rinfo[NL80211_RATE_INFO_MAX + 1];
 	char mac_addr[20], state_name[10], dev[20];
 	static struct nla_policy stats_policy[NL80211_STA_INFO_MAX + 1] =3D {
 		[NL80211_STA_INFO_INACTIVE_TIME] =3D { .type =3D NLA_U32 },
 		[NL80211_STA_INFO_RX_BYTES] =3D { .type =3D NLA_U32 },
 		[NL80211_STA_INFO_TX_BYTES] =3D { .type =3D NLA_U32 },
+		[NL80211_STA_INFO_SIGNAL] =3D { .type =3D NLA_U8 },
+		[NL80211_STA_INFO_TX_BITRATE] =3D { .type =3D NLA_NESTED },
 		[NL80211_STA_INFO_LLID] =3D { .type =3D NLA_U16 },
 		[NL80211_STA_INFO_PLID] =3D { .type =3D NLA_U16 },
 		[NL80211_STA_INFO_PLINK_STATE] =3D { .type =3D NLA_U8 },
 	};
=20
+	static struct nla_policy rate_policy[NL80211_RATE_INFO_MAX + 1] =3D {
+		[NL80211_RATE_INFO_BITRATE] =3D { .type =3D NLA_U16 },
+		[NL80211_RATE_INFO_MCS] =3D { .type =3D NLA_U8 },
+		[NL80211_RATE_INFO_40_MHZ_WIDTH] =3D { .type =3D NLA_FLAG },
+		[NL80211_RATE_INFO_SHORT_GI] =3D { .type =3D NLA_FLAG },
+	};
+
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
=20
@@ -62,7 +71,7 @@ static int print_sta_handler(struct nl_msg *msg, void *ar=
g)
 		fprintf(stderr, "failed to parse nested attributes!");
 		return NL_SKIP;
 	}
=2D
+=09
 	mac_addr_n2a(mac_addr, nla_data(tb[NL80211_ATTR_MAC]));
 	if_indextoname(nla_get_u32(tb[NL80211_ATTR_IFINDEX]), dev);
 	printf("Station %s (on %s)", mac_addr, dev);
@@ -76,6 +85,33 @@ static int print_sta_handler(struct nl_msg *msg, void *a=
rg)
 	if (sinfo[NL80211_STA_INFO_TX_BYTES])
 		printf("\n\ttx bytes:\t%d",
 			nla_get_u32(sinfo[NL80211_STA_INFO_TX_BYTES]));
+	if (sinfo[NL80211_STA_INFO_SIGNAL])
+		printf("\n\tsignal:  \t%d dBm",
+			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL]));
+
+	if (sinfo[NL80211_STA_INFO_TX_BITRATE]) {
+		if (nla_parse_nested(rinfo, NL80211_RATE_INFO_MAX,
+				sinfo[NL80211_STA_INFO_TX_BITRATE],
+				rate_policy)) {
+			fprintf(stderr, "failed to parse nested rate attributes!");
+		} else {
+			printf("\n\ttx bitrate:\t");
+			if (rinfo[NL80211_RATE_INFO_BITRATE]) {
+				int rate =3D nla_get_u16(rinfo[NL80211_RATE_INFO_BITRATE]);
+				printf("%d.%d MBit/s", rate / 10, rate % 10);
+			}
+			else
+				printf("?");
+
+			if (rinfo[NL80211_RATE_INFO_MCS])
+				printf(" msc:%d",
+					nla_get_u8(rinfo[NL80211_RATE_INFO_MCS]));
+			if (rinfo[NL80211_RATE_INFO_40_MHZ_WIDTH])
+				printf(" 40Mhz");
+			if (rinfo[NL80211_RATE_INFO_SHORT_GI])
+				printf(" short-guard-interval");
+		}
+	}
 	if (sinfo[NL80211_STA_INFO_LLID])
 		printf("\n\tmesh llid:\t%d",
 			nla_get_u16(sinfo[NL80211_STA_INFO_LLID]));


--Boundary-01=_JPXQJCeIWsIanbd
Content-Type: text/x-patch;
  charset="ISO-8859-15";
  name="iw.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="iw.patch"

diff --git a/nl80211.h b/nl80211.h
index 04d4516..cc93e7a 100644
=2D-- a/nl80211.h
+++ b/nl80211.h
@@ -425,6 +425,30 @@ enum nl80211_sta_flags {
 };
=20
 /**
+ * enum nl80211_rate_info - bitrate information
+ *
+ * These attribute types are used with %NL80211_STA_INFO_TXRATE
+ * when getting information about the bitrate of a station.
+ *
+ * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
+ * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
+ * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
+ * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
+ * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
+ */
+enum nl80211_rate_info {
+	__NL80211_RATE_INFO_INVALID,
+	NL80211_RATE_INFO_BITRATE,
+	NL80211_RATE_INFO_MCS,
+	NL80211_RATE_INFO_40_MHZ_WIDTH,
+	NL80211_RATE_INFO_SHORT_GI,
+
+	/* keep last */
+	__NL80211_RATE_INFO_AFTER_LAST,
+	NL80211_RATE_INFO_MAX =3D __NL80211_RATE_INFO_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_sta_info - station information
  *
  * These attribute types are used with %NL80211_ATTR_STA_INFO
@@ -436,6 +460,9 @@ enum nl80211_sta_flags {
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this stati=
on)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
+ * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dB=
m)
+ * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
+ * 	containing info as possible, see &enum nl80211_sta_info_txrate.
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -445,6 +472,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_TX_BITRATE,
=20
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/station.c b/station.c
index 6503574..cf13f61 100644
=2D-- a/station.c
+++ b/station.c
@@ -27,22 +27,31 @@ enum plink_actions {
 	PLINK_ACTION_BLOCK,
 };
=20
=2D
 static int print_sta_handler(struct nl_msg *msg, void *arg)
 {
 	struct nlattr *tb[NL80211_ATTR_MAX + 1];
 	struct genlmsghdr *gnlh =3D nlmsg_data(nlmsg_hdr(msg));
 	struct nlattr *sinfo[NL80211_STA_INFO_MAX + 1];
+	struct nlattr *rinfo[NL80211_RATE_INFO_MAX + 1];
 	char mac_addr[20], state_name[10], dev[20];
 	static struct nla_policy stats_policy[NL80211_STA_INFO_MAX + 1] =3D {
 		[NL80211_STA_INFO_INACTIVE_TIME] =3D { .type =3D NLA_U32 },
 		[NL80211_STA_INFO_RX_BYTES] =3D { .type =3D NLA_U32 },
 		[NL80211_STA_INFO_TX_BYTES] =3D { .type =3D NLA_U32 },
+		[NL80211_STA_INFO_SIGNAL] =3D { .type =3D NLA_U8 },
+		[NL80211_STA_INFO_TX_BITRATE] =3D { .type =3D NLA_NESTED },
 		[NL80211_STA_INFO_LLID] =3D { .type =3D NLA_U16 },
 		[NL80211_STA_INFO_PLID] =3D { .type =3D NLA_U16 },
 		[NL80211_STA_INFO_PLINK_STATE] =3D { .type =3D NLA_U8 },
 	};
=20
+	static struct nla_policy rate_policy[NL80211_RATE_INFO_MAX + 1] =3D {
+		[NL80211_RATE_INFO_BITRATE] =3D { .type =3D NLA_U16 },
+		[NL80211_RATE_INFO_MCS] =3D { .type =3D NLA_U8 },
+		[NL80211_RATE_INFO_40_MHZ_WIDTH] =3D { .type =3D NLA_FLAG },
+		[NL80211_RATE_INFO_SHORT_GI] =3D { .type =3D NLA_FLAG },
+	};
+
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
=20
@@ -62,7 +71,7 @@ static int print_sta_handler(struct nl_msg *msg, void *ar=
g)
 		fprintf(stderr, "failed to parse nested attributes!");
 		return NL_SKIP;
 	}
=2D
+=09
 	mac_addr_n2a(mac_addr, nla_data(tb[NL80211_ATTR_MAC]));
 	if_indextoname(nla_get_u32(tb[NL80211_ATTR_IFINDEX]), dev);
 	printf("Station %s (on %s)", mac_addr, dev);
@@ -76,6 +85,33 @@ static int print_sta_handler(struct nl_msg *msg, void *a=
rg)
 	if (sinfo[NL80211_STA_INFO_TX_BYTES])
 		printf("\n\ttx bytes:\t%d",
 			nla_get_u32(sinfo[NL80211_STA_INFO_TX_BYTES]));
+	if (sinfo[NL80211_STA_INFO_SIGNAL])
+		printf("\n\tsignal:  \t%d dBm",
+			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL]));
+
+	if (sinfo[NL80211_STA_INFO_TX_BITRATE]) {
+		if (nla_parse_nested(rinfo, NL80211_RATE_INFO_MAX,
+				sinfo[NL80211_STA_INFO_TX_BITRATE],
+				rate_policy)) {
+			fprintf(stderr, "failed to parse nested rate attributes!");
+		} else {
+			printf("\n\ttx bitrate:\t");
+			if (rinfo[NL80211_RATE_INFO_BITRATE]) {
+				int rate =3D nla_get_u16(rinfo[NL80211_RATE_INFO_BITRATE]);
+				printf("%d.%d MBit/s", rate / 10, rate % 10);
+			}
+			else
+				printf("?");
+
+			if (rinfo[NL80211_RATE_INFO_MCS])
+				printf(" msc:%d",
+					nla_get_u8(rinfo[NL80211_RATE_INFO_MCS]));
+			if (rinfo[NL80211_RATE_INFO_40_MHZ_WIDTH])
+				printf(" 40Mhz");
+			if (rinfo[NL80211_RATE_INFO_SHORT_GI])
+				printf(" short-guard-interval");
+		}
+	}
 	if (sinfo[NL80211_STA_INFO_LLID])
 		printf("\n\tmesh llid:\t%d",
 			nla_get_u16(sinfo[NL80211_STA_INFO_LLID]));

--Boundary-01=_JPXQJCeIWsIanbd--

--nextPart8845675.195NBtcVJk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAklBc9MACgkQcenvcwAcHWdrXACdEUyXSaYlYcLRnVis4de6rwC8
izAAn0Oe4sTMKogwk3fQzmLj8Q+rGqf1
=3PIO
-----END PGP SIGNATURE-----

--nextPart8845675.195NBtcVJk--
