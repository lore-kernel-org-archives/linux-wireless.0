Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56586 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753171AbeBFXF2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Feb 2018 18:05:28 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  break out of irq handler after 5 jiffies
Date: Tue,  6 Feb 2018 15:05:24 -0800
Message-Id: <1517958324-13536-1-git-send-email-greearb@candelatech.com> (sfid-20180207_000532_065672_AC953DE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

In case where the system is sluggish, we should probably break out
early.  Maybe this will fix issues where the OS thinks the IRQ handler
is not responding and disables the IRQ because 'nobody cared'

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b90ea2b..274814c 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1084,6 +1084,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	dma_addr_t new_buf_addr;
 	unsigned int budget = 512;
 	struct ieee80211_hdr *hdr;
+	unsigned long expires_jiffies = jiffies + 5;
 
 	if (edma)
 		dma_type = DMA_BIDIRECTIONAL;
@@ -1241,6 +1242,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 		if (!budget--)
 			break;
+
+		if (time_is_before_jiffies(expires_jiffies))
+			break;
 	} while (1);
 
 	if (!(ah->imask & ATH9K_INT_RXEOL)) {
-- 
2.4.11
