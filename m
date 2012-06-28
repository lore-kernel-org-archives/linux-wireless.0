Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:55811 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118Ab2F1Vtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 17:49:52 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, thomas@net.t-labs.tu-berlin.de,
	nbd@nbd.name
Subject: [PATCH] mwl8k: fix possible race condition in info->control.sta use
Date: Thu, 28 Jun 2012 14:39:51 -0700
Message-Id: <1340919591-53246-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120628_235041_913399_F4501C85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

info->control.sta may only be dereferenced during the drv_tx call otherwise
could lead to use-after-free bugs

Reported-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/mwl8k.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cf7bdc6..1404373 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1665,7 +1665,8 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 
 		info = IEEE80211_SKB_CB(skb);
 		if (ieee80211_is_data(wh->frame_control)) {
-			sta = info->control.sta;
+			sta = ieee80211_find_sta_by_ifaddr(hw, wh->addr1,
+								wh->addr2);
 			if (sta) {
 				sta_info = MWL8K_STA(sta);
 				BUG_ON(sta_info == NULL);
-- 
1.7.10.4

