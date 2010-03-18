Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33171 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0CRK1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:47 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 14/21] wl1271: Fix MAC address handling
Date: Thu, 18 Mar 2010 12:26:39 +0200
Message-Id: <1268908006-16992-15-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch fixes MAC address handling. To achieve this, firmware booting had
to be delayed from the previous op_start to op_add_interface, which is the point
when the driver gets to know the configured MAC address. As the wl1271 only
supports one virtual interface, this even seems quite logical.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |    8 ++
 drivers/net/wireless/wl12xx/wl1271_main.c |  149 ++++++++++++-----------------
 2 files changed, 68 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index f88d52e..41c6aff 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -228,6 +228,14 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	nvs_len = sizeof(wl->nvs->nvs);
 	nvs_ptr = (u8 *)wl->nvs->nvs;
 
+	/* update current MAC address to NVS */
+	nvs_ptr[11] = wl->mac_addr[0];
+	nvs_ptr[10] = wl->mac_addr[1];
+	nvs_ptr[6] = wl->mac_addr[2];
+	nvs_ptr[5] = wl->mac_addr[3];
+	nvs_ptr[4] = wl->mac_addr[4];
+	nvs_ptr[3] = wl->mac_addr[5];
+
 	/*
 	 * Layout before the actual NVS tables:
 	 * 1 byte : burst length.
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 037a4f4..d8cb514 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -570,40 +570,6 @@ out:
 	return ret;
 }
 
-static int wl1271_update_mac_addr(struct wl1271 *wl)
-{
-	int ret = 0;
-	u8 *nvs_ptr = (u8 *)wl->nvs->nvs;
-
-	/* get mac address from the NVS */
-	wl->mac_addr[0] = nvs_ptr[11];
-	wl->mac_addr[1] = nvs_ptr[10];
-	wl->mac_addr[2] = nvs_ptr[6];
-	wl->mac_addr[3] = nvs_ptr[5];
-	wl->mac_addr[4] = nvs_ptr[4];
-	wl->mac_addr[5] = nvs_ptr[3];
-
-	/* FIXME: if it is a zero-address, we should bail out. Now, instead,
-	   we randomize an address */
-	if (is_zero_ether_addr(wl->mac_addr)) {
-		static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
-		memcpy(wl->mac_addr, nokia_oui, 3);
-		get_random_bytes(wl->mac_addr + 3, 3);
-
-		/* update this address to the NVS */
-		nvs_ptr[11] = wl->mac_addr[0];
-		nvs_ptr[10] = wl->mac_addr[1];
-		nvs_ptr[6] = wl->mac_addr[2];
-		nvs_ptr[5] = wl->mac_addr[3];
-		nvs_ptr[4] = wl->mac_addr[4];
-		nvs_ptr[3] = wl->mac_addr[5];
-	}
-
-	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
-
-	return ret;
-}
-
 static int wl1271_fetch_nvs(struct wl1271 *wl)
 {
 	const struct firmware *fw;
@@ -633,8 +599,6 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 
 	memcpy(wl->nvs, fw->data, sizeof(struct wl1271_nvs_file));
 
-	ret = wl1271_update_mac_addr(wl);
-
 out:
 	release_firmware(fw);
 
@@ -952,13 +916,58 @@ static struct notifier_block wl1271_dev_notifier = {
 
 static int wl1271_op_start(struct ieee80211_hw *hw)
 {
+	wl1271_debug(DEBUG_MAC80211, "mac80211 start");
+
+	/*
+	 * We have to delay the booting of the hardware because
+	 * we need to know the local MAC address before downloading and
+	 * initializing the firmware. The MAC address cannot be changed
+	 * after boot, and without the proper MAC address, the firmware
+	 * will not function properly.
+	 *
+	 * The MAC address is first known when the corresponding interface
+	 * is added. That is where we will initialize the hardware.
+	 */
+
+	return 0;
+}
+
+static void wl1271_op_stop(struct ieee80211_hw *hw)
+{
+	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
+}
+
+static int wl1271_op_add_interface(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif)
+{
 	struct wl1271 *wl = hw->priv;
 	int retries = WL1271_BOOT_RETRIES;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 start");
+	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
+		     vif->type, vif->addr);
 
 	mutex_lock(&wl->mutex);
+	if (wl->vif) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	wl->vif = vif;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		wl->bss_type = BSS_TYPE_STA_BSS;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		wl->bss_type = BSS_TYPE_IBSS;
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	memcpy(wl->mac_addr, vif->addr, ETH_ALEN);
 
 	if (wl->state != WL1271_STATE_OFF) {
 		wl1271_error("cannot start because not in off state: %d",
@@ -1014,20 +1023,20 @@ out:
 	return ret;
 }
 
-static void wl1271_op_stop(struct ieee80211_hw *hw)
+static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif)
 {
 	struct wl1271 *wl = hw->priv;
 	int i;
 
-	wl1271_info("down");
+	mutex_lock(&wl->mutex);
+	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
+	wl1271_info("down");
 
 	unregister_inetaddr_notifier(&wl1271_dev_notifier);
 	list_del(&wl->list);
 
-	mutex_lock(&wl->mutex);
-
 	WARN_ON(wl->state != WL1271_STATE_ON);
 
 	if (test_and_clear_bit(WL1271_FLAG_SCANNING, &wl->flags)) {
@@ -1070,6 +1079,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->sta_rate_set = 0;
 	wl->flags = 0;
+	wl->vif = NULL;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
@@ -1078,53 +1088,6 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	mutex_unlock(&wl->mutex);
 }
 
-static int wl1271_op_add_interface(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif)
-{
-	struct wl1271 *wl = hw->priv;
-	int ret = 0;
-
-	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
-		     vif->type, vif->addr);
-
-	mutex_lock(&wl->mutex);
-	if (wl->vif) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	wl->vif = vif;
-
-	switch (vif->type) {
-	case NL80211_IFTYPE_STATION:
-		wl->bss_type = BSS_TYPE_STA_BSS;
-		break;
-	case NL80211_IFTYPE_ADHOC:
-		wl->bss_type = BSS_TYPE_IBSS;
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
-	/* FIXME: what if conf->mac_addr changes? */
-
-out:
-	mutex_unlock(&wl->mutex);
-	return ret;
-}
-
-static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
-					 struct ieee80211_vif *vif)
-{
-	struct wl1271 *wl = hw->priv;
-
-	mutex_lock(&wl->mutex);
-	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
-	wl->vif = NULL;
-	mutex_unlock(&wl->mutex);
-}
-
 #if 0
 static int wl1271_op_config_interface(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
@@ -2114,6 +2077,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
 	int i, ret;
+	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
 	if (!hw) {
@@ -2155,6 +2119,13 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->state = WL1271_STATE_OFF;
 	mutex_init(&wl->mutex);
 
+	/*
+	 * FIXME: we should use a zero MAC address here, but for now we
+	 * generate a random Nokia address.
+	 */
+	memcpy(wl->mac_addr, nokia_oui, 3);
+	get_random_bytes(wl->mac_addr + 3, 3);
+
 	/* Apply default driver configuration. */
 	wl1271_conf_init(wl);
 
-- 
1.6.3.3

