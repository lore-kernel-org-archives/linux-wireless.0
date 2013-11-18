Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:55455 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3KRRLx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 12:11:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH 06/12 NEXT] rtlwifi: Increase the RX queue length for USB drivers
Date: Mon, 18 Nov 2013 11:11:30 -0600
Message-Id: <1384794696-20314-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20131118_181215_825582_7AE75624)
In-Reply-To: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1384794696-20314-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current number of RX buffers queued is 32, which is too small under
heavy load. That number is doubled.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/rtlwifi/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 6e2b5c5..75481d2 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -553,7 +553,7 @@ static void _rtl_rx_pre_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 }
 
-#define __RX_SKB_MAX_QUEUED	32
+#define __RX_SKB_MAX_QUEUED	64
 
 static void _rtl_rx_work(unsigned long param)
 {
-- 
1.8.4

