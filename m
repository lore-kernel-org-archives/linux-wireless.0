Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43152 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1JJFvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 01:51:36 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH v2 08/13] ath9k_hw: Support fast channel change on 5GHz for AR9003 chips
Date: Mon, 10 Oct 2011 11:21:13 +0530
Message-ID: <1318225878-7283-8-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111010_075139_017316_9BDBA198)
In-Reply-To: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k_hw: Improve fast channel change for AR9003 chips"
fixes the fast channel change issue for AR9003 chips that was
originally observed in AR9382 chip. Hence enabling fastcc support
again for 11A channel for AR9003 chips.

Cc: Paul Stewart <pstew@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 067f968..9c60132 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1534,8 +1534,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 	ah->noise = ath9k_hw_getchan_noise(ah, chan);
 
-	if ((AR_SREV_9280(ah) && common->bus_ops->ath_bus_type == ATH_PCI) ||
-	    (AR_SREV_9300_20_OR_LATER(ah) && IS_CHAN_5GHZ(chan)))
+	if (AR_SREV_9280(ah) && common->bus_ops->ath_bus_type == ATH_PCI)
 		bChannelChange = false;
 
 	if (bChannelChange &&
-- 
1.7.7

