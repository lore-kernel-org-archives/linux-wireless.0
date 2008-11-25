Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:31909 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYKYUbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 15:31:35 -0500
Received: by ey-out-2122.google.com with SMTP id 6so59500eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 12:31:33 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: RFC Patch: Add signal strength to nl80211station info
Date: Tue, 25 Nov 2008 21:31:24 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1407293.meWJ6kxEJo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200811252131.30161.hrogge@googlemail.com> (sfid-20081125_213139_680674_17E7A0BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1407293.meWJ6kxEJo
Content-Type: multipart/mixed;
  boundary="Boundary-01=_dCGLJj13g5iFFbC"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_dCGLJj13g5iFFbC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I have just written a prototype of a patch that adds signal strength inform=
ation to the nl80211 station info. This allows user space programs to keep =
track of the signal=20
strength of each other station in communication range (in adhoc mode) witho=
ut using radiotap headers (which consume lots of cpu power on embedded syst=
ems).

I have tested the patch with a modified iw command on ath5k. I'm still look=
ing for a way to add the datarate of unicast for each of the stations in ra=
nge, but would like=20
to hear comments about the patch.

=2D------------------------------------------
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e08c8bc..1e20e47 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -413,7 +413,10 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
=2D
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_NOISE,
+	NL80211_STA_INFO_QUAL,
+=09
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
 	NL80211_STA_INFO_MAX =3D __NL80211_STA_INFO_AFTER_LAST - 1
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1d57835..7fc1aaf 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -175,6 +175,9 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_NOISE		=3D 1<<7,
+	STATION_INFO_QUAL		=3D 1<<8,
 };
=20
 /**
@@ -195,6 +198,7 @@ struct station_info {
 	u32 inactive_time;
 	u32 rx_bytes;
 	u32 tx_bytes;
+	u32 signal,noise,qual;
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16423f9..8006555 100644
=2D-- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -310,12 +310,18 @@ static void sta_set_sinfo(struct sta_info *sta, struc=
t station_info *sinfo)
=20
 	sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
=2D			STATION_INFO_TX_BYTES;
+			STATION_INFO_TX_BYTES |
+			STATION_INFO_SIGNAL |
+			STATION_INFO_NOISE |
+			STATION_INFO_QUAL;
=20
 	sinfo->inactive_time =3D jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes =3D sta->rx_bytes;
 	sinfo->tx_bytes =3D sta->tx_bytes;
=2D
+	sinfo->signal =3D sta->last_signal;
+	sinfo->qual =3D sta->last_qual;
+	sinfo->noise =3D sta->last_noise;
+=09
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |=3D STATION_INFO_LLID |
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c9141e3..de30b1a 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1057,6 +1057,15 @@ static int nl80211_send_station(struct sk_buff *msg,=
 u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
+	if (sinfo->filled & STATION_INFO_SIGNAL)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_SIGNAL,
+			    sinfo->signal);
+	if (sinfo->filled & STATION_INFO_NOISE)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_NOISE,
+			    sinfo->noise);
+	if (sinfo->filled & STATION_INFO_QUAL)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_QUAL,
+			    sinfo->qual);
=20
 	nla_nest_end(msg, sinfoattr);
=20


--Boundary-01=_dCGLJj13g5iFFbC
Content-Type: text/x-patch;
  charset="UTF-8";
  name="wireless.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="wireless.patch"

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e08c8bc..1e20e47 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -413,7 +413,10 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
=2D
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_NOISE,
+	NL80211_STA_INFO_QUAL,
+=09
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
 	NL80211_STA_INFO_MAX =3D __NL80211_STA_INFO_AFTER_LAST - 1
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1d57835..7fc1aaf 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -175,6 +175,9 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_NOISE		=3D 1<<7,
+	STATION_INFO_QUAL		=3D 1<<8,
 };
=20
 /**
@@ -195,6 +198,7 @@ struct station_info {
 	u32 inactive_time;
 	u32 rx_bytes;
 	u32 tx_bytes;
+	u32 signal,noise,qual;
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16423f9..8006555 100644
=2D-- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -310,12 +310,18 @@ static void sta_set_sinfo(struct sta_info *sta, struc=
t station_info *sinfo)
=20
 	sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
=2D			STATION_INFO_TX_BYTES;
+			STATION_INFO_TX_BYTES |
+			STATION_INFO_SIGNAL |
+			STATION_INFO_NOISE |
+			STATION_INFO_QUAL;
=20
 	sinfo->inactive_time =3D jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes =3D sta->rx_bytes;
 	sinfo->tx_bytes =3D sta->tx_bytes;
=2D
+	sinfo->signal =3D sta->last_signal;
+	sinfo->qual =3D sta->last_qual;
+	sinfo->noise =3D sta->last_noise;
+=09
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |=3D STATION_INFO_LLID |
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c9141e3..de30b1a 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1057,6 +1057,15 @@ static int nl80211_send_station(struct sk_buff *msg,=
 u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
+	if (sinfo->filled & STATION_INFO_SIGNAL)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_SIGNAL,
+			    sinfo->signal);
+	if (sinfo->filled & STATION_INFO_NOISE)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_NOISE,
+			    sinfo->noise);
+	if (sinfo->filled & STATION_INFO_QUAL)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_QUAL,
+			    sinfo->qual);
=20
 	nla_nest_end(msg, sinfoattr);
=20

--Boundary-01=_dCGLJj13g5iFFbC--

--nextPart1407293.meWJ6kxEJo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkksYKIACgkQcenvcwAcHWeL2QCgkfxHQW19hRFQaZ6EFLfd7tus
DUAAnjvrM3cNfpnSJp04aUJOkfYPPq2t
=cZuG
-----END PGP SIGNATURE-----

--nextPart1407293.meWJ6kxEJo--
