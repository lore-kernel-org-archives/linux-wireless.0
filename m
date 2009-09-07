Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64531 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZIGMZR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 08:25:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2009 05:25:21 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Disable ASPM when btcoex is active
Date: Mon, 7 Sep 2009 17:46:49 +0530
Message-ID: <1252325810-6159-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   14 ++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h   |    5 +++++
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 011b14f..97a09db 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -16,6 +16,7 @@
 
 #include <linux/io.h>
 #include <asm/unaligned.h>
+#include <linux/pci.h>
 
 #include "ath9k.h"
 #include "initvals.h"
@@ -4298,3 +4299,16 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		timer->trigger(timer->arg);
 	}
 }
+
+/*
+ * Primitive to disable ASPM
+ */
+void ath_pcie_aspm_disable(struct ath_softc *sc)
+{
+	struct pci_dev *pdev = to_pci_dev(sc->dev);
+	u8 aspm;
+
+	pci_read_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, &aspm);
+	aspm &= ~(ATH_PCIE_CAP_LINK_L0S | ATH_PCIE_CAP_LINK_L1);
+	pci_write_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, aspm);
+}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5ca6ffa..a592f1a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -665,4 +665,9 @@ void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer);
 void ath_gen_timer_isr(struct ath_hw *hw);
 u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 
+#define ATH_PCIE_CAP_LINK_CTRL	0x70
+#define ATH_PCIE_CAP_LINK_L0S	1
+#define ATH_PCIE_CAP_LINK_L1	2
+
+void ath_pcie_aspm_disable(struct ath_softc *sc);
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a69fda8..ce011ab 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2010,6 +2010,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 				      AR_STOMP_LOW_WLAN_WGHT);
 		ath9k_hw_btcoex_enable(sc->sc_ah);
 
+		ath_pcie_aspm_disable(sc);
 		if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath_btcoex_timer_resume(sc, &sc->btcoex_info);
 	}
-- 
1.5.5.1

