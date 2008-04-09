Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:58616 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbYDIPCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 11:02:04 -0400
From: Daniel Wagner <wagi@monom.org>
To: linux-wireless@vger.kernel.org
Cc: Daniel Wagner <wagi@monom.org>
Subject: [PATCH] rt61pci: rt61pci_beacon_update do not free skb twice
Date: Wed,  9 Apr 2008 16:29:01 +0200
Message-Id: <1207751341-27611-1-git-send-email-wagi@monom.org> (sfid-20080409_160212_498076_5EF69EC1)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The layer above will free the skb in an error case.

Signed-off-by: Daniel Wagner <wagi@monom.org>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 1cb056b..468a31c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2379,10 +2379,8 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 */
 	if (skb_headroom(skb) < intf->beacon->queue->desc_size) {
 		if (pskb_expand_head(skb, intf->beacon->queue->desc_size,
-				     0, GFP_ATOMIC)) {
-			dev_kfree_skb(skb);
+				     0, GFP_ATOMIC))
 			return -ENOMEM;
-		}
 	}
 
 	/*
-- 
1.5.4.3

