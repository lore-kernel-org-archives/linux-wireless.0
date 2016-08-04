Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45631 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbcHDH4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2016 03:56:04 -0400
From: miaoqing@codeaurora.org
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	s.l-h@gmx.de, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH] ath9k: fix AR5416 access GPIO warning
Date: Thu,  4 Aug 2016 15:48:34 +0800
Message-Id: <1470296914-9152-1-git-send-email-miaoqing@codeaurora.org> (sfid-20160804_095627_621437_BB7B0F45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

The warning was seen on AR5416 chip, which invoke ath9k_hw_gio_get()
before the GPIO initialized correctly.

    WARNING: CPU: 1 PID: 1159 at ~/drivers/net/wireless/ath/ath9k/hw.c:2776 ath9k_hw_gpio_get+0x148/0x1a0 [ath9k_hw]
    ...
    CPU: 1 PID: 1159 Comm: systemd-udevd Not tainted 4.7.0-rc7-aptosid-amd64 #1 aptosid 4.7~rc7-1~git92.slh.3
    Hardware name:                  /DH67CL, BIOS BLH6710H.86A.0160.2012.1204.1156 12/04/2012
      0000000000000286 00000000f912d633 ffffffff81290fd3 0000000000000000
      0000000000000000 ffffffff81063fd4 ffff88040c6dc018 0000000000000000
      0000000000000002 0000000000000000 0000000000000100 ffff88040c6dc018
    Call Trace:
      [<ffffffff81290fd3>] ? dump_stack+0x5c/0x79
      [<ffffffff81063fd4>] ? __warn+0xb4/0xd0
      [<ffffffffa0668fb8>] ? ath9k_hw_gpio_get+0x148/0x1a0 [ath9k_hw]

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d1d0c06..14b13f0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2482,6 +2482,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		return -EINVAL;
 	}
 
+	ath9k_gpio_cap_init(ah);
+
 	if (AR_SREV_9485(ah) ||
 	    AR_SREV_9285(ah) ||
 	    AR_SREV_9330(ah) ||
@@ -2531,8 +2533,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
 
-	ath9k_gpio_cap_init(ah);
-
 	if (AR_SREV_9160_10_OR_LATER(ah) || AR_SREV_9100(ah))
 		pCap->rts_aggr_limit = ATH_AMPDU_LIMIT_MAX;
 	else
-- 
1.9.1

