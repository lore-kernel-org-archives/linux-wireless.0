Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51944 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaDUXPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 19:15:07 -0400
Received: by mail-pa0-f47.google.com with SMTP id lj1so4231540pab.34
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 16:15:07 -0700 (PDT)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, nbd@openwrt.org
Subject: [PATCH 2/2] ath9k: add a recv budget
Date: Mon, 21 Apr 2014 16:14:57 -0700
Message-Id: <1398122097-23544-2-git-send-email-tharvey@gateworks.com> (sfid-20140422_011540_554938_BD80F542)
In-Reply-To: <1398122097-23544-1-git-send-email-tharvey@gateworks.com>
References: <1398122097-23544-1-git-send-email-tharvey@gateworks.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement a recv budget so that in cases of high traffic we still allow other
taskets to get processed.

Without this, we can encounter a host of issues during high wireless traffic
reception depending on system load including rcu stall's detected (ARM),
soft lockups, failure to service critical tasks such as watchdog resets,
and triggering of the tx stuck tasklet.

The same thing was proposed previously by Ben:
 http://www.spinics.net/lists/linux-wireless/msg112891.html

The only difference here is that I make sure only processed packets are counted
in the budget by checking at the end of the rx loop.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index e77a253..19df969 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -975,6 +975,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	u64 tsf = 0;
 	unsigned long flags;
 	dma_addr_t new_buf_addr;
+	unsigned int budget = 512;
 
 	if (edma)
 		dma_type = DMA_BIDIRECTIONAL;
@@ -1121,6 +1122,9 @@ requeue:
 			if (!flush)
 				ath9k_hw_rxena(ah);
 		}
+
+		if (!budget--)
+			break;
 	} while (1);
 
 	if (!(ah->imask & ATH9K_INT_RXEOL)) {
-- 
1.8.3.2

