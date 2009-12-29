Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:62627 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbZL2O5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2009 09:57:45 -0500
Received: by yxe17 with SMTP id 17so10096396yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 29 Dec 2009 06:57:44 -0800 (PST)
From: tom.leiming@gmail.com
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] ath9k: fix ito64
Date: Tue, 29 Dec 2009 22:57:28 +0800
Message-Id: <1262098648-5033-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

The unit of sizeof() is byte instead of bit, so fix it.
The patch can fix debug output of some dma_addr_t variables.
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e2cef2f..1597a42 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -33,11 +33,11 @@ struct ath_node;
 
 /* Macro to expand scalars to 64-bit objects */
 
-#define	ito64(x) (sizeof(x) == 8) ?			\
+#define	ito64(x) (sizeof(x) == 1) ?			\
 	(((unsigned long long int)(x)) & (0xff)) :	\
-	(sizeof(x) == 16) ?				\
+	(sizeof(x) == 2) ?				\
 	(((unsigned long long int)(x)) & 0xffff) :	\
-	((sizeof(x) == 32) ?				\
+	((sizeof(x) == 4) ?				\
 	 (((unsigned long long int)(x)) & 0xffffffff) : \
 	 (unsigned long long int)(x))
 
-- 
1.6.2.5

