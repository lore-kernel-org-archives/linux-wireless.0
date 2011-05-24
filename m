Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23274 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab1EXKAT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 06:00:19 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 02:59:48 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH v3] ath9k: wake up chip before initializing PAPRD table
Date: Tue, 24 May 2011 15:29:52 +0530
Message-ID: <1306231192-20638-1-git-send-email-mshajakhan@atheros.com> (sfid-20110524_120023_848673_3F6AD293)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

In PAPRD table initialization path we do some register read, so
make sure the chip is awake during that. Currently PAPRD is disabled.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a198ee3..bbdc1e8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -394,12 +394,14 @@ void ath_paprd_calibrate(struct work_struct *work)
 	if (!caldata)
 		return;
 
+	ath9k_ps_wakeup(sc);
+
 	if (ar9003_paprd_init_table(ah) < 0)
-		return;
+		goto fail_paprd;
 
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb)
-		return;
+		goto fail_paprd;
 
 	skb_put(skb, len);
 	memset(skb->data, 0, len);
@@ -411,7 +413,6 @@ void ath_paprd_calibrate(struct work_struct *work)
 	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
 	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
 
-	ath9k_ps_wakeup(sc);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
 		if (!(common->tx_chainmask & BIT(chain)))
 			continue;
-- 
1.7.0.4

