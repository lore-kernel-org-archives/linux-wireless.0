Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:42380 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757172Ab2GKLVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 07:21:50 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, buytenh@wantstofly.org,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3] mwl8k: fix possible race condition in info->control.sta use
Date: Wed, 11 Jul 2012 13:21:41 +0200
Message-Id: <1342005701-5757-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120711_132154_057728_C982B558)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

info->control.sta may only be dereferenced during the drv_tx call otherwise
could lead to use-after-free bugs

Reported-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
fix wrog indentation. thx to David Miller
make sure *sta* function is called under RCU lock. thx to Christian Lamparter
---
 drivers/net/wireless/mwl8k.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cf7bdc6..224e03a 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1665,7 +1665,9 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 
 		info = IEEE80211_SKB_CB(skb);
 		if (ieee80211_is_data(wh->frame_control)) {
-			sta = info->control.sta;
+			rcu_read_lock();
+			sta = ieee80211_find_sta_by_ifaddr(hw, wh->addr1,
+							   wh->addr2);
 			if (sta) {
 				sta_info = MWL8K_STA(sta);
 				BUG_ON(sta_info == NULL);
@@ -1682,6 +1684,7 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 					sta_info->is_ampdu_allowed = true;
 				}
 			}
+			rcu_read_unlock();
 		}
 
 		ieee80211_tx_info_clear_status(info);
-- 
1.7.11.1

