Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40723 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1DZKkL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 06:40:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 03:39:44 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] ath9k_hw: Enable generic timer interrupt.
Date: Tue, 26 Apr 2011 10:39:54 +0530
Message-ID: <1303794595-4031-3-git-send-email-vnatarajan@atheros.com> (sfid-20110426_124016_453846_1CA5A430)
In-Reply-To: <1303794595-4031-2-git-send-email-vnatarajan@atheros.com>
References: <1303794595-4031-1-git-send-email-vnatarajan@atheros.com>
 <1303794595-4031-2-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generic timer interrupt was not triggered unless autosleep was
disabled. Since autosleep is enabled in the newer chipsets,
enable generic timer for using with bt coex logic.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index c8a4ced..9cf7a7d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -885,6 +885,9 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 			mask |= AR_IMR_GENTMR;
 	}
 
+	if (ints & ATH9K_INT_GENTIMER)
+		mask |= AR_IMR_GENTMR;
+
 	if (ints & (ATH9K_INT_BMISC)) {
 		mask |= AR_IMR_BCNMISC;
 		if (ints & ATH9K_INT_TIM)
-- 
1.7.1

