Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62563 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab0DNKFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 06:05:55 -0400
Received: by wyf19 with SMTP id 19so650515wyf.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Apr 2010 03:05:54 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH v2] wl1251: read default MAC address from EEPROM when available
Date: Wed, 14 Apr 2010 13:05:48 +0300
Message-Id: <1271239548-15326-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some wl1251 hardware configurations (like in WG7210 module) have
EEPROM attached where NVS data is kept, which includes MAC address.

In such configurations, let's read default MAC address from EEPROM,
instead of using random one.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |   63 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_reg.h  |    7 +++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 56b78e4..5dc04df 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1196,6 +1196,66 @@ static const struct ieee80211_ops wl1251_ops = {
 	.conf_tx = wl1251_op_conf_tx,
 };
 
+static int wl1251_read_eeprom_byte(struct wl1251 *wl, off_t offset, u8 *data)
+{
+	unsigned long timeout;
+
+	wl1251_reg_write32(wl, EE_ADDR, offset);
+	wl1251_reg_write32(wl, EE_CTL, EE_CTL_READ);
+
+	/* EE_CTL_READ clears when data is ready */
+	timeout = jiffies + msecs_to_jiffies(100);
+	while (1) {
+		if (!(wl1251_reg_read32(wl, EE_CTL) & EE_CTL_READ))
+			break;
+
+		if (time_after(jiffies, timeout))
+			return -ETIMEDOUT;
+
+		msleep(1);
+	}
+
+	*data = wl1251_reg_read32(wl, EE_DATA);
+	return 0;
+}
+
+static int wl1251_read_eeprom(struct wl1251 *wl, off_t offset,
+			      u8 *data, size_t len)
+{
+	size_t i;
+	int ret;
+
+	wl1251_reg_write32(wl, EE_START, 0);
+
+	for (i = 0; i < len; i++) {
+		ret = wl1251_read_eeprom_byte(wl, offset + i, &data[i]);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int wl1251_read_eeprom_mac(struct wl1251 *wl)
+{
+	u8 mac[ETH_ALEN];
+	int i, ret;
+
+	wl1251_set_partition(wl, 0, 0, REGISTERS_BASE, REGISTERS_DOWN_SIZE);
+
+	ret = wl1251_read_eeprom(wl, 0x1c, mac, sizeof(mac));
+	if (ret < 0) {
+		wl1251_warning("failed to read MAC address from EEPROM");
+		return ret;
+	}
+
+	/* MAC is stored in reverse order */
+	for (i = 0; i < ETH_ALEN; i++)
+		wl->mac_addr[i] = mac[ETH_ALEN - i - 1];
+
+	return 0;
+}
+
 static int wl1251_register_hw(struct wl1251 *wl)
 {
 	int ret;
@@ -1242,6 +1302,9 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 
 	wl->hw->queues = 4;
 
+	if (wl->use_eeprom)
+		wl1251_read_eeprom_mac(wl);
+
 	ret = wl1251_register_hw(wl);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/wl12xx/wl1251_reg.h b/drivers/net/wireless/wl12xx/wl1251_reg.h
index 0ca3b43..d16edd9 100644
--- a/drivers/net/wireless/wl12xx/wl1251_reg.h
+++ b/drivers/net/wireless/wl12xx/wl1251_reg.h
@@ -46,7 +46,14 @@
 #define SOR_CFG                        (REGISTERS_BASE + 0x0800)
 #define ECPU_CTRL                      (REGISTERS_BASE + 0x0804)
 #define HI_CFG                         (REGISTERS_BASE + 0x0808)
+
+/* EEPROM registers */
 #define EE_START                       (REGISTERS_BASE + 0x080C)
+#define EE_CTL                         (REGISTERS_BASE + 0x2000)
+#define EE_DATA                        (REGISTERS_BASE + 0x2004)
+#define EE_ADDR                        (REGISTERS_BASE + 0x2008)
+
+#define EE_CTL_READ                   2
 
 #define CHIP_ID_B                      (REGISTERS_BASE + 0x5674)
 
-- 
1.6.3.3

