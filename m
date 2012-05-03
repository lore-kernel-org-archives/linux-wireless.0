Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:56115 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2ECFLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 01:11:49 -0400
Message-ID: <4FA21392.5060401@gtri.gatech.edu> (sfid-20120503_071151_736143_C99D03B8)
Date: Thu, 3 May 2012 01:11:46 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/9] rtlwifi: fix the selection of the bulk in endpoint
References: <4FA212D9.5020602@gtri.gatech.edu>
In-Reply-To: <4FA212D9.5020602@gtri.gatech.edu>
Content-Type: multipart/mixed;
	boundary="------------090909030207070901060809"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------090909030207070901060809
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit



--------------090909030207070901060809
Content-Type: text/x-patch;
	name="0004-rtlwifi-fix-the-selection-of-the-bulk-in-endpoint.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0004-rtlwifi-fix-the-selection-of-the-bulk-in-endpoint.patch"

>From 750c8403c86edc794999de6330ee7390f923cf6a Mon Sep 17 00:00:00 2001
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Date: Thu, 3 May 2012 00:12:48 -0400
Subject: [PATCH 4/9] rtlwifi: fix the selection of the bulk in endpoint

The endpoint number is not always the same as the number of bulk in
endpoints.  I don't actually have a CU card, but I can only assume
that the bulk in endpoint number is 1.

Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    2 ++
 drivers/net/wireless/rtlwifi/usb.c           |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 9e01f96..32dc884 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -203,7 +203,9 @@ err_out:
 int  rtl8192cu_endpoint_mapping(struct ieee80211_hw *hw)
 {
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_usb *rtlusb = rtl_usbdev(usb_priv);
 	int error = 0;
+	rtlusb->in_ep = 0x01;
 	if (likely(IS_NORMAL_CHIP(rtlhal->version)))
 		error = _ConfigVerNOutEP(hw);
 	else
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 91969ee..88dbef0 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -302,7 +302,6 @@ static int _rtl_usb_init_rx(struct ieee80211_hw *hw)
 
 	rtlusb->rx_max_size = rtlpriv->cfg->usb_interface_cfg->rx_max_size;
 	rtlusb->rx_urb_num = rtlpriv->cfg->usb_interface_cfg->rx_urb_num;
-	rtlusb->in_ep = rtlpriv->cfg->usb_interface_cfg->in_ep_num;
 	rtlusb->usb_rx_hdl = rtlpriv->cfg->usb_interface_cfg->usb_rx_hdl;
 	rtlusb->usb_rx_segregate_hdl =
 		rtlpriv->cfg->usb_interface_cfg->usb_rx_segregate_hdl;
-- 
1.7.7.6


--------------090909030207070901060809--
