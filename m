Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:54847 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab2EHCTA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 22:19:00 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 6/9] rtlwifi: fail rtl_usb_start if any bulk in urbs fail
Date: Mon, 7 May 2012 22:18:38 -0400
Message-ID: <1336443521-15299-7-git-send-email-Joshua.Roys@gtri.gatech.edu> (sfid-20120508_041908_206736_AB54E2F8)
In-Reply-To: <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
References: <4FA212D9.5020602@gtri.gatech.edu>
 <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This would have made debugging the erroneous bulk in endpoint number
easier.

Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/usb.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index d9a0a9f..686af86 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -648,13 +648,17 @@ static int _rtl_usb_receive(struct ieee80211_hw *hw)
 
 		usb_anchor_urb(urb, &rtlusb->rx_submitted);
 		err = usb_submit_urb(urb, GFP_KERNEL);
-		if (err)
+		if (err) {
+			RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
+				 "Failed to submit URB!!\n");
 			goto err_out;
+		}
 		usb_free_urb(urb);
 	}
 	return 0;
 
 err_out:
+	RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG, "err=%i\n", err);
 	usb_kill_anchored_urbs(&rtlusb->rx_submitted);
 	return err;
 }
@@ -676,7 +680,7 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
 		set_hal_start(rtlhal);
 
 		/* Start bulk IN */
-		_rtl_usb_receive(hw);
+		err = _rtl_usb_receive(hw);
 	}
 
 	return err;
-- 
1.7.4.1

