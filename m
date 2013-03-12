Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50601 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab3CLNpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:46 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 10/13] wlcore: free AP global links properly on recovery
Date: Tue, 12 Mar 2013 15:44:21 +0200
Message-ID: <1363095864-24422-11-git-send-email-coelho@ti.com> (sfid-20130312_144555_824152_17004840)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Dont use free_sta() on AP global links. It would fail an internal check
within the function and various structures within the link struct would
not be reset.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    3 ++-
 drivers/net/wireless/ti/wlcore/tx.c   |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index bf86c71..4da5584 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2523,6 +2523,8 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		wl1271_ps_elp_sleep(wl);
 	}
 deinit:
+	wl12xx_tx_reset_wlvif(wl, wlvif);
+
 	/* clear all hlids (except system_hlid) */
 	wlvif->dev_hlid = WL12XX_INVALID_LINK_ID;
 
@@ -2546,7 +2548,6 @@ deinit:
 
 	dev_kfree_skb(wlvif->probereq);
 	wlvif->probereq = NULL;
-	wl12xx_tx_reset_wlvif(wl, wlvif);
 	if (wl->last_wlvif == wlvif)
 		wl->last_wlvif = NULL;
 	list_del(&wlvif->list);
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index e0d9504..85003c0 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -1047,7 +1047,8 @@ void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	/* TX failure */
 	for_each_set_bit(i, wlvif->links_map, WL12XX_MAX_LINKS) {
-		if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
+		if (wlvif->bss_type == BSS_TYPE_AP_BSS &&
+		    i != wlvif->ap.bcast_hlid && i != wlvif->ap.global_hlid) {
 			/* this calls wl12xx_free_link */
 			wl1271_free_sta(wl, wlvif, i);
 		} else {
-- 
1.7.10.4

