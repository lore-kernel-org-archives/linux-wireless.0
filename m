Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:58193 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3J2WGv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 18:06:51 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH NEXT] rtl8187: Increase RX queue depth
Date: Tue, 29 Oct 2013 17:06:41 -0500
Message-Id: <1383084401-4593-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20131029_230659_983270_F0DF0677)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under heavy load, the relatively small number of RX queue entries are
completely filled. With an increase from 16 to 32 entries, this condition
rarely happens.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtl818x/rtl8187/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 9a6edb0..ec9aa5b 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -416,7 +416,7 @@ static int rtl8187_init_urbs(struct ieee80211_hw *dev)
 	struct rtl8187_rx_info *info;
 	int ret = 0;
 
-	while (skb_queue_len(&priv->rx_queue) < 16) {
+	while (skb_queue_len(&priv->rx_queue) < 32) {
 		skb = __dev_alloc_skb(RTL8187_MAX_RX, GFP_KERNEL);
 		if (!skb) {
 			ret = -ENOMEM;
-- 
1.8.4

