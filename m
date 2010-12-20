Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:55696 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab0LTJKR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 04:10:17 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 01:10:01 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH v2 1/2] ath9k: Fix warnings on card removal
Date: Mon, 20 Dec 2010 14:39:51 +0530
Message-ID: <1292836191-23465-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recently added warning message on power change failure
is not needed on device removal.

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

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
v2: handled module unload
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/init.c  |    2 ++
 drivers/net/wireless/ath/ath9k/pci.c   |    2 ++
 drivers/net/wireless/ath/ath9k/recv.c  |    3 ++-
 4 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b0b1216..c0f6222 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -666,6 +666,7 @@ extern struct ieee80211_ops ath9k_ops;
 extern int modparam_nohwcrypt;
 extern int led_blink;
 extern int ath9k_pm_qos_value;
+extern bool is_ath9k_unloaded;
 
 irqreturn_t ath_isr(int irq, void *dev);
 int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1238795..3a8a4c6 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -45,6 +45,7 @@ int ath9k_pm_qos_value = ATH9K_PM_QOS_DEFAULT_VALUE;
 module_param_named(pmqos, ath9k_pm_qos_value, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(pmqos, "User specified PM-QOS value");
 
+bool is_ath9k_unloaded;
 /* We use the hw_value as an index into our private channel structure */
 
 #define CHAN2G(_freq, _idx)  { \
@@ -898,6 +899,7 @@ module_init(ath9k_init);
 
 static void __exit ath9k_exit(void)
 {
+	is_ath9k_unloaded = true;
 	ath_ahb_exit();
 	ath_pci_exit();
 	ath_rate_control_unregister();
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 7ca8499..3eb938d 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -264,6 +264,8 @@ static void ath_pci_remove(struct pci_dev *pdev)
 	struct ath_softc *sc = aphy->sc;
 	void __iomem *mem = sc->mem;
 
+	if (!is_ath9k_unloaded)
+		sc->sc_ah->ah_flags |= AH_UNPLUGGED;
 	ath9k_deinit_device(sc);
 	free_irq(sc->irq, sc);
 	ieee80211_free_hw(sc->hw);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 00ebed3..b2497b8 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -528,7 +528,8 @@ bool ath_stoprecv(struct ath_softc *sc)
 		sc->rx.rxlink = NULL;
 	spin_unlock_bh(&sc->rx.rxbuflock);
 
-	if (unlikely(!stopped)) {
+	if (!(ah->ah_flags & AH_UNPLUGGED) &&
+	    unlikely(!stopped)) {
 		ath_err(ath9k_hw_common(sc->sc_ah),
 			"Could not stop RX, we could be "
 			"confusing the DMA engine when we start RX up\n");
-- 
1.7.3.3

