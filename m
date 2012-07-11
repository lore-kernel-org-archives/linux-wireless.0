Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:42081 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382Ab2GKFcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 01:32:43 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, buytenh@wantstofly.org,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v2] mwl8k: fix possible race condition in info->control.sta use
Date: Wed, 11 Jul 2012 07:32:34 +0200
Message-Id: <1341984754-76477-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120711_073248_103349_746EB1D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

info->control.sta may only be dereferenced during the drv_tx call otherwise
could lead to use-after-free bugs

Reported-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
fix wrog indentation. thx to David Miller
---
 drivers/net/wireless/mwl8k.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index df6c6f1..eec5cd1 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1667,7 +1667,8 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw,
 
 		info = IEEE80211_SKB_CB(skb);
 		if (ieee80211_is_data(wh->frame_control)) {
-			sta = info->control.sta;
+			sta = ieee80211_find_sta_by_ifaddr(hw, wh->addr1,
+							   wh->addr2);
 			if (sta) {
 				sta_info = MWL8K_STA(sta);
 				BUG_ON(sta_info == NULL);
-- 
1.7.11.1

