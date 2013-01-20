Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39939 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab3ATRwK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 12:52:10 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 8/8] ath9k_hw: remove a useless WARN_ON
Date: Sun, 20 Jan 2013 18:51:59 +0100
Message-Id: <1358704319-81749-8-git-send-email-nbd@openwrt.org> (sfid-20130120_185216_571085_314AF073)
In-Reply-To: <1358704319-81749-7-git-send-email-nbd@openwrt.org>
References: <1358704319-81749-1-git-send-email-nbd@openwrt.org>
 <1358704319-81749-2-git-send-email-nbd@openwrt.org>
 <1358704319-81749-3-git-send-email-nbd@openwrt.org>
 <1358704319-81749-4-git-send-email-nbd@openwrt.org>
 <1358704319-81749-5-git-send-email-nbd@openwrt.org>
 <1358704319-81749-6-git-send-email-nbd@openwrt.org>
 <1358704319-81749-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

&ah->curchan->ani can never be NULL

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index a9218a1..7ecd40f 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -419,9 +419,6 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 		return;
 
 	aniState = &ah->curchan->ani;
-	if (WARN_ON(!aniState))
-		return;
-
 	if (!ath9k_hw_ani_read_counters(ah))
 		return;
 
-- 
1.8.0.2

