Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34946 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbbCIIqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 04:46:32 -0400
Received: from [117.207.78.0] (port=10150 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YUtKZ-0033Ry-N0
	for linux-wireless@vger.kernel.org; Mon, 09 Mar 2015 04:46:32 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] ath9k: Fix RTT chainmask usage
Date: Mon,  9 Mar 2015 14:20:10 +0530
Message-Id: <1425891010-21522-6-git-send-email-sujith@msujith.org> (sfid-20150309_094641_380611_2FC24785)
In-Reply-To: <1425891010-21522-1-git-send-email-sujith@msujith.org>
References: <1425891010-21522-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since the RTT registers need to be configured for all
valid chains irrespective of the runtime chainmask,
use the actual chainmask of the chip.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_rtt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_rtt.c b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
index 9344188..e4d11fa 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
@@ -106,7 +106,7 @@ void ar9003_hw_rtt_load_hist(struct ath_hw *ah)
 	int chain, i;
 
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
-		if (!(ah->rxchainmask & (1 << chain)))
+		if (!(ah->caps.rx_chainmask & (1 << chain)))
 			continue;
 		for (i = 0; i < MAX_RTT_TABLE_ENTRY; i++) {
 			ar9003_hw_rtt_load_hist_entry(ah, chain, i,
@@ -171,7 +171,7 @@ void ar9003_hw_rtt_fill_hist(struct ath_hw *ah)
 	int chain, i;
 
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
-		if (!(ah->rxchainmask & (1 << chain)))
+		if (!(ah->caps.rx_chainmask & (1 << chain)))
 			continue;
 		for (i = 0; i < MAX_RTT_TABLE_ENTRY; i++) {
 			ah->caldata->rtt_table[chain][i] =
@@ -193,7 +193,7 @@ void ar9003_hw_rtt_clear_hist(struct ath_hw *ah)
 	int chain, i;
 
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
-		if (!(ah->rxchainmask & (1 << chain)))
+		if (!(ah->caps.rx_chainmask & (1 << chain)))
 			continue;
 		for (i = 0; i < MAX_RTT_TABLE_ENTRY; i++)
 			ar9003_hw_rtt_load_hist_entry(ah, chain, i, 0);
-- 
2.3.1

