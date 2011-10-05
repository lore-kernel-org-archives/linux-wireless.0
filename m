Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48103 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218Ab1JEJ4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:02 -0400
Received: by gyg10 with SMTP id 10so1387199gyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:02 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/29] wl12xx: move probereq into wlvif
Date: Wed,  5 Oct 2011 11:55:49 +0200
Message-Id: <1317808566-18857-13-git-send-email-eliad@wizery.com> (sfid-20111005_115605_462990_A46B3CF4)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move probereq into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   11 ++++++-----
 drivers/net/wireless/wl12xx/scan.c   |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    6 +++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c8acd33..3686109 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3520,11 +3520,12 @@ sta_not_found:
 			/*
 			 * Get a template for hardware connection maintenance
 			 */
-			dev_kfree_skb(wl->probereq);
-			wl->probereq = wl1271_cmd_build_ap_probe_req(wl, NULL);
+			dev_kfree_skb(wlvif->probereq);
+			wlvif->probereq = wl1271_cmd_build_ap_probe_req(wl,
+									NULL);
 			ieoffset = offsetof(struct ieee80211_mgmt,
 					    u.probe_req.variable);
-			wl1271_ssid_set(vif, wl->probereq, ieoffset);
+			wl1271_ssid_set(vif, wlvif->probereq, ieoffset);
 
 			/* enable the connection monitoring feature */
 			ret = wl1271_acx_conn_monit_params(wl, true);
@@ -3541,8 +3542,8 @@ sta_not_found:
 			wl->aid = 0;
 
 			/* free probe-request template */
-			dev_kfree_skb(wl->probereq);
-			wl->probereq = NULL;
+			dev_kfree_skb(wlvif->probereq);
+			wlvif->probereq = NULL;
 
 			/* re-enable dynamic ps - just in case */
 			ieee80211_enable_dyn_ps(wl->vif);
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 197d2c2..e3b863b 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -64,7 +64,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
 		/* restore hardware connection monitoring template */
-		wl1271_cmd_build_ap_probe_req(wl, wl->probereq);
+		wl1271_cmd_build_ap_probe_req(wl, wlvif->probereq);
 	}
 
 	/* return to ROC if needed */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index df24500..81d3839 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -506,9 +506,6 @@ struct wl1271 {
 
 	bool sched_scanning;
 
-	/* probe-req template for the current AP */
-	struct sk_buff *probereq;
-
 	/* Our association ID */
 	u16 aid;
 
@@ -640,6 +637,9 @@ struct wl12xx_vif {
 	 */
 	u32 basic_rate;
 	u32 rate_set;
+
+	/* probe-req template for the current AP */
+	struct sk_buff *probereq;
 };
 
 static inline struct wl12xx_vif *wl12xx_vif_to_data(struct ieee80211_vif *vif)
-- 
1.7.6.401.g6a319

