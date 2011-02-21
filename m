Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43591 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:20:37 -0500
Received: by mail-gx0-f174.google.com with SMTP id 8so301890gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:20:37 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52199.90241.627771@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:50:23 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 21/23] ath9k_htc: Fix RX filters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Add ATH9K_RX_FILTER_UNCOMP_BA_BAR and ATH9K_RX_FILTER_PSPOLL
when mac80211 requires it.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 426620a..564ac13 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -407,7 +407,7 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 	 */
 	if (((ah->opmode != NL80211_IFTYPE_AP) &&
 	     (priv->rxfilter & FIF_PROMISC_IN_BSS)) ||
-	    (ah->opmode == NL80211_IFTYPE_MONITOR))
+	    ah->is_monitoring)
 		rfilt |= ATH9K_RX_FILTER_PROM;
 
 	if (priv->rxfilter & FIF_CONTROL)
@@ -419,8 +419,13 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 	else
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
-	if (conf_is_ht(&priv->hw->conf))
+	if (conf_is_ht(&priv->hw->conf)) {
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
+		rfilt |= ATH9K_RX_FILTER_UNCOMP_BA_BAR;
+	}
+
+	if (priv->rxfilter & FIF_PSPOLL)
+		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
 	return rfilt;
 
-- 
1.7.4.1

