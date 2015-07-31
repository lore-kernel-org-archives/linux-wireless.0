Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:53944 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbbGaNLg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 09:11:36 -0400
From: Jakub Kicinski <moorray3@wp.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH -next 2/4] mt7601u: use correct ieee80211_rx variant
Date: Fri, 31 Jul 2015 15:04:47 +0200
Message-Id: <1438347889-14669-2-git-send-email-moorray3@wp.pl> (sfid-20150731_151139_856841_09DB1533)
In-Reply-To: <1438347889-14669-1-git-send-email-moorray3@wp.pl>
References: <1438347889-14669-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

Rx is run inside a tasklet so ieee80211_rx() should be used
instead of ieee80211_rx_ni().

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index 7217da4f1543..fb183e369d92 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -112,7 +112,7 @@ static void mt7601u_rx_process_seg(struct mt7601u_dev *dev, u8 *data,
 	if (!skb)
 		return;
 
-	ieee80211_rx_ni(dev->hw, skb);
+	ieee80211_rx(dev->hw, skb);
 }
 
 static u16 mt7601u_rx_next_seg_len(u8 *data, u32 data_len)
-- 
2.1.0

