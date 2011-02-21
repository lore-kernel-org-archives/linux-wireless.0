Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54824 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:20:45 -0500
Received: by gyb11 with SMTP id 11so65762gyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:20:44 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52206.806482.52979@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:50:30 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 22/23] ath9k_htc: Add debug code to print endpoint mapping
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 52c6af2..fc67c93 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -787,6 +787,7 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 	struct ath_hw *ah;
 	int error = 0;
 	struct ath_regulatory *reg;
+	char hw_name[64];
 
 	/* Bring up device */
 	error = ath9k_init_priv(priv, devid, product, drv_info);
@@ -827,6 +828,22 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 			goto err_world;
 	}
 
+	ath_dbg(common, ATH_DBG_CONFIG,
+		"WMI:%d, BCN:%d, CAB:%d, UAPSD:%d, MGMT:%d, "
+		"BE:%d, BK:%d, VI:%d, VO:%d\n",
+		priv->wmi_cmd_ep,
+		priv->beacon_ep,
+		priv->cab_ep,
+		priv->uapsd_ep,
+		priv->mgmt_ep,
+		priv->data_be_ep,
+		priv->data_bk_ep,
+		priv->data_vi_ep,
+		priv->data_vo_ep);
+
+	ath9k_hw_name(priv->ah, hw_name, sizeof(hw_name));
+	wiphy_info(hw->wiphy, "%s\n", hw_name);
+
 	ath9k_init_leds(priv);
 	ath9k_start_rfkill_poll(priv);
 
-- 
1.7.4.1

