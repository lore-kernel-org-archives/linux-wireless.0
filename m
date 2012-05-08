Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:54862 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123Ab2EHCTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 22:19:02 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 8/9] rtlwifi: ugly hack to enable feature disparity between subdrivers
Date: Mon, 7 May 2012 22:18:40 -0400
Message-ID: <1336443521-15299-9-git-send-email-Joshua.Roys@gtri.gatech.edu> (sfid-20120508_041912_921286_B7DB6E9F)
In-Reply-To: <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
References: <4FA212D9.5020602@gtri.gatech.edu>
 <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/core.c |    2 +-
 drivers/net/wireless/rtlwifi/core.h |    2 +-
 drivers/net/wireless/rtlwifi/usb.c  |    7 ++++++-
 drivers/net/wireless/rtlwifi/wifi.h |    1 +
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 278e9f9..3b1108c 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -1171,7 +1171,7 @@ static void rtl_op_flush(struct ieee80211_hw *hw, bool drop)
 		rtlpriv->intf_ops->flush(hw, drop);
 }
 
-const struct ieee80211_ops rtl_ops = {
+struct ieee80211_ops rtl_ops = {
 	.start = rtl_op_start,
 	.stop = rtl_op_stop,
 	.tx = rtl_op_tx,
diff --git a/drivers/net/wireless/rtlwifi/core.h b/drivers/net/wireless/rtlwifi/core.h
index 2fe46a1..a1d8227 100644
--- a/drivers/net/wireless/rtlwifi/core.h
+++ b/drivers/net/wireless/rtlwifi/core.h
@@ -39,7 +39,7 @@
 
 #define RTL_SUPPORTED_CTRL_FILTER	0xFF
 
-extern const struct ieee80211_ops rtl_ops;
+extern struct ieee80211_ops rtl_ops;
 void rtl_fw_cb(const struct firmware *firmware, void *context);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 64f7464..15ffb97d 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -953,6 +953,11 @@ int __devinit rtl_usb_probe(struct usb_interface *intf,
 	struct rtl_priv *rtlpriv = NULL;
 	struct usb_device	*udev;
 	struct rtl_usb_priv *usb_priv;
+	struct rtl_hal_cfg *hal_cfg;
+
+	hal_cfg = (struct rtl_hal_cfg *)(id->driver_info);
+	if (hal_cfg->ops->modify_ieee80211_ops)
+		hal_cfg->ops->modify_ieee80211_ops(&rtl_ops);
 
 	hw = ieee80211_alloc_hw(sizeof(struct rtl_priv) +
 				sizeof(struct rtl_usb_priv), &rtl_ops);
@@ -977,7 +982,7 @@ int __devinit rtl_usb_probe(struct usb_interface *intf,
 	usb_set_intfdata(intf, hw);
 	/* init cfg & intf_ops */
 	rtlpriv->rtlhal.interface = INTF_USB;
-	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_info);
+	rtlpriv->cfg = hal_cfg;
 	rtlpriv->intf_ops = &rtl_usb_ops;
 	rtl_dbgp_flag_init(hw);
 	/* Init IO handler */
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index bd816ae..618f09c 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1386,6 +1386,7 @@ struct rtl_tcb_desc {
 };
 
 struct rtl_hal_ops {
+	void (*modify_ieee80211_ops) (struct ieee80211_ops *ops);
 	int (*init_sw_vars) (struct ieee80211_hw *hw);
 	void (*deinit_sw_vars) (struct ieee80211_hw *hw);
 	void (*read_chip_version)(struct ieee80211_hw *hw);
-- 
1.7.4.1

