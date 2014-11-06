Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61843 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaKFHyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:47 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 21/21] ath9k_htc: add spectral scan debug interface
Date: Thu,  6 Nov 2014 08:53:38 +0100
Message-Id: <1415260418-14321-22-git-send-email-linux@rempel-privat.de> (sfid-20141106_085452_136651_AD2EF98F)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h           | 2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c | 6 ++++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c  | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 1f019aa..b34acde 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -626,8 +626,10 @@ int ath9k_htc_resume(struct htc_target *htc_handle);
 #endif
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 int ath9k_htc_init_debug(struct ath_hw *ah);
+void ath9k_htc_deinit_debug(struct ath9k_htc_priv *priv);
 #else
 static inline int ath9k_htc_init_debug(struct ath_hw *ah) { return 0; };
+static inline void ath9k_htc_deinit_debug(struct ath9k_htc_priv *priv) { return 0; };
 #endif /* CONFIG_ATH9K_HTC_DEBUGFS */
 
 #endif /* HTC_H */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 8b529e4..8cef1ed 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -490,6 +490,10 @@ void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
 	WARN_ON(i != ATH9K_HTC_SSTATS_LEN);
 }
 
+void ath9k_htc_deinit_debug(struct ath9k_htc_priv *priv)
+{
+	ath9k_cmn_spectral_deinit_debug(&priv->spec_priv);
+}
 
 int ath9k_htc_init_debug(struct ath_hw *ah)
 {
@@ -501,6 +505,8 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 	if (!priv->debug.debugfs_phy)
 		return -ENOMEM;
 
+	ath9k_cmn_spectral_init_debug(&priv->spec_priv, priv->debug.debugfs_phy);
+
 	debugfs_create_file("tgt_int_stats", S_IRUSR, priv->debug.debugfs_phy,
 			    priv, &fops_tgt_int_stats);
 	debugfs_create_file("tgt_tx_stats", S_IRUSR, priv->debug.debugfs_phy,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 285d0ad..ad8f1dc 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -102,6 +102,7 @@ static void ath9k_deinit_device(struct ath9k_htc_priv *priv)
 
 	wiphy_rfkill_stop_polling(hw->wiphy);
 	ath9k_deinit_leds(priv);
+	ath9k_htc_deinit_debug(priv);
 	ieee80211_unregister_hw(hw);
 	ath9k_rx_cleanup(priv);
 	ath9k_tx_cleanup(priv);
-- 
1.9.1

