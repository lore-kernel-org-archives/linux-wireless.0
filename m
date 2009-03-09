Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:56180 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZCIOrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 10:47:23 -0400
Received: by fxm24 with SMTP id 24so1269202fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 07:47:20 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Subject: [PATCH] mac80211: handle failed scan requests in STA mode
Date: Mon, 9 Mar 2009 15:47:08 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903091547.09223.helmut.schaa@gmail.com> (sfid-20090309_154728_331598_4C751C9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If cfg80211 requests a scan it awaits either a return code != 0 from
the scan function or the cfg80211_scan_done to be called. In case of
a STA mac80211's scan function ever returns 0 and queues the scan request.
If ieee80211_sta_work is executed and ieee80211_start_scan fails for
some reason cfg80211_scan_done will never be called but cfg80211 still
thinks the scan was triggered successfully and will refuse any future
scan requests due to drv->scan_req not being cleaned up.

If a scan is triggered from within the MLME a similar problem appears. If
ieee80211_start_scan returns an error, local->scan_req will not be reset
and mac80211 will refuse any future scan requests.

Hence, in both cases call ieee80211_scan_failed (which notifies cfg80211
and resets local->scan_req) if ieee80211_start_scan returns an error.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

It just happend to me that after rf-killing iwlwifi wpa_supplicant triggered
a scan (which was accepted by mac80211 as it is not rfkill aware yet) which
failed in iwlwifi and left cfg80211 in a state where it won't accept a new
scan request even after unkilling the radio again.

Johannes, do you think it is worth to add something like a scan watchdog that
triggers after 30 seconds to cfg80211 and prints "scan request failed", cancels
the scan request and notifies user space?

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ecbc8e0..fbb91f1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -972,6 +972,7 @@ int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata,
 			       char *ie, size_t len);
 
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local);
+void ieee80211_scan_failed(struct ieee80211_local *local);
 int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 			 struct cfg80211_scan_request *req);
 struct ieee80211_bss *
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index eeb6da8..6e92674 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1720,7 +1720,10 @@ static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data *sdata)
 				local->int_scan_req.ssids[0].ssid_len = 0;
 			else
 				local->int_scan_req.ssids[0].ssid_len = ifmgd->ssid_len;
-			ieee80211_start_scan(sdata, &local->int_scan_req);
+
+			if (ieee80211_start_scan(sdata, &local->int_scan_req))
+				ieee80211_scan_failed(local);
+
 			ifmgd->state = IEEE80211_STA_MLME_AUTHENTICATE;
 			set_bit(IEEE80211_STA_REQ_AUTH, &ifmgd->request);
 		} else {
@@ -1757,7 +1760,14 @@ static void ieee80211_sta_work(struct work_struct *work)
 	    ifmgd->state != IEEE80211_STA_MLME_AUTHENTICATE &&
 	    ifmgd->state != IEEE80211_STA_MLME_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request)) {
-		ieee80211_start_scan(sdata, local->scan_req);
+		/*
+		 * The call to ieee80211_start_scan can fail but ieee80211_request_scan 
+		 * (which queued ieee80211_sta_work) did not return an error. Thus, call
+		 * ieee80211_scan_failed here if ieee80211_start_scan fails in order to
+		 * notify the scan requester.
+		 */
+		if (ieee80211_start_scan(sdata, local->scan_req))
+			ieee80211_scan_failed(local);
 		return;
 	}
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 0e81e16..5030a3c 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -202,6 +202,18 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 	return RX_QUEUED;
 }
 
+void ieee80211_scan_failed(struct ieee80211_local *local)
+{
+	if (WARN_ON(!local->scan_req))
+		return;
+
+	/* notify cfg80211 about the failed scan */
+	if (local->scan_req != &local->int_scan_req)
+		cfg80211_scan_done(local->scan_req, true);
+
+	local->scan_req = NULL;
+}
+
 void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
