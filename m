Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:54423 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbaHVNSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 09:18:22 -0400
Received: by mail-ig0-f172.google.com with SMTP id h15so14885959igd.5
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 06:18:22 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, mickflemm@gmail.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/3] ath5k: remove redundant null check before kfree()
Date: Fri, 22 Aug 2014 09:18:02 -0400
Message-Id: <1408713482-7917-3-git-send-email-me@bobcopeland.com> (sfid-20140822_151827_550114_1DC2DEA5)
In-Reply-To: <1408713482-7917-1-git-send-email-me@bobcopeland.com>
References: <1408713482-7917-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kfree() null-checks its argument.
Found by smatch.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/attach.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 7106547..66b6366 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -351,8 +351,7 @@ void ath5k_hw_deinit(struct ath5k_hw *ah)
 {
 	__set_bit(ATH_STAT_INVALID, ah->status);
 
-	if (ah->ah_rf_banks != NULL)
-		kfree(ah->ah_rf_banks);
+	kfree(ah->ah_rf_banks);
 
 	ath5k_eeprom_detach(ah);
 
-- 
1.7.10.4

