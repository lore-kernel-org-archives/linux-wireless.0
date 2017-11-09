Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:45840 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754802AbdKIXiv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 18:38:51 -0500
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
Subject: [PATCH v2 2/6] wl1251: Generate random MAC address only if driver does not have valid
Date: Fri, 10 Nov 2017 00:38:24 +0100
Message-Id: <1510270708-14377-3-git-send-email-pali.rohar@gmail.com> (sfid-20171110_004136_240813_B0C73985)
In-Reply-To: <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
 <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before this patch, driver generated random MAC address every time it was
initialized. After that random MAC address could be overwritten with fixed
one, if provided.

This patch changes order. First it tries to read fixed MAC address and if
it fails then driver generates random MAC address.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/net/wireless/ti/wl1251/main.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 8929bb3..9106c20 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1492,7 +1492,24 @@ int wl1251_init_ieee80211(struct wl1251 *wl)
 	wl->hw->queues = 4;
 
 	if (wl->use_eeprom)
-		wl1251_read_eeprom_mac(wl);
+		ret = wl1251_read_eeprom_mac(wl);
+	else
+		ret = -EINVAL;
+
+	if (ret == 0 && !is_valid_ether_addr(wl->mac_addr))
+		ret = -EINVAL;
+
+	if (ret < 0) {
+		/*
+		 * In case our MAC address is not correctly set,
+		 * we use a random but Nokia MAC.
+		 */
+		static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
+		memcpy(wl->mac_addr, nokia_oui, 3);
+		get_random_bytes(wl->mac_addr + 3, 3);
+		wl1251_warning("MAC address in eeprom or nvs data is not valid");
+		wl1251_warning("Setting random MAC address: %pM", wl->mac_addr);
+	}
 
 	ret = wl1251_register_hw(wl);
 	if (ret)
@@ -1513,7 +1530,6 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	struct ieee80211_hw *hw;
 	struct wl1251 *wl;
 	int i;
-	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1251_ops);
 	if (!hw) {
@@ -1563,13 +1579,6 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	INIT_WORK(&wl->irq_work, wl1251_irq_work);
 	INIT_WORK(&wl->tx_work, wl1251_tx_work);
 
-	/*
-	 * In case our MAC address is not correctly set,
-	 * we use a random but Nokia MAC.
-	 */
-	memcpy(wl->mac_addr, nokia_oui, 3);
-	get_random_bytes(wl->mac_addr + 3, 3);
-
 	wl->state = WL1251_STATE_OFF;
 	mutex_init(&wl->mutex);
 	spin_lock_init(&wl->wl_lock);
-- 
1.7.9.5
