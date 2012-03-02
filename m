Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31748 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134Ab2CBTVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 14:21:24 -0500
Date: Fri, 02 Mar 2012 13:21:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] rtlwifi: Detect misread of end-point count
Message-ID: <4f511db2.c8Kdx49+RQ5tOZnL%Larry.Finger@lwfinger.net> (sfid-20120302_202138_501025_F6C3059C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the unlikely event of a misread of the USB end point count, the driver
generates a divide fault. To prevent this, add a check of the value
returned by _rtl_usb_init(). In addition, add some logging to indicate
why the condition occurred.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch needs no particular priority. The failure has only happened
once for me, but it was nasty as the divide fault required a power off
and reboot.

Larry
---

 usb.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -346,9 +346,14 @@ static int _rtl_usb_init(struct ieee8021
 			 pep_desc->bEndpointAddress, pep_desc->wMaxPacketSize,
 			 pep_desc->bInterval);
 	}
-	if (rtlusb->in_ep_nums <  rtlpriv->cfg->usb_interface_cfg->in_ep_num)
-		return -EINVAL ;
-
+	if (rtlusb->in_ep_nums <  rtlpriv->cfg->usb_interface_cfg->in_ep_num) {
+		pr_err("Too few input end points found\n");
+		return -EINVAL;
+	}
+	if (rtlusb->out_ep_nums == 0) {
+		pr_err("No output end points found\n");
+		return -EINVAL;
+	}
 	/* usb endpoint mapping */
 	err = rtlpriv->cfg->usb_interface_cfg->usb_endpoint_mapping(hw);
 	rtlusb->usb_mq_to_hwq =  rtlpriv->cfg->usb_interface_cfg->usb_mq_to_hwq;
@@ -976,6 +981,8 @@ int __devinit rtl_usb_probe(struct usb_i
 	}
 	rtlpriv->cfg->ops->init_sw_leds(hw);
 	err = _rtl_usb_init(hw);
+	if (err)
+		goto error_out;
 	err = _rtl_usb_init_sw(hw);
 	/* Init mac80211 sw */
 	err = rtl_init_core(hw);
