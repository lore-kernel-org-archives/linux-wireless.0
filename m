Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:35208 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYLCKbi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 05:31:38 -0500
From: Henning Rogge <rogge@fgan.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Wed, 3 Dec 2008 11:31:27 +0100
Cc: Henning Rogge <hrogge@googlemail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
References: <200811252131.30161.hrogge@googlemail.com> <200812022146.12363.hrogge@googlemail.com> <20081203014430.GH9351@tesla>
In-Reply-To: <20081203014430.GH9351@tesla>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1561538.dovAiFogOV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812031131.34936.rogge@fgan.de> (sfid-20081203_113144_858816_75A3A646)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1561538.dovAiFogOV
Content-Type: multipart/mixed;
  boundary="Boundary-01=_AAmNJBSVVGyTxEo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_AAmNJBSVVGyTxEo
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Wednesday 03 December 2008 02:44:30 schrieb Luis R. Rodriguez:
> So... what if we pass the throughput as you have it but also pass the
> other stuff (flags, and MCS index) just so all userspace apps that
> want to get last TX/RX guard interval, HT20/HT40, and MCS index
> doesn't have to have a funky reverse map to get the flags and MCS index?

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

The IEEE80211_TX_RC_40_MHZ_WIDTH flag in nl80211 should work for 802.11g=20
"turbomodes" and 802.11n, the IEEE80211_TX_RC_SHORT_GI is only available if=
=20
the NL80211_STA_INFO_TX_BITRATE_MCS index is set too. All three fields will=
 be=20
only available if the STATION_INFO_TX_BITRATE field is set. (see station.c)

The whole 802.11n stuff is only compile-tested, but the code works on an=20
atheros 802.11g card.

What do you think about the idea to export the 802.11n transmission rate=20
through the old WExt interface, so iwconfig will show the correct rate too =
?=20
But for this the "mcs to bitrate" tables would have to be moved to some oth=
er=20
file, so wext.c can access them too (which one ?).

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

=2D------------------------------------------------------
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e08c8bc..32bb7ad 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -404,6 +404,14 @@ enum nl80211_sta_flags {
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this stati=
on)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
+ * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u8,=
=20
dBm)
+ * @NL80211_STA_INFO_RX_BITRATE: bitrate of last received unicast packet
+ *  (u16, 100 kbit/s)
+ * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate (u16, 100 kbit/s)
+ * @NL80211_STA_INFO_TX_BITRATE_40_MHZ: dual channel transmission (flag)
+ * @NL80211_STA_INFO_TX_BITRATE_MCS: 802.11n MCS index of tx rate (u8)
+ * @NL80211_STA_INFO_TX_BITRATE_SHORT_GI: 802.11n with 400ns GI, 800ns
+ *  otherwise, should be ignored if TX_BITRATE_MCS is not set (flag)
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -413,6 +421,12 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_RX_BITRATE,
+	NL80211_STA_INFO_TX_BITRATE,
+	NL80211_STA_INFO_TX_BITRATE_40_MHZ,
+	NL80211_STA_INFO_TX_BITRATE_MCS,
+	NL80211_STA_INFO_TX_BITRATE_SHORT_GI,
=20
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1d57835..5cc8b53 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -160,6 +160,8 @@ struct station_parameters {
  *
  * Used by the driver to indicate which info in &struct station_info
  * it has filled in during get_station() or dump_station().
+ * Signal strength is only available if driver supports dBm signal
+ * strength.
  *
  * @STATION_INFO_INACTIVE_TIME: @inactive_time filled
  * @STATION_INFO_RX_BYTES: @rx_bytes filled
@@ -167,6 +169,10 @@ struct station_parameters {
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
@@ -175,6 +181,9 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_RX_BITRATE		=3D 1<<7,
+	STATION_INFO_TX_BITRATE		=3D 1<<8,
 };
=20
 /**
@@ -189,6 +198,15 @@ enum station_info_flags {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
+ * @signal: signal strength of last received package in dBm
+ * @rx_bitrate: bitrate of last received unicast packet in 100 kbit/sec
+ * @tx_bitrate: current unicast bitrate to this station in 100 kbit/sec
+ * @tx_bitrate_flags: a binary field with a combination of flags
+ *  IEEE80211_TX_RC_MCS: bitrate_mcs field contains the 802.11n MCS number
+ *  IEEE80211_TX_RC_40_MHZ_WIDTH: 40 Mhz wide channel, 20 Mhz if not set
+ *  IEEE80211_TX_RC_SHORT_GI: 400ns guard interval, 800ns if not set
+ * @tx_bitrate_mcs: if IEEE80211_TX_RC_MCS is set this is the MCS index
+ *  of a 802.11n transmission, if not it is set to zero
  */
 struct station_info {
 	u32 filled;
@@ -198,6 +216,10 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	u16 rx_bitrate;
+	u16 tx_bitrate;
+	u8 tx_bitrate_flags, tx_bitrate_mcs;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16423f9..dc684a4 100644
=2D-- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -17,6 +17,41 @@
 #include "rate.h"
 #include "mesh.h"
=20
+/* bitrate of 802.11n ht20 connections with 800ns guard interval in 100kbi=
t/s=20
*/
+const u16 ieee80211n_ht20_gi800[] =3D {
+    65, 130, 195, 260, 390, 520, 585, 650,
+    130, 260, 390, 520, 780, 1040, 1170, 1300,
+    195, 390, 585, 780, 1170, 1560, 1755, 1950,
+    260, 520, 780, 1040, 1560, 2080, 2340, 2600
+};
+
+/* bitrate of 802.11n ht20 connections with 400ns guard interval
+ * in 100kbit/s per spatial stream */
+const u16 ieee80211n_ht20_gi400[] =3D {
+    72, 144, 217, 289, 433, 578, 650, 722,
+    144, 289, 433, 578, 867, 1156, 1300, 1440,
+    217, 433, 650, 867, 1300, 1733, 1950, 2167,
+    289, 578, 867, 1157, 1733, 2311, 2600, 2889
+};
+
+/* bitrate of 802.11n ht40 connections with 800ns guard interval
+ * in 100kbit/s per spatial stream */
+const u16 ieee80211n_ht40_gi800[] =3D {
+    135, 270, 405, 540, 810, 1080, 1215, 1350,
+    270, 540, 810, 1080, 1620, 2160, 2430, 2700,
+    405, 810, 1215, 1620, 2430, 3240, 3645, 4050,
+    540, 1080, 1620, 2160, 3240, 4320, 4860, 5400
+};
+
+/* bitrate of 802.11n ht40 connections with 400ns guard interval
+ * in 100kbit/s per spatial stream */
+const u16 ieee80211n_ht40_gi400[] =3D {
+    150, 300, 450, 600, 900, 1200, 1350, 1500,
+    300, 600, 900, 1200, 1800, 2400, 2700, 3000,
+    450, 900, 1350, 1800, 2700, 3600, 4050, 4500,
+    600, 1200, 1800, 2400, 3600, 4800, 5400, 6000
+};
+
 static bool nl80211_type_check(enum nl80211_iftype type)
 {
 	switch (type) {
@@ -304,18 +339,58 @@ static int ieee80211_config_default_key(struct wiphy=
=20
*wiphy,
 	return 0;
 }
=20
+static u16 sta_get_80211n_bitrate(struct ieee80211_tx_rate *rate) {
+  if (!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)) {
+    if (!(rate->flags & IEEE80211_TX_RC_SHORT_GI))
+      return ieee80211n_ht20_gi800[rate->idx];
+
+    return ieee80211n_ht20_gi400[rate->idx];
+  }
+  else {
+    if (!(rate->flags & IEEE80211_TX_RC_SHORT_GI))
+      return ieee80211n_ht40_gi800[rate->idx];
+
+    return ieee80211n_ht40_gi400[rate->idx];
+  }
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
+	sinfo->rx_bitrate =3D sta->last_rxrate_unicast;
+
+	sinfo->tx_bitrate_flags =3D sta->last_tx_rate.flags &
+	    (IEEE80211_TX_RC_MCS |
+	     IEEE80211_TX_RC_40_MHZ_WIDTH |
+	     IEEE80211_TX_RC_SHORT_GI);
+
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
+		struct ieee80211_supported_band *sband;
+		sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
+		sinfo->tx_bitrate =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+		sinfo->tx_bitrate_mcs =3D 0;
+	}
+	else {
+		sinfo->tx_bitrate =3D sta_get_80211n_bitrate(&sta->last_tx_rate);
+		sinfo->tx_bitrate_mcs =3D sta->last_tx_rate.idx;
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |=3D STATION_INFO_LLID |
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5a1a60f..4b8ee9b 100644
=2D-- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -720,8 +720,15 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *r=
x)
 	if (rx->sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
 		u8 *bssid =3D ieee80211_get_bssid(hdr, rx->skb->len,
 						NL80211_IFTYPE_ADHOC);
=2D		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) =3D=3D 0)
+		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) =3D=3D 0) {
 			sta->last_rx =3D jiffies;
+
+			/* only update last_rxrate_unicast when we receive a
+			 * unicast packet for this station */
+			if (compare_ether_addr(hdr->addr1, sta->sta.addr)) {
+			  sta->last_rxrate_unicast =3D rx->rate->bitrate;
+			}
+		}
 	} else
 	if (!is_multicast_ether_addr(hdr->addr1) ||
 	    rx->sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index dc2606d..d2853ae 100644
=2D-- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -254,6 +254,7 @@ struct sta_info {
 	int last_signal;
 	int last_qual;
 	int last_noise;
+	u16 last_rxrate_unicast;
 	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
=20
 	/* Updated from TX status path only, no locking requirements */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c9141e3..1a89409 100644
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
@@ -1057,7 +1058,24 @@ static int nl80211_send_station(struct sk_buff *msg,=
=20
u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
=2D
+	if (sinfo->filled & STATION_INFO_SIGNAL)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
+			    sinfo->signal);
+	if (sinfo->filled & STATION_INFO_RX_BITRATE)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_RX_BITRATE,
+		            sinfo->rx_bitrate);
+	if (sinfo->filled & STATION_INFO_TX_BITRATE) {
+		NLA_PUT_U16(msg, NL80211_STA_INFO_TX_BITRATE,
+		            sinfo->tx_bitrate);
+
+		if (sinfo->tx_bitrate_flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_TX_BITRATE_40_MHZ);
+		if (sinfo->tx_bitrate_flags & IEEE80211_TX_RC_SHORT_GI)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_TX_BITRATE_SHORT_GI);
+		if (sinfo->tx_bitrate_flags & IEEE80211_TX_RC_MCS)
+			NLA_PUT_U16(msg, NL80211_STA_INFO_TX_BITRATE_MCS,
+				    sinfo->tx_bitrate_mcs);
+	}
 	nla_nest_end(msg, sinfoattr);
=20
 	return genlmsg_end(msg, hdr);


--Boundary-01=_AAmNJBSVVGyTxEo
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="station.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="station.c"

#include <net/if.h>
#include <errno.h>
#include <string.h>

#include <netlink/genl/genl.h>
#include <netlink/genl/family.h>
#include <netlink/genl/ctrl.h>
#include <netlink/msg.h>
#include <netlink/attr.h>

#include "nl80211.h"
#include "iw.h"

enum plink_state {
	LISTEN,
	OPN_SNT,
	OPN_RCVD,
	CNF_RCVD,
	ESTAB,
	HOLDING,
	BLOCKED
};

enum plink_actions {
	PLINK_ACTION_UNDEFINED,
	PLINK_ACTION_OPEN,
	PLINK_ACTION_BLOCK,
};


static int print_sta_handler(struct nl_msg *msg, void *arg)
{
	struct nlattr *tb[NL80211_ATTR_MAX + 1];
	struct genlmsghdr *gnlh =3D nlmsg_data(nlmsg_hdr(msg));
	struct nlattr *sinfo[NL80211_STA_INFO_MAX + 1];
	char mac_addr[20], state_name[10], dev[20];
	static struct nla_policy stats_policy[NL80211_STA_INFO_MAX + 1] =3D {
		[NL80211_STA_INFO_INACTIVE_TIME] =3D { .type =3D NLA_U32 },
		[NL80211_STA_INFO_RX_BYTES] =3D { .type =3D NLA_U32 },
		[NL80211_STA_INFO_TX_BYTES] =3D { .type =3D NLA_U32 },
		[NL80211_STA_INFO_LLID] =3D { .type =3D NLA_U16 },
		[NL80211_STA_INFO_PLID] =3D { .type =3D NLA_U16 },
		[NL80211_STA_INFO_PLINK_STATE] =3D { .type =3D NLA_U8 },
		[NL80211_STA_INFO_SIGNAL] =3D { .type =3D NLA_U8 },
		[NL80211_STA_INFO_RX_BITRATE] =3D { .type =3D NLA_U16 },
		[NL80211_STA_INFO_TX_BITRATE] =3D { .type =3D NLA_U16 },
		[NL80211_STA_INFO_TX_BITRATE_40_MHZ] =3D { .type =3D NLA_FLAG },
		[NL80211_STA_INFO_TX_BITRATE_SHORT_GI] =3D { .type =3D NLA_FLAG },
		[NL80211_STA_INFO_TX_BITRATE_MCS] =3D { .type =3D NLA_U8 },
	};

	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
		  genlmsg_attrlen(gnlh, 0), NULL);

	/*
	 * TODO: validate the interface and mac address!
	 * Otherwise, there's a race condition as soon as
	 * the kernel starts sending station notifications.
	 */

	if (!tb[NL80211_ATTR_STA_INFO]) {
		fprintf(stderr, "sta stats missing!");
		return NL_SKIP;
	}
	if (nla_parse_nested(sinfo, NL80211_STA_INFO_MAX,
			     tb[NL80211_ATTR_STA_INFO],
			     stats_policy)) {
		fprintf(stderr, "failed to parse nested attributes!");
		return NL_SKIP;
	}

	mac_addr_n2a(mac_addr, nla_data(tb[NL80211_ATTR_MAC]));
	if_indextoname(nla_get_u32(tb[NL80211_ATTR_IFINDEX]), dev);
	printf("Station %s (on %s)", mac_addr, dev);

	if (sinfo[NL80211_STA_INFO_INACTIVE_TIME])
		printf("\n\tinactive time:\t%d ms",
			nla_get_u32(sinfo[NL80211_STA_INFO_INACTIVE_TIME]));
	if (sinfo[NL80211_STA_INFO_RX_BYTES])
		printf("\n\trx bytes:\t%d",
			nla_get_u32(sinfo[NL80211_STA_INFO_RX_BYTES]));
	if (sinfo[NL80211_STA_INFO_TX_BYTES])
		printf("\n\ttx bytes:\t%d",
			nla_get_u32(sinfo[NL80211_STA_INFO_TX_BYTES]));
	if (sinfo[NL80211_STA_INFO_SIGNAL])
		printf("\n\tsignal:  \t%d dBm",
			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL]));
	if (sinfo[NL80211_STA_INFO_RX_BITRATE]) {
		int bitrate =3D nla_get_u16(sinfo[NL80211_STA_INFO_RX_BITRATE]);
		printf("\n\trx-bitrate:\t%d.%01d MBit/s", bitrate/10, bitrate % 10);
	}
	if (sinfo[NL80211_STA_INFO_TX_BITRATE]) {
		int bitrate =3D 0;
		int mcs =3D -1;
		int short_gi =3D 0;
	=09
		bitrate =3D nla_get_u16(sinfo[NL80211_STA_INFO_TX_BITRATE]);
		if (sinfo[NL80211_STA_INFO_TX_BITRATE_MCS])
			mcs =3D nla_get_u8(sinfo[NL80211_STA_INFO_TX_BITRATE_MCS]);
		if (sinfo[NL80211_STA_INFO_TX_BITRATE_SHORT_GI])
			short_gi =3D 1;
	=09
		printf("\n\ttx-bitrate:\t%d.%01d MBit/s", bitrate/10, bitrate % 10);
		if (sinfo[NL80211_STA_INFO_TX_BITRATE_40_MHZ])
			printf(" 40Mhz");
		if (mcs !=3D -1) {
			printf(" (MCS %d%s)", mcs, short_gi ? ", short guard interval" : "");
		}
	}
	if (sinfo[NL80211_STA_INFO_LLID])
		printf("\n\tmesh llid:\t%d",
			nla_get_u16(sinfo[NL80211_STA_INFO_LLID]));
	if (sinfo[NL80211_STA_INFO_PLID])
		printf("\n\tmesh plid:\t%d",
			nla_get_u16(sinfo[NL80211_STA_INFO_PLID]));
	if (sinfo[NL80211_STA_INFO_PLINK_STATE]) {
		switch (nla_get_u16(sinfo[NL80211_STA_INFO_PLINK_STATE])) {
		case LISTEN:
			strcpy(state_name, "LISTEN");
			break;
		case OPN_SNT:
			strcpy(state_name, "OPN_SNT");
			break;
		case OPN_RCVD:
			strcpy(state_name, "OPN_RCVD");
			break;
		case CNF_RCVD:
			strcpy(state_name, "CNF_RCVD");
			break;
		case ESTAB:
			strcpy(state_name, "ESTAB");
			break;
		case HOLDING:
			strcpy(state_name, "HOLDING");
			break;
		case BLOCKED:
			strcpy(state_name, "BLOCKED");
			break;
		default:
			strcpy(state_name, "UNKNOWN");
			break;
		}
		printf("\n\tmesh plink:\t%s", state_name);
	}

	printf("\n");
	return NL_SKIP;
}

static int handle_station_get(struct nl_cb *cb,
			      struct nl_msg *msg,
			      int argc, char **argv)
{
	unsigned char mac_addr[ETH_ALEN];

	if (argc < 1)
		return 1;

	if (mac_addr_a2n(mac_addr, argv[0])) {
		fprintf(stderr, "invalid mac address\n");
		return 2;
	}

	argc--;
	argv++;

	if (argc)
		return 1;

	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);

	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_sta_handler, NULL);

	return 0;
 nla_put_failure:
	return -ENOBUFS;
}
COMMAND(station, get, "<MAC address>",
	NL80211_CMD_GET_STATION, 0, CIB_NETDEV, handle_station_get);
COMMAND(station, del, "<MAC address>",
	NL80211_CMD_DEL_STATION, 0, CIB_NETDEV, handle_station_get);

static int handle_station_set(struct nl_cb *cb,
			      struct nl_msg *msg,
			      int argc, char **argv)
{
	unsigned char plink_action;
	unsigned char mac_addr[ETH_ALEN];

	if (argc < 3)
		return 1;

	if (mac_addr_a2n(mac_addr, argv[0])) {
		fprintf(stderr, "invalid mac address\n");
		return 2;
	}
	argc--;
	argv++;

	if (strcmp("plink_action", argv[0]) !=3D 0)
		return 1;
	argc--;
	argv++;

	if (strcmp("open", argv[0]) =3D=3D 0)
		plink_action =3D PLINK_ACTION_OPEN;
	else if (strcmp("block", argv[0]) =3D=3D 0)
		plink_action =3D PLINK_ACTION_BLOCK;
	else {
		fprintf(stderr, "plink action not supported\n");
		return 2;
	}
	argc--;
	argv++;

	if (argc)
		return 1;

	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
	NLA_PUT_U8(msg, NL80211_ATTR_STA_PLINK_ACTION, plink_action);

	return 0;
 nla_put_failure:
	return -ENOBUFS;
}
COMMAND(station, set, "<MAC address> plink_action <open|block>",
	NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set);

static int handle_station_dump(struct nl_cb *cb,
			       struct nl_msg *msg,
			       int argc, char **argv)
{
	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_sta_handler, NULL);
	return 0;
}
COMMAND(station, dump, NULL,
	NL80211_CMD_GET_STATION, NLM_F_DUMP, CIB_NETDEV, handle_station_dump);

--Boundary-01=_AAmNJBSVVGyTxEo
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="nl80211ext_v5.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nl80211ext_v5.patch"

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e08c8bc..32bb7ad 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -404,6 +404,14 @@ enum nl80211_sta_flags {
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this stati=
on)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
+ * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u8,=
 dBm)
+ * @NL80211_STA_INFO_RX_BITRATE: bitrate of last received unicast packet
+ *  (u16, 100 kbit/s)
+ * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate (u16, 100 kbit/s)
+ * @NL80211_STA_INFO_TX_BITRATE_40_MHZ: dual channel transmission (flag)
+ * @NL80211_STA_INFO_TX_BITRATE_MCS: 802.11n MCS index of tx rate (u8)
+ * @NL80211_STA_INFO_TX_BITRATE_SHORT_GI: 802.11n with 400ns GI, 800ns
+ *  otherwise, should be ignored if TX_BITRATE_MCS is not set (flag)
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -413,6 +421,12 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_RX_BITRATE,
+	NL80211_STA_INFO_TX_BITRATE,
+	NL80211_STA_INFO_TX_BITRATE_40_MHZ,
+	NL80211_STA_INFO_TX_BITRATE_MCS,
+	NL80211_STA_INFO_TX_BITRATE_SHORT_GI,
=20
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1d57835..5cc8b53 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -160,6 +160,8 @@ struct station_parameters {
  *
  * Used by the driver to indicate which info in &struct station_info
  * it has filled in during get_station() or dump_station().
+ * Signal strength is only available if driver supports dBm signal
+ * strength.
  *
  * @STATION_INFO_INACTIVE_TIME: @inactive_time filled
  * @STATION_INFO_RX_BYTES: @rx_bytes filled
@@ -167,6 +169,10 @@ struct station_parameters {
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
@@ -175,6 +181,9 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_RX_BITRATE		=3D 1<<7,
+	STATION_INFO_TX_BITRATE		=3D 1<<8,
 };
=20
 /**
@@ -189,6 +198,15 @@ enum station_info_flags {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
+ * @signal: signal strength of last received package in dBm
+ * @rx_bitrate: bitrate of last received unicast packet in 100 kbit/sec
+ * @tx_bitrate: current unicast bitrate to this station in 100 kbit/sec
+ * @tx_bitrate_flags: a binary field with a combination of flags
+ *  IEEE80211_TX_RC_MCS: bitrate_mcs field contains the 802.11n MCS number
+ *  IEEE80211_TX_RC_40_MHZ_WIDTH: 40 Mhz wide channel, 20 Mhz if not set
+ *  IEEE80211_TX_RC_SHORT_GI: 400ns guard interval, 800ns if not set
+ * @tx_bitrate_mcs: if IEEE80211_TX_RC_MCS is set this is the MCS index
+ *  of a 802.11n transmission, if not it is set to zero
  */
 struct station_info {
 	u32 filled;
@@ -198,6 +216,10 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	u16 rx_bitrate;
+	u16 tx_bitrate;
+	u8 tx_bitrate_flags, tx_bitrate_mcs;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16423f9..dc684a4 100644
=2D-- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -17,6 +17,41 @@
 #include "rate.h"
 #include "mesh.h"
=20
+/* bitrate of 802.11n ht20 connections with 800ns guard interval in 100kbi=
t/s */
+const u16 ieee80211n_ht20_gi800[] =3D {
+    65, 130, 195, 260, 390, 520, 585, 650,
+    130, 260, 390, 520, 780, 1040, 1170, 1300,
+    195, 390, 585, 780, 1170, 1560, 1755, 1950,
+    260, 520, 780, 1040, 1560, 2080, 2340, 2600
+};
+
+/* bitrate of 802.11n ht20 connections with 400ns guard interval
+ * in 100kbit/s per spatial stream */
+const u16 ieee80211n_ht20_gi400[] =3D {
+    72, 144, 217, 289, 433, 578, 650, 722,
+    144, 289, 433, 578, 867, 1156, 1300, 1440,
+    217, 433, 650, 867, 1300, 1733, 1950, 2167,
+    289, 578, 867, 1157, 1733, 2311, 2600, 2889
+};
+
+/* bitrate of 802.11n ht40 connections with 800ns guard interval
+ * in 100kbit/s per spatial stream */
+const u16 ieee80211n_ht40_gi800[] =3D {
+    135, 270, 405, 540, 810, 1080, 1215, 1350,
+    270, 540, 810, 1080, 1620, 2160, 2430, 2700,
+    405, 810, 1215, 1620, 2430, 3240, 3645, 4050,
+    540, 1080, 1620, 2160, 3240, 4320, 4860, 5400
+};
+
+/* bitrate of 802.11n ht40 connections with 400ns guard interval
+ * in 100kbit/s per spatial stream */
+const u16 ieee80211n_ht40_gi400[] =3D {
+    150, 300, 450, 600, 900, 1200, 1350, 1500,
+    300, 600, 900, 1200, 1800, 2400, 2700, 3000,
+    450, 900, 1350, 1800, 2700, 3600, 4050, 4500,
+    600, 1200, 1800, 2400, 3600, 4800, 5400, 6000
+};
+
 static bool nl80211_type_check(enum nl80211_iftype type)
 {
 	switch (type) {
@@ -304,18 +339,58 @@ static int ieee80211_config_default_key(struct wiphy =
*wiphy,
 	return 0;
 }
=20
+static u16 sta_get_80211n_bitrate(struct ieee80211_tx_rate *rate) {
+  if (!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)) {
+    if (!(rate->flags & IEEE80211_TX_RC_SHORT_GI))
+      return ieee80211n_ht20_gi800[rate->idx];
+
+    return ieee80211n_ht20_gi400[rate->idx];
+  }
+  else {
+    if (!(rate->flags & IEEE80211_TX_RC_SHORT_GI))
+      return ieee80211n_ht40_gi800[rate->idx];
+
+    return ieee80211n_ht40_gi400[rate->idx];
+  }
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
+	sinfo->rx_bitrate =3D sta->last_rxrate_unicast;
+
+	sinfo->tx_bitrate_flags =3D sta->last_tx_rate.flags &
+	    (IEEE80211_TX_RC_MCS |
+	     IEEE80211_TX_RC_40_MHZ_WIDTH |
+	     IEEE80211_TX_RC_SHORT_GI);
+
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
+		struct ieee80211_supported_band *sband;
+		sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band];
+		sinfo->tx_bitrate =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+		sinfo->tx_bitrate_mcs =3D 0;
+	}
+	else {
+		sinfo->tx_bitrate =3D sta_get_80211n_bitrate(&sta->last_tx_rate);
+		sinfo->tx_bitrate_mcs =3D sta->last_tx_rate.idx;
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |=3D STATION_INFO_LLID |
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5a1a60f..4b8ee9b 100644
=2D-- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -720,8 +720,15 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *r=
x)
 	if (rx->sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
 		u8 *bssid =3D ieee80211_get_bssid(hdr, rx->skb->len,
 						NL80211_IFTYPE_ADHOC);
=2D		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) =3D=3D 0)
+		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) =3D=3D 0) {
 			sta->last_rx =3D jiffies;
+
+			/* only update last_rxrate_unicast when we receive a
+			 * unicast packet for this station */
+			if (compare_ether_addr(hdr->addr1, sta->sta.addr)) {
+			  sta->last_rxrate_unicast =3D rx->rate->bitrate;
+			}
+		}
 	} else
 	if (!is_multicast_ether_addr(hdr->addr1) ||
 	    rx->sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index dc2606d..d2853ae 100644
=2D-- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -254,6 +254,7 @@ struct sta_info {
 	int last_signal;
 	int last_qual;
 	int last_noise;
+	u16 last_rxrate_unicast;
 	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
=20
 	/* Updated from TX status path only, no locking requirements */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c9141e3..1a89409 100644
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
@@ -1057,7 +1058,24 @@ static int nl80211_send_station(struct sk_buff *msg,=
 u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
=2D
+	if (sinfo->filled & STATION_INFO_SIGNAL)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
+			    sinfo->signal);
+	if (sinfo->filled & STATION_INFO_RX_BITRATE)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_RX_BITRATE,
+		            sinfo->rx_bitrate);
+	if (sinfo->filled & STATION_INFO_TX_BITRATE) {
+		NLA_PUT_U16(msg, NL80211_STA_INFO_TX_BITRATE,
+		            sinfo->tx_bitrate);
+
+		if (sinfo->tx_bitrate_flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_TX_BITRATE_40_MHZ);
+		if (sinfo->tx_bitrate_flags & IEEE80211_TX_RC_SHORT_GI)
+			NLA_PUT_FLAG(msg, NL80211_STA_INFO_TX_BITRATE_SHORT_GI);
+		if (sinfo->tx_bitrate_flags & IEEE80211_TX_RC_MCS)
+			NLA_PUT_U16(msg, NL80211_STA_INFO_TX_BITRATE_MCS,
+				    sinfo->tx_bitrate_mcs);
+	}
 	nla_nest_end(msg, sinfoattr);
=20
 	return genlmsg_end(msg, hdr);

--Boundary-01=_AAmNJBSVVGyTxEo--

--nextPart1561538.dovAiFogOV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk2YAAACgkQRIfGfFXsz+AK+ACfQEFL9Wiw0OmlpUeKbdK9oUt6
O3QAoJONvxCg8CzUU11pvWihGtxIVHxw
=z6ex
-----END PGP SIGNATURE-----

--nextPart1561538.dovAiFogOV--
