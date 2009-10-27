Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767AbZJ0UAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 16:00:20 -0400
Subject: [PATCH 2.6.32] mac80211: split hardware scan by band
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 20:59:55 +0100
Message-ID: <1256673595.4237.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's currently a very odd bug in mac80211 -- a
hardware scan that is done while the hardware is
really operating on 2.4 GHz will include CCK rates
in the probe request frame, even on 5 GHz (if the
driver uses the mac80211 IEs). Vice versa, if the
hardware is operating on 5 GHz the 2.4 GHz probe
requests will not include CCK rates even though
they should.

Fix this by splitting up cfg80211 scan requests by
band -- recalculating the IEs every time -- and
requesting only per-band scans from the driver.

Apparently this bug hasn't been a problem yet, but
it is imaginable that some older access points get
confused if confronted with such behaviour.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    8 +--
 net/mac80211/scan.c        |   96 +++++++++++++++++++++++++++++++++------------
 net/mac80211/util.c        |    8 ++-
 3 files changed, 80 insertions(+), 32 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-10-27 20:53:00.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-10-27 20:54:01.000000000 +0100
@@ -667,10 +667,9 @@ struct ieee80211_local {
 	unsigned long scanning;
 	struct cfg80211_ssid scan_ssid;
 	struct cfg80211_scan_request *int_scan_req;
-	struct cfg80211_scan_request *scan_req;
+	struct cfg80211_scan_request *scan_req, *hw_scan_req;
 	struct ieee80211_channel *scan_channel;
-	const u8 *orig_ies;
-	int orig_ies_len;
+	enum ieee80211_band hw_scan_band;
 	int scan_channel_idx;
 	int scan_ies_len;
 
@@ -1050,7 +1049,8 @@ void ieee80211_send_auth(struct ieee8021
 			 u8 *extra, size_t extra_len, const u8 *bssid,
 			 const u8 *key, u8 key_len, u8 key_idx);
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
-			     const u8 *ie, size_t ie_len);
+			     const u8 *ie, size_t ie_len,
+			     enum ieee80211_band band);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len);
--- wireless-testing.orig/net/mac80211/scan.c	2009-10-27 20:53:00.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-10-27 20:54:01.000000000 +0100
@@ -187,6 +187,39 @@ ieee80211_scan_rx(struct ieee80211_sub_i
 	return RX_QUEUED;
 }
 
+/* return false if no more work */
+static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
+{
+	struct cfg80211_scan_request *req = local->scan_req;
+	enum ieee80211_band band;
+	int i, ielen, n_chans;
+
+	do {
+		if (local->hw_scan_band == IEEE80211_NUM_BANDS)
+			return false;
+
+		band = local->hw_scan_band;
+		n_chans = 0;
+		for (i = 0; i < req->n_channels; i++) {
+			if (req->channels[i]->band == band) {
+				local->hw_scan_req->channels[n_chans] =
+							req->channels[i];
+				n_chans++;
+			}
+		}
+
+		local->hw_scan_band++;
+	} while (!n_chans);
+
+	local->hw_scan_req->n_channels = n_chans;
+
+	ielen = ieee80211_build_preq_ies(local, (u8 *)local->hw_scan_req->ie,
+					 req->ie, req->ie_len, band);
+	local->hw_scan_req->ie_len = ielen;
+
+	return true;
+}
+
 /*
  * inform AP that we will go to sleep so that it will buffer the frames
  * while we scan
@@ -247,13 +280,6 @@ static void ieee80211_scan_ps_disable(st
 	}
 }
 
-static void ieee80211_restore_scan_ies(struct ieee80211_local *local)
-{
-	kfree(local->scan_req->ie);
-	local->scan_req->ie = local->orig_ies;
-	local->scan_req->ie_len = local->orig_ies_len;
-}
-
 void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -272,15 +298,22 @@ void ieee80211_scan_completed(struct iee
 		return;
 	}
 
-	if (test_bit(SCAN_HW_SCANNING, &local->scanning))
-		ieee80211_restore_scan_ies(local);
+	was_hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
+	if (was_hw_scan && !aborted && ieee80211_prep_hw_scan(local)) {
+		ieee80211_queue_delayed_work(&local->hw,
+					     &local->scan_work, 0);
+		mutex_unlock(&local->scan_mtx);
+		return;
+	}
+
+	kfree(local->hw_scan_req);
+	local->hw_scan_req = NULL;
 
 	if (local->scan_req != local->int_scan_req)
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
 	local->scan_sdata = NULL;
 
-	was_hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
 	local->scanning = 0;
 	local->scan_channel = NULL;
 
@@ -392,19 +425,23 @@ static int __ieee80211_start_scan(struct
 
 	if (local->ops->hw_scan) {
 		u8 *ies;
-		int ielen;
 
-		ies = kmalloc(2 + IEEE80211_MAX_SSID_LEN +
-			      local->scan_ies_len + req->ie_len, GFP_KERNEL);
-		if (!ies)
+		local->hw_scan_req = kmalloc(
+				sizeof(*local->hw_scan_req) +
+				req->n_channels * sizeof(req->channels[0]) +
+				2 + IEEE80211_MAX_SSID_LEN + local->scan_ies_len +
+				req->ie_len, GFP_KERNEL);
+		if (!local->hw_scan_req)
 			return -ENOMEM;
 
-		ielen = ieee80211_build_preq_ies(local, ies,
-						 req->ie, req->ie_len);
-		local->orig_ies = req->ie;
-		local->orig_ies_len = req->ie_len;
-		req->ie = ies;
-		req->ie_len = ielen;
+		local->hw_scan_req->ssids = req->ssids;
+		local->hw_scan_req->n_ssids = req->n_ssids;
+		ies = (u8 *)local->hw_scan_req +
+			sizeof(*local->hw_scan_req) +
+			req->n_channels * sizeof(req->channels[0]);
+		local->hw_scan_req->ie = ies;
+
+		local->hw_scan_band = 0;
 	}
 
 	local->scan_req = req;
@@ -436,16 +473,17 @@ static int __ieee80211_start_scan(struct
 	ieee80211_recalc_idle(local);
 	mutex_unlock(&local->scan_mtx);
 
-	if (local->ops->hw_scan)
-		rc = drv_hw_scan(local, local->scan_req);
-	else
+	if (local->ops->hw_scan) {
+		WARN_ON(!ieee80211_prep_hw_scan(local));
+		rc = drv_hw_scan(local, local->hw_scan_req);
+	} else
 		rc = ieee80211_start_sw_scan(local);
 
 	mutex_lock(&local->scan_mtx);
 
 	if (rc) {
-		if (local->ops->hw_scan)
-			ieee80211_restore_scan_ies(local);
+		kfree(local->hw_scan_req);
+		local->hw_scan_req = NULL;
 		local->scanning = 0;
 
 		ieee80211_recalc_idle(local);
@@ -654,6 +692,14 @@ void ieee80211_scan_work(struct work_str
 		return;
 	}
 
+	if (local->hw_scan_req) {
+		int rc = drv_hw_scan(local, local->hw_scan_req);
+		mutex_unlock(&local->scan_mtx);
+		if (rc)
+			ieee80211_scan_completed(&local->hw, true);
+		return;
+	}
+
 	if (local->scan_req && !local->scanning) {
 		struct cfg80211_scan_request *req = local->scan_req;
 		int rc;
--- wireless-testing.orig/net/mac80211/util.c	2009-10-27 20:53:00.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-10-27 20:54:01.000000000 +0100
@@ -872,13 +872,14 @@ void ieee80211_send_auth(struct ieee8021
 }
 
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
-			     const u8 *ie, size_t ie_len)
+			     const u8 *ie, size_t ie_len,
+			     enum ieee80211_band band)
 {
 	struct ieee80211_supported_band *sband;
 	u8 *pos, *supp_rates_len, *esupp_rates_len = NULL;
 	int i;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[band];
 
 	pos = buffer;
 
@@ -966,7 +967,8 @@ void ieee80211_send_probe_req(struct iee
 	memcpy(pos, ssid, ssid_len);
 	pos += ssid_len;
 
-	skb_put(skb, ieee80211_build_preq_ies(local, pos, ie, ie_len));
+	skb_put(skb, ieee80211_build_preq_ies(local, pos, ie, ie_len,
+					      local->hw.conf.channel->band));
 
 	ieee80211_tx_skb(sdata, skb, 0);
 }


