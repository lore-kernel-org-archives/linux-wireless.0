Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19124 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab1EXFBa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 01:01:30 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 22:00:59 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: wake up chip before initializing PAPRD table
Date: Tue, 24 May 2011 10:31:03 +0530
Message-ID: <1306213263-4028-1-git-send-email-mshajakhan@atheros.com> (sfid-20110524_070133_196011_AF61EF49)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

in PAPRD table initialization path we have register read. so make sure
that the chip is awake. currently PAPRD is disabled.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a198ee3..af8aa9e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -394,6 +394,8 @@ void ath_paprd_calibrate(struct work_struct *work)
 	if (!caldata)
 		return;
 
+	ath9k_ps_wakeup(sc);
+
 	if (ar9003_paprd_init_table(ah) < 0)
 		return;
 
@@ -411,7 +413,6 @@ void ath_paprd_calibrate(struct work_struct *work)
 	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
 	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
 
-	ath9k_ps_wakeup(sc);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
 		if (!(common->tx_chainmask & BIT(chain)))
 			continue;
-- 
1.7.0.4

