Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61615 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbaKFHyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:38 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 19/21] ath9k_htc: trigger spectral scan on set_channel
Date: Thu,  6 Nov 2014 08:53:36 +0100
Message-Id: <1415260418-14321-20-git-send-email-linux@rempel-privat.de> (sfid-20141106_085455_700155_233AA3F3)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 994fff1..689ac99 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -314,6 +314,10 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	mod_timer(&priv->tx.cleanup_timer,
 		  jiffies + msecs_to_jiffies(ATH9K_HTC_TX_CLEANUP_INTERVAL));
 
+	/* perform spectral scan if requested. */
+	if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
+		     priv->spec_priv.spectral_mode == SPECTRAL_CHANSCAN)
+		ath9k_cmn_spectral_scan_trigger(common, &priv->spec_priv);
 err:
 	ath9k_htc_ps_restore(priv);
 	return ret;
-- 
1.9.1

