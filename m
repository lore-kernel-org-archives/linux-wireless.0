Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56006 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867AbaEKIFX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:05:23 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 10/10] ath9k_htc: use ath9k_cmn_debug_phy_err
Date: Sun, 11 May 2014 10:04:40 +0200
Message-Id: <1399795480-7459-11-git-send-email-linux@rempel-privat.de> (sfid-20140511_100539_849002_4F556460)
In-Reply-To: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
References: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c | 44 ++++----------------------
 1 file changed, 6 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index bc7b551..8b529e4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -248,13 +248,9 @@ void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 	ath9k_cmn_debug_stat_rx(&priv->debug.rx_stats, rs);
 }
 
-static ssize_t read_file_recv(struct file *file, char __user *user_buf,
+static ssize_t read_file_skb_rx(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
-#define PHY_ERR(s, p)							\
-	len += scnprintf(buf + len, size - len, "%20s : %10u\n", s,	\
-			 priv->debug.rx_stats.phy_err_stats[p]);
-
 	struct ath9k_htc_priv *priv = file->private_data;
 	char *buf;
 	unsigned int len = 0, size = 1500;
@@ -274,33 +270,6 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 			 "%20s : %10u\n", "SKBs Dropped",
 			 priv->debug.skbrx_stats.skb_dropped);
 
-	PHY_ERR("UNDERRUN", ATH9K_PHYERR_UNDERRUN);
-	PHY_ERR("TIMING", ATH9K_PHYERR_TIMING);
-	PHY_ERR("PARITY", ATH9K_PHYERR_PARITY);
-	PHY_ERR("RATE", ATH9K_PHYERR_RATE);
-	PHY_ERR("LENGTH", ATH9K_PHYERR_LENGTH);
-	PHY_ERR("RADAR", ATH9K_PHYERR_RADAR);
-	PHY_ERR("SERVICE", ATH9K_PHYERR_SERVICE);
-	PHY_ERR("TOR", ATH9K_PHYERR_TOR);
-	PHY_ERR("OFDM-TIMING", ATH9K_PHYERR_OFDM_TIMING);
-	PHY_ERR("OFDM-SIGNAL-PARITY", ATH9K_PHYERR_OFDM_SIGNAL_PARITY);
-	PHY_ERR("OFDM-RATE", ATH9K_PHYERR_OFDM_RATE_ILLEGAL);
-	PHY_ERR("OFDM-LENGTH", ATH9K_PHYERR_OFDM_LENGTH_ILLEGAL);
-	PHY_ERR("OFDM-POWER-DROP", ATH9K_PHYERR_OFDM_POWER_DROP);
-	PHY_ERR("OFDM-SERVICE", ATH9K_PHYERR_OFDM_SERVICE);
-	PHY_ERR("OFDM-RESTART", ATH9K_PHYERR_OFDM_RESTART);
-	PHY_ERR("FALSE-RADAR-EXT", ATH9K_PHYERR_FALSE_RADAR_EXT);
-	PHY_ERR("CCK-TIMING", ATH9K_PHYERR_CCK_TIMING);
-	PHY_ERR("CCK-HEADER-CRC", ATH9K_PHYERR_CCK_HEADER_CRC);
-	PHY_ERR("CCK-RATE", ATH9K_PHYERR_CCK_RATE_ILLEGAL);
-	PHY_ERR("CCK-SERVICE", ATH9K_PHYERR_CCK_SERVICE);
-	PHY_ERR("CCK-RESTART", ATH9K_PHYERR_CCK_RESTART);
-	PHY_ERR("CCK-LENGTH", ATH9K_PHYERR_CCK_LENGTH_ILLEGAL);
-	PHY_ERR("CCK-POWER-DROP", ATH9K_PHYERR_CCK_POWER_DROP);
-	PHY_ERR("HT-CRC", ATH9K_PHYERR_HT_CRC_ERROR);
-	PHY_ERR("HT-LENGTH", ATH9K_PHYERR_HT_LENGTH_ILLEGAL);
-	PHY_ERR("HT-RATE", ATH9K_PHYERR_HT_RATE_ILLEGAL);
-
 	if (len > size)
 		len = size;
 
@@ -308,12 +277,10 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	kfree(buf);
 
 	return retval;
-
-#undef PHY_ERR
 }
 
-static const struct file_operations fops_recv = {
-	.read = read_file_recv,
+static const struct file_operations fops_skb_rx = {
+	.read = read_file_skb_rx,
 	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
@@ -542,10 +509,11 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 			    priv, &fops_tgt_rx_stats);
 	debugfs_create_file("xmit", S_IRUSR, priv->debug.debugfs_phy,
 			    priv, &fops_xmit);
-	debugfs_create_file("phy_err", S_IRUSR, priv->debug.debugfs_phy,
-			    priv, &fops_recv);
+	debugfs_create_file("skb_rx", S_IRUSR, priv->debug.debugfs_phy,
+			    priv, &fops_skb_rx);
 
 	ath9k_cmn_debug_recv(priv->debug.debugfs_phy, &priv->debug.rx_stats);
+	ath9k_cmn_debug_phy_err(priv->debug.debugfs_phy, &priv->debug.rx_stats);
 
 	debugfs_create_file("slot", S_IRUSR, priv->debug.debugfs_phy,
 			    priv, &fops_slot);
-- 
1.9.1

