Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:47500 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbYLBNZt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 08:25:49 -0500
From: Henning Rogge <rogge@fgan.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: RFC Patch v2: Add signal strength to nl80211station info
Date: Tue, 2 Dec 2008 14:25:36 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Henning Rogge <hrogge@googlemail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>, nbd@openwrt.org
References: <200811252131.30161.hrogge@googlemail.com> <200812011422.30671.rogge@fgan.de> <20081201173948.GD5992@tesla>
In-Reply-To: <20081201173948.GD5992@tesla>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4471189.uUMbzfVYyn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812021425.44488.rogge@fgan.de> (sfid-20081202_142555_176535_51F584A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4471189.uUMbzfVYyn
Content-Type: multipart/mixed;
  boundary="Boundary-01=_RdTNJDZAtDqzx3i"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_RdTNJDZAtDqzx3i
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Monday 01 December 2008 18:39:48 schrieb Luis R. Rodriguez:
> It would be nice to get this figured out before adding it. We got random
> complaints from users claiming 802.11n wasn't working before because
> iwconfig didn't report a good rate. Users will trust it so I'd rather
> see this go in with MCS rate figured out as part of the API to avoid
> such reports. Would it be possible for you to work on that?
>
> This might come in handy:
>
> http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n#=
MC
>SRates
>
> What you need then is the guard interval, the MCS rate index and the
> number of streams being used for communication.

> Also how about we add a last TX rate and last RX rate so we get both?
>
>   Luis

Changes since v1:
=2D removed noise and quality from station info in NL80211
=2D added bandwith to station info in NL80211
=2D changed name of patch file to nl80211ext_v2.patch
=20
Changes since v2:
=2D added kernel comment lines for new fields/enums
=2D changed name of "bandwith" field to tx_bitrate

Changes since v3:
=2D added rx_bitrate to station info and sta_info
=2D remember bitrate of last received unicast packet to this station
=2D decode 802.11n MCS index for nl80211
  (maybe this should be ported to WEXT too ?)

The last part is untested because I own only one 802.11n capable wlan devic=
e,=20
so I cannot create an adhoc network with 802.11n, but I hope I got the code=
=20
right. The four data arrays and sta_get_80211n_bitrate() should be maybe mo=
ved=20
to another file, but I'm not sure where to put it.

I have attached a patched station.c for the iw command, so the changes can =
be
tested with "iw dev wlan0 station dump":

root@.....:~/iw.new# ./iw dev wlan0 station dump                           =
              =20
Station xx:xx:xx:xx:xx:xx (on wlan0)                                       =
               =20
        inactive time:  228 ms                                             =
               =20
        rx bytes:       4247                                               =
               =20
        tx bytes:       932                                                =
               =20
        signal:         -68 dBm                                            =
               =20
        rx-bitrate:     12.0 MBit/s                                        =
               =20
        tx-bitrate:     6.0 MBit/s                                         =
               =20

Henning

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

=2D-------------------------------------------------------
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e08c8bc..3a83e97 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -404,6 +404,10 @@ enum nl80211_sta_flags {
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
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -413,6 +417,9 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_RX_BITRATE,
+	NL80211_STA_INFO_TX_BITRATE,
=20
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1d57835..cdf9433 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -167,6 +167,9 @@ struct station_parameters {
  * @STATION_INFO_LLID: @llid filled
  * @STATION_INFO_PLID: @plid filled
  * @STATION_INFO_PLINK_STATE: @plink_state filled
+ * @STATION_INFO_SIGNAL: @signal filled
+ * @STATION_INFO_RX_BITRATE: @rx_bitrate filled
+ * @STATION_INFO_TX_BITRATE: @tx_bitrate filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	=3D 1<<0,
@@ -175,6 +178,9 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_RX_BITRATE		=3D 1<<7,
+	STATION_INFO_TX_BITRATE		=3D 1<<8,
 };
=20
 /**
@@ -189,6 +195,9 @@ enum station_info_flags {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
+ * @signal: signal strength of last received package in dBm
+ * @rx_bitrate: bitrate of last received unicast packet in 100 kbit/sec
+ * @tx_bitrate: current unicast tx rate in 100 kbit/sec
  */
 struct station_info {
 	u32 filled;
@@ -198,6 +207,9 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	u16 rx_bitrate;
+	u16 tx_bitrate;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16423f9..77f0b1e 100644
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
@@ -304,18 +339,50 @@ static int ieee80211_config_default_key(struct wiphy=
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
+	  sinfo->filled |=3D STATION_INFO_SIGNAL;
+	  sinfo->signal =3D sta->last_signal;
+	}
+
+	sinfo->rx_bitrate =3D sta->last_rxrate_unicast;
+
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
+	  struct ieee80211_supported_band *sband;
+	  sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band=
];
+	  sinfo->tx_bitrate =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	}
+	else
+	  sinfo->tx_bitrate =3D sta_get_80211n_bitrate(&sta->last_tx_rate);
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
index c9141e3..776e333 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1057,6 +1057,15 @@ static int nl80211_send_station(struct sk_buff *msg,=
=20
u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
+	if (sinfo->filled & STATION_INFO_SIGNAL)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
+			    sinfo->signal);
+	if (sinfo->filled & STATION_INFO_RX_BITRATE)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_RX_BITRATE,
+		            sinfo->rx_bitrate);
+	if (sinfo->filled & STATION_INFO_TX_BITRATE)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_TX_BITRATE,
+		            sinfo->tx_bitrate);
=20
 	nla_nest_end(msg, sinfoattr);
=20


--Boundary-01=_RdTNJDZAtDqzx3i
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="nl80211ext_v4.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="nl80211ext_v4.patch"

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e08c8bc..3a83e97 100644
=2D-- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -404,6 +404,10 @@ enum nl80211_sta_flags {
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this stati=
on)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
+ * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u8,=
 dBm)
+ * @NL80211_STA_INFO_RX_BITRATE: bitrate of last received unicast packet
+ *  (u16, 100 kbit/s)
+ * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate (u16, 100 kbit/s)
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -413,6 +417,9 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_RX_BITRATE,
+	NL80211_STA_INFO_TX_BITRATE,
=20
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1d57835..cdf9433 100644
=2D-- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -167,6 +167,9 @@ struct station_parameters {
  * @STATION_INFO_LLID: @llid filled
  * @STATION_INFO_PLID: @plid filled
  * @STATION_INFO_PLINK_STATE: @plink_state filled
+ * @STATION_INFO_SIGNAL: @signal filled
+ * @STATION_INFO_RX_BITRATE: @rx_bitrate filled
+ * @STATION_INFO_TX_BITRATE: @tx_bitrate filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	=3D 1<<0,
@@ -175,6 +178,9 @@ enum station_info_flags {
 	STATION_INFO_LLID		=3D 1<<3,
 	STATION_INFO_PLID		=3D 1<<4,
 	STATION_INFO_PLINK_STATE	=3D 1<<5,
+	STATION_INFO_SIGNAL		=3D 1<<6,
+	STATION_INFO_RX_BITRATE		=3D 1<<7,
+	STATION_INFO_TX_BITRATE		=3D 1<<8,
 };
=20
 /**
@@ -189,6 +195,9 @@ enum station_info_flags {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
+ * @signal: signal strength of last received package in dBm
+ * @rx_bitrate: bitrate of last received unicast packet in 100 kbit/sec
+ * @tx_bitrate: current unicast tx rate in 100 kbit/sec
  */
 struct station_info {
 	u32 filled;
@@ -198,6 +207,9 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	u8 signal;
+	u16 rx_bitrate;
+	u16 tx_bitrate;
 };
=20
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16423f9..77f0b1e 100644
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
@@ -304,18 +339,50 @@ static int ieee80211_config_default_key(struct wiphy =
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
+	  sinfo->filled |=3D STATION_INFO_SIGNAL;
+	  sinfo->signal =3D sta->last_signal;
+	}
+
+	sinfo->rx_bitrate =3D sta->last_rxrate_unicast;
+
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
+	  struct ieee80211_supported_band *sband;
+	  sband =3D sta->local->hw.wiphy->bands[sta->local->hw.conf.channel->band=
];
+	  sinfo->tx_bitrate =3D sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	}
+	else
+	  sinfo->tx_bitrate =3D sta_get_80211n_bitrate(&sta->last_tx_rate);
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
index c9141e3..776e333 100644
=2D-- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1057,6 +1057,15 @@ static int nl80211_send_station(struct sk_buff *msg,=
 u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
+	if (sinfo->filled & STATION_INFO_SIGNAL)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
+			    sinfo->signal);
+	if (sinfo->filled & STATION_INFO_RX_BITRATE)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_RX_BITRATE,
+		            sinfo->rx_bitrate);
+	if (sinfo->filled & STATION_INFO_TX_BITRATE)
+		NLA_PUT_U16(msg, NL80211_STA_INFO_TX_BITRATE,
+		            sinfo->tx_bitrate);
=20
 	nla_nest_end(msg, sinfoattr);
=20

--Boundary-01=_RdTNJDZAtDqzx3i
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="station.c"
Content-Transfer-Encoding: 7bit
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
	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
	struct nlattr *sinfo[NL80211_STA_INFO_MAX + 1];
	char mac_addr[20], state_name[10], dev[20];
	static struct nla_policy stats_policy[NL80211_STA_INFO_MAX + 1] = {
		[NL80211_STA_INFO_INACTIVE_TIME] = { .type = NLA_U32 },
		[NL80211_STA_INFO_RX_BYTES] = { .type = NLA_U32 },
		[NL80211_STA_INFO_TX_BYTES] = { .type = NLA_U32 },
		[NL80211_STA_INFO_LLID] = { .type = NLA_U16 },
		[NL80211_STA_INFO_PLID] = { .type = NLA_U16 },
		[NL80211_STA_INFO_PLINK_STATE] = { .type = NLA_U8 },
		[NL80211_STA_INFO_SIGNAL] = { .type = NLA_U8 },
		[NL80211_STA_INFO_RX_BITRATE] = { .type = NLA_U16 },
		[NL80211_STA_INFO_TX_BITRATE] = { .type = NLA_U16 },
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
		int bitrate = nla_get_u16(sinfo[NL80211_STA_INFO_RX_BITRATE]);
		printf("\n\trx-bitrate:\t%d.%01d MBit/s", bitrate/10, bitrate % 10);
	}
	if (sinfo[NL80211_STA_INFO_TX_BITRATE]) {
		int bitrate = nla_get_u16(sinfo[NL80211_STA_INFO_TX_BITRATE]);
		printf("\n\ttx-bitrate:\t%d.%01d MBit/s", bitrate/10, bitrate % 10);
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

	if (strcmp("plink_action", argv[0]) != 0)
		return 1;
	argc--;
	argv++;

	if (strcmp("open", argv[0]) == 0)
		plink_action = PLINK_ACTION_OPEN;
	else if (strcmp("block", argv[0]) == 0)
		plink_action = PLINK_ACTION_BLOCK;
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

--Boundary-01=_RdTNJDZAtDqzx3i--

--nextPart4471189.uUMbzfVYyn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk1N1EACgkQRIfGfFXsz+By3gCgqbX+JRtiyBVOk8FRyGAv8HOM
gL8AniyUOi9f3bavl5Zxo7lpwAva0wSx
=PaLP
-----END PGP SIGNATURE-----

--nextPart4471189.uUMbzfVYyn--
