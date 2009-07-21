Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:52248 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZGUTLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 15:11:51 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 2/3] wl1251: remove wl1251_plt_start/stop()
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com
Date: Tue, 21 Jul 2009 22:11:46 +0300
Message-ID: <20090721191145.22374.51976.stgit@tikku>
In-Reply-To: <20090721191136.22374.69017.stgit@tikku>
References: <20090721191136.22374.69017.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

This Production Line Testing code is currently unused and can be removed.
It can be reintroduced when nl80211 test mode implemented for the driver.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |   54 -----------------------------
 1 files changed, 0 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index cf5e054..08fcf90 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -246,60 +246,6 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-int wl1251_plt_start(struct wl1251 *wl)
-{
-	int ret;
-
-	mutex_lock(&wl->mutex);
-
-	wl1251_notice("power up");
-
-	if (wl->state != WL1251_STATE_OFF) {
-		wl1251_error("cannot go into PLT state because not "
-			     "in off state: %d", wl->state);
-		return -EBUSY;
-	}
-
-	wl->state = WL1251_STATE_PLT;
-
-	ret = wl1251_chip_wakeup(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl->chip.op_boot(wl);
-	if (ret < 0)
-		return ret;
-
-	wl1251_notice("firmware booted in PLT mode (%s)", wl->chip.fw_ver);
-
-	ret = wl->chip.op_plt_init(wl);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-int wl1251_plt_stop(struct wl1251 *wl)
-{
-	mutex_lock(&wl->mutex);
-
-	wl1251_notice("power down");
-
-	if (wl->state != WL1251_STATE_PLT) {
-		wl1251_error("cannot power down because not in PLT "
-			     "state: %d", wl->state);
-		return -EBUSY;
-	}
-
-	wl1251_disable_interrupts(wl);
-	wl1251_power_off(wl);
-
-	wl->state = WL1251_STATE_OFF;
-
-	return 0;
-}
-
-
 static int wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1251 *wl = hw->priv;

