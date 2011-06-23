Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64219 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab1FWOoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 10:44:37 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 07:44:00 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: make use of the gain_table_entry macro
Date: Thu, 23 Jun 2011 20:14:29 +0530
Message-ID: <1308840270-15920-1-git-send-email-mshajakhan@atheros.com> (sfid-20110623_164440_273395_E9B12275)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 8f6d11d..38b4cdc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -236,7 +236,7 @@ static void ar9003_paprd_get_gain_table(struct ath_hw *ah)
 	memset(entry, 0, sizeof(ah->paprd_gain_table_entries));
 	memset(index, 0, sizeof(ah->paprd_gain_table_index));
 
-	for (i = 0; i < 32; i++) {
+	for (i = 0; i < PAPRD_GAIN_TABLE_ENTRIES; i++) {
 		entry[i] = REG_READ(ah, reg);
 		index[i] = (entry[i] >> 24) & 0xff;
 		reg += 4;
@@ -727,7 +727,7 @@ int ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain)
 	desired_gain = ar9003_get_desired_gain(ah, chain, train_power);
 
 	gain_index = 0;
-	for (i = 0; i < 32; i++) {
+	for (i = 0; i < PAPRD_GAIN_TABLE_ENTRIES; i++) {
 		if (ah->paprd_gain_table_index[i] >= desired_gain)
 			break;
 		gain_index++;
-- 
1.7.0.4

