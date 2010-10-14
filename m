Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25466 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab0JNFOg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 01:14:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 22:14:26 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: set probe request rx filter
Date: Thu, 14 Oct 2010 10:50:26 +0530
Message-ID: <1287033626-4233-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables to receive probe request frames on p2p
client mode.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f12591f..55c8086 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1454,6 +1454,7 @@ out:
 	FIF_PSPOLL |				\
 	FIF_OTHER_BSS |				\
 	FIF_BCN_PRBRESP_PROMISC |		\
+	FIF_PROBE_REQ |				\
 	FIF_FCSFAIL)
 
 static void ath9k_htc_configure_filter(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index c99600a..3d19b5b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -369,8 +369,7 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 		| ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
 		| ATH9K_RX_FILTER_MCAST;
 
-	/* If not a STA, enable processing of Probe Requests */
-	if (ah->opmode != NL80211_IFTYPE_STATION)
+	if (priv->rxfilter & FIF_PROBE_REQ)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
 	/*
-- 
1.7.3.1

