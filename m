Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:51239 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbbCLOgC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 10:36:02 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/3] rt2x00usb: drop rt2x00usb_disable_radio() from rt2800usb_disable_radio()
Date: Thu, 12 Mar 2015 15:35:46 +0100
Message-Id: <1426170946-13918-3-git-send-email-bigeasy@linutronix.de> (sfid-20150312_153608_159585_DDBDA183)
In-Reply-To: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de>
References: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have here FRITZ!WLAN USB Stick N v2 / idVendor=057c, idProduct=8501
and every single of this requests ends up with:

|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x0c  failed for offset 0x0000 with error -32

I was browsing the the vedor code and I haven't seen such request so I
remove it with this patch. If I wasn't look enough or if this error is
expected then please excuse :)

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index e692e5fe4e01..9a2f44a54d94 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -378,7 +378,6 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 static void rt2800usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_disable_radio(rt2x00dev);
-	rt2x00usb_disable_radio(rt2x00dev);
 }
 
 static int rt2800usb_set_state(struct rt2x00_dev *rt2x00dev,
-- 
2.1.4

