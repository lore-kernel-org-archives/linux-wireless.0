Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:54357 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755248AbdKIXiz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 18:38:55 -0500
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
Subject: [PATCH v2 4/6] wl1251: Set generated MAC address back to NVS data
Date: Fri, 10 Nov 2017 00:38:26 +0100
Message-Id: <1510270708-14377-5-git-send-email-pali.rohar@gmail.com> (sfid-20171110_004012_856753_9654A351)
In-Reply-To: <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
 <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case there is no valid MAC address kernel generates random one. This
patch propagate this generated MAC address back to NVS data which will be
uploaded to wl1251 chip. So HW would have same MAC address as linux kernel
uses.

This should not change any functionality, but it is better to tell wl1251
correct mac address since beginning of chip usage.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index d497ba5..1f423be 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1481,6 +1481,21 @@ static int wl1251_read_nvs_mac(struct wl1251 *wl)
 	return 0;
 }
 
+static int wl1251_write_nvs_mac(struct wl1251 *wl)
+{
+	int i, ret;
+
+	ret = wl1251_check_nvs_mac(wl);
+	if (ret)
+		return ret;
+
+	/* MAC is stored in reverse order */
+	for (i = 0; i < ETH_ALEN; i++)
+		wl->nvs[NVS_OFF_MAC_DATA + i] = wl->mac_addr[ETH_ALEN - i - 1];
+
+	return 0;
+}
+
 static int wl1251_register_hw(struct wl1251 *wl)
 {
 	int ret;
@@ -1546,6 +1561,8 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 		static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
 		memcpy(wl->mac_addr, nokia_oui, 3);
 		get_random_bytes(wl->mac_addr + 3, 3);
+		if (!wl->use_eeprom)
+			wl1251_write_nvs_mac(wl);
 		wl1251_warning("MAC address in eeprom or nvs data is not valid");
 		wl1251_warning("Setting random MAC address: %pM", wl->mac_addr);
 	}
-- 
1.7.9.5
