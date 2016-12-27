Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47822 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752694AbcL0MC1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Dec 2016 07:02:27 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] ath5k: drop bogus warning on drv_set_key with unsupported cipher
Date: Tue, 27 Dec 2016 12:16:09 +0100
Message-Id: <20161227111609.11113-1-nbd@nbd.name> (sfid-20161227_130230_536455_5E694BE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simply return -EOPNOTSUPP instead.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath5k/mac80211-ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index dc44cfef7517..16e052d02c94 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -502,8 +502,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			break;
 		return -EOPNOTSUPP;
 	default:
-		WARN_ON(1);
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	mutex_lock(&ah->lock);
-- 
2.11.0
