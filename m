Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27323 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbZG2Jm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 05:42:58 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 02:42:59 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 3/3] ath9k: Remove unused ath9k_hw_intrget()
Date: Wed, 29 Jul 2009 15:05:23 +0530
Message-ID: <1248860123-12079-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1248860123-12079-2-git-send-email-vasanth@atheros.com>
References: <1248860123-12079-1-git-send-email-vasanth@atheros.com>
 <1248860123-12079-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 -----
 drivers/net/wireless/ath/ath9k/hw.h |    1 -
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 431854c..7a0a6ae 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3152,11 +3152,6 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 	return true;
 }
 
-enum ath9k_int ath9k_hw_intrget(struct ath_hw *ah)
-{
-	return ah->mask_reg;
-}
-
 enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 {
 	u32 omask = ah->mask_reg;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 2e196df..93a8930 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -612,7 +612,6 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore);
 /* Interrupt Handling */
 bool ath9k_hw_intrpend(struct ath_hw *ah);
 bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked);
-enum ath9k_int ath9k_hw_intrget(struct ath_hw *ah);
 enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints);
 
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
-- 
1.5.5.1

