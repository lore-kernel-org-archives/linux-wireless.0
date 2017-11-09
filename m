Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:54606 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755324AbdKIXix (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 18:38:53 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Michal Kazior <michal.kazior@tieto.com>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 3/6] wl1251: Parse and use MAC address from supplied NVS data
Date: Fri, 10 Nov 2017 00:38:25 +0100
Message-Id: <1510270708-14377-4-git-send-email-pali.rohar@gmail.com> (sfid-20171110_003939_827622_E4D9083C)
In-Reply-To: <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
 <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements parsing MAC address from NVS data which are sent to
wl1251 chip. Calibration NVS data could contain valid MAC address and it
will be used instead of randomly generated one.

This patch also moves code for requesting NVS data from userspace to driver
initialization code to make sure that NVS data will be there at time when
permanent MAC address is needed.

Calibration NVS data for wl1251 are device specific. Every device with
wl1251 chip should have been calibrated in factory and needs to provide own
calibration data.

Default example file wl1251-nvs.bin, found in linux-firmware repository,
contains MAC address 00:00:20:07:03:09. So this MAC address is marked as
invalid as it is not real device specific address, just example one.

Format of calibration NVS data can be found at:
http://notaz.gp2x.de/misc/pnd/wl1251/nvs_map.txt

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c |   55 ++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 9106c20..d497ba5 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -203,13 +203,6 @@ static int wl1251_chip_wakeup(struct wl1251 *wl)
 			goto out;
 	}
 
-	if (wl->nvs == NULL && !wl->use_eeprom) {
-		/* No NVS from netlink, try to get it from the filesystem */
-		ret = wl1251_fetch_nvs(wl);
-		if (ret < 0)
-			goto out;
-	}
-
 out:
 	return ret;
 }
@@ -1448,6 +1441,46 @@ static int wl1251_read_eeprom_mac(struct wl1251 *wl)
 	return 0;
 }
 
+#define NVS_OFF_MAC_LEN 0x19
+#define NVS_OFF_MAC_ADDR_LO 0x1a
+#define NVS_OFF_MAC_ADDR_HI 0x1b
+#define NVS_OFF_MAC_DATA 0x1c
+
+static int wl1251_check_nvs_mac(struct wl1251 *wl)
+{
+	if (wl->nvs_len < 0x24)
+		return -ENODATA;
+
+	/* length is 2 and data address is 0x546c (ANDed with 0xfffe) */
+	if (wl->nvs[NVS_OFF_MAC_LEN] != 2 ||
+	    wl->nvs[NVS_OFF_MAC_ADDR_LO] != 0x6d ||
+	    wl->nvs[NVS_OFF_MAC_ADDR_HI] != 0x54)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int wl1251_read_nvs_mac(struct wl1251 *wl)
+{
+	u8 mac[ETH_ALEN];
+	int i, ret;
+
+	ret = wl1251_check_nvs_mac(wl);
+	if (ret)
+		return ret;
+
+	/* MAC is stored in reverse order */
+	for (i = 0; i < ETH_ALEN; i++)
+		mac[i] = wl->nvs[NVS_OFF_MAC_DATA + ETH_ALEN - i - 1];
+
+	/* 00:00:20:07:03:09 is in example file wl1251-nvs.bin, so invalid */
+	if (ether_addr_equal_unaligned(mac, "\x00\x00\x20\x07\x03\x09"))
+		return -EINVAL;
+
+	memcpy(wl->mac_addr, mac, ETH_ALEN);
+	return 0;
+}
+
 static int wl1251_register_hw(struct wl1251 *wl)
 {
 	int ret;
@@ -1491,10 +1524,16 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 
 	wl->hw->queues = 4;
 
+	if (wl->nvs == NULL && !wl->use_eeprom) {
+		ret = wl1251_fetch_nvs(wl);
+		if (ret < 0)
+			goto out;
+	}
+
 	if (wl->use_eeprom)
 		ret = wl1251_read_eeprom_mac(wl);
 	else
-		ret = -EINVAL;
+		ret = wl1251_read_nvs_mac(wl);
 
 	if (ret == 0 && !is_valid_ether_addr(wl->mac_addr))
 		ret = -EINVAL;
-- 
1.7.9.5
