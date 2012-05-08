Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:54855 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044Ab2EHCTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 22:19:01 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 7/9] rtlwifi: mimic rtl_pci_stop and disable LEDs
Date: Mon, 7 May 2012 22:18:39 -0400
Message-ID: <1336443521-15299-8-git-send-email-Joshua.Roys@gtri.gatech.edu> (sfid-20120508_041910_232973_79FA4C9E)
In-Reply-To: <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
References: <4FA212D9.5020602@gtri.gatech.edu>
 <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joshua Roys <roysjosh@gmail.com>

Signed-off-by: Joshua Roys <roysjosh@gmail.com>
---
 drivers/net/wireless/rtlwifi/usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 686af86..64f7464 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -739,6 +739,7 @@ static void rtl_usb_stop(struct ieee80211_hw *hw)
 	SET_USB_STOP(rtlusb);
 	rtl_usb_deinit(hw);
 	rtlpriv->cfg->ops->hw_disable(hw);
+	rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_OFF);
 }
 
 static void _rtl_submit_tx_urb(struct ieee80211_hw *hw, struct urb *_urb)
-- 
1.7.4.1

