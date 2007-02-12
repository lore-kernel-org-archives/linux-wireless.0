Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:25367 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932881AbXBLDKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 22:10:15 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] d80211: Fix wireless statistics reporting
Date: Sun, 11 Feb 2007 22:09:41 -0500
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9460067.Em0Sdm2Yth";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702112209.46093.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart9460067.Em0Sdm2Yth
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

d80211: Fix wireless statistics reporting

This fixes statistics reporting. It allows drivers to specify what type of
values they support, makes scan results return correct statistics, and
generally fixes the brain damaged statistics reporting code.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 include/net/d80211.h         |    9 ++++++---
 net/d80211/ieee80211.c       |   18 +++++++++++++++---
 net/d80211/ieee80211_i.h     |    3 ++-
 net/d80211/ieee80211_ioctl.c |   42 ++++++++++++++++++--------------------=
=2D---
 net/d80211/ieee80211_sta.c   |   19 +++++++++++++++++++
 5 files changed, 60 insertions(+), 31 deletions(-)

diff --git a/include/net/d80211.h b/include/net/d80211.h
index 0b7b963..25a4dca 100644
=2D-- a/include/net/d80211.h
+++ b/include/net/d80211.h
@@ -230,7 +230,7 @@ struct ieee80211_rx_status {
         int channel;
         int phymode;
         int ssi;
=2D	int signal;
+	int signal; /* used as qual in statistics reporting */
 	int noise;
         int antenna;
         int rate;
@@ -541,8 +541,11 @@ struct ieee80211_hw {
         /* This is the time in us to change channels
          */
         int channel_change_time;
=2D	/* This is maximum value for rssi reported by this device */
=2D	int maxssi;
+	/* Maximum values for various statistics.
+	 * Leave at 0 to indicate no support. Use negative numbers for dBm. */
+	char max_rssi;
+	char max_signal;
+	char max_noise;
=20
 	/* Number of available hardware TX queues for data packets.
 	 * WMM requires at least four queues. */
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index c83520e..0e5f23f 100644
=2D-- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -3334,9 +3334,12 @@ ieee80211_rx_h_sta_process(struct ieee80
=20
 	sta->rx_fragments++;
 	sta->rx_bytes +=3D rx->skb->len;
=2D	sta->last_rssi =3D rx->u.rx.status->ssi;
=2D	sta->last_signal =3D rx->u.rx.status->signal;
=2D	sta->last_noise =3D rx->u.rx.status->noise;
+	sta->last_rssi =3D (sta->last_rssi * 15 +
+			  rx->u.rx.status->ssi) / 16;
+	sta->last_signal =3D (sta->last_signal * 15 +
+			    rx->u.rx.status->signal) / 16;
+	sta->last_noise =3D (sta->last_noise * 15 +
+			   rx->u.rx.status->noise) / 16;
=20
 	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
 		/* Change STA power saving mode only in the end of a frame
@@ -4624,6 +4627,15 @@ int ieee80211_register_hw(struct ieee802
=20
 	local->hw.conf.beacon_int =3D 1000;
=20
+	local->wstats_flags |=3D local->hw.max_rssi ?
+			       IW_QUAL_LEVEL_UPDATED : IW_QUAL_LEVEL_INVALID;
+	local->wstats_flags |=3D local->hw.max_signal ?
+			       IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
+	local->wstats_flags |=3D local->hw.max_noise ?
+			       IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
+	if (local->hw.max_rssi < 0 || local->hw.max_noise < 0)
+		local->wstats_flags |=3D IW_QUAL_DBM;
+
 	result =3D sta_info_start(local);
 	if (result < 0)
 		goto fail_sta_info;
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index 3c59a1f..d965704 100644
=2D-- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -83,7 +83,7 @@ struct ieee80211_sta_bss {
 	int hw_mode;
 	int channel;
 	int freq;
=2D	int rssi;
+	int rssi, signal, noise;
 	u8 *wpa_ie;
 	size_t wpa_ie_len;
 	u8 *rsn_ie;
@@ -355,6 +355,7 @@ struct ieee80211_local {
 	int open_count;
 	int monitors;
 	struct iw_statistics wstats;
+	u8 wstats_flags;
=20
 	struct class_device class_dev;
=20
diff --git a/net/d80211/ieee80211_ioctl.c b/net/d80211/ieee80211_ioctl.c
index fa85fb0..cad4d54 100644
=2D-- a/net/d80211/ieee80211_ioctl.c
+++ b/net/d80211/ieee80211_ioctl.c
@@ -1578,6 +1578,7 @@ static int ieee80211_ioctl_giwrange(stru
 				 struct iw_request_info *info,
 				 struct iw_point *data, char *extra)
 {
+	struct ieee80211_local *local =3D dev->ieee80211_ptr;
 	struct iw_range *range =3D (struct iw_range *) extra;
=20
 	data->length =3D sizeof(struct iw_range);
@@ -1594,15 +1595,15 @@ static int ieee80211_ioctl_giwrange(stru
 	range->min_frag =3D 256;
 	range->max_frag =3D 2346;
=20
=2D	range->max_qual.qual =3D 100;
=2D	range->max_qual.level =3D 146;  /* set floor at -110 dBm (146 - 256) */
=2D	range->max_qual.noise =3D 146;
=2D	range->max_qual.updated =3D IW_QUAL_ALL_UPDATED;
+	range->max_qual.qual =3D local->hw.max_signal;
+	range->max_qual.level =3D local->hw.max_rssi;
+	range->max_qual.noise =3D local->hw.max_noise;
+	range->max_qual.updated =3D local->wstats_flags;
=20
=2D	range->avg_qual.qual =3D 50;
+	range->avg_qual.qual =3D local->hw.max_signal/2;
 	range->avg_qual.level =3D 0;
 	range->avg_qual.noise =3D 0;
=2D	range->avg_qual.updated =3D IW_QUAL_ALL_UPDATED;
+	range->avg_qual.updated =3D local->wstats_flags;
=20
 	return 0;
 }
@@ -3052,16 +3053,16 @@ static int ieee80211_ioctl_siwauth(struc
 }
=20
 /* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWST=
ATS */
=2Dstatic struct iw_statistics *ieee80211_get_wireless_stats(struct net_dev=
ice *net_dev)
+static struct iw_statistics *ieee80211_get_wireless_stats(struct net_devic=
e *dev)
 {
=2D	struct ieee80211_local *local =3D net_dev->ieee80211_ptr;
=2D	struct iw_statistics * wstats =3D &local->wstats;
=2D	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(net_dev=
);
=2D	struct sta_info *sta;
=2D	static int tmp_level =3D 0;
=2D	static int tmp_qual =3D 0;
+	struct ieee80211_local *local =3D dev->ieee80211_ptr;
+	struct iw_statistics *wstats =3D &local->wstats;
+	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta =3D NULL;
=20
=2D	sta =3D sta_info_get(local, sdata->u.sta.bssid);
+	if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA ||
+	    sdata->type =3D=3D IEEE80211_IF_TYPE_IBSS)
+		sta =3D sta_info_get(local, sdata->u.sta.bssid);
 	if (!sta) {
 		wstats->discard.fragment =3D 0;
 		wstats->discard.misc =3D 0;
@@ -3070,17 +3071,10 @@ static struct iw_statistics *ieee80211_g
 		wstats->qual.noise =3D 0;
 		wstats->qual.updated =3D IW_QUAL_ALL_INVALID;
 	} else {
=2D		if (!tmp_level) {	/* get initial values */
=2D			tmp_level =3D sta->last_signal;
=2D			tmp_qual =3D sta->last_rssi;
=2D		} else {		/* smooth results */
=2D			tmp_level =3D (15 * tmp_level + sta->last_signal)/16;
=2D			tmp_qual =3D (15 * tmp_qual + sta->last_rssi)/16;
=2D		}
=2D		wstats->qual.level =3D tmp_level;
=2D		wstats->qual.qual =3D 100*tmp_qual/local->hw.maxssi;
+		wstats->qual.level =3D sta->last_rssi;
+		wstats->qual.qual =3D sta->last_signal;
 		wstats->qual.noise =3D sta->last_noise;
=2D		wstats->qual.updated =3D IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
+		wstats->qual.updated =3D local->wstats_flags;
 		sta_info_put(sta);
 	}
 	return wstats;
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index 78d5cf5..fc71cb2 100644
=2D-- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -1175,12 +1175,20 @@ static void ieee80211_rx_mgmt_assoc_resp
 	/* Add STA entry for the AP */
 	sta =3D sta_info_get(local, ifsta->bssid);
 	if (!sta) {
+		struct ieee80211_sta_bss *bss;
 		sta =3D sta_info_add(local, dev, ifsta->bssid, GFP_ATOMIC);
 		if (!sta) {
 			printk(KERN_DEBUG "%s: failed to add STA entry for the"
 			       " AP\n", dev->name);
 			return;
 		}
+		bss =3D ieee80211_rx_bss_get(dev, ifsta->bssid);
+		if (bss) {
+			sta->last_rssi =3D bss->rssi;
+			sta->last_signal =3D bss->signal;
+			sta->last_noise =3D bss->noise;
+			ieee80211_rx_bss_put(dev, bss);
+		}
 	}
=20
 	sta->dev =3D dev;
@@ -1566,6 +1574,8 @@ static void ieee80211_rx_bss_info(struct
 	bss->timestamp =3D timestamp;
 	bss->last_update =3D jiffies;
 	bss->rssi =3D rx_status->ssi;
+	bss->signal =3D rx_status->signal;
+	bss->noise =3D rx_status->noise;
 	if (!beacon)
 		bss->probe_resp++;
 	ieee80211_rx_bss_put(dev, bss);
@@ -2751,6 +2761,15 @@ ieee80211_sta_scan_result(struct net_dev
 					  IW_EV_FREQ_LEN);
=20
 	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd =3D IWEVQUAL;
+	iwe.u.qual.qual =3D bss->signal;
+	iwe.u.qual.level =3D bss->rssi;
+	iwe.u.qual.noise =3D bss->noise;
+	iwe.u.qual.updated =3D local->wstats_flags;
+	current_ev =3D iwe_stream_add_event(current_ev, end_buf, &iwe,
+					  IW_EV_QUAL_LEN);
+
+	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd =3D SIOCGIWENCODE;
 	if (bss->capability & WLAN_CAPABILITY_PRIVACY)
 		iwe.u.data.flags =3D IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;

--nextPart9460067.Em0Sdm2Yth
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFz9p6T3Oqt9AH4aERAkLMAJ0a26ZAI6H/Mepuy3oPS2TltieisgCgkiON
FuXA9vdYl9bLoUekJOfjeOw=
=4S1j
-----END PGP SIGNATURE-----

--nextPart9460067.Em0Sdm2Yth--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
