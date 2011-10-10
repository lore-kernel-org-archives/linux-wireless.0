Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62854 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1JJIMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:12:46 -0400
Received: by wwf22 with SMTP id 22so8786663wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:45 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/29] wl12xx: add vifs list
Date: Mon, 10 Oct 2011 10:12:54 +0200
Message-Id: <1318234397-21081-7-git-send-email-eliad@wizery.com> (sfid-20111010_101248_612345_25F9EE2E)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

keep a list of all the vifs associated with our hw.
it will be later used in order to iterate through vifs.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    4 ++++
 drivers/net/wireless/wl12xx/wl12xx.h |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index acfc497..56d5923 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1957,6 +1957,7 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 	wlvif->beacon_int = WL1271_DEFAULT_BEACON_INT;
 
 	INIT_DELAYED_WORK(&wlvif->pspoll_work, wl1271_pspoll_work);
+	INIT_LIST_HEAD(&wlvif->list);
 
 	return 0;
 }
@@ -2114,6 +2115,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		goto out;
 
 	wl->vif = vif;
+	list_add(&wlvif->list, &wl->wlvif_list);
 	set_bit(WL1271_FLAG_IF_INITIALIZED, &wl->flags);
 out:
 	mutex_unlock(&wl->mutex);
@@ -2181,6 +2183,7 @@ deinit:
 
 	wl12xx_tx_reset_wlvif(wl, wlvif);
 	wl1271_free_ap_keys(wl, wlvif);
+	list_del(&wlvif->list);
 	memset(wlvif->ap.sta_hlid_map, 0, sizeof(wlvif->ap.sta_hlid_map));
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
 	wlvif->dev_role_id = WL12XX_INVALID_ROLE_ID;
@@ -4869,6 +4872,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	memset(wl, 0, sizeof(*wl));
 
 	INIT_LIST_HEAD(&wl->list);
+	INIT_LIST_HEAD(&wl->wlvif_list);
 
 	wl->hw = hw;
 	wl->plat_dev = plat_dev;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 33ccdf8..55561c5 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -394,6 +394,8 @@ struct wl1271 {
 	unsigned long roles_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
 	unsigned long roc_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
 
+	struct list_head wlvif_list;
+
 	struct wl1271_acx_mem_map *target_mem_map;
 
 	/* Accounting for allocated / available TX blocks on HW */
@@ -564,6 +566,7 @@ struct wl1271_station {
 
 struct wl12xx_vif {
 	struct wl1271 *wl;
+	struct list_head list;
 	u8 bss_type;
 	u8 p2p; /* we are using p2p role */
 	u8 role_id;
@@ -653,6 +656,9 @@ struct ieee80211_vif *wl12xx_wlvif_to_vif(struct wl12xx_vif *wlvif)
 	return container_of((void *)wlvif, struct ieee80211_vif, drv_priv);
 }
 
+#define wl12xx_for_each_wlvif(wl, wlvif) \
+		list_for_each_entry(wlvif, &wl->wlvif_list, list)
+
 int wl1271_plt_start(struct wl1271 *wl);
 int wl1271_plt_stop(struct wl1271 *wl);
 int wl1271_recalc_rx_streaming(struct wl1271 *wl);
-- 
1.7.6.401.g6a319

