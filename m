Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:45347 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2H0OSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 10:18:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Subject: [PATCH] Revert "ath6kl: protect firmware from excessive WoW pattern length"
Date: Mon, 27 Aug 2012 17:12:01 +0300
Message-Id: <1346076721-32081-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120827_161813_834391_140EFA67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit d9070af7d48985324c1896a4758230c2bfe59f3c.

Thomas requested this in 20120820181837.GA4695@pista as Johannes
pointed out that cfg80211 already checks this.
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index fb20ff6..f5300c3 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1876,9 +1876,6 @@ static int ath6kl_wow_usr(struct ath6kl *ar, struct ath6kl_vif *vif,
 	/* Configure the patterns that we received from the user. */
 	for (i = 0; i < wow->n_patterns; i++) {
 
-		if (wow->patterns[i].pattern_len > WOW_MASK_SIZE)
-			return -EINVAL;
-
 		/*
 		 * Convert given nl80211 specific mask value to equivalent
 		 * driver specific mask value and send it to the chip along
-- 
1.7.1

