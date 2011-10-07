Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51354 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867Ab1JGLsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 07:48:15 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH 08/14] ath9k_hw: Support fast channel change on 5GHz for AR9003 chips
Date: Fri, 7 Oct 2011 17:17:13 +0530
Message-ID: <1317988039-28632-8-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111007_134817_555507_8563E450)
In-Reply-To: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
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

