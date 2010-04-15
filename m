Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14773 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419Ab0DOFbZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 01:31:25 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 14 Apr 2010 22:31:25 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19398.42102.609318.193999@gargle.gargle.HOWL>
Date: Thu, 15 Apr 2010 11:00:30 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/6] ath9k_hw: Relocate Opmode initialization
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Programming the opmode in the HW can be done
before the assoc_id and STA_ID registers are
setup. This helps ath9k_htc when multiple register
writes are used.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ab6794d..deb542f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1238,6 +1238,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_spur_mitigate_freq(ah, chan);
 	ah->eep_ops->set_board_values(ah, chan);
 
+	ath9k_hw_set_operating_mode(ah, ah->opmode);
+
 	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
 	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
 		  | macStaId1
@@ -1245,16 +1247,10 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		  | (ah->config.
 		     ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
 		  | ah->sta_id1_defaults);
-	ath9k_hw_set_operating_mode(ah, ah->opmode);
-
 	ath_hw_setbssidmask(common);
-
 	REG_WRITE(ah, AR_DEF_ANTENNA, saveDefAntenna);
-
 	ath9k_hw_write_associd(ah);
-
 	REG_WRITE(ah, AR_ISR, ~0);
-
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
 
 	r = ath9k_hw_rf_set_freq(ah, chan);
-- 
1.7.0.4

