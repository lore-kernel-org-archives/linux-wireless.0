Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:59143 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYLGRc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 12:32:26 -0500
Received: by nf-out-0910.google.com with SMTP id d3so373457nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 09:32:24 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Sun, 7 Dec 2008 18:32:14 +0100
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Henning Rogge" <rogge@fgan.de>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <1228579172.16752.21.camel@johannes.berg> <43e72e890812061246n1d63c306x942759674cf0b26a@mail.gmail.com>
In-Reply-To: <43e72e890812061246n1d63c306x942759674cf0b26a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4493163.yE06bzObV6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812071832.20533.hrogge@googlemail.com> (sfid-20081207_183247_789489_53B8F59D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4493163.yE06bzObV6
Content-Type: multipart/mixed;
  boundary="Boundary-01=_fiAPJbov/02eKrK"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_fiAPJbov/02eKrK
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 06 December 2008 21:46:13 Luis R. Rodriguez wrote:
> On Sat, Dec 6, 2008 at 7:59 AM, Johannes Berg <johannes@sipsolutions.net>=
=20
wrote:
> > Also, there are duplicate numbers possible, so just the pure bitrate
> > will _not_ actually be "the typical information" because it's not
> > specific enough, when debugging, for example, you will probably need to
> > know whether it's short-gi or not.
>
> Aren't we providing that *as well*?
I think the suggestion is to remove the total/legacy bitrate for 802.11n=20
completely from the nl80211 station_info. Which I still think is not a good=
=20
idea. This way we force any  application displaying the bitrate to check fo=
r=20
several cases, know about the 802.11n table, ...
I think it's funny that we have the "total bitrate" information available o=
n=20
driver level but translate it into the mcs index with the help of tables...=
=20
and assume that userspace knows about the tables.

But here is the next version of my patch, this one without the "total=20
bandwith" for 802.11n... I can easily put it back later.

Changes since v1:
=2D removed noise and quality from station info in NL80211
=2D added bandwith to station info in NL80211
=2D changed name of patch file to nl80211ext_v2.patch
=C2=A0=C2=A0
Changes since v2:
=2D added kernel comment lines for new fields/enums
=2D changed name of "bandwith" field to tx_bitrate

Changes since v3:
=2D added rx_bitrate to station info and sta_info
=2D remember bitrate of last received unicast packet to this station
=2D decode 802.11n MCS index for nl80211
=C2=A0 (maybe this should be ported to WEXT too ?)

Changes since v4:
=2D added tx_bitrate_flags adn tx_bitrate_mcs field to station info
=2D added flags for 40Mhz and small guard interval to NL80211 station info
=2D added mcs field to NL80211 station info

Changes since v5:
=2D remove rx_bitrate from patch until we get a sane way to learn the detai=
ls of =20
received 802.11n packages
=2Dreplace 802.11n bitrate arrays with calculation based on basic rates
=2D pushed txrate nl80211 stationinfo into nested attribute
=2D created station_info_rate_flags enum to save bitrate flags in station_i=
nfo
=2D cleanup of kerneldoc

Changes since v6:
=2D removed mcs index to bitrate conversion
=2D push station info bitrate into substructure
=2D renamed "total" bitrate into "legacy"
=2D some code cleanup

Henning

=2D------------------
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 04d4516..26e68b9 100644
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
+ * @NL80211_STA_INFO_RATE_LEGACY: bitrate for 802.11abg (u16, 100kbit/s)
+ * @NL80211_STA_INFO_RATE_MCS: mcs index for 802.11n (u8)
+ * @NL80211_STA_INFO_RATE_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
+ * @NL80211_STA_INFO_RATE_SHORT_GI: 400ns guard interval
+ */
+enum nl80211_sta_info_rate {
+	__NL80211_STA_INFO_RATE_INVALID,
+	NL80211_STA_INFO_RATE_LEGACY,
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
index 7a7a6c1..e6c2b7a 100644
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
+		sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
+		sinfo->txrate.legacy =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	}
+	else {
+		sinfo->txrate.mcs =3D sta->last_tx_rate.idx;
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |=3D STATION_INFO_LLID |
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9caee60..ced38a7 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14,6 +14,7 @@
 #include <linux/nl80211.h>
 #include <linux/rtnetlink.h>
 #include <linux/netlink.h>
+#include <net/mac80211.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include "core.h"
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
@@ -1114,7 +1115,28 @@ static int nl80211_send_station(struct sk_buff *msg,=
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
+			NLA_PUT_U16(msg, NL80211_STA_INFO_RATE_LEGACY,
+				    sinfo->txrate.legacy);
+		else
+			NLA_PUT_U16(msg, NL80211_STA_INFO_RATE_MCS,
+				    sinfo->txrate.mcs);
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_RATE_40_MHZ_WIDTH);
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_SHORT_GI)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_RATE_SHORT_GI);
+
+		nla_nest_end(msg, txrate);
+	}
 	nla_nest_end(msg, sinfoattr);
=20
 	return genlmsg_end(msg, hdr);


--Boundary-01=_fiAPJbov/02eKrK
Content-Type: text/x-patch;
  charset="ISO-8859-15";
  name="nl80211ext_v7.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nl80211ext_v7.patch"

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 04d4516..26e68b9 100644
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
+ * @NL80211_STA_INFO_RATE_LEGACY: bitrate for 802.11abg (u16, 100kbit/s)
+ * @NL80211_STA_INFO_RATE_MCS: mcs index for 802.11n (u8)
+ * @NL80211_STA_INFO_RATE_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
+ * @NL80211_STA_INFO_RATE_SHORT_GI: 400ns guard interval
+ */
+enum nl80211_sta_info_rate {
+	__NL80211_STA_INFO_RATE_INVALID,
+	NL80211_STA_INFO_RATE_LEGACY,
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
index 7a7a6c1..e6c2b7a 100644
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
+		sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
+		sinfo->txrate.legacy =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	}
+	else {
+		sinfo->txrate.mcs =3D sta->last_tx_rate.idx;
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |=3D STATION_INFO_LLID |
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9caee60..ced38a7 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14,6 +14,7 @@
 #include <linux/nl80211.h>
 #include <linux/rtnetlink.h>
 #include <linux/netlink.h>
+#include <net/mac80211.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include "core.h"
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
@@ -1114,7 +1115,28 @@ static int nl80211_send_station(struct sk_buff *msg,=
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
+			NLA_PUT_U16(msg, NL80211_STA_INFO_RATE_LEGACY,
+				    sinfo->txrate.legacy);
+		else
+			NLA_PUT_U16(msg, NL80211_STA_INFO_RATE_MCS,
+				    sinfo->txrate.mcs);
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_RATE_40_MHZ_WIDTH);
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_SHORT_GI)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_RATE_SHORT_GI);
+
+		nla_nest_end(msg, txrate);
+	}
 	nla_nest_end(msg, sinfoattr);
=20
 	return genlmsg_end(msg, hdr);

--Boundary-01=_fiAPJbov/02eKrK--

--nextPart4493163.yE06bzObV6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk8CKQACgkQcenvcwAcHWeqoQCcCkCOF3+ZYPt+l4aFKNOgvmOc
b80An3n3lgvP1Wcu6xnfzZqvzPO5a82X
=Y/bJ
-----END PGP SIGNATURE-----

--nextPart4493163.yE06bzObV6--
