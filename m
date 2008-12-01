Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:51090 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbYLAOHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 09:07:07 -0500
From: Henning Rogge <rogge@fgan.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Mon, 1 Dec 2008 14:22:23 +0100
Cc: Henning Rogge <hrogge@googlemail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200811252131.30161.hrogge@googlemail.com> <200811291150.16702.hrogge@googlemail.com> <1228130256.3478.5.camel@johannes.berg>
In-Reply-To: <1228130256.3478.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1370454.xJPUhOOfoN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812011422.30671.rogge@fgan.de> (sfid-20081201_150712_248740_B069C8E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1370454.xJPUhOOfoN
Content-Type: multipart/mixed;
  boundary="Boundary-01=_QU+MJZwDSDonQeO"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_QU+MJZwDSDonQeO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Monday 01 December 2008 12:17:36 schrieb Johannes Berg:
> Even if you corrected the spelling to "bandwidth" you'd (a) be missing
> documentation and (b) be using an entirely wrong term for what you're
> doing.

Changes since v1:
=2D removed noise and quality from station info in NL80211
=2D added bandwith to station info in NL80211
=2D changed name of patch file to nl80211ext_v2.patch

Changes since v2:
=2D added kernel comment lines for new fields/enums
=2D changed name of "bandwith" field to tx_bitrate

Henning Rogge

*************************************************
Diplom Informatiker Henning Rogge
=46orschungsgesellschaft f=FCr
Angewandte Naturwissenschaften e. V. (FGAN)=20
Neuenahrer Str. 20, 53343 Wachtberg, Germany
Tel.: 0049 (0)228 9435-961
=46ax: 0049 (0)228 9435-685
E-Mail: rogge@fgan.de
Web: www.fgan.de
************************************************
Sitz der Gesellschaft: Bonn
Registergericht: Amtsgericht Bonn VR 2530
Vorstand: Dr. rer. nat. Ralf Dornhaus (Vors.), Prof. Dr. Joachim Ender=20
(Stellv.)

=2D--------------------------------------------------

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e08c8bc..030feed 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -404,6 +404,8 @@ enum nl80211_sta_flags {
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this stati=
on)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
+ * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u8,=
=20
dBm)
+ * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate (u16, 100 kbit/s)
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -413,6 +415,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_TX_BITRATE,
=20
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1d57835..fd9964c 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -167,6 +167,8 @@ struct station_parameters {
  * @STATION_INFO_LLID: @llid filled
  * @STATION_INFO_PLID: @plid filled
  * @STATION_INFO_PLINK_STATE: @plink_state filled
+ * @STATION_INFO_SIGNAL: @signal filled
+ * @STATION_INFO_TX_BITRATE: @tx_bitrate filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	=3D 1<<0,
@@ -175,6 +177,8 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_TX_BITRATE		=3D 1<<7,
 };
=20
 /**
@@ -189,6 +193,8 @@ enum station_info_flags {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
+ * @signal: signal strength of last received package in dBm
+ * @tx_bitrate: current unicast tx rate in 100 kbit/sec
  */
 struct station_info {
 	u32 filled;
@@ -198,6 +204,8 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	u16 tx_bitrate;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16423f9..f6ed5b5 100644
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
+			STATION_INFO_TX_BITRATE;
=20
 	sinfo->inactive_time =3D jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes =3D sta->rx_bytes;
 	sinfo->tx_bytes =3D sta->tx_bytes;
+	sinfo->signal =3D sta->last_signal;
+
+	sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS))
+	  sinfo->tx_bitrate =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	else
+	  sinfo->tx_bitrate =3D 0;
=20
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c9141e3..0afc641 100644
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
+	if (sinfo->filled & STATION_INFO_TX_BITRATE)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_TX_BITRATE,
+			    sinfo->tx_bitrate);
=20
 	nla_nest_end(msg, sinfoattr);
=20


--Boundary-01=_QU+MJZwDSDonQeO
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="nl80211ext_v3.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nl80211ext_v3.patch"

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e08c8bc..030feed 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -404,6 +404,8 @@ enum nl80211_sta_flags {
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this stati=
on)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
+ * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u8,=
 dBm)
+ * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate (u16, 100 kbit/s)
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -413,6 +415,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_TX_BITRATE,
=20
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1d57835..fd9964c 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -167,6 +167,8 @@ struct station_parameters {
  * @STATION_INFO_LLID: @llid filled
  * @STATION_INFO_PLID: @plid filled
  * @STATION_INFO_PLINK_STATE: @plink_state filled
+ * @STATION_INFO_SIGNAL: @signal filled
+ * @STATION_INFO_TX_BITRATE: @tx_bitrate filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	=3D 1<<0,
@@ -175,6 +177,8 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_TX_BITRATE		=3D 1<<7,
 };
=20
 /**
@@ -189,6 +193,8 @@ enum station_info_flags {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
+ * @signal: signal strength of last received package in dBm
+ * @tx_bitrate: current unicast tx rate in 100 kbit/sec
  */
 struct station_info {
 	u32 filled;
@@ -198,6 +204,8 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	u16 tx_bitrate;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16423f9..f6ed5b5 100644
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
+			STATION_INFO_TX_BITRATE;
=20
 	sinfo->inactive_time =3D jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes =3D sta->rx_bytes;
 	sinfo->tx_bytes =3D sta->tx_bytes;
+	sinfo->signal =3D sta->last_signal;
+
+	sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS))
+	  sinfo->tx_bitrate =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	else
+	  sinfo->tx_bitrate =3D 0;
=20
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c9141e3..0afc641 100644
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
+	if (sinfo->filled & STATION_INFO_TX_BITRATE)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_TX_BITRATE,
+			    sinfo->tx_bitrate);
=20
 	nla_nest_end(msg, sinfoattr);
=20

--Boundary-01=_QU+MJZwDSDonQeO--

--nextPart1370454.xJPUhOOfoN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkz5RAACgkQRIfGfFXsz+CHjQCfW3eFQyT+PGvVNMifTqznsT5D
qiwAn1cUuWDlsA4xTr7c9mRrQF3onGMA
=JZO+
-----END PGP SIGNATURE-----

--nextPart1370454.xJPUhOOfoN--
