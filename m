Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40385 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0GHOup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:50:45 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 07/13] wl1271: Update hardware ARP filtering configuration handling
Date: Thu,  8 Jul 2010 17:50:02 +0300
Message-Id: <1278600608-22411-8-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The interface for hardware ARP configuration changed in the mac80211. Change
driver accordingly.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   10 ++--
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   61 ++++++----------------------
 3 files changed, 19 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index b45ebbc..bb245f0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1075,12 +1075,12 @@ out:
 	return ret;
 }
 
-int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 mode, u8 *address)
+int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, __be32 address)
 {
 	struct wl1271_acx_arp_filter *acx;
 	int ret;
 
-	wl1271_debug(DEBUG_ACX, "acx arp ip filter, mode: %d", mode);
+	wl1271_debug(DEBUG_ACX, "acx arp ip filter, enable: %d", enable);
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
@@ -1089,10 +1089,10 @@ int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 mode, u8 *address)
 	}
 
 	acx->version = ACX_IPV4_VERSION;
-	acx->enable = mode;
+	acx->enable = enable;
 
-	if (mode != ACX_ARP_DISABLE)
-		memcpy(acx->address, address, ACX_IPV4_ADDR_SIZE);
+	if (enable == true)
+		memcpy(acx->address, &address, ACX_IPV4_ADDR_SIZE);
 
 	ret = wl1271_cmd_configure(wl, ACX_ARP_IP_FILTER,
 				   acx, sizeof(*acx));
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 6a6f3e3..d915683 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1117,7 +1117,7 @@ int wl1271_acx_init_mem_config(struct wl1271 *wl);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
 int wl1271_acx_bet_enable(struct wl1271 *wl, bool enable);
-int wl1271_acx_arp_ip_filter(struct wl1271 *wl, u8 mode, u8 *address);
+int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, __be32 address);
 int wl1271_acx_pm_config(struct wl1271 *wl);
 int wl1271_acx_keep_alive_mode(struct wl1271 *wl, bool enable);
 int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 3a64896..15c99dd 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1312,53 +1312,6 @@ struct wl1271_filter_params {
 	u8 mc_list[ACX_MC_ADDRESS_GROUP_MAX][ETH_ALEN];
 };
 
-static int wl1271_op_configure_arp_filter(struct ieee80211_hw *hw,
-					  struct ieee80211_vif *vif,
-					  struct in_ifaddr *ifa_list)
-{
-	struct wl1271 *wl = hw->priv;
-	int ret = 0;
-
-	WARN_ON(vif != wl->vif);
-
-	/* disable filtering if there are multiple addresses */
-	if (ifa_list && ifa_list->ifa_next)
-		ifa_list = NULL;
-
-	mutex_lock(&wl->mutex);
-
-	if (wl->state == WL1271_STATE_OFF)
-		goto out;
-
-	WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
-
-	ret = wl1271_ps_elp_wakeup(wl, false);
-	if (ret < 0)
-		goto out;
-
-	if (ifa_list) {
-		ret = wl1271_cmd_build_arp_reply(wl, &ifa_list->ifa_address);
-		if (ret < 0)
-			goto out_sleep;
-		ret = wl1271_acx_arp_ip_filter(wl, ACX_ARP_FILTER_AND_REPLY,
-					       (u8 *)&ifa_list->ifa_address);
-		if (ret < 0)
-			goto out_sleep;
-	} else {
-		ret = wl1271_acx_arp_ip_filter(wl, ACX_ARP_DISABLE, NULL);
-		if (ret < 0)
-			goto out_sleep;
-	}
-
-out_sleep:
-	wl1271_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-
-	return ret;
-}
-
 static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw,
 				       struct netdev_hw_addr_list *mc_list)
 {
@@ -1869,6 +1822,19 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (changed & BSS_CHANGED_ARP_FILTER) {
+		__be32 addr = bss_conf->arp_addr_list[0];
+		WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
+
+		if (bss_conf->arp_addr_cnt == 1 && bss_conf->arp_filter_enabled)
+			ret = wl1271_acx_arp_ip_filter(wl, true, addr);
+		else
+			ret = wl1271_acx_arp_ip_filter(wl, false, addr);
+
+		if (ret < 0)
+			goto out_sleep;
+	}
+
 	if (do_join) {
 		ret = wl1271_join(wl, set_assoc);
 		if (ret < 0) {
@@ -2174,7 +2140,6 @@ static const struct ieee80211_ops wl1271_ops = {
 	.add_interface = wl1271_op_add_interface,
 	.remove_interface = wl1271_op_remove_interface,
 	.config = wl1271_op_config,
-	.configure_arp_filter = wl1271_op_configure_arp_filter,
 	.prepare_multicast = wl1271_op_prepare_multicast,
 	.configure_filter = wl1271_op_configure_filter,
 	.tx = wl1271_op_tx,
-- 
1.6.3.3

