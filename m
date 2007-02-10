Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:34247 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753028AbXBJE0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 23:26:08 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] d80211: Simplify channel & mode configuration
Date: Fri, 9 Feb 2007 23:25:31 -0500
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2073975.uxkRRxTBmB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702092325.39994.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2073975.uxkRRxTBmB
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

d80211: Simplify channel & mode configuration

This patch simplifies channel & mode setting while eliminating a race
between channel configuration and scanning. It also adds a call to
ieee80211_hw_config after ops->open.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/d80211/ieee80211.c       |   45 ++++++++++++++-------
 net/d80211/ieee80211_i.h     |    9 +---
 net/d80211/ieee80211_ioctl.c |   14 +++----
 net/d80211/ieee80211_sta.c   |   90 ++++++--------------------------------=
=2D---
 4 files changed, 51 insertions(+), 107 deletions(-)

diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 03d4028..c83520e 100644
=2D-- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -2005,8 +2005,24 @@ int ieee80211_if_config_beacon(struct ne
 int ieee80211_hw_config(struct ieee80211_local *local)
 {
 	struct ieee80211_hw_mode *mode;
+	struct ieee80211_channel *chan;
 	int ret =3D 0;
=20
+	if (local->sta_scanning) {
+		chan =3D local->scan_channel;
+		mode =3D local->scan_hw_mode;
+	} else {
+		chan =3D local->oper_channel;
+		mode =3D local->oper_hw_mode;
+	}
+
+	local->hw.conf.channel =3D chan->chan;
+	local->hw.conf.channel_val =3D chan->val;
+	local->hw.conf.power_level =3D chan->power_level;
+	local->hw.conf.freq =3D chan->freq;
+	local->hw.conf.phymode =3D mode->mode;
+	local->hw.conf.antenna_max =3D chan->antenna_max;
+
 #ifdef CONFIG_D80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "HW CONFIG: channel=3D%d freq=3D%d "
 	       "phymode=3D%d\n", local->hw.conf.channel, local->hw.conf.freq,
@@ -2016,16 +2032,11 @@ int ieee80211_hw_config(struct ieee80211
 	if (local->ops->config)
 		ret =3D local->ops->config(local_to_hw(local), &local->hw.conf);
=20
=2D	list_for_each_entry(mode, &local->modes_list, list) {
=2D		if (mode->mode =3D=3D local->hw.conf.phymode) {
=2D			if (local->curr_rates !=3D mode->rates)
=2D				rate_control_clear(local);
=2D			local->curr_rates =3D mode->rates;
=2D			local->num_curr_rates =3D mode->num_rates;
=2D			ieee80211_prepare_rates(local);
=2D			break;
=2D		}
=2D	}
+	if (local->curr_rates !=3D mode->rates)
+		rate_control_clear(local);
+	local->curr_rates =3D mode->rates;
+	local->num_curr_rates =3D mode->num_rates;
+	ieee80211_prepare_rates(local);
=20
 	return ret;
 }
@@ -2344,8 +2355,13 @@ static int ieee80211_open(struct net_dev
 			if (res) {
 				if (local->ops->stop)
 					local->ops->stop(local_to_hw(local));
=2D			} else if (local->apdev)
=2D				dev_open(local->apdev);
+			} else {
+				res =3D ieee80211_hw_config(local);
+				if (res && local->ops->stop)
+					local->ops->stop(local_to_hw(local));
+				else if (!res && local->apdev)
+					dev_open(local->apdev);
+			}
 		}
 		if (res) {
 			if (local->ops->remove_interface)
@@ -4711,12 +4727,11 @@ int ieee80211_register_hwmode(struct iee
 	if (!local->curr_rates) {
 		/* Default to this mode */
 		local->hw.conf.phymode =3D mode->mode;
+		local->oper_hw_mode =3D local->scan_hw_mode =3D mode;
+		local->oper_channel =3D local->scan_channel =3D &mode->channels[0];
 		local->curr_rates =3D mode->rates;
 		local->num_curr_rates =3D mode->num_rates;
 		ieee80211_prepare_rates(local);
=2D		local->hw.conf.freq =3D mode->channels[0].freq;
=2D		local->hw.conf.channel =3D mode->channels[0].chan;
=2D		local->hw.conf.channel_val =3D mode->channels[0].val;
 	}
=20
 	ieee80211_init_client(local->mdev);
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index 9307882..60d0a22 100644
=2D-- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -435,18 +435,13 @@ struct ieee80211_local {
         spinlock_t sub_if_lock; /* mutex for STA data structures */
         struct list_head sub_if_list;
 	int sta_scanning;
=2D	struct ieee80211_hw_mode *scan_hw_mode;
 	int scan_channel_idx;
 	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
 	unsigned long last_scan_completed;
 	struct delayed_work scan_work;
 	struct net_device *scan_dev;
=2D	int scan_oper_channel;
=2D	int scan_oper_channel_val;
=2D	int scan_oper_power_level;
=2D	int scan_oper_freq;
=2D	int scan_oper_phymode;
=2D	int scan_oper_antenna_max;
+	struct ieee80211_channel *oper_channel, *scan_channel;
+	struct ieee80211_hw_mode *oper_hw_mode, *scan_hw_mode;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
 	struct list_head sta_bss_list;
diff --git a/net/d80211/ieee80211_ioctl.c b/net/d80211/ieee80211_ioctl.c
index 35d73f7..c7300cb 100644
=2D-- a/net/d80211/ieee80211_ioctl.c
+++ b/net/d80211/ieee80211_ioctl.c
@@ -1828,20 +1828,18 @@ int ieee80211_ioctl_siwfreq(struct net_d
 				if (set && mode->mode !=3D local->next_mode)
 					continue;
=20
=2D				local->hw.conf.channel =3D chan->chan;
=2D				local->hw.conf.channel_val =3D chan->val;
=2D                                local->hw.conf.power_level =3D chan->pow=
er_level;
=2D				local->hw.conf.freq =3D chan->freq;
=2D				local->hw.conf.phymode =3D mode->mode;
=2D                                local->hw.conf.antenna_max =3D chan->ant=
enna_max;
+				local->oper_channel =3D chan;
+				local->oper_hw_mode =3D mode;
 				set++;
 			}
 		}
 	}
=20
 	if (set) {
=2D		local->sta_scanning =3D 0; /* Abort possible scan */
=2D		return ieee80211_hw_config(local);
+		if (local->sta_scanning)
+			return 0;
+		else
+			return ieee80211_hw_config(local);
 	}
=20
 	return -EINVAL;
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index 57e7fa7..ed231a5 100644
=2D-- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -1401,19 +1401,12 @@ static void ieee80211_rx_bss_info(struct
 		struct ieee80211_rate *rates;
 		size_t num_rates;
 		u32 supp_rates, prev_rates;
=2D		int i, j, oper_mode;
=2D
=2D		rates =3D local->curr_rates;
=2D		num_rates =3D local->num_curr_rates;
=2D		oper_mode =3D local->sta_scanning ? local->scan_oper_phymode :
=2D			local->hw.conf.phymode;
=2D		list_for_each_entry(mode, &local->modes_list, list) {
=2D			if (oper_mode =3D=3D mode->mode) {
=2D				rates =3D mode->rates;
=2D				num_rates =3D mode->num_rates;
=2D				break;
=2D			}
=2D		}
+		int i, j;
+
+		mode =3D local->sta_scanning ?
+		       local->scan_hw_mode : local->oper_hw_mode;
+		rates =3D mode->rates;
+		num_rates =3D mode->num_rates;
=20
 		supp_rates =3D 0;
 		for (i =3D 0; i < elems.supp_rates_len +
@@ -1426,7 +1419,7 @@ static void ieee80211_rx_bss_info(struct
 				rate =3D elems.ext_supp_rates
 					[i - elems.supp_rates_len];
 			own_rate =3D 5 * (rate & 0x7f);
=2D			if (oper_mode =3D=3D MODE_ATHEROS_TURBO)
+			if (mode->mode =3D=3D MODE_ATHEROS_TURBO)
 				own_rate *=3D 2;
 			for (j =3D 0; j < num_rates; j++)
 				if (rates[j].rate =3D=3D own_rate)
@@ -2445,54 +2438,6 @@ int ieee80211_sta_set_bssid(struct net_d
 }
=20
=20
=2Dstatic void ieee80211_sta_save_oper_chan(struct net_device *dev)
=2D{
=2D	struct ieee80211_local *local =3D dev->ieee80211_ptr;
=2D	local->scan_oper_channel =3D local->hw.conf.channel;
=2D	local->scan_oper_channel_val =3D local->hw.conf.channel_val;
=2D	local->scan_oper_power_level =3D local->hw.conf.power_level;
=2D	local->scan_oper_freq =3D local->hw.conf.freq;
=2D	local->scan_oper_phymode =3D local->hw.conf.phymode;
=2D	local->scan_oper_antenna_max =3D local->hw.conf.antenna_max;
=2D}
=2D
=2D
=2Dstatic int ieee80211_sta_restore_oper_chan(struct net_device *dev)
=2D{
=2D	struct ieee80211_local *local =3D dev->ieee80211_ptr;
=2D	local->hw.conf.channel =3D local->scan_oper_channel;
=2D	local->hw.conf.channel_val =3D local->scan_oper_channel_val;
=2D	local->hw.conf.power_level =3D local->scan_oper_power_level;
=2D	local->hw.conf.freq =3D local->scan_oper_freq;
=2D	local->hw.conf.phymode =3D local->scan_oper_phymode;
=2D	local->hw.conf.antenna_max =3D local->scan_oper_antenna_max;
=2D	return ieee80211_hw_config(local);
=2D}
=2D
=2D
=2Dstatic int ieee80211_active_scan(struct ieee80211_local *local)
=2D{
=2D	struct ieee80211_hw_mode *mode;
=2D	int c;
=2D
=2D	list_for_each_entry(mode, &local->modes_list, list) {
=2D		if (mode->mode !=3D local->hw.conf.phymode)
=2D			continue;
=2D		for (c =3D 0; c < mode->num_channels; c++) {
=2D			struct ieee80211_channel *chan =3D &mode->channels[c];
=2D			if (chan->flag & IEEE80211_CHAN_W_SCAN &&
=2D			    chan->chan =3D=3D local->hw.conf.channel) {
=2D				if (chan->flag & IEEE80211_CHAN_W_ACTIVE_SCAN)
=2D					return 1;
=2D				break;
=2D			}
=2D		}
=2D	}
=2D
=2D	return 0;
=2D}
=2D
=2D
 void ieee80211_scan_completed(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local =3D hw_to_local(hw);
@@ -2505,6 +2450,10 @@ void ieee80211_scan_completed(struct iee
 	wmb();
 	local->sta_scanning =3D 0;
=20
+	if (ieee80211_hw_config(local))
+		printk(KERN_DEBUG "%s: failed to restore operational"
+		       "channel after scan\n", dev->name);
+
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
=20
@@ -2539,12 +2488,6 @@ void ieee80211_sta_scan_work(struct work
 		mode =3D local->scan_hw_mode;
 		if (local->scan_hw_mode->list.next =3D=3D &local->modes_list &&
 		    local->scan_channel_idx >=3D mode->num_channels) {
=2D			if (ieee80211_sta_restore_oper_chan(dev)) {
=2D				printk(KERN_DEBUG "%s: failed to restore "
=2D				       "operational channel after scan\n",
=2D				       dev->name);
=2D			}
=2D
 			ieee80211_scan_completed(local_to_hw(local));
 			return;
 		}
@@ -2563,12 +2506,7 @@ void ieee80211_sta_scan_work(struct work
 			       dev->name, chan->chan, chan->freq);
 #endif
=20
=2D			local->hw.conf.channel =3D chan->chan;
=2D			local->hw.conf.channel_val =3D chan->val;
=2D			local->hw.conf.power_level =3D chan->power_level;
=2D			local->hw.conf.freq =3D chan->freq;
=2D			local->hw.conf.phymode =3D mode->mode;
=2D			local->hw.conf.antenna_max =3D chan->antenna_max;
+			local->scan_channel =3D chan;
 			if (ieee80211_hw_config(local)) {
 				printk(KERN_DEBUG "%s: failed to set channel "
 				       "%d (%d MHz) for scan\n", dev->name,
@@ -2595,7 +2533,7 @@ void ieee80211_sta_scan_work(struct work
 		local->scan_state =3D SCAN_SEND_PROBE;
 		break;
 	case SCAN_SEND_PROBE:
=2D		if (ieee80211_active_scan(local)) {
+		if (local->scan_channel->flag & IEEE80211_CHAN_W_ACTIVE_SCAN) {
 			ieee80211_send_probe_req(dev, NULL, local->scan_ssid,
 						 local->scan_ssid_len);
 			next_delay =3D IEEE80211_CHANNEL_TIME;
@@ -2656,8 +2594,6 @@ static int ieee80211_sta_start_scan(stru
 		return rc;
 	}
=20
=2D	ieee80211_sta_save_oper_chan(dev);
=2D
 	local->sta_scanning =3D 1;
 	/* TODO: stop TX queue? */
=20

--nextPart2073975.uxkRRxTBmB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFzUlDT3Oqt9AH4aERAkTPAJ9gCkuQlGNYbLdLmwHM46UbpCuzSwCfRknj
kkv8fu87IcJa/JHCv/J5lrE=
=OZ0Y
-----END PGP SIGNATURE-----

--nextPart2073975.uxkRRxTBmB--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
