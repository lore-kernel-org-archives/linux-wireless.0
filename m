Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52004 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaKFHye (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:34 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 18/21] ath9k_htc: set initial spec_config values
Date: Thu,  6 Nov 2014 08:53:35 +0100
Message-Id: <1415260418-14321-19-git-send-email-linux@rempel-privat.de> (sfid-20141106_085444_449480_471A8F4C)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use values provided by Ashish Patro <patro@cs.wisc.edu>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index f91b8e6..285d0ad 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -464,6 +464,14 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 
 	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	priv->ah->opmode = NL80211_IFTYPE_STATION;
+
+	priv->spec_priv.ah = priv->ah;
+	priv->spec_priv.spec_config.enabled = 0;
+	priv->spec_priv.spec_config.short_repeat = false;
+	priv->spec_priv.spec_config.count = 8;
+	priv->spec_priv.spec_config.endless = false;
+	priv->spec_priv.spec_config.period = 0x12;
+	priv->spec_priv.spec_config.fft_period = 0x02;
 }
 
 static int ath9k_init_priv(struct ath9k_htc_priv *priv,
-- 
1.9.1

