Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50799 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604Ab0BRL2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:35 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/22] wl1271: Retrieve device mac address from the nvs file
Date: Thu, 18 Feb 2010 13:25:43 +0200
Message-Id: <1266492357-462-9-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of always randomizing the MAC address, retrieve and configure the
MAC address from the device specific nvs file. For now, randomize an address
only if the address in the NVS is zero.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |    8 ------
 drivers/net/wireless/wl12xx/wl1271_main.c |   36 +++++++++++++++++++++-------
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index bc3fe02..57ba78d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -228,14 +228,6 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	nvs_len = sizeof(wl->nvs->nvs);
 	nvs_ptr = (u8 *)wl->nvs->nvs;
 
-	/* Update the device MAC address into the nvs */
-	nvs_ptr[11] = wl->mac_addr[0];
-	nvs_ptr[10] = wl->mac_addr[1];
-	nvs_ptr[6] = wl->mac_addr[2];
-	nvs_ptr[5] = wl->mac_addr[3];
-	nvs_ptr[4] = wl->mac_addr[4];
-	nvs_ptr[3] = wl->mac_addr[5];
-
 	/*
 	 * Layout before the actual NVS tables:
 	 * 1 byte : burst length.
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 282c2bb..b5d53a3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -467,6 +467,32 @@ out:
 	return ret;
 }
 
+static int wl1271_update_mac_addr(struct wl1271 *wl)
+{
+	int ret = 0;
+	u8 *nvs_ptr = (u8 *)wl->nvs->nvs;
+
+	/* get mac address from the NVS */
+	wl->mac_addr[0] = nvs_ptr[11];
+	wl->mac_addr[1] = nvs_ptr[10];
+	wl->mac_addr[2] = nvs_ptr[6];
+	wl->mac_addr[3] = nvs_ptr[5];
+	wl->mac_addr[4] = nvs_ptr[4];
+	wl->mac_addr[5] = nvs_ptr[3];
+
+	/* FIXME: if it is a zero-address, we should bail out. Now, instead,
+	   we randomize an address */
+	if (is_zero_ether_addr(wl->mac_addr)) {
+		static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
+		memcpy(wl->mac_addr, nokia_oui, 3);
+		get_random_bytes(wl->mac_addr + 3, 3);
+	}
+
+	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
+
+	return ret;
+}
+
 static int wl1271_fetch_nvs(struct wl1271 *wl)
 {
 	const struct firmware *fw;
@@ -496,7 +522,7 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 
 	memcpy(wl->nvs, fw->data, sizeof(struct wl1271_nvs_file));
 
-	ret = 0;
+	ret = wl1271_update_mac_addr(wl);
 
 out:
 	release_firmware(fw);
@@ -1893,7 +1919,6 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
 	int ret, i;
-	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
 
 	pdata = spi->dev.platform_data;
 	if (!pdata) {
@@ -1938,13 +1963,6 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 
 	spin_lock_init(&wl->wl_lock);
 
-	/*
-	 * In case our MAC address is not correctly set,
-	 * we use a random but Nokia MAC.
-	 */
-	memcpy(wl->mac_addr, nokia_oui, 3);
-	get_random_bytes(wl->mac_addr + 3, 3);
-
 	wl->state = WL1271_STATE_OFF;
 	mutex_init(&wl->mutex);
 
-- 
1.6.3.3

