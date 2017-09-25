Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36838 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934940AbdIYN1n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 09:27:43 -0400
Received: by mail-pg0-f65.google.com with SMTP id d8so4865228pgt.3
        for <linux-wireless@vger.kernel.org>; Mon, 25 Sep 2017 06:27:43 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [PATCH 3/3] rsi: sdio: Add WOWLAN support for S5 shutdown state
Date: Mon, 25 Sep 2017 18:52:05 +0530
Message-Id: <1506345725-4742-1-git-send-email-amitkarwar@gmail.com> (sfid-20170925_152949_465938_12AF95B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

Unlike other power states, WoWLAN configuration does not come from
mac80211 for shutdown. Hence configuring the WoWLAN from shut down
callback it self. Remaining steps of disabling SDIO interrupts,
setting 'MMC_PM_KEEP_POWER' flag are same as other power states.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  1 +
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 30 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index c6b2ce5..0483d80 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1817,6 +1817,7 @@ int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan)
 
 	return 0;
 }
+EXPORT_SYMBOL(rsi_config_wowlan);
 #endif
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b8b5795..7f2f3af 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1257,6 +1257,35 @@ static int rsi_thaw(struct device *dev)
 	return 0;
 }
 
+static void rsi_shutdown(struct device *dev)
+{
+	struct sdio_func *pfunction = dev_to_sdio_func(dev);
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
+	struct rsi_91x_sdiodev *sdev =
+		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+#ifdef CONFIG_RSI_WOW
+	struct ieee80211_hw *hw = adapter->hw;
+	struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
+#endif
+
+	rsi_dbg(ERR_ZONE, "SDIO Bus shutdown =====>\n");
+
+#ifdef CONFIG_RSI_WOW
+	if (rsi_config_wowlan(adapter, wowlan))
+		rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
+#endif
+
+	rsi_sdio_disable_interrupts(sdev->pfunction);
+
+	if (sdev->write_fail)
+		rsi_dbg(INFO_ZONE, "###### Device is not ready #######\n");
+
+	if (rsi_set_sdio_pm_caps(adapter))
+		rsi_dbg(INFO_ZONE, "Setting power management caps failed\n");
+
+	rsi_dbg(INFO_ZONE, "***** RSI module shut down *****\n");
+}
+
 static int rsi_sdio_reinit_device(struct rsi_hw *adapter)
 {
 	struct rsi_91x_sdiodev *sdev = adapter->rsi_dev;
@@ -1333,6 +1362,7 @@ static struct sdio_driver rsi_driver = {
 #ifdef CONFIG_PM
 	.drv = {
 		.pm = &rsi_pm_ops,
+		.shutdown   = rsi_shutdown,
 	}
 #endif
 };
-- 
2.7.4
