Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44296 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab0KHPDh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 10:03:37 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 07:03:25 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <stable@kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_hw: Fix memory leak on ath9k_hw_rf_alloc_ext_banks failure
Date: Mon, 8 Nov 2010 20:40:53 +0530
Message-ID: <1289229053-3698-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The allocated externel radio banks have to be freed in
case of ath9k_hw_rf_alloc_ext_banks failure.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cc13ee1..53f2543 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -484,6 +484,7 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
 			  "Failed allocating banks for "
 			  "external radio\n");
+		ath9k_hw_rf_free_ext_banks(ah);
 		return ecode;
 	}
 
-- 
1.7.3.2

