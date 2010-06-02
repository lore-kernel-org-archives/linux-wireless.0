Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57549 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0FBKWb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 06:22:31 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 03:22:31 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19462.12591.292464.298666@gargle.gargle.HOWL>
Date: Wed, 2 Jun 2010 15:53:43 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/8] ath9k_htc: Configure dual stream rates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rate information on the target has to be updated
for 2-stream devices, along with the correct chainmask.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 569b9c0..b7ce902 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -325,9 +325,9 @@ static int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv)
 	tcap.flags_ext = 0x80601000;
 	tcap.ampdu_limit = 0xffff0000;
 	tcap.ampdu_subframes = 20;
-	tcap.tx_chainmask_legacy = 1;
+	tcap.tx_chainmask_legacy = priv->ah->caps.tx_chainmask;
 	tcap.protmode = 1;
-	tcap.tx_chainmask = 1;
+	tcap.tx_chainmask = priv->ah->caps.tx_chainmask;
 
 	WMI_CMD_BUF(WMI_TARGET_IC_UPDATE_CMDID, &tcap);
 
@@ -365,6 +365,11 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 		trate->rates.ht_rates.rs_nrates = j;
 
 		caps = WLAN_RC_HT_FLAG;
+		if (priv->ah->caps.tx_chainmask != 1 &&
+		    ath9k_hw_getcapability(priv->ah, ATH9K_CAP_DS, 0, NULL)) {
+			if (sta->ht_cap.mcs.rx_mask[1])
+				caps |= WLAN_RC_DS_FLAG;
+		}
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			caps |= WLAN_RC_40_FLAG;
 		if (conf_is_ht40(&priv->hw->conf) &&
-- 
1.7.1

