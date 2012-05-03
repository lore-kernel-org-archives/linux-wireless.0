Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:56198 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2ECFNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 01:13:18 -0400
Message-ID: <4FA213EC.3030202@gtri.gatech.edu> (sfid-20120503_071321_930896_DA3A0F4A)
Date: Thu, 3 May 2012 01:13:16 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 7/9] rtlwifi: fail rtl_usb_start if any bulk in urbs fail
References: <4FA212D9.5020602@gtri.gatech.edu>
In-Reply-To: <4FA212D9.5020602@gtri.gatech.edu>
Content-Type: multipart/mixed;
	boundary="------------030402060204000104070405"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------030402060204000104070405
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit



--------------030402060204000104070405
Content-Type: text/x-patch;
	name="0007-rtlwifi-fail-rtl_usb_start-if-any-bulk-in-urbs-fail.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0007-rtlwifi-fail-rtl_usb_start-if-any-bulk-in-urbs-fail.pat";
	filename*1="ch"

>From 2cb9c6eca9f0b05d8055d1c7ba78f89c89c34869 Mon Sep 17 00:00:00 2001
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Date: Thu, 3 May 2012 00:20:18 -0400
Subject: [PATCH 7/9] rtlwifi: fail rtl_usb_start if any bulk in urbs fail

This would have made debugging the erroneous bulk in endpoint number
easier.

Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/usb.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 00e90bc..c62fc7d 100644
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
1.7.7.6


--------------030402060204000104070405--
