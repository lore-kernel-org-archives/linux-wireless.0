Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57293 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab1DSODR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 10:03:17 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 07:02:51 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V2 07/22] ath9k_hw: Don't do ani initialization for AR9340
Date: Tue, 19 Apr 2011 19:33:21 +0530
Message-ID: <1303221803-25230-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1303221803-25230-1-git-send-email-vasanth@atheros.com>
References: <1303221803-25230-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 013ffba..08e0aa9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -462,7 +462,7 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 		return ecode;
 	}
 
-	if (!AR_SREV_9100(ah)) {
+	if (!AR_SREV_9100(ah) && !AR_SREV_9340(ah)) {
 		ath9k_hw_ani_setup(ah);
 		ath9k_hw_ani_init(ah);
 	}
-- 
1.7.0.4

