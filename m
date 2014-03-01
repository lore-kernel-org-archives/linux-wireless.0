Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62085 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbaCAURZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:25 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 16/23] ath9k_htc: add ath9k_htc_beacon_init (but not use it)
Date: Sat,  1 Mar 2014 21:15:59 +0100
Message-Id: <1393704966-13985-17-git-send-email-linux@rempel-privat.de> (sfid-20140301_214709_142326_5321CB1D)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index fc16c10..b9b03c1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -62,6 +62,28 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 	}
 }
 
+/*
+ * Both nexttbtt and intval have to be in usecs.
+ */
+static void ath9k_htc_beacon_init(struct ath9k_htc_priv *priv,
+				  struct ath_beacon_config *conf,
+				  bool reset_tsf)
+{
+	struct ath_hw *ah = priv->ah;
+	int ret __attribute__ ((unused));
+	__be32 htc_imask = 0;
+	u8 cmd_rsp;
+
+	WMI_CMD(WMI_DISABLE_INTR_CMDID);
+	if (reset_tsf)
+		ath9k_hw_reset_tsf(ah);
+	ath9k_htc_beaconq_config(priv);
+	ath9k_hw_beaconinit(ah, conf->nexttbtt, conf->intval);
+	priv->beacon.bmisscnt = 0;
+	htc_imask = cpu_to_be32(ah->imask);
+	WMI_CMD_BUF(WMI_ENABLE_INTR_CMDID, &htc_imask);
+}
+
 static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 					struct ath_beacon_config *bss_conf)
 {
-- 
1.9.0

