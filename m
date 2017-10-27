Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:53586 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbdJ0LdN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 07:33:13 -0400
Received: by mail-pg0-f67.google.com with SMTP id s2so5070251pge.10
        for <linux-wireless@vger.kernel.org>; Fri, 27 Oct 2017 04:33:13 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v3 3/3] rsi: sdio: Add WOWLAN support for S5 shutdown state
Date: Fri, 27 Oct 2017 16:55:57 +0530
Message-Id: <1509103557-6215-4-git-send-email-amitkarwar@gmail.com> (sfid-20171027_133318_563146_187BC46D)
In-Reply-To: <1509103557-6215-1-git-send-email-amitkarwar@gmail.com>
References: <1509103557-6215-1-git-send-email-amitkarwar@gmail.com>
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
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 31 +++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 95eb5e6..36c63e9 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1822,6 +1822,7 @@ int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan)
 
 	return 0;
 }
+EXPORT_SYMBOL(rsi_config_wowlan);
 
 #ifdef CONFIG_PM
 static int rsi_mac80211_suspend(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 3f683d8..3288fb6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1218,12 +1218,11 @@ static int rsi_freeze(struct device *dev)
 	common = adapter->priv;
 	sdev = (struct rsi_91x_sdiodev *)adapter->rsi_dev;
 
-#ifdef CONFIG_RSI_WOW
 	if ((common->wow_flags & RSI_WOW_ENABLED) &&
 	    (common->wow_flags & RSI_WOW_NO_CONNECTION))
 		rsi_dbg(ERR_ZONE,
 			"##### Device can not wake up through WLAN\n");
-#endif
+
 	ret = rsi_sdio_disable_interrupts(pfunction);
 
 	if (sdev->write_fail)
@@ -1257,6 +1256,31 @@ static int rsi_thaw(struct device *dev)
 	return 0;
 }
 
+static void rsi_shutdown(struct device *dev)
+{
+	struct sdio_func *pfunction = dev_to_sdio_func(dev);
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
+	struct rsi_91x_sdiodev *sdev =
+		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
+	struct ieee80211_hw *hw = adapter->hw;
+	struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
+
+	rsi_dbg(ERR_ZONE, "SDIO Bus shutdown =====>\n");
+
+	if (rsi_config_wowlan(adapter, wowlan))
+		rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
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
 int rsi_sdio_reinit_device(struct rsi_hw *adapter)
 {
 	struct rsi_91x_sdiodev *sdev = adapter->rsi_dev;
@@ -1297,9 +1321,7 @@ static int rsi_restore(struct device *dev)
 	adapter->sc_nvifs = 0;
 	ieee80211_restart_hw(adapter->hw);
 
-#ifdef CONFIG_RSI_WOW
 	common->wow_flags = 0;
-#endif
 	common->iface_down = false;
 
 	rsi_dbg(INFO_ZONE, "RSI module restored\n");
@@ -1331,6 +1353,7 @@ static struct sdio_driver rsi_driver = {
 #ifdef CONFIG_PM
 	.drv = {
 		.pm = &rsi_pm_ops,
+		.shutdown   = rsi_shutdown,
 	}
 #endif
 };
-- 
2.7.4
