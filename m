Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:39663
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752859AbbG3MOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 08:14:53 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: make local->tx_headroom a multiple of 4
Date: Thu, 30 Jul 2015 14:14:47 +0200
Message-Id: <1438258487-74594-1-git-send-email-nbd@openwrt.org> (sfid-20150730_141458_113048_3D788C89)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ensures that mac80211 generated management frames and beacons are
aligned before being passed to the driver

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ff79a13..e8b9224 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1034,6 +1034,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	 */
 	local->tx_headroom = max_t(unsigned int , local->hw.extra_tx_headroom,
 				   IEEE80211_TX_STATUS_HEADROOM);
+	local->tx_headroom = ALIGN(local->tx_headroom, 4);
 
 	debugfs_hw_add(local);
 
-- 
2.2.2

