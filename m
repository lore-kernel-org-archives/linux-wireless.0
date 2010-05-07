Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:17781 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab0EGIjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 04:39:41 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 1/5] wl1271: Add sysfs file to retrieve HW PG-version and ROM-version
Date: Fri,  7 May 2010 11:38:58 +0300
Message-Id: <1273221542-14283-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1273221542-14283-1-git-send-email-luciano.coelho@nokia.com>
References: <1273221542-14283-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch reads the HW PG version (along with a ROM-version, embedded in the
same value) from the wl1271 hardware and publishes the value in a sysfs -file.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +
 drivers/net/wireless/wl12xx/wl1271_boot.c |   12 ++++++++++
 drivers/net/wireless/wl12xx/wl1271_boot.h |    3 ++
 drivers/net/wireless/wl12xx/wl1271_main.c |   34 +++++++++++++++++++++++++++++
 4 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 75887e7..3e1769d 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -388,6 +388,8 @@ struct wl1271 {
 	size_t fw_len;
 	struct wl1271_nvs_file *nvs;
 
+	s8 hw_pg_ver;
+
 	u8 bssid[ETH_ALEN];
 	u8 mac_addr[ETH_ALEN];
 	u8 bss_type;
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index acb1d9e..1a36d8a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -441,11 +441,23 @@ static int wl1271_boot_write_irq_polarity(struct wl1271 *wl)
 	return 0;
 }
 
+static void wl1271_boot_hw_version(struct wl1271 *wl)
+{
+	u32 fuse;
+
+	fuse = wl1271_top_reg_read(wl, REG_FUSE_DATA_2_1);
+	fuse = (fuse & PG_VER_MASK) >> PG_VER_OFFSET;
+
+	wl->hw_pg_ver = (s8)fuse;
+}
+
 int wl1271_boot(struct wl1271 *wl)
 {
 	int ret = 0;
 	u32 tmp, clk, pause;
 
+	wl1271_boot_hw_version(wl);
+
 	if (REF_CLOCK == 0 || REF_CLOCK == 2 || REF_CLOCK == 4)
 		/* ref clk: 19.2/38.4/38.4-XTAL */
 		clk = 0x3;
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.h b/drivers/net/wireless/wl12xx/wl1271_boot.h
index 95ecc52..f829699 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.h
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.h
@@ -55,6 +55,9 @@ struct wl1271_static_data {
 #define OCP_REG_CLK_POLARITY 0x0cb2
 #define OCP_REG_CLK_PULL     0x0cb4
 
+#define REG_FUSE_DATA_2_1    0x050a
+#define PG_VER_MASK          0x3c
+#define PG_VER_OFFSET        2
 
 #define CMD_MBOX_ADDRESS     0x407B4
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index b167248..5ad94fc 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2233,6 +2233,29 @@ static DEVICE_ATTR(bt_coex_state, S_IRUGO | S_IWUSR,
 		   wl1271_sysfs_show_bt_coex_state,
 		   wl1271_sysfs_store_bt_coex_state);
 
+static ssize_t wl1271_sysfs_show_hw_pg_ver(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct wl1271 *wl = dev_get_drvdata(dev);
+	ssize_t len;
+
+	/* FIXME: what's the maximum length of buf? page size?*/
+	len = 500;
+
+	mutex_lock(&wl->mutex);
+	if (wl->hw_pg_ver >= 0)
+		len = snprintf(buf, len, "%d\n", wl->hw_pg_ver);
+	else
+		len = snprintf(buf, len, "n/a\n");
+	mutex_unlock(&wl->mutex);
+
+	return len;
+}
+
+static DEVICE_ATTR(hw_pg_ver, S_IRUGO | S_IWUSR,
+		   wl1271_sysfs_show_hw_pg_ver, NULL);
+
 int wl1271_register_hw(struct wl1271 *wl)
 {
 	int ret;
@@ -2352,6 +2375,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->vif = NULL;
 	wl->flags = 0;
 	wl->sg_enabled = true;
+	wl->hw_pg_ver = -1;
 
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		wl->tx_frames[i] = NULL;
@@ -2381,8 +2405,18 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 		goto err_platform;
 	}
 
+	/* Create sysfs file to get HW PG version */
+	ret = device_create_file(&wl->plat_dev->dev, &dev_attr_hw_pg_ver);
+	if (ret < 0) {
+		wl1271_error("failed to create sysfs file hw_pg_ver");
+		goto err_bt_coex_state;
+	}
+
 	return hw;
 
+err_bt_coex_state:
+	device_remove_file(&wl->plat_dev->dev, &dev_attr_bt_coex_state);
+
 err_platform:
 	platform_device_unregister(wl->plat_dev);
 
-- 
1.6.3.3

