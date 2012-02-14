Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7477 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2BNIj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 03:39:26 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20282.7611.998976.523140@gargle.gargle.HOWL> (sfid-20120214_093929_912848_AD276C87)
Date: Tue, 14 Feb 2012 14:09:23 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 4/4] ath9k: Fix descriptor length for AR9462
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX descriptor length is 24 for AR9462. Fix this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 09b8c9d..3ddf221 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -28,11 +28,14 @@ ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 	struct ar9003_txc *ads = ds;
 	int checksum = 0;
 	u32 val, ctl12, ctl17;
+	u8 desc_len;
+
+	desc_len = (AR_SREV_9462(ah) ? 0x18 : 0x17);
 
 	val = (ATHEROS_VENDOR_ID << AR_DescId_S) |
 	      (1 << AR_TxRxDesc_S) |
 	      (1 << AR_CtrlStat_S) |
-	      (i->qcu << AR_TxQcuNum_S) | 0x17;
+	      (i->qcu << AR_TxQcuNum_S) | desc_len;
 
 	checksum += val;
 	ACCESS_ONCE(ads->info) = val;
-- 
1.7.9

