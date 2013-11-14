Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40216 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540Ab3KNUd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 15:33:29 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sgruszka@redhat.com
Subject: [PATCH] rt2x00: fix a crash bug in the HT descriptor handling fix
Date: Thu, 14 Nov 2013 21:33:15 +0100
Message-Id: <1384461195-37185-1-git-send-email-nbd@openwrt.org> (sfid-20131114_213336_891490_F13EC5A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit "rt2x00: fix HT TX descriptor settings regression"
assumes that the control parameter to rt2x00mac_tx is always non-NULL.
There is an internal call in rt2x00lib_bc_buffer_iter where NULL is
passed. Fix the resulting crash by adding an initialized dummy on-stack
ieee80211_tx_control struct.

Cc: stable@vger.kernel.org # 3.7+
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 080b1fc..9dd92a7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -181,6 +181,7 @@ static void rt2x00lib_autowakeup(struct work_struct *work)
 static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
+	struct ieee80211_tx_control control = {};
 	struct rt2x00_dev *rt2x00dev = data;
 	struct sk_buff *skb;
 
@@ -195,7 +196,7 @@ static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
 	 */
 	skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
 	while (skb) {
-		rt2x00mac_tx(rt2x00dev->hw, NULL, skb);
+		rt2x00mac_tx(rt2x00dev->hw, &control, skb);
 		skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
 	}
 }
-- 
1.8.3.4 (Apple Git-47)

