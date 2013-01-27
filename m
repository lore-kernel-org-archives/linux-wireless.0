Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:57614 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab3A0WYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2013 17:24:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: Fix the usage of the wrong variable in usb.c
Date: Sun, 27 Jan 2013 16:24:25 -0600
Message-Id: <1359325465-10280-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130127_232451_515818_D1CE86CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In routine _rtl_rx_pre_process(), skb_dequeue() is called to get an skb;
however, the wrong variable name is used in subsequent calls.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Stable <stable@vger.kernel.org>
---

John,

This is material for 3.8. Sorry that it was not found earlier.

Larry
---

 drivers/net/wireless/rtlwifi/usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index f2ecdeb..1535efd 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -542,8 +542,8 @@ static void _rtl_rx_pre_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	WARN_ON(skb_queue_empty(&rx_queue));
 	while (!skb_queue_empty(&rx_queue)) {
 		_skb = skb_dequeue(&rx_queue);
-		_rtl_usb_rx_process_agg(hw, skb);
-		ieee80211_rx_irqsafe(hw, skb);
+		_rtl_usb_rx_process_agg(hw, _skb);
+		ieee80211_rx_irqsafe(hw, _skb);
 	}
 }
 
-- 
1.8.1

