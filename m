Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:61956 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbZHNF7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 01:59:33 -0400
Received: by rv-out-0506.google.com with SMTP id f6so389093rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 22:59:34 -0700 (PDT)
Date: Fri, 14 Aug 2009 11:29:27 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] ath9k: Set AR_WA for AR9287 as it improves consistency
	in throughput.
Message-ID: <20090814055927.GB3541@myhost.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1d2cc25..4f58112 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3073,7 +3073,7 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
 	if (ah->config.pcie_waen) {
 		REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
 	} else {
-		if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
+		if (AR_SREV_9285(ah) || AR_SREV_9271(ah) || AR_SREV_9287(ah))
 			REG_WRITE(ah, AR_WA, AR9285_WA_DEFAULT);
 		/*
 		 * On AR9280 chips bit 22 of 0x4004 needs to be set to
-- 
1.6.0.1

