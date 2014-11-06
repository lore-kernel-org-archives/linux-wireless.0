Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57589 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaKFHyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:15 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 08/21] ath9k: add ath_ps_ops bindings
Date: Thu,  6 Nov 2014 08:53:25 +0100
Message-Id: <1415260418-14321-9-git-send-email-linux@rempel-privat.de> (sfid-20141106_085426_691224_B96A497B)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/init.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index fe811b3..61232d0 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -88,6 +88,21 @@ static const struct ieee80211_tpt_blink ath9k_tpt_blink[] = {
 
 static void ath9k_deinit_softc(struct ath_softc *sc);
 
+void ath9k_op_ps_wakeup(struct ath_common *common)
+{
+	ath9k_ps_wakeup((struct ath_softc *) common->priv);
+}
+
+void ath9k_op_ps_restore(struct ath_common *common)
+{
+	ath9k_ps_restore((struct ath_softc *) common->priv);
+}
+
+struct ath_ps_ops ath9k_ps_ops = {
+	.wakeup = ath9k_op_ps_wakeup,
+	.restore = ath9k_op_ps_restore,
+};
+
 /*
  * Read and write, they both share the same lock. We do this to serialize
  * reads and writes on Atheros 802.11n PCI devices only. This is required
@@ -540,6 +555,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 
 	common->ops = &ah->reg_ops;
 	common->bus_ops = bus_ops;
+	common->ps_ops = &ath9k_ps_ops;
 	common->ah = ah;
 	common->hw = sc->hw;
 	common->priv = sc;
-- 
1.9.1

