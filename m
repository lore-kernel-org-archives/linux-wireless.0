Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48163 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1ADIOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 03:14:04 -0500
Received: by pzk35 with SMTP id 35so1464547pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 00:14:03 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19746.54963.351883.504009@gargle.gargle.HOWL>
Date: Tue, 4 Jan 2011 13:43:39 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH] ath9k_hw: Fix RX handling for USB devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Commit "ath9k_hw: Abort rx if hw is not coming out of full sleep in reset"
uncondionally added aborting RX DMA in a HW reset, though it is a bit
unclear as to why this is needed.

Anyway, RX DMA is handled in the target for USB devices, and this would
interfere with normal operations (scanning etc.), so fix this.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4a44f71..1afb8bb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1214,7 +1214,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ah->txchainmask = common->tx_chainmask;
 	ah->rxchainmask = common->rx_chainmask;
 
-	if (!ah->chip_fullsleep) {
+	if ((common->bus_ops->ath_bus_type != ATH_USB) && !ah->chip_fullsleep) {
 		ath9k_hw_abortpcurecv(ah);
 		if (!ath9k_hw_stopdmarecv(ah)) {
 			ath_dbg(common, ATH_DBG_XMIT,
-- 
1.7.3.4

