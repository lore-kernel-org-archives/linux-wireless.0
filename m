Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63410 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbZLWIfe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 03:35:34 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 00:35:34 -0800
From: vasanth <vasanth@atheros.com>
To: <greg@kroah.com>, <stable@kernel.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 1/2] ath9k_hw: Fix possible OOB array indexing in gen_timer_index[] on 64-bit
Date: Wed, 23 Dec 2009 13:54:35 +0530
Message-ID: <1261556676-6081-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

commit c90017dd43f0cdb42134b9229761e8be02bcd524 upstream

debruijn32 (0x077CB531) is used to index gen_timer_index[]
which is an array of 32 u32. Having debruijn32 as unsigned
long on a 64-bit platform  will result in indexing more than 32
in gen_timer_index[] and there by causing a crash. Make it
unsigned to fix this issue.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 57f1463..ff4383b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -408,7 +408,7 @@ struct ath9k_hw_version {
  * Using de Bruijin sequence to to look up 1's index in a 32 bit number
  * debruijn32 = 0000 0111 0111 1100 1011 0101 0011 0001
  */
-#define debruijn32 0x077CB531UL
+#define debruijn32 0x077CB531U
 
 struct ath_gen_timer_configuration {
 	u32 next_addr;
-- 
1.5.5.1

