Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54982 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1JJIN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:27 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so5615227wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:27 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 29/29] wl12xx: use round-robin policy for tx
Date: Mon, 10 Oct 2011 10:13:17 +0200
Message-Id: <1318234397-21081-30-git-send-email-eliad@wizery.com> (sfid-20111010_101334_192119_6BA02998)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, a single vif might starve all the other vifs.
Save the last vif we dequeued a packet from, and continue
with the following one using a round-robin policy.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    2 ++
 drivers/net/wireless/wl12xx/tx.c     |   26 ++++++++++++++++++++------
 drivers/net/wireless/wl12xx/wl12xx.h |    6 ++++++
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index e5edf64..e1d33b2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2277,6 +2277,8 @@ deinit:
 
 	wl12xx_tx_reset_wlvif(wl, wlvif);
 	wl1271_free_ap_keys(wl, wlvif);
+	if (wl->last_wlvif == wlvif)
+		wl->last_wlvif = NULL;
 	list_del(&wlvif->list);
 	memset(wlvif->ap.sta_hlid_map, 0, sizeof(wlvif->ap.sta_hlid_map));
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index f434331..05968c6 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -590,14 +590,28 @@ static struct sk_buff *wl12xx_vif_skb_dequeue(struct wl1271 *wl,
 static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 {
 	unsigned long flags;
-	struct wl12xx_vif *wlvif;
+	struct wl12xx_vif *wlvif = wl->last_wlvif;
 	struct sk_buff *skb = NULL;
 
-	/* TODO: rememeber last vif and consider it */
-	wl12xx_for_each_wlvif(wl, wlvif) {
-		skb = wl12xx_vif_skb_dequeue(wl, wlvif);
-		if (skb)
-			break;
+	if (wlvif) {
+		wl12xx_for_each_wlvif_continue(wl, wlvif) {
+			skb = wl12xx_vif_skb_dequeue(wl, wlvif);
+			if (skb) {
+				wl->last_wlvif = wlvif;
+				break;
+			}
+		}
+	}
+
+	/* do another pass */
+	if (!skb) {
+		wl12xx_for_each_wlvif(wl, wlvif) {
+			skb = wl12xx_vif_skb_dequeue(wl, wlvif);
+			if (skb) {
+				wl->last_wlvif = wlvif;
+				break;
+			}
+		}
 	}
 
 	if (!skb &&
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 3673994..94b24c2 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -549,6 +549,9 @@ struct wl1271 {
 
 	/* AP-mode - number of currently connected stations */
 	int active_sta_count;
+
+	/* last wlvif we transmitted from */
+	struct wl12xx_vif *last_wlvif;
 };
 
 struct wl1271_station {
@@ -690,6 +693,9 @@ struct ieee80211_vif *wl12xx_wlvif_to_vif(struct wl12xx_vif *wlvif)
 #define wl12xx_for_each_wlvif(wl, wlvif) \
 		list_for_each_entry(wlvif, &wl->wlvif_list, list)
 
+#define wl12xx_for_each_wlvif_continue(wl, wlvif) \
+		list_for_each_entry_continue(wlvif, &wl->wlvif_list, list)
+
 #define wl12xx_for_each_wlvif_bss_type(wl, wlvif, _bss_type)	\
 		wl12xx_for_each_wlvif(wl, wlvif)		\
 			if (wlvif->bss_type == _bss_type)
-- 
1.7.6.401.g6a319

