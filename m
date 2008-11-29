Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:44243 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYK2KuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 05:50:22 -0500
Received: by ug-out-1314.google.com with SMTP id 39so2169538ugf.37
        for <linux-wireless@vger.kernel.org>; Sat, 29 Nov 2008 02:50:19 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Sat, 29 Nov 2008 11:50:11 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200811252131.30161.hrogge@googlemail.com> <1227646037.4613.46.camel@johannes.berg> <EA31B699-C803-460C-8D90-9E946CC97A33@linux.intel.com>
In-Reply-To: <EA31B699-C803-460C-8D90-9E946CC97A33@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2244641.TaaiOj8kXA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200811291150.16702.hrogge@googlemail.com> (sfid-20081129_115028_752921_80935A67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2244641.TaaiOj8kXA
Content-Type: multipart/mixed;
  boundary="Boundary-01=_j5RMJNpPK6oFEoF"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_j5RMJNpPK6oFEoF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 26 November 2008 06:21:40 Marcel Holtmann wrote:
> I know that WEXT were pretty bad in describing what to expect from
> these values and every driver did whatever it thought it would be
> best. Can we not just try to define how these values should be filled
> in and then either mark drivers as broken or try to fix them? Just an
> idea.

I just created a second patch for station info.

Changes since v1:
=2D removed noise and quality from station info in NL80211
=2D added bandwith to station info in NL80211
=2D changed name of patch file to nl80211ext_v2.patch

The problem of a well defined signal strength value is still not addressed,=
=20
but I have not enough knowledge about the driver specific implementations t=
o=20
make a good suggestion I think.

Henning

=2D--------------------------------------------------

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e08c8bc..a9639fa 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -413,6 +413,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_BANDWITH,
=20
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1d57835..3621ae2 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -175,6 +175,8 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_BANDWITH		=3D 1<<7,
 };
=20
 /**
@@ -198,6 +200,8 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	u16 bandwith;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16423f9..14e3457 100644
=2D-- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -307,14 +307,24 @@ static int ieee80211_config_default_key(struct wiphy=
=20
*wiphy,
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata =3D sta->sdata;
+  struct ieee80211_supported_band *sband;
=20
 	sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
=2D			STATION_INFO_TX_BYTES;
+			STATION_INFO_TX_BYTES |
+			STATION_INFO_SIGNAL |
+			STATION_INFO_BANDWITH;
=20
 	sinfo->inactive_time =3D jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes =3D sta->rx_bytes;
 	sinfo->tx_bytes =3D sta->tx_bytes;
+	sinfo->signal =3D sta->last_signal;
+
+	sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS))
+	  sinfo->bandwith =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	else
+	  sinfo->bandwith =3D 0;
=20
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c9141e3..225ec26 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1057,6 +1057,12 @@ static int nl80211_send_station(struct sk_buff *msg,=
=20
u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
+	if (sinfo->filled & STATION_INFO_SIGNAL)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
+			    sinfo->signal);
+	if (sinfo->filled & STATION_INFO_BANDWITH)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_BANDWITH,
+			    sinfo->bandwith);
=20
 	nla_nest_end(msg, sinfoattr);
=20


--Boundary-01=_j5RMJNpPK6oFEoF
Content-Type: text/x-patch;
  charset="UTF-8";
  name="nl80211ext_v2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nl80211ext_v2.patch"

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e08c8bc..a9639fa 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -413,6 +413,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_BANDWITH,
=20
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1d57835..3621ae2 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -175,6 +175,8 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_BANDWITH		=3D 1<<7,
 };
=20
 /**
@@ -198,6 +200,8 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	u16 bandwith;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16423f9..14e3457 100644
=2D-- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -307,14 +307,24 @@ static int ieee80211_config_default_key(struct wiphy =
*wiphy,
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata =3D sta->sdata;
+  struct ieee80211_supported_band *sband;
=20
 	sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
=2D			STATION_INFO_TX_BYTES;
+			STATION_INFO_TX_BYTES |
+			STATION_INFO_SIGNAL |
+			STATION_INFO_BANDWITH;
=20
 	sinfo->inactive_time =3D jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes =3D sta->rx_bytes;
 	sinfo->tx_bytes =3D sta->tx_bytes;
+	sinfo->signal =3D sta->last_signal;
+
+	sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS))
+	  sinfo->bandwith =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	else
+	  sinfo->bandwith =3D 0;
=20
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c9141e3..225ec26 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1057,6 +1057,12 @@ static int nl80211_send_station(struct sk_buff *msg,=
 u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
+	if (sinfo->filled & STATION_INFO_SIGNAL)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
+			    sinfo->signal);
+	if (sinfo->filled & STATION_INFO_BANDWITH)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_BANDWITH,
+			    sinfo->bandwith);
=20
 	nla_nest_end(msg, sinfoattr);
=20

--Boundary-01=_j5RMJNpPK6oFEoF--

--nextPart2244641.TaaiOj8kXA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkxHmgACgkQcenvcwAcHWflIQCeKQueIOjY/56Z9RQuWRjO+d47
x0sAniN+6b8nRSCzL3D+UExm+pEfzzHa
=UhKD
-----END PGP SIGNATURE-----

--nextPart2244641.TaaiOj8kXA--
