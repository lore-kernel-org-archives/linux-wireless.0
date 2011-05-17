Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57703 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1EQHNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 03:13:23 -0400
Received: by mail-pw0-f46.google.com with SMTP id 15so151989pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 00:13:23 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19922.8120.180103.210221@gargle.gargle.HOWL> (sfid-20110517_091326_572690_CAD7A301)
Date: Tue, 17 May 2011 12:41:52 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 4/8] ath9k_htc: Fix RX filter calculation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Choose the MY_BEACON filter only in case of a single interface.
Also, set the ATH9K_RX_FILTER_MCAST_BCAST_ALL filter in case
of interfaces.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index a898dac..0ecc242 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -875,6 +875,7 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
 	if ((ah->opmode == NL80211_IFTYPE_STATION) &&
+	    (priv->nvifs <= 1) &&
 	    !(priv->rxfilter & FIF_BCN_PRBRESP_PROMISC))
 		rfilt |= ATH9K_RX_FILTER_MYBEACON;
 	else
@@ -888,6 +889,9 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 	if (priv->rxfilter & FIF_PSPOLL)
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
+	if (priv->nvifs > 1)
+		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
+
 	return rfilt;
 
 #undef RX_FILTER_PRESERVE
-- 
1.7.5.1

