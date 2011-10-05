Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41414 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934298Ab1JEJ4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:17 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so1903568bkb.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:17 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 20/29] wl12xx: move dev_hlid into wlvif
Date: Wed,  5 Oct 2011 11:55:57 +0200
Message-Id: <1317808566-18857-21-git-send-email-eliad@wizery.com> (sfid-20111005_115624_673912_9167FF23)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move dev_hlid into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   14 ++++++--------
 drivers/net/wireless/wl12xx/main.c   |    4 ++--
 drivers/net/wireless/wl12xx/tx.c     |    4 ++--
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index c827759..c2066a4 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -483,12 +483,12 @@ int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		cmd->band = WL12XX_BAND_5GHZ;
 	cmd->channel = wl->channel;
 
-	if (wl->dev_hlid == WL12XX_INVALID_LINK_ID) {
-		ret = wl12xx_allocate_link(wl, &wl->dev_hlid);
+	if (wlvif->dev_hlid == WL12XX_INVALID_LINK_ID) {
+		ret = wl12xx_allocate_link(wl, &wlvif->dev_hlid);
 		if (ret)
 			goto out_free;
 	}
-	cmd->device.hlid = wl->dev_hlid;
+	cmd->device.hlid = wlvif->dev_hlid;
 	cmd->device.session = wlvif->session_counter;
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d",
@@ -504,9 +504,7 @@ int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 err_hlid:
 	/* clear links on error */
-	__clear_bit(wl->dev_hlid, wl->links_map);
-	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
-
+	wl12xx_free_link(wl, &wlvif->dev_hlid);
 
 out_free:
 	kfree(cmd);
@@ -520,7 +518,7 @@ int wl12xx_cmd_role_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	struct wl12xx_cmd_role_stop *cmd;
 	int ret;
 
-	if (WARN_ON(wl->dev_hlid == WL12XX_INVALID_LINK_ID))
+	if (WARN_ON(wlvif->dev_hlid == WL12XX_INVALID_LINK_ID))
 		return -EINVAL;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -547,7 +545,7 @@ int wl12xx_cmd_role_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out_free;
 	}
 
-	wl12xx_free_link(wl, &wl->dev_hlid);
+	wl12xx_free_link(wl, &wlvif->dev_hlid);
 
 out_free:
 	kfree(cmd);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0f13dd5..1bdb78d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1884,6 +1884,7 @@ static int wl12xx_init_vif_data(struct ieee80211_vif *vif)
 
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
 	wlvif->dev_role_id = WL12XX_INVALID_ROLE_ID;
+	wlvif->dev_hlid = WL12XX_INVALID_LINK_ID;
 
 	if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
 	    wlvif->bss_type == BSS_TYPE_IBSS) {
@@ -2103,7 +2104,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 deinit:
 	/* clear all hlids (except system_hlid) */
 	wlvif->sta.hlid = WL12XX_INVALID_LINK_ID;
-	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
+	wlvif->dev_hlid = WL12XX_INVALID_LINK_ID;
 	wlvif->ap.bcast_hlid = WL12XX_INVALID_LINK_ID;
 	wlvif->ap.global_hlid = WL12XX_INVALID_LINK_ID;
 
@@ -4867,7 +4868,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->tx_security_last_seq_lsb = 0;
 	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
-	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
 	wl->active_sta_count = 0;
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index da8427f..8db68c6 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -94,7 +94,7 @@ static int wl1271_tx_update_filters(struct wl1271 *wl,
 	if (!ieee80211_is_auth(hdr->frame_control))
 		return 0;
 
-	if (wl->dev_hlid != WL12XX_INVALID_LINK_ID)
+	if (wlvif->dev_hlid != WL12XX_INVALID_LINK_ID)
 		goto out;
 
 	wl1271_debug(DEBUG_CMD, "starting device role for roaming");
@@ -202,7 +202,7 @@ static u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct ieee80211_vif *vif,
 	    !ieee80211_is_assoc_req(hdr->frame_control))
 		return wlvif->sta.hlid;
 	else
-		return wl->dev_hlid;
+		return wlvif->dev_hlid;
 }
 
 static unsigned int wl12xx_calc_packet_alignment(struct wl1271 *wl,
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 10b45f7..567b09d 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -401,7 +401,6 @@ struct wl1271 {
 	u8 mac_addr[ETH_ALEN];
 	int channel;
 	u8 system_hlid;
-	u8 dev_hlid;
 
 	unsigned long links_map[BITS_TO_LONGS(WL12XX_MAX_LINKS)];
 	unsigned long roles_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
@@ -616,6 +615,7 @@ struct wl12xx_vif {
 
 	/* sta/ibss specific */
 	u8 dev_role_id;
+	u8 dev_hlid;
 
 	union {
 		struct {
-- 
1.7.6.401.g6a319

