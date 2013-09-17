Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63110 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab3IQPll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 11:41:41 -0400
Received: by mail-ea0-f176.google.com with SMTP id q16so2821027ead.35
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2013 08:41:40 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 04/11] wlcore: re-enable idle handling
Date: Tue, 17 Sep 2013 18:41:23 +0300
Message-Id: <1379432490-22157-4-git-send-email-eliad@wizery.com> (sfid-20130917_174151_713439_D9D878B0)
In-Reply-To: <1379432490-22157-1-git-send-email-eliad@wizery.com>
References: <1379432490-22157-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

We need some stuff done on idle change, most notably we have to stop
sched-scanning. Take care of this by reintroducing idle handling.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c     | 22 ++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/wlcore_i.h |  1 +
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 611e81d..d952593 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2927,6 +2927,25 @@ static void wl1271_set_band_rate(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	wlvif->rate_set = wlvif->basic_rate_set;
 }
 
+static void wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				   bool idle)
+{
+	bool cur_idle = !test_bit(WLVIF_FLAG_ACTIVE, &wlvif->flags);
+
+	if (idle == cur_idle)
+		return;
+
+	if (idle) {
+		clear_bit(WLVIF_FLAG_ACTIVE, &wlvif->flags);
+	} else {
+		/* The current firmware only supports sched_scan in idle */
+		if (wl->sched_vif == wlvif)
+			wl->ops->sched_scan_stop(wl, wlvif);
+
+		set_bit(WLVIF_FLAG_ACTIVE, &wlvif->flags);
+	}
+}
+
 static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			     struct ieee80211_conf *conf, u32 changed)
 {
@@ -4179,6 +4198,9 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		do_join = true;
 	}
 
+	if (changed & BSS_CHANGED_IDLE && !is_ibss)
+		wl1271_sta_handle_idle(wl, wlvif, bss_conf->idle);
+
 	if (changed & BSS_CHANGED_CQM) {
 		bool enable = false;
 		if (bss_conf->cqm_rssi_thold)
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 3f4f08b..2a50e08 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -255,6 +255,7 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_CS_PROGRESS,
 	WLVIF_FLAG_AP_PROBE_RESP_SET,
 	WLVIF_FLAG_IN_USE,
+	WLVIF_FLAG_ACTIVE,
 };
 
 struct wl12xx_vif;
-- 
1.8.3.rc1.35.g9b79519

