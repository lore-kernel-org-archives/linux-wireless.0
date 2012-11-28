Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36268 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2K1Jn1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:27 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so4384742wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:26 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 16/20] wlcore: consolidate Rx BA bitmap management to links struct
Date: Wed, 28 Nov 2012 11:42:45 +0200
Message-Id: <1354095769-8724-17-git-send-email-arik@wizery.com> (sfid-20121128_104333_246226_E7D5806A)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the STA specific ba_rx_bitmap field and use the common links
structure. This simplifies code setting/checking the BA bitmap.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c  |    1 -
 drivers/net/wireless/ti/wlcore/event.c    |    5 +++--
 drivers/net/wireless/ti/wlcore/main.c     |    4 ++--
 drivers/net/wireless/ti/wlcore/tx.c       |    1 -
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    1 -
 5 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index f115fba..e70a7c8 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -560,7 +560,6 @@ static ssize_t vifs_state_read(struct file *file, char __user *user_buf,
 		if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
 		    wlvif->bss_type == BSS_TYPE_IBSS) {
 			VIF_STATE_PRINT_INT(sta.hlid);
-			VIF_STATE_PRINT_INT(sta.ba_rx_bitmap);
 			VIF_STATE_PRINT_INT(sta.basic_rate_idx);
 			VIF_STATE_PRINT_INT(sta.ap_rate_idx);
 			VIF_STATE_PRINT_INT(sta.p2p_rate_idx);
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index cb32c02..2776d95 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -58,9 +58,10 @@ static void wl1271_stop_ba_event(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 
 	if (wlvif->bss_type != BSS_TYPE_AP_BSS) {
-		if (!wlvif->sta.ba_rx_bitmap)
+		u8 hlid = wlvif->sta.hlid;
+		if (!wl->links[hlid].ba_bitmap)
 			return;
-		ieee80211_stop_rx_ba_session(vif, wlvif->sta.ba_rx_bitmap,
+		ieee80211_stop_rx_ba_session(vif, wl->links[hlid].ba_bitmap,
 					     vif->bss_conf.bssid);
 	} else {
 		u8 hlid;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3ffbba3..1793a82 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4793,18 +4793,18 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 
 	if (wlvif->bss_type == BSS_TYPE_STA_BSS) {
 		hlid = wlvif->sta.hlid;
-		ba_bitmap = &wlvif->sta.ba_rx_bitmap;
 	} else if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
 		struct wl1271_station *wl_sta;
 
 		wl_sta = (struct wl1271_station *)sta->drv_priv;
 		hlid = wl_sta->hlid;
-		ba_bitmap = &wl->links[hlid].ba_bitmap;
 	} else {
 		ret = -EINVAL;
 		goto out;
 	}
 
+	ba_bitmap = &wl->links[hlid].ba_bitmap;
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index bbfa14a..07bd1f4 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -1061,7 +1061,6 @@ void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 			wl1271_free_sta(wl, wlvif, i);
 		} else {
 			u8 hlid = i;
-			wlvif->sta.ba_rx_bitmap = 0;
 			wl12xx_free_link(wl, wlvif, &hlid);
 		}
 	}
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 99b19e2..d9313a3 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -342,7 +342,6 @@ struct wl12xx_vif {
 	union {
 		struct {
 			u8 hlid;
-			u8 ba_rx_bitmap;
 
 			u8 basic_rate_idx;
 			u8 ap_rate_idx;
-- 
1.7.9.5

