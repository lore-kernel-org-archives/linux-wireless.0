Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:54825 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105Ab2EHCS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 22:18:58 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/9] rtlwifi: fix the selection of the bulk in endpoint
Date: Mon, 7 May 2012 22:18:35 -0400
Message-ID: <1336443521-15299-4-git-send-email-Joshua.Roys@gtri.gatech.edu> (sfid-20120508_041915_936657_4258B352)
In-Reply-To: <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
References: <4FA212D9.5020602@gtri.gatech.edu>
 <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The endpoint number is not always the same as the number of bulk in
endpoints.  I don't actually have a CU card, but I can only assume
that the bulk in endpoint number is 1.

Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    2 ++
 drivers/net/wireless/rtlwifi/usb.c           |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 9e01f96..a2dae17 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -203,7 +203,9 @@ err_out:
 int  rtl8192cu_endpoint_mapping(struct ieee80211_hw *hw)
 {
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	int error = 0;
+	rtlusb->in_ep = 0x01;
 	if (likely(IS_NORMAL_CHIP(rtlhal->version)))
 		error = _ConfigVerNOutEP(hw);
 	else
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 8dd588b..471a112 100644
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
1.7.4.1

