Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1JJIM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:58 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:58 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/29] wl12xx: make WL1271_FLAG_IBSS_JOINED flag per-vif
Date: Mon, 10 Oct 2011 10:13:01 +0200
Message-Id: <1318234397-21081-14-git-send-email-eliad@wizery.com> (sfid-20111010_101303_012740_10951E4B)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag should be set per-vif, rather than globally.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    6 +++---
 drivers/net/wireless/wl12xx/scan.c   |    2 +-
 drivers/net/wireless/wl12xx/tx.c     |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6e67cbf..092b3b5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3484,11 +3484,11 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 
 	if (changed & BSS_CHANGED_IBSS) {
 		if (bss_conf->ibss_joined) {
-			set_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags);
+			set_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags);
 			ibss_joined = true;
 		} else {
-			if (test_and_clear_bit(WL1271_FLAG_IBSS_JOINED,
-					       &wl->flags)) {
+			if (test_and_clear_bit(WLVIF_FLAG_IBSS_JOINED,
+					       &wlvif->flags)) {
 				wl1271_unjoin(wl, wlvif);
 				wl12xx_cmd_role_start_dev(wl, wlvif);
 				wl12xx_roc(wl, wlvif->dev_role_id);
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 687f59b..765f08b 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -73,7 +73,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	is_sta = (wlvif->bss_type == BSS_TYPE_STA_BSS);
 	is_ibss = (wlvif->bss_type == BSS_TYPE_IBSS);
 	if (((is_sta && !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) ||
-	     (is_ibss && !test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags))) &&
+	     (is_ibss && !test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags))) &&
 	    !test_bit(wlvif->dev_role_id, wl->roc_map)) {
 		/* restore remain on channel */
 		wl12xx_cmd_role_start_dev(wl, wlvif);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index f37444c..5ad4173 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -193,7 +193,7 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	wl1271_tx_update_filters(wl, wlvif, skb);
 
 	if ((test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
-	     test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags)) &&
+	     test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags)) &&
 	    !ieee80211_is_auth(hdr->frame_control) &&
 	    !ieee80211_is_assoc_req(hdr->frame_control))
 		return wlvif->sta.hlid;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 400dd17..aa198a6 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -313,7 +313,6 @@ struct wl1271_ap_key {
 };
 
 enum wl12xx_flags {
-	WL1271_FLAG_IBSS_JOINED,
 	WL1271_FLAG_GPIO_POWER,
 	WL1271_FLAG_TX_QUEUE_STOPPED,
 	WL1271_FLAG_TX_PENDING,
@@ -339,6 +338,7 @@ enum wl12xx_flags {
 
 enum wl12xx_vif_flags {
 	WLVIF_FLAG_STA_ASSOCIATED,
+	WLVIF_FLAG_IBSS_JOINED,
 };
 
 struct wl1271_link {
-- 
1.7.6.401.g6a319

