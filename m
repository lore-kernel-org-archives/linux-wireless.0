Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0101.outbound.protection.outlook.com ([104.47.0.101]:62008
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752141AbeB0L1s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 06:27:48 -0500
From: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: inform wireless layer when frame RSSI is invalid
Date: Tue, 27 Feb 2018 11:27:44 +0000
Message-ID: <AM4PR0101MB2305A017789378709138D53EE4C00@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> (sfid-20180227_122753_965751_A9D6FBE9)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the low-level driver returns an invalid RSSI indication,
set the signal value to 0 as an indication to the upper layer.

Also, skip average level computation if signal is invalid.

Signed-off-by: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
---
V2:
Move the beacon rssi processing to a helper function which is
called conditionally, instead of jumping over the code with a goto
(this makes the code smarter but the patch is much harder to grasp :-)

WARNING:
This patch applies to wireless-testing retrieved on Feb 26, 2018
but it was tested on a much older version (OpenWrt kernel 3.18 with
compat-wireless-2015-07-21).

 net/mac80211/mlme.c |  159 +++++++++++++++++++++++++++--------------------=
----
 net/mac80211/rx.c   |    6 +-
 net/mac80211/scan.c |    4 +-
 3 files changed, 92 insertions(+), 77 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0024eff..8cb1710 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3306,82 +3306,14 @@ static void ieee80211_rx_mgmt_probe_resp(struct iee=
e80211_sub_if_data *sdata,
 	(1ULL << WLAN_EID_HT_OPERATION) |
 	(1ULL << WLAN_EID_EXT_CHANSWITCH_ANN);
=20
-static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_mgmt *mgmt, size_t len,
-				     struct ieee80211_rx_status *rx_status)
+static void ieee80211_handle_beacon_signal(struct ieee80211_sub_if_data *s=
data,
+					struct ieee80211_if_managed *ifmgd,
+					struct ieee80211_bss_conf *bss_conf,
+					struct ieee80211_local *local,
+					struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
-	struct ieee80211_bss_conf *bss_conf =3D &sdata->vif.bss_conf;
-	size_t baselen;
-	struct ieee802_11_elems elems;
-	struct ieee80211_local *local =3D sdata->local;
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_channel *chan;
-	struct sta_info *sta;
-	u32 changed =3D 0;
-	bool erp_valid;
-	u8 erp_value =3D 0;
-	u32 ncrc;
-	u8 *bssid;
-	u8 deauth_buf[IEEE80211_DEAUTH_FRAME_LEN];
-
-	sdata_assert_lock(sdata);
-
-	/* Process beacon from the current BSS */
-	baselen =3D (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
-	if (baselen > len)
-		return;
-
-	rcu_read_lock();
-	chanctx_conf =3D rcu_dereference(sdata->vif.chanctx_conf);
-	if (!chanctx_conf) {
-		rcu_read_unlock();
-		return;
-	}
-
-	if (rx_status->freq !=3D chanctx_conf->def.chan->center_freq) {
-		rcu_read_unlock();
-		return;
-	}
-	chan =3D chanctx_conf->def.chan;
-	rcu_read_unlock();
-
-	if (ifmgd->assoc_data && ifmgd->assoc_data->need_beacon &&
-	    ether_addr_equal(mgmt->bssid, ifmgd->assoc_data->bss->bssid)) {
-		ieee802_11_parse_elems(mgmt->u.beacon.variable,
-				       len - baselen, false, &elems);
-
-		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
-		if (elems.tim && !elems.parse_error) {
-			const struct ieee80211_tim_ie *tim_ie =3D elems.tim;
-			ifmgd->dtim_period =3D tim_ie->dtim_period;
-		}
-		ifmgd->have_beacon =3D true;
-		ifmgd->assoc_data->need_beacon =3D false;
-		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
-			sdata->vif.bss_conf.sync_tsf =3D
-				le64_to_cpu(mgmt->u.beacon.timestamp);
-			sdata->vif.bss_conf.sync_device_ts =3D
-				rx_status->device_timestamp;
-			if (elems.tim)
-				sdata->vif.bss_conf.sync_dtim_count =3D
-					elems.tim->dtim_count;
-			else
-				sdata->vif.bss_conf.sync_dtim_count =3D 0;
-		}
-		/* continue assoc process */
-		ifmgd->assoc_data->timeout =3D jiffies;
-		ifmgd->assoc_data->timeout_started =3D true;
-		run_again(sdata, ifmgd->assoc_data->timeout);
-		return;
-	}
-
-	if (!ifmgd->associated ||
-	    !ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
-		return;
-	bssid =3D ifmgd->associated->bssid;
-
 	/* Track average RSSI from the Beacon frames of the current AP */
+
 	if (ifmgd->flags & IEEE80211_STA_RESET_SIGNAL_AVE) {
 		ifmgd->flags &=3D ~IEEE80211_STA_RESET_SIGNAL_AVE;
 		ewma_beacon_signal_init(&ifmgd->ave_beacon_signal);
@@ -3468,6 +3400,85 @@ static void ieee80211_rx_mgmt_beacon(struct ieee8021=
1_sub_if_data *sdata,
 				sig, GFP_KERNEL);
 		}
 	}
+}
+
+static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_mgmt *mgmt, size_t len,
+				     struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_if_managed *ifmgd =3D &sdata->u.mgd;
+	struct ieee80211_bss_conf *bss_conf =3D &sdata->vif.bss_conf;
+	size_t baselen;
+	struct ieee802_11_elems elems;
+	struct ieee80211_local *local =3D sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *chan;
+	struct sta_info *sta;
+	u32 changed =3D 0;
+	bool erp_valid;
+	u8 erp_value =3D 0;
+	u32 ncrc;
+	u8 *bssid;
+	u8 deauth_buf[IEEE80211_DEAUTH_FRAME_LEN];
+
+	sdata_assert_lock(sdata);
+
+	/* Process beacon from the current BSS */
+	baselen =3D (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
+	if (baselen > len)
+		return;
+
+	rcu_read_lock();
+	chanctx_conf =3D rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf) {
+		rcu_read_unlock();
+		return;
+	}
+
+	if (rx_status->freq !=3D chanctx_conf->def.chan->center_freq) {
+		rcu_read_unlock();
+		return;
+	}
+	chan =3D chanctx_conf->def.chan;
+	rcu_read_unlock();
+
+	if (ifmgd->assoc_data && ifmgd->assoc_data->need_beacon &&
+	    ether_addr_equal(mgmt->bssid, ifmgd->assoc_data->bss->bssid)) {
+		ieee802_11_parse_elems(mgmt->u.beacon.variable,
+				       len - baselen, false, &elems);
+
+		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
+		if (elems.tim && !elems.parse_error) {
+			const struct ieee80211_tim_ie *tim_ie =3D elems.tim;
+			ifmgd->dtim_period =3D tim_ie->dtim_period;
+		}
+		ifmgd->have_beacon =3D true;
+		ifmgd->assoc_data->need_beacon =3D false;
+		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
+			sdata->vif.bss_conf.sync_tsf =3D
+				le64_to_cpu(mgmt->u.beacon.timestamp);
+			sdata->vif.bss_conf.sync_device_ts =3D
+				rx_status->device_timestamp;
+			if (elems.tim)
+				sdata->vif.bss_conf.sync_dtim_count =3D
+					elems.tim->dtim_count;
+			else
+				sdata->vif.bss_conf.sync_dtim_count =3D 0;
+		}
+		/* continue assoc process */
+		ifmgd->assoc_data->timeout =3D jiffies;
+		ifmgd->assoc_data->timeout_started =3D true;
+		run_again(sdata, ifmgd->assoc_data->timeout);
+		return;
+	}
+
+	if (!ifmgd->associated ||
+	    !ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
+		return;
+	bssid =3D ifmgd->associated->bssid;
+
+	if (!(rx_status->flag & RX_FLAG_NO_SIGNAL_VAL))
+		ieee80211_handle_beacon_signal(sdata, ifmgd, bss_conf, local, rx_status)=
;
=20
 	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL) {
 		mlme_dbg_ratelimited(sdata,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5be957a..0afb8ce 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2793,7 +2793,8 @@ static void ieee80211_process_sa_query_req(struct iee=
e80211_sub_if_data *sdata,
 	    !(rx->flags & IEEE80211_RX_BEACON_REPORTED)) {
 		int sig =3D 0;
=20
-		if (ieee80211_hw_check(&rx->local->hw, SIGNAL_DBM))
+		if (ieee80211_hw_check(&rx->local->hw, SIGNAL_DBM) &&
+		    !(status->flag & RX_FLAG_NO_SIGNAL_VAL))
 			sig =3D status->signal;
=20
 		cfg80211_report_obss_beacon(rx->local->hw.wiphy,
@@ -3134,7 +3135,8 @@ static void ieee80211_process_sa_query_req(struct iee=
e80211_sub_if_data *sdata,
 	 * it transmitted were processed or returned.
 	 */
=20
-	if (ieee80211_hw_check(&rx->local->hw, SIGNAL_DBM))
+	if (ieee80211_hw_check(&rx->local->hw, SIGNAL_DBM) &&
+	    !(status->flag & RX_FLAG_NO_SIGNAL_VAL))
 		sig =3D status->signal;
=20
 	if (cfg80211_rx_mgmt(&rx->sdata->wdev, status->freq, sig,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index ef2beca..a3b1bcc 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -73,7 +73,9 @@ struct ieee80211_bss *
 	bool signal_valid;
 	struct ieee80211_sub_if_data *scan_sdata;
=20
-	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM))
+	if (rx_status->flag & RX_FLAG_NO_SIGNAL_VAL)
+		bss_meta.signal =3D 0; /* invalid signal indication */
+	else if (ieee80211_hw_check(&local->hw, SIGNAL_DBM))
 		bss_meta.signal =3D rx_status->signal * 100;
 	else if (ieee80211_hw_check(&local->hw, SIGNAL_UNSPEC))
 		bss_meta.signal =3D (rx_status->signal * 100) / local->hw.max_signal;
--=20
1.7.2.5
