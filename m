Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:52657 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbYLFOoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 09:44:09 -0500
Received: by ug-out-1314.google.com with SMTP id 39so241416ugf.37
        for <linux-wireless@vger.kernel.org>; Sat, 06 Dec 2008 06:44:06 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Sat, 6 Dec 2008 15:43:56 +0100
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <1228470310.3970.13.camel@johannes.berg> <200812061511.05473.hrogge@googlemail.com>
In-Reply-To: <200812061511.05473.hrogge@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3297693.BJQHX3K4QO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812061544.02312.hrogge@googlemail.com> (sfid-20081206_154416_576375_55CD0F3C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3297693.BJQHX3K4QO
Content-Type: multipart/mixed;
  boundary="Boundary-01=_s+oOJLsypDRxKED"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_s+oOJLsypDRxKED
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Okay, here is v6 of my patch... feel free to rip it apart. ;)
(forgot to put the patch inline too... sorry)

Changes since v1:
=2D removed noise and quality from station info in NL80211
=2D added bandwith to station info in NL80211
=2D changed name of patch file to nl80211ext_v2.patch
 =A0
Changes since v2:
=2D added kernel comment lines for new fields/enums
=2D changed name of "bandwith" field to tx_bitrate

Changes since v3:
=2D added rx_bitrate to station info and sta_info
=2D remember bitrate of last received unicast packet to this station
=2D decode 802.11n MCS index for nl80211
=A0 (maybe this should be ported to WEXT too ?)

Changes since v4:
=2D added tx_bitrate_flags adn tx_bitrate_mcs field to station info
=2D added flags for 40Mhz and small guard interval to NL80211 station info
=2D added mcs field to NL80211 station info

Changes since v5:
=2D remove rx_bitrate from patch until we get a sane way to learn the detai=
ls of=20
received 802.11n packages
=2Dreplace 802.11n bitrate arrays with calculation based on basic rates
=2D pushed txrate nl80211 stationinfo into nested attribute
=2D created station_info_rate_flags enum to save bitrate flags in
station_info - cleanup of kerneldoc

TODO:
=2D push magic numbers of sta_get_80211n_bitrate (65/135) into constants
=2D coding style cleanup

Henning
=2D----------------------
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 04d4516..e14caa9 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -425,6 +425,30 @@ enum nl80211_sta_flags {
 };
=20
 /**
+ * enum nl80211_sta_info_rate - station information about bitrate
+ *
+ * These attribute types are used with %NL80211_STA_INFO_TXRATE
+ * when getting information about the bitrate of a station.
+ *
+ * @__NL80211_STA_INFO_RATE_INVALID: attribute number 0 is reserved
+ * @NL80211_STA_INFO_RATE_TOTAL: total bitrate (u16, 100kbit/s)
+ * @NL80211_STA_INFO_RATE_MCS: mcs index for 802.11n (u8)
+ * @NL80211_STA_INFO_RATE_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
+ * @NL80211_STA_INFO_RATE_SHORT_GI: 400ns guard interval
+ */
+enum nl80211_sta_info_rate {
+	__NL80211_STA_INFO_RATE_INVALID,
+	NL80211_STA_INFO_RATE_TOTAL,
+	NL80211_STA_INFO_RATE_MCS,
+	NL80211_STA_INFO_RATE_40_MHZ_WIDTH,
+	NL80211_STA_INFO_RATE_SHORT_GI,
+
+	/* keep last */
+	__NL80211_STA_INFO_RATE_AFTER_LAST,
+	NL80211_STA_INFO_RATE_MAX =3D __NL80211_STA_INFO_RATE_AFTER_LAST - 1
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
+ * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u8,=
=20
dBm)
+ * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
+ *  containing info as possible, see &enum nl80211_sta_info_txrate.
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
index a0c0bf1..9ebcb11 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -169,6 +169,10 @@ struct station_parameters {
  * @STATION_INFO_LLID: @llid filled
  * @STATION_INFO_PLID: @plid filled
  * @STATION_INFO_PLINK_STATE: @plink_state filled
+ * @STATION_INFO_SIGNAL: @signal filled
+ * @STATION_INFO_RX_BITRATE: @rx_bitrate filled
+ * @STATION_INFO_TX_BITRATE: @tx_bitrate fields are filled
+ *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	=3D 1<<0,
@@ -177,6 +181,25 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_RX_BITRATE		=3D 1<<7,
+	STATION_INFO_TX_BITRATE		=3D 1<<8,
+};
+
+/**
+ * enum station_info_rate_flags - station transmission rate flags
+ *
+ * Used by the driver to indicate the specific rate transmission
+ * type for 802.11n transmissions.
+ *
+ * @STATION_INFO_BITRATE_MCS: @tx_bitrate_mcs filled
+ * @STATION_INFO_BITRATE_40_MHZ_WIDTH: 40 Mhz width transmission
+ * @STATION_INFO_BITRATE_SHORT_GI: 400ns guard interval
+ */
+enum station_info_rate_flags {
+	STATION_INFO_BITRATE_MCS		=3D 1<<0,
+	STATION_INFO_BITRATE_40_MHZ_WIDTH	=3D 1<<1,
+	STATION_INFO_BITRATE_SHORT_GI		=3D 1<<2,
 };
=20
 /**
@@ -191,6 +214,11 @@ enum station_info_flags {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
+ * @signal: signal strength of last received package in dBm
+ * @txrate_total: current unicast bitrate to this station in 100 kbit/sec
+ * @txrate_flags: bitflag of flags from &enum station_info_bitrate_flags
+ * @txrate_mcs: MCS index of a 802.11n transmission, see
+ *  &enum station_info_bitrate_flags
  */
 struct station_info {
 	u32 filled;
@@ -200,6 +228,10 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	u16 txrate_total;
+	u8 txrate_flags;
+	u8 txrate_mcs;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7a7a6c1..3567cd9 100644
=2D-- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -304,18 +304,65 @@ static int ieee80211_config_default_key(struct wiphy=
=20
*wiphy,
 	return 0;
 }
=20
+static u16 sta_get_80211n_bitrate(struct ieee80211_tx_rate *rate)
+{
+	int modulation =3D rate->idx & 7;
+	int streams =3D rate->idx >> 3;
+
+	int bitrate =3D (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ? 13500000 :=
=20
6500000;
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
+	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+		bitrate =3D (bitrate * 10) / 9;
+
+	return (bitrate + 50000) / 100000; // do NOT just round down
+}
+
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata =3D sta->sdata;
=20
 	sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
=2D			STATION_INFO_TX_BYTES;
+			STATION_INFO_TX_BYTES |
+			STATION_INFO_RX_BITRATE |
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
+	sinfo->txrate_flags =3D 0;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
+		sinfo->txrate_flags |=3D STATION_INFO_BITRATE_MCS;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		sinfo->txrate_flags |=3D STATION_INFO_BITRATE_40_MHZ_WIDTH;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_SHORT_GI)
+		sinfo->txrate_flags |=3D STATION_INFO_BITRATE_SHORT_GI;
+
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
+		struct ieee80211_supported_band *sband;
+		sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
+		sinfo->txrate_total =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	}
+	else {
+		sinfo->txrate_total =3D sta_get_80211n_bitrate(&sta->last_tx_rate);
+		sinfo->txrate_mcs =3D sta->last_tx_rate.idx;
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |=3D STATION_INFO_LLID |
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 59f356a..84922b0 100644
=2D-- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -727,8 +727,9 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	if (rx->sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
 		u8 *bssid =3D ieee80211_get_bssid(hdr, rx->skb->len,
 						NL80211_IFTYPE_ADHOC);
=2D		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) =3D=3D 0)
+		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) =3D=3D 0) {
 			sta->last_rx =3D jiffies;
+		}
 	} else
 	if (!is_multicast_ether_addr(hdr->addr1) ||
 	    rx->sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9caee60..197dc4d 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16,6 +16,7 @@
 #include <linux/netlink.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
+#include <net/mac80211.h>
 #include "core.h"
 #include "nl80211.h"
 #include "reg.h"
@@ -1084,7 +1085,7 @@ static int nl80211_send_station(struct sk_buff *msg, =
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
@@ -1114,7 +1115,27 @@ static int nl80211_send_station(struct sk_buff *msg,=
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
+		NLA_PUT_U16(msg, NL80211_STA_INFO_RATE_TOTAL,
+			    sinfo->txrate_total);
=20
+		if (sinfo->txrate_flags & STATION_INFO_BITRATE_MCS)
+			NLA_PUT_U16(msg, NL80211_STA_INFO_RATE_MCS,
+				    sinfo->txrate_mcs);
+		if (sinfo->txrate_flags & STATION_INFO_BITRATE_40_MHZ_WIDTH)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_RATE_40_MHZ_WIDTH);
+		if (sinfo->txrate_flags & STATION_INFO_BITRATE_SHORT_GI)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_RATE_SHORT_GI);
+
+		nla_nest_end(msg, txrate);
+	}
 	nla_nest_end(msg, sinfoattr);
=20
 	return genlmsg_end(msg, hdr);


--Boundary-01=_s+oOJLsypDRxKED
Content-Type: text/x-patch;
  charset="UTF-8";
  name="nl80211ext_v6.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nl80211ext_v6.patch"

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 04d4516..e14caa9 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -425,6 +425,30 @@ enum nl80211_sta_flags {
 };
=20
 /**
+ * enum nl80211_sta_info_rate - station information about bitrate
+ *
+ * These attribute types are used with %NL80211_STA_INFO_TXRATE
+ * when getting information about the bitrate of a station.
+ *
+ * @__NL80211_STA_INFO_RATE_INVALID: attribute number 0 is reserved
+ * @NL80211_STA_INFO_RATE_TOTAL: total bitrate (u16, 100kbit/s)
+ * @NL80211_STA_INFO_RATE_MCS: mcs index for 802.11n (u8)
+ * @NL80211_STA_INFO_RATE_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
+ * @NL80211_STA_INFO_RATE_SHORT_GI: 400ns guard interval
+ */
+enum nl80211_sta_info_rate {
+	__NL80211_STA_INFO_RATE_INVALID,
+	NL80211_STA_INFO_RATE_TOTAL,
+	NL80211_STA_INFO_RATE_MCS,
+	NL80211_STA_INFO_RATE_40_MHZ_WIDTH,
+	NL80211_STA_INFO_RATE_SHORT_GI,
+
+	/* keep last */
+	__NL80211_STA_INFO_RATE_AFTER_LAST,
+	NL80211_STA_INFO_RATE_MAX =3D __NL80211_STA_INFO_RATE_AFTER_LAST - 1
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
+ * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u8,=
 dBm)
+ * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
+ *  containing info as possible, see &enum nl80211_sta_info_txrate.
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
index a0c0bf1..9ebcb11 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -169,6 +169,10 @@ struct station_parameters {
  * @STATION_INFO_LLID: @llid filled
  * @STATION_INFO_PLID: @plid filled
  * @STATION_INFO_PLINK_STATE: @plink_state filled
+ * @STATION_INFO_SIGNAL: @signal filled
+ * @STATION_INFO_RX_BITRATE: @rx_bitrate filled
+ * @STATION_INFO_TX_BITRATE: @tx_bitrate fields are filled
+ *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	=3D 1<<0,
@@ -177,6 +181,25 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_RX_BITRATE		=3D 1<<7,
+	STATION_INFO_TX_BITRATE		=3D 1<<8,
+};
+
+/**
+ * enum station_info_rate_flags - station transmission rate flags
+ *
+ * Used by the driver to indicate the specific rate transmission
+ * type for 802.11n transmissions.
+ *
+ * @STATION_INFO_BITRATE_MCS: @tx_bitrate_mcs filled
+ * @STATION_INFO_BITRATE_40_MHZ_WIDTH: 40 Mhz width transmission
+ * @STATION_INFO_BITRATE_SHORT_GI: 400ns guard interval
+ */
+enum station_info_rate_flags {
+	STATION_INFO_BITRATE_MCS		=3D 1<<0,
+	STATION_INFO_BITRATE_40_MHZ_WIDTH	=3D 1<<1,
+	STATION_INFO_BITRATE_SHORT_GI		=3D 1<<2,
 };
=20
 /**
@@ -191,6 +214,11 @@ enum station_info_flags {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
+ * @signal: signal strength of last received package in dBm
+ * @txrate_total: current unicast bitrate to this station in 100 kbit/sec
+ * @txrate_flags: bitflag of flags from &enum station_info_bitrate_flags
+ * @txrate_mcs: MCS index of a 802.11n transmission, see
+ *  &enum station_info_bitrate_flags
  */
 struct station_info {
 	u32 filled;
@@ -200,6 +228,10 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	u16 txrate_total;
+	u8 txrate_flags;
+	u8 txrate_mcs;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7a7a6c1..3567cd9 100644
=2D-- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -304,18 +304,65 @@ static int ieee80211_config_default_key(struct wiphy =
*wiphy,
 	return 0;
 }
=20
+static u16 sta_get_80211n_bitrate(struct ieee80211_tx_rate *rate)
+{
+	int modulation =3D rate->idx & 7;
+	int streams =3D rate->idx >> 3;
+
+	int bitrate =3D (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ? 13500000 :=
 6500000;
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
+	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+		bitrate =3D (bitrate * 10) / 9;
+
+	return (bitrate + 50000) / 100000; // do NOT just round down
+}
+
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata =3D sta->sdata;
=20
 	sinfo->filled =3D STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
=2D			STATION_INFO_TX_BYTES;
+			STATION_INFO_TX_BYTES |
+			STATION_INFO_RX_BITRATE |
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
+	sinfo->txrate_flags =3D 0;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
+		sinfo->txrate_flags |=3D STATION_INFO_BITRATE_MCS;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		sinfo->txrate_flags |=3D STATION_INFO_BITRATE_40_MHZ_WIDTH;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_SHORT_GI)
+		sinfo->txrate_flags |=3D STATION_INFO_BITRATE_SHORT_GI;
+
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
+		struct ieee80211_supported_band *sband;
+		sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
+		sinfo->txrate_total =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	}
+	else {
+		sinfo->txrate_total =3D sta_get_80211n_bitrate(&sta->last_tx_rate);
+		sinfo->txrate_mcs =3D sta->last_tx_rate.idx;
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |=3D STATION_INFO_LLID |
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 59f356a..84922b0 100644
=2D-- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -727,8 +727,9 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	if (rx->sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
 		u8 *bssid =3D ieee80211_get_bssid(hdr, rx->skb->len,
 						NL80211_IFTYPE_ADHOC);
=2D		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) =3D=3D 0)
+		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) =3D=3D 0) {
 			sta->last_rx =3D jiffies;
+		}
 	} else
 	if (!is_multicast_ether_addr(hdr->addr1) ||
 	    rx->sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9caee60..197dc4d 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16,6 +16,7 @@
 #include <linux/netlink.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
+#include <net/mac80211.h>
 #include "core.h"
 #include "nl80211.h"
 #include "reg.h"
@@ -1084,7 +1085,7 @@ static int nl80211_send_station(struct sk_buff *msg, =
u32 pid, u32 seq,
 				u8 *mac_addr, struct station_info *sinfo)
 {
 	void *hdr;
=2D	struct nlattr *sinfoattr;
+	struct nlattr *sinfoattr, *txrate;
=20
 	hdr =3D nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
 	if (!hdr)
@@ -1114,7 +1115,27 @@ static int nl80211_send_station(struct sk_buff *msg,=
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
+		NLA_PUT_U16(msg, NL80211_STA_INFO_RATE_TOTAL,
+			    sinfo->txrate_total);
=20
+		if (sinfo->txrate_flags & STATION_INFO_BITRATE_MCS)
+			NLA_PUT_U16(msg, NL80211_STA_INFO_RATE_MCS,
+				    sinfo->txrate_mcs);
+		if (sinfo->txrate_flags & STATION_INFO_BITRATE_40_MHZ_WIDTH)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_RATE_40_MHZ_WIDTH);
+		if (sinfo->txrate_flags & STATION_INFO_BITRATE_SHORT_GI)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_RATE_SHORT_GI);
+
+		nla_nest_end(msg, txrate);
+	}
 	nla_nest_end(msg, sinfoattr);
=20
 	return genlmsg_end(msg, hdr);

--Boundary-01=_s+oOJLsypDRxKED--

--nextPart3297693.BJQHX3K4QO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk6j7IACgkQcenvcwAcHWctMwCffnLOYl2KNJueVmHogbjwE3wv
eSYAoJNnVoNgckMr6GlPB8SM6N8xiqe5
=Z0jt
-----END PGP SIGNATURE-----

--nextPart3297693.BJQHX3K4QO--
