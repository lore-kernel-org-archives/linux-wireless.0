Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:55510 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763160AbXKIPWZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 10:22:25 -0500
From: Helmut Schaa <hschaa@suse.de>
To: linville@tuxdriver.com
Subject: [PATCH 1/2] mac80211: Fix queuing of scan containing a SSID
Date: Fri, 9 Nov 2007 16:25:08 +0100
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <200711091622.16671.hschaa@suse.de>
In-Reply-To: <200711091622.16671.hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711091625.08261.hschaa@suse.de> (sfid-20071109_152250_451310_5B6891D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes scanning for specific ssid's which is broken due to the 
scan being queued up without respecting the ssid to scan for.

Signed-off-by: Helmut Schaa <hschaa@suse.de>
Signed-off-by: Jiri Benc <jbenc@suse.cz>
---
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4b4ed2a..d575ccd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -241,6 +241,8 @@ struct ieee80211_if_sta {
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
+	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
+	size_t scan_ssid_len;
 	u16 aid;
 	u16 ap_capab, capab;
 	u8 *extra_ie; /* to be added to the end of AssocReq */
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index f7ffeec..0b47328 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1998,7 +1998,10 @@ void ieee80211_sta_work(struct work_struct *work)
 	if (ifsta->state != IEEE80211_AUTHENTICATE &&
 	    ifsta->state != IEEE80211_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
-		ieee80211_sta_start_scan(dev, NULL, 0);
+ 		if (ifsta->scan_ssid_len)
+ 			ieee80211_sta_start_scan(dev, ifsta->scan_ssid, ifsta->scan_ssid_len);
+ 		else
+ 			ieee80211_sta_start_scan(dev, NULL, 0);
 		return;
 	}
 
@@ -2867,6 +2870,9 @@ int ieee80211_sta_req_scan(struct net_device *dev, u8 
*ssid, size_t ssid_len)
 		return -EBUSY;
 	}
 
+	ifsta->scan_ssid_len = ssid_len;
+	if (ssid_len)
+		memcpy(ifsta->scan_ssid, ssid, ssid_len);
 	set_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request);
 	queue_work(local->hw.workqueue, &ifsta->work);
 	return 0;
