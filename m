Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36627 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755928AbcLURTx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Dec 2016 12:19:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, driver-devel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl_usb: Fix missing entry in USB driver's private data
Date: Wed, 21 Dec 2016 11:18:55 -0600
Message-Id: <20161221171855.5056-1-Larry.Finger@lwfinger.net> (sfid-20161221_182018_027455_498980BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These drivers need to be able to reference "struct ieee80211_hw" from
the driver's private data, and vice versa. The USB driver failed to
store the address of ieee80211_hw in the private data. Although this
bug has been present for a long time, it was not exposed until
commit ba9f93f82aba ("rtlwifi: Fix enter/exit power_save").

Fixes: ba9f93f82aba ("rtlwifi: Fix enter/exit power_save")
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Kalle,

This patch needs to be included in 4.10.

Larry
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 40160c7..bf00399 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1047,6 +1047,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 	rtlpriv = hw->priv;
+	rtlpriv->hw = hw;
 	rtlpriv->usb_data = kzalloc(RTL_USB_MAX_RX_COUNT * sizeof(u32),
 				    GFP_KERNEL);
 	if (!rtlpriv->usb_data)
-- 
2.10.2
