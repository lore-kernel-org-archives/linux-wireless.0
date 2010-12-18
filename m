Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47813 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab0LRISC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 03:18:02 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 18 Dec 2010 00:17:47 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 1/2] ath9k: Fix warnings on card removal
Date: Sat, 18 Dec 2010 13:47:37 +0530
Message-ID: <1292660258-4063-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no point in doing register read/write operations
when is hardware is not present. This leads to unnecessary
warnings on log. This patch resolves the following
warnings on card removal.

ath: Failed to wakeup in 500us
------------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/ath9k/hw.c:1618
ath9k_hw_setpower+0x61f/0x630 [ath9k_hw]()
Hardware name: 64756D6
Pid: 540, comm: kworker/u:3 Not tainted 2.6.37-rc6-wl #37
Call Trace:
 [<ffffffff810501aa>] warn_slowpath_common+0x7a/0xb0
 [<ffffffffa056e280>] ? ath9k_iowrite32+0x0/0x90 [ath9k]
 [<ffffffff810501f5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa05226ef>] ath9k_hw_setpower+0x61f/0x630 [ath9k_hw]
 [<ffffffffa05700e5>] ath9k_ps_wakeup+0x85/0xd0 [ath9k]
 [<ffffffffa0570685>] ath9k_configure_filter+0x25/0x80 [ath9k]
 [<ffffffffa04dde43>] ieee80211_configure_filter+0x133/0x190 [mac80211]
 [<ffffffffa04ee502>] ieee80211_do_stop+0x132/0x540 [mac80211]
 [<ffffffff813466ff>] ? _raw_spin_unlock_bh+0x1f/0x30
 [<ffffffff812b6923>] ? dev_deactivate+0x1c3/0x1e0
 [<ffffffffa04ee925>] ieee80211_stop+0x15/0x20 [mac80211]
 [<ffffffff8129d1b6>] __dev_close+0x56/0x90
 [<ffffffff8129d20a>] dev_close+0x1a/0x50
 [<ffffffff8129d57a>] rollback_registered_many+0x6a/0x250
 [<ffffffff8129d776>] unregister_netdevice_many+0x16/0x80
 [<ffffffffa04ee0f4>] ieee80211_remove_interfaces+0xb4/0xf0 [mac80211]
 [<ffffffffa04dd0be>] ieee80211_unregister_hw+0x4e/0x110 [mac80211]
 [<ffffffffa056f467>] ath9k_deinit_device+0x87/0xd0 [ath9k]
 [<ffffffffa057d029>] ath_pci_remove+0x49/0x90 [ath9k]

ath: Could not stop RX, we could be confusing the DMA engine when we
start RX up
------------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/ath9k/recv.c:535
ath_stoprecv+0xdc/0xf0 [ath9k]()
Hardware name: 64756D6
Pid: 5493, comm: kworker/u:0 Tainted: G        W   2.6.37-rc5-wl+ #34
Call Trace:
 [<ffffffff8105018a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810501d5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa030806c>] ath_stoprecv+0xdc/0xf0 [ath9k]
 [<ffffffffa0306891>] ath9k_stop+0x221/0x260 [ath9k]
 [<ffffffffa052e387>] ieee80211_stop_device+0x57/0x90 [mac80211]
 [<ffffffffa051f63f>] ieee80211_do_stop+0x26f/0x540 [mac80211]
 [<ffffffff8134678f>] ? _raw_spin_unlock_bh+0x1f/0x30
 [<ffffffff812b6983>] ? dev_deactivate+0x1c3/0x1e0
 [<ffffffffa051f925>] ieee80211_stop+0x15/0x20 [mac80211]
 [<ffffffff8129d226>] __dev_close+0x56/0x90
 [<ffffffff8129d27a>] dev_close+0x1a/0x50

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h |    3 ++-
 drivers/net/wireless/ath/ath9k/gpio.c   |    3 ++-
 drivers/net/wireless/ath/ath9k/init.c   |    5 +++--
 drivers/net/wireless/ath/ath9k/main.c   |   20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/pci.c    |    1 +
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index f6f09d1..c0942f7 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -23,7 +23,8 @@
 #include <net/cfg80211.h>
 #include "ar9003_eeprom.h"
 
-#define AH_USE_EEPROM   0x1
+#define AH_USE_EEPROM   0x00000001
+#define AH_UNPLUGGED    0x00000002
 
 #ifdef __BIG_ENDIAN
 #define AR5416_EEPROM_MAGIC 0x5aa5
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 1337640..978a223 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -125,7 +125,8 @@ void ath_deinit_leds(struct ath_softc *sc)
 	ath_unregister_led(&sc->tx_led);
 	ath_unregister_led(&sc->rx_led);
 	ath_unregister_led(&sc->radio_led);
-	ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
+	if (!(sc->sc_ah->ah_flags & AH_UNPLUGGED))
+		ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
 }
 
 void ath_init_leds(struct ath_softc *sc)
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1238795..8cf2414 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -542,6 +542,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	if (!sc->dev->platform_data)
 		ah->ah_flags |= AH_USE_EEPROM;
 
+	sc->sc_ah->ah_flags &= ~AH_UNPLUGGED;
 	common = ath9k_hw_common(ah);
 	common->ops = &ath9k_common_ops;
 	common->bus_ops = bus_ops;
@@ -818,8 +819,8 @@ void ath9k_deinit_device(struct ath_softc *sc)
 	struct ieee80211_hw *hw = sc->hw;
 	int i = 0;
 
-	ath9k_ps_wakeup(sc);
-
+	if (!(sc->sc_ah->ah_flags & AH_UNPLUGGED))
+		ath9k_ps_wakeup(sc);
 	wiphy_rfkill_stop_polling(sc->hw->wiphy);
 	ath_deinit_leds(sc);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cb53fbb..e06a44e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1220,6 +1220,12 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	struct ath_tx_control txctl;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
+	if (sc->sc_ah->ah_flags & AH_UNPLUGGED) {
+		ath_dbg(common, ATH_DBG_ANY,
+			"Device not present, can not xmit\n");
+		goto exit;
+	}
+
 	if (aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN) {
 		ath_dbg(common, ATH_DBG_XMIT,
 			"ath9k: %s: TX in unexpected wiphy state %d\n",
@@ -1318,6 +1324,12 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		return;
 	}
 
+	if (ah->ah_flags & AH_UNPLUGGED) {
+		ath_dbg(common, ATH_DBG_ANY, "Device not present\n");
+		mutex_unlock(&sc->mutex);
+		return;
+	}
+
 	if (ath9k_wiphy_started(sc)) {
 		mutex_unlock(&sc->mutex);
 		return; /* another wiphy still in use */
@@ -1585,6 +1597,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&sc->mutex);
 
+	if (ah->ah_flags & AH_UNPLUGGED) {
+		mutex_unlock(&sc->mutex);
+		return 0;
+	}
+
 	/*
 	 * Leave this as the first check because we need to turn on the
 	 * radio if it was disabled before prior to processing the rest
@@ -1765,6 +1782,9 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
 
+	if (sc->sc_ah->ah_flags & AH_UNPLUGGED)
+		return;
+
 	sc->rx.rxfilter = *total_flags;
 	ath9k_ps_wakeup(sc);
 	rfilt = ath_calcrxfilter(sc);
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 7ca8499..96c6005 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -264,6 +264,7 @@ static void ath_pci_remove(struct pci_dev *pdev)
 	struct ath_softc *sc = aphy->sc;
 	void __iomem *mem = sc->mem;
 
+	sc->sc_ah->ah_flags |= AH_UNPLUGGED;
 	ath9k_deinit_device(sc);
 	free_irq(sc->irq, sc);
 	ieee80211_free_hw(sc->hw);
-- 
1.7.3.3

