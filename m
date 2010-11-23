Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47055 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0KWSn1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 13:43:27 -0500
Received: by ewy5 with SMTP id 5so2637664ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 10:43:26 -0800 (PST)
Date: Tue, 23 Nov 2010 20:43:18 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 03/30] ath5k: Stop PCU on reset
Message-ID: <20101123184318.GC4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Stop PCU receive logic (DRU) durring reset
 We need to be sure pcu is not active when trying to stop rx dma
 right now this is done on ath5k_reset (base.c) but later we are
 going to clean it up.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/reset.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 4f94a60..e4900e1 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -823,6 +823,11 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	mode = 0;
 
 	/*
+	 * Stop PCU
+	 */
+	ath5k_hw_stop_rx_pcu(ah);
+
+	/*
 	 * Stop DMA
 	 *
 	 * Note: If DMA didn't stop continue
