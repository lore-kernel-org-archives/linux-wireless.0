Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53188 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929AbaEKIFk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:05:40 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 08/10] ath9k_htc: use ath9k_cmn_debug_recv
Date: Sun, 11 May 2014 10:04:38 +0200
Message-Id: <1399795480-7459-9-git-send-email-linux@rempel-privat.de> (sfid-20140511_100559_319409_0A487840)
In-Reply-To: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
References: <1399795480-7459-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index a71f5f4..bc7b551 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -542,8 +542,11 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 			    priv, &fops_tgt_rx_stats);
 	debugfs_create_file("xmit", S_IRUSR, priv->debug.debugfs_phy,
 			    priv, &fops_xmit);
-	debugfs_create_file("recv", S_IRUSR, priv->debug.debugfs_phy,
+	debugfs_create_file("phy_err", S_IRUSR, priv->debug.debugfs_phy,
 			    priv, &fops_recv);
+
+	ath9k_cmn_debug_recv(priv->debug.debugfs_phy, &priv->debug.rx_stats);
+
 	debugfs_create_file("slot", S_IRUSR, priv->debug.debugfs_phy,
 			    priv, &fops_slot);
 	debugfs_create_file("queue", S_IRUSR, priv->debug.debugfs_phy,
-- 
1.9.1

