Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:3635 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbYLITzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 14:55:10 -0500
Received: by ug-out-1314.google.com with SMTP id 39so50067ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2008 11:55:08 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [Patch 1/2 v2] Add signal strength and bandwith to nl80211station info
Date: Tue, 9 Dec 2008 20:54:59 +0100
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
  boundary="nextPart1277176.YCa5gHb76k";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812092055.05160.hrogge@googlemail.com> (sfid-20081209_205516_653753_D0507666)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1277176.YCa5gHb76k
Content-Type: multipart/mixed;
  boundary="Boundary-01=_T0sPJ1Fcj3vX6dr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_T0sPJ1Fcj3vX6dr
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This patch adds information about signal strength and unicast transmission=
=20
bitrate to the nl80211 station info.

=2D-----------------------------------
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 04d4516..56450b4 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
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
+ * @NL80211_RATE_INFO_LEGACY: bitrate for 802.11abg (u16, 100kbit/s)
+ * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
+ * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
+ * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
+ */
+enum nl80211_rate_info {
+	__NL80211_RATE_INFO_INVALID,
+	NL80211_RATE_INFO_LEGACY,
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
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a0c0bf1..d9ce51e 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -169,6 +169,9 @@ struct station_parameters {
  * @STATION_INFO_LLID: @llid filled
  * @STATION_INFO_PLID: @plid filled
  * @STATION_INFO_PLINK_STATE: @plink_state filled
+ * @STATION_INFO_SIGNAL: @signal filled
+ * @STATION_INFO_TX_BITRATE: @tx_bitrate fields are filled
+ *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	=3D 1<<0,
@@ -177,6 +180,39 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_TX_BITRATE		=3D 1<<7,
+};
+
+/**
+ * enum station_info_rate_flags - bitrate info flags
+ *
+ * Used by the driver to indicate the specific rate transmission
+ * type for 802.11n transmissions.
+ *
+ * @RATE_INFO_FLAGS_MCS: @tx_bitrate_mcs filled
+ * @RATE_INFO_FLAGS_40_MHZ_WIDTH: 40 Mhz width transmission
+ * @RATE_INFO_FLAGS_SHORT_GI: 400ns guard interval
+ */
+enum rate_info_flags {
+	RATE_INFO_FLAGS_MCS		=3D 1<<0,
+	RATE_INFO_FLAGS_40_MHZ_WIDTH	=3D 1<<1,
+	RATE_INFO_FLAGS_SHORT_GI	=3D 1<<2,
+};
+
+/**
+ * struct rate_info - bitrate information
+ *
+ * Information about a receiving or transmitting bitrate
+ *
+ * @flags: bitflag of flags from &enum rate_info_flags
+ * @mcs: mcs index if struct describes a 802.11n bitrate
+ * @legacy: bitrate in 100kbit/s for 802.11abg
+ */
+struct rate_info {
+	u8 flags;
+	u8 mcs;
+	u16 legacy;
 };
=20
 /**
@@ -191,6 +227,8 @@ enum station_info_flags {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
+ * @signal: signal strength of last received package in dBm
+ * @txrate: current unicast bitrate to this station
  */
 struct station_info {
 	u32 filled;
@@ -200,6 +238,8 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	struct rate_info txrate;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7a7a6c1..b5b1301 100644
=2D-- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -310,12 +310,35 @@ static void sta_set_sinfo(struct sta_info *sta, struc=
t=20
station_info *sinfo)
=20
 	sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
=2D			STATION_INFO_TX_BYTES;
+			STATION_INFO_TX_BYTES |
+			STATION_INFO_TX_BITRATE;
=20
 	sinfo->inactive_time =3D jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes =3D sta->rx_bytes;
 	sinfo->tx_bytes =3D sta->tx_bytes;
=20
+	if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+		sinfo->filled |=3D STATION_INFO_SIGNAL;
+		sinfo->signal =3D sta->last_signal;
+	}
+
+	sinfo->txrate.flags =3D 0;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
+		sinfo->txrate.flags |=3D RATE_INFO_FLAGS_MCS;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		sinfo->txrate.flags |=3D RATE_INFO_FLAGS_40_MHZ_WIDTH;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_SHORT_GI)
+		sinfo->txrate.flags |=3D RATE_INFO_FLAGS_SHORT_GI;
+
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
+		struct ieee80211_supported_band *sband;
+		sband =3D sta->local->hw.wiphy->bands[
+				sta->local->hw.conf.channel->band];
+		sinfo->txrate.legacy =3D
+			sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	} else
+		sinfo->txrate.mcs =3D sta->last_tx_rate.idx;
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |=3D STATION_INFO_LLID |
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9caee60..3f13928 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1084,7 +1084,7 @@ static int nl80211_send_station(struct sk_buff *msg, =
u32=20
pid, u32 seq,
 				u8 *mac_addr, struct station_info *sinfo)
 {
 	void *hdr;
=2D	struct nlattr *sinfoattr;
+	struct nlattr *sinfoattr, *txrate;
=20
 	hdr =3D nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
 	if (!hdr)
@@ -1114,7 +1114,28 @@ static int nl80211_send_station(struct sk_buff *msg,=
=20
u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
+	if (sinfo->filled & STATION_INFO_SIGNAL)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
+			   sinfo->signal);
+	if (sinfo->filled & STATION_INFO_TX_BITRATE) {
+		txrate =3D nla_nest_start(msg, NL80211_STA_INFO_TX_BITRATE);
+		if (!txrate)
+			goto nla_put_failure;
+
=20
+		if (!(sinfo->txrate.flags & RATE_INFO_FLAGS_MCS))
+			NLA_PUT_U16(msg, NL80211_RATE_INFO_LEGACY,
+				    sinfo->txrate.legacy);
+		else
+			NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS,
+				    sinfo->txrate.mcs);
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
+			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_40_MHZ_WIDTH);
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_SHORT_GI)
+			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_SHORT_GI);
+
+		nla_nest_end(msg, txrate);
+	}
 	nla_nest_end(msg, sinfoattr);
=20
 	return genlmsg_end(msg, hdr);


--Boundary-01=_T0sPJ1Fcj3vX6dr
Content-Type: text/x-patch;
  charset="ISO-8859-15";
  name="nl80211ext_v9_1.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nl80211ext_v9_1.patch"

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 04d4516..56450b4 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
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
+ * @NL80211_RATE_INFO_LEGACY: bitrate for 802.11abg (u16, 100kbit/s)
+ * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
+ * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
+ * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
+ */
+enum nl80211_rate_info {
+	__NL80211_RATE_INFO_INVALID,
+	NL80211_RATE_INFO_LEGACY,
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
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a0c0bf1..d9ce51e 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -169,6 +169,9 @@ struct station_parameters {
  * @STATION_INFO_LLID: @llid filled
  * @STATION_INFO_PLID: @plid filled
  * @STATION_INFO_PLINK_STATE: @plink_state filled
+ * @STATION_INFO_SIGNAL: @signal filled
+ * @STATION_INFO_TX_BITRATE: @tx_bitrate fields are filled
+ *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	=3D 1<<0,
@@ -177,6 +180,39 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_TX_BITRATE		=3D 1<<7,
+};
+
+/**
+ * enum station_info_rate_flags - bitrate info flags
+ *
+ * Used by the driver to indicate the specific rate transmission
+ * type for 802.11n transmissions.
+ *
+ * @RATE_INFO_FLAGS_MCS: @tx_bitrate_mcs filled
+ * @RATE_INFO_FLAGS_40_MHZ_WIDTH: 40 Mhz width transmission
+ * @RATE_INFO_FLAGS_SHORT_GI: 400ns guard interval
+ */
+enum rate_info_flags {
+	RATE_INFO_FLAGS_MCS		=3D 1<<0,
+	RATE_INFO_FLAGS_40_MHZ_WIDTH	=3D 1<<1,
+	RATE_INFO_FLAGS_SHORT_GI	=3D 1<<2,
+};
+
+/**
+ * struct rate_info - bitrate information
+ *
+ * Information about a receiving or transmitting bitrate
+ *
+ * @flags: bitflag of flags from &enum rate_info_flags
+ * @mcs: mcs index if struct describes a 802.11n bitrate
+ * @legacy: bitrate in 100kbit/s for 802.11abg
+ */
+struct rate_info {
+	u8 flags;
+	u8 mcs;
+	u16 legacy;
 };
=20
 /**
@@ -191,6 +227,8 @@ enum station_info_flags {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
+ * @signal: signal strength of last received package in dBm
+ * @txrate: current unicast bitrate to this station
  */
 struct station_info {
 	u32 filled;
@@ -200,6 +238,8 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	struct rate_info txrate;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7a7a6c1..b5b1301 100644
=2D-- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -310,12 +310,35 @@ static void sta_set_sinfo(struct sta_info *sta, struc=
t station_info *sinfo)
=20
 	sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
=2D			STATION_INFO_TX_BYTES;
+			STATION_INFO_TX_BYTES |
+			STATION_INFO_TX_BITRATE;
=20
 	sinfo->inactive_time =3D jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes =3D sta->rx_bytes;
 	sinfo->tx_bytes =3D sta->tx_bytes;
=20
+	if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+		sinfo->filled |=3D STATION_INFO_SIGNAL;
+		sinfo->signal =3D sta->last_signal;
+	}
+
+	sinfo->txrate.flags =3D 0;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
+		sinfo->txrate.flags |=3D RATE_INFO_FLAGS_MCS;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		sinfo->txrate.flags |=3D RATE_INFO_FLAGS_40_MHZ_WIDTH;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_SHORT_GI)
+		sinfo->txrate.flags |=3D RATE_INFO_FLAGS_SHORT_GI;
+
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
+		struct ieee80211_supported_band *sband;
+		sband =3D sta->local->hw.wiphy->bands[
+				sta->local->hw.conf.channel->band];
+		sinfo->txrate.legacy =3D
+			sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	} else
+		sinfo->txrate.mcs =3D sta->last_tx_rate.idx;
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |=3D STATION_INFO_LLID |
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9caee60..3f13928 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1084,7 +1084,7 @@ static int nl80211_send_station(struct sk_buff *msg, =
u32 pid, u32 seq,
 				u8 *mac_addr, struct station_info *sinfo)
 {
 	void *hdr;
=2D	struct nlattr *sinfoattr;
+	struct nlattr *sinfoattr, *txrate;
=20
 	hdr =3D nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
 	if (!hdr)
@@ -1114,7 +1114,28 @@ static int nl80211_send_station(struct sk_buff *msg,=
 u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
+	if (sinfo->filled & STATION_INFO_SIGNAL)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
+			   sinfo->signal);
+	if (sinfo->filled & STATION_INFO_TX_BITRATE) {
+		txrate =3D nla_nest_start(msg, NL80211_STA_INFO_TX_BITRATE);
+		if (!txrate)
+			goto nla_put_failure;
+
=20
+		if (!(sinfo->txrate.flags & RATE_INFO_FLAGS_MCS))
+			NLA_PUT_U16(msg, NL80211_RATE_INFO_LEGACY,
+				    sinfo->txrate.legacy);
+		else
+			NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS,
+				    sinfo->txrate.mcs);
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
+			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_40_MHZ_WIDTH);
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_SHORT_GI)
+			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_SHORT_GI);
+
+		nla_nest_end(msg, txrate);
+	}
 	nla_nest_end(msg, sinfoattr);
=20
 	return genlmsg_end(msg, hdr);

--Boundary-01=_T0sPJ1Fcj3vX6dr--

--nextPart1277176.YCa5gHb76k
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk+zRkACgkQcenvcwAcHWernACfVMvU7JRybc0KaU5UnWhS+UMg
vZQAn0dtgZe3rOI8mQ0/t00L99n9rSOP
=vtC6
-----END PGP SIGNATURE-----

--nextPart1277176.YCa5gHb76k--
