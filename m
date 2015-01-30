Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59031 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbbA3NdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:33:00 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgx-004FiR-M1
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:33:00 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 15/17] ath9k: Remove incorrect register macros
Date: Fri, 30 Jan 2015 19:05:35 +0530
Message-Id: <1422624937-4810-16-git-send-email-sujith@msujith.org> (sfid-20150130_143630_687366_2A368DF9)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

These macros are applicable to pre-AR9003 chips
and the addresses are different for the AR9003
family. Since they are unused anyway, remove them.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg_wow.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg_wow.h b/drivers/net/wireless/ath/ath9k/reg_wow.h
index 3dbe5db..780553a 100644
--- a/drivers/net/wireless/ath/ath9k/reg_wow.h
+++ b/drivers/net/wireless/ath/ath9k/reg_wow.h
@@ -23,14 +23,9 @@
 #define AR_WOW_BCN_TIMO                 0x8274
 #define AR_WOW_KEEP_ALIVE_TIMO          0x8278
 #define AR_WOW_KEEP_ALIVE               0x827c
-#define AR_WOW_US_SCALAR                0x8284
 #define AR_WOW_KEEP_ALIVE_DELAY         0x8288
 #define AR_WOW_PATTERN_MATCH            0x828c
-#define AR_WOW_PATTERN_OFF1             0x8290  /* pattern bytes 0 -> 3 */
-#define AR_WOW_PATTERN_OFF2             0x8294  /* pattern bytes 4 -> 7 */
 
-/* for AR9285 or later version of chips */
-#define AR_WOW_EXACT                    0x829c
 #define AR_WOW_LENGTH1                  0x8360
 #define AR_WOW_LENGTH2                  0X8364
 /* register to enable match for less than 256 bytes packets */
-- 
2.2.2

