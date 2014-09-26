Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34937 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaIZVk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 17:40:57 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, troy_tan@realsil.com.cn,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 7/7 NEXT] rtlwifi: rtl8188ee: rtl8723ae: rtl8821ae: Initialize some variables
Date: Fri, 26 Sep 2014 16:40:28 -0500
Message-Id: <1411767628-7965-8-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140926_234146_639216_95C8F65A)
In-Reply-To: <1411767628-7965-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1411767628-7965-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In a number of places, kmalloc or valloc were used to acquire memory.
To ensure that these locations are correctly initialized, the calls were
changed to kzalloc and vzalloc. The change fixes a problem that was causing
HT operations to be cancelled.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/efuse.c             |  4 ++--
 drivers/net/wireless/rtlwifi/pci.c               | 20 ++++++++++----------
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.c      |  2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c |  2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c      |  2 +-
 drivers/net/wireless/rtlwifi/rtl8821ae/sw.c      |  2 +-
 drivers/net/wireless/rtlwifi/usb.c               |  4 ++--
 7 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
index 118293b..0b4082c 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -251,7 +251,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 	}
 
 	/* allocate memory for efuse_tbl and efuse_word */
-	efuse_tbl = kmalloc(rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE] *
+	efuse_tbl = kzalloc(rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE] *
 			    sizeof(u8), GFP_ATOMIC);
 	if (!efuse_tbl)
 		return;
@@ -259,7 +259,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 	if (!efuse_word)
 		goto out;
 	for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
-		efuse_word[i] = kmalloc(efuse_max_section * sizeof(u16),
+		efuse_word[i] = kzalloc(efuse_max_section * sizeof(u16),
 					GFP_ATOMIC);
 		if (!efuse_word[i])
 			goto done;
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 1dbb22b..667aba8 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -2243,16 +2243,6 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	/*like read eeprom and so on */
 	rtlpriv->cfg->ops->read_eeprom_info(hw);
 
-	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
-		err = -ENODEV;
-		goto fail3;
-	}
-	rtlpriv->cfg->ops->init_sw_leds(hw);
-
-	/*aspm */
-	rtl_pci_init_aspm(hw);
-
 	/* Init mac80211 sw */
 	err = rtl_init_core(hw);
 	if (err) {
@@ -2268,6 +2258,16 @@ int rtl_pci_probe(struct pci_dev *pdev,
 		goto fail3;
 	}
 
+	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
+		err = -ENODEV;
+		goto fail3;
+	}
+	rtlpriv->cfg->ops->init_sw_leds(hw);
+
+	/*aspm */
+	rtl_pci_init_aspm(hw);
+
 	err = ieee80211_register_hw(hw);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
index ab7dbfb..1134412 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
@@ -159,7 +159,7 @@ int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
 		rtlpriv->psc.fwctrl_psmode = FW_PS_DTIM_MODE;
 
 	/* for firmware buf */
-	rtlpriv->rtlhal.pfirmware = vmalloc(0x8000);
+	rtlpriv->rtlhal.pfirmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.pfirmware) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Can't alloc buffer for fw.\n");
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
index 747958a..00a0531 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
@@ -1735,7 +1735,7 @@ void rtl_8723e_c2h_command_handle(struct ieee80211_hw *hw)
 		rtl_write_byte(rtlpriv, 0x1AF, 0x00);
 		return;
 	}
-	ptmp_buf = kmalloc(c2h_event.cmd_len, GFP_KERNEL);
+	ptmp_buf = kzalloc(c2h_event.cmd_len, GFP_KERNEL);
 	if (ptmp_buf == NULL) {
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
 			 "malloc cmd buf failed\n");
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
index d8f8cc4..8280bab 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
@@ -164,7 +164,7 @@ int rtl8723e_init_sw_vars(struct ieee80211_hw *hw)
 		rtlpriv->psc.fwctrl_psmode = FW_PS_DTIM_MODE;
 
 	/* for firmware buf */
-	rtlpriv->rtlhal.pfirmware = vmalloc(0x6000);
+	rtlpriv->rtlhal.pfirmware = vzalloc(0x6000);
 	if (!rtlpriv->rtlhal.pfirmware) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Can't alloc buffer for fw.\n");
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/rtlwifi/rtl8821ae/sw.c
index 3cf7557..fc92dd6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/sw.c
@@ -95,7 +95,7 @@ static void load_wowlan_fw(struct rtl_priv *rtlpriv)
 	int err;
 
 	/* for wowlan firmware buf */
-	rtlpriv->rtlhal.wowlan_firmware = vmalloc(0x8000);
+	rtlpriv->rtlhal.wowlan_firmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.wowlan_firmware) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Can't alloc buffer for wowlan fw.\n");
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 0398d3e..10cf69c 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -75,11 +75,11 @@ static int _usbctrl_vendorreq_async_write(struct usb_device *udev, u8 request,
 	pipe = usb_sndctrlpipe(udev, 0); /* write_out */
 	reqtype =  REALTEK_USB_VENQT_WRITE;
 
-	dr = kmalloc(sizeof(*dr), GFP_ATOMIC);
+	dr = kzalloc(sizeof(*dr), GFP_ATOMIC);
 	if (!dr)
 		return -ENOMEM;
 
-	databuf = kmalloc(databuf_maxlen, GFP_ATOMIC);
+	databuf = kzalloc(databuf_maxlen, GFP_ATOMIC);
 	if (!databuf) {
 		kfree(dr);
 		return -ENOMEM;
-- 
1.8.4.5

