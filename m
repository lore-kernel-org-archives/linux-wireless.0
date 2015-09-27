Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33274 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbbI0IS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2015 04:18:28 -0400
Received: by wiclk2 with SMTP id lk2so68253943wic.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2015 01:18:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/6] staging: vt6656: implement power saving.
Date: Sun, 27 Sep 2015 09:17:42 +0100
Message-Id: <1443341864-2756-4-git-send-email-tvboxspy@gmail.com> (sfid-20150927_101859_716437_3DB808C3)
In-Reply-To: <1443341864-2756-1-git-send-email-tvboxspy@gmail.com>
References: <1443341864-2756-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device can now operate in low power mode

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 7246c76..3fc6862 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1002,6 +1002,7 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	ieee80211_hw_set(priv->hw, SIGNAL_DBM);
 	ieee80211_hw_set(priv->hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(priv->hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(priv->hw, SUPPORTS_PS);
 
 	priv->hw->max_signal = 100;
 
-- 
2.5.0

