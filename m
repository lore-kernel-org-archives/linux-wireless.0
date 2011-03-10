Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51178 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab1CJFf7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 00:35:59 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 21:35:36 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k_hw: Increase the wait count for nf load.
Date: Thu, 10 Mar 2011 11:05:43 +0530
Message-ID: <1299735343-915-3-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1299735343-915-2-git-send-email-vnatarajan@atheros.com>
References: <1299735343-915-1-git-send-email-vnatarajan@atheros.com>
 <1299735343-915-2-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Increasing the wait count makes the nf load pass in
most of the cases.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index b4a92a4..8649581 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -262,7 +262,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	 * since 250us often results in NF load timeout and causes deaf
 	 * condition during stress testing 12/12/2009
 	 */
-	for (j = 0; j < 1000; j++) {
+	for (j = 0; j < 10000; j++) {
 		if ((REG_READ(ah, AR_PHY_AGC_CONTROL) &
 		     AR_PHY_AGC_CONTROL_NF) == 0)
 			break;
@@ -278,7 +278,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	 * here, the baseband nf cal will just be capped by our present
 	 * noisefloor until the next calibration timer.
 	 */
-	if (j == 1000) {
+	if (j == 10000) {
 		ath_dbg(common, ATH_DBG_ANY,
 			"Timeout while waiting for nf to load: AR_PHY_AGC_CONTROL=0x%x\n",
 			REG_READ(ah, AR_PHY_AGC_CONTROL));
-- 
1.6.3.3

