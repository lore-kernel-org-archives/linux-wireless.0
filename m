Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29515 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0FXJm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 05:42:58 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 02:42:58 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k: Restore ps state in ath_paprd_calibrate() upon failure to allocate skb
Date: Thu, 24 Jun 2010 02:42:45 -0700
Message-ID: <1277372566-22883-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1277372566-22883-1-git-send-email-vasanth@atheros.com>
References: <1277372566-22883-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6d57877..484d113 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -271,7 +271,7 @@ void ath_paprd_calibrate(struct work_struct *work)
 	ath9k_ps_wakeup(sc);
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb)
-		return;
+		goto fail_paprd;
 
 	tx_info = IEEE80211_SKB_CB(skb);
 
-- 
1.7.0.4

