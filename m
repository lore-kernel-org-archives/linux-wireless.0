Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49580 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab1IOID1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 04:03:27 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH] ath9k: fix setting the IEEE80211_TX_CTL_CLEAR_PS_FILT flag
Date: Thu, 15 Sep 2011 10:03:12 +0200
Message-Id: <1316073792-45875-1-git-send-email-nbd@openwrt.org> (sfid-20110915_100332_316718_2FC0397F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver inserts padding between the 802.11 header and data, it
needs to set the hdr variable to the new header location.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2c6aefa..31a01b5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1902,6 +1902,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 			skb_push(skb, padsize);
 			memmove(skb->data, skb->data + padsize, padpos);
+			hdr = (struct ieee80211_hdr *) skb->data;
 		}
 	}
 
-- 
1.7.3.2

