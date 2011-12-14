Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64379 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1LNP2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 10:28:52 -0500
Received: by wgbds13 with SMTP id ds13so1582617wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 07:28:51 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ivdoorn@gmail.com, gwingerde@gmail.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: Make use of ieee80211_free_txskb in tx path
Date: Wed, 14 Dec 2011 16:28:41 +0100
Message-Id: <1323876521-21224-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111214_162856_136658_4903C5B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_free_txskb should be used when dropping a frame in the device
rx path such that mac80211 knows about this frame being dropped.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 7996cd0..5889558 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -159,7 +159,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
  exit_fail:
 	rt2x00queue_pause_queue(queue);
  exit_free_skb:
-	dev_kfree_skb_any(skb);
+	ieee80211_free_txskb(hw, skb);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_tx);
 
-- 
1.7.7

