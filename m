Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50422 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0CDN3q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 08:29:46 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 04 Mar 2010 05:29:46 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] ar9170: Fix illegal kfree_skb
Date: Thu, 4 Mar 2010 18:58:33 +0530
Message-ID: <1267709313-2222-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ar9170/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index f4650fc..d47450a 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2517,7 +2517,7 @@ void *ar9170_alloc(size_t priv_size)
 
 	skb = __dev_alloc_skb(AR9170_MAX_RX_BUFFER_SIZE, GFP_KERNEL);
 	if (!skb)
-		goto err_nomem;
+		goto err_out;
 
 	hw = ieee80211_alloc_hw(priv_size, &ar9170_ops);
 	if (!hw)
@@ -2574,6 +2574,7 @@ void *ar9170_alloc(size_t priv_size)
 
 err_nomem:
 	kfree_skb(skb);
+err_out:
 	return ERR_PTR(-ENOMEM);
 }
 
-- 
1.7.0.1

