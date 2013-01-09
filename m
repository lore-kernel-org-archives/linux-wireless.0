Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54170 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757764Ab3AIMnP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 07:43:15 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 3.8 2/5] ath9k: fix double-free bug on beacon generate failure
Date: Wed,  9 Jan 2013 13:43:10 +0100
Message-Id: <1357735393-93564-2-git-send-email-nbd@openwrt.org> (sfid-20130109_134319_496505_5705E2FE)
In-Reply-To: <1357735393-93564-1-git-send-email-nbd@openwrt.org>
References: <1357735393-93564-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the next beacon is sent, the ath_buf from the previous run is reused.
If getting a new beacon from mac80211 fails, bf->bf_mpdu is not reset, yet
the skb is freed, leading to a double-free on the next beacon tx attempt,
resulting in a system crash.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 531fffd..4eb269d 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -147,6 +147,7 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		bf->bf_buf_addr = 0;
+		bf->bf_mpdu = NULL;
 	}
 
 	skb = ieee80211_beacon_get(hw, vif);
-- 
1.8.0.2

