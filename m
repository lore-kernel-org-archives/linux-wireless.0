Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37963 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2JNUOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 16:14:10 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2144957bkc.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2012 13:14:09 -0700 (PDT)
Subject: [RFC] rtlwifi: fix in_ep = in_ep_num mishap in _rtl_usb_init_rx
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org, Joshua.Roys@gtri.gatech.edu
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 14 Oct 2012 22:13:56 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201210142213.56197.chunkeey@googlemail.com> (sfid-20121014_221414_915145_DB95E433)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in_ep and in_ep_num should not be the same as
a device can have a different in_ep than "1".

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Note:
This patch is related to:
"[PATCH 3/9] rtlwifi: fix the selection of the bulk in endpoint"

However, it would be much better if we can get rid of
in_ep_num and define an in_ep array so the rtlwifi
frameworks knows which EPs to scan. But this could be
"too much" of an overkill, so another solution would
be to just have a single in_ep. 

Larry, do you know of any hardware which has two in endpoints?

Joshua, I get as far as "blinking LEDs". But the PHY/RF and RX
seem to need more work, or did you have some success with it
and it's just the HW combination/refactoring that broke it?!

Regards,
	Chr
---
 rtlwifi/rtl8192cu/sw.c |    1 +
 rtlwifi/usb.c          |    3 ++-
 rtlwifi/wifi.h         |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/rtlwifi/rtl8192cu/sw.c b/rtlwifi/rtl8192cu/sw.c
index 9970c2b..24b6f69 100644
--- a/rtlwifi/rtl8192cu/sw.c
+++ b/rtlwifi/rtl8192cu/sw.c
@@ -151,6 +151,7 @@ MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
 static struct rtl_hal_usbint_cfg rtl92cu_interface_cfg = {
 	/* rx */
+	.in_ep = RTL92C_USB_BULK_IN_NUM,
 	.in_ep_num = RTL92C_USB_BULK_IN_NUM,
 	.rx_urb_num = RTL92C_NUM_RX_URBS,
 	.rx_max_size = RTL92C_SIZE_MAX_RX_BUFFER,
diff --git a/rtlwifi/usb.c b/rtlwifi/usb.c
index 31db282..d7744e1 100644
--- a/rtlwifi/usb.c
+++ b/rtlwifi/usb.c
@@ -306,7 +306,8 @@ static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
 
 	rtlusb->rx_max_size = rtlpriv->cfg->usb_interface_cfg->rx_max_size;
 	rtlusb->rx_urb_num = rtlpriv->cfg->usb_interface_cfg->rx_urb_num;
-	rtlusb->in_ep = rtlpriv->cfg->usb_interface_cfg->in_ep_num;
+	rtlusb->in_ep = rtlpriv->cfg->usb_interface_cfg->in_ep;
+	rtlusb->in_ep_nums = rtlpriv->cfg->usb_interface_cfg->in_ep_num;
 	rtlusb->usb_rx_hdl = rtlpriv->cfg->usb_interface_cfg->usb_rx_hdl;
 	rtlusb->usb_rx_segregate_hdl =
 		rtlpriv->cfg->usb_interface_cfg->usb_rx_segregate_hdl;
diff --git a/rtlwifi/wifi.h b/rtlwifi/wifi.h
index ad02203..882b870 100644
--- a/rtlwifi/wifi.h
+++ b/rtlwifi/wifi.h
@@ -1550,6 +1550,7 @@ struct rtl_mod_params {
 
 struct rtl_hal_usbint_cfg {
 	/* data - rx */
+	u32 in_ep;
 	u32 in_ep_num;
 	u32 rx_urb_num;
 	u32 rx_max_size;
-- 
1.7.10.4

