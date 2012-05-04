Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15444 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab2EDN1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 09:27:47 -0400
Date: Fri, 04 May 2012 08:27:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: frostyplanet@gmail.com, Joshua.Roys@gtri.gatech.edu,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: fix for race condition when firmware is cached
Message-ID: <4fa3d94f.HMgKjSzWMwTy5sU7%Larry.Finger@lwfinger.net> (sfid-20120504_152751_919490_05A555BF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit b0302ab, the rtlwifi family of drivers was converted to use
asynchronous firmware loading. Unfortumately, the implementation was
racy, and the ieee80211 routines could be started before rtl_init_core()
was called to setup the data.

This patch fixes the bug noted in https://bugzilla.kernel.org/show_bug.cgi?id=43187.

Reported-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Tested-by: Neptune Ning <frostyplanet@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>    [3.3]
---

John,

This bug is kind of nasty. I never see its effects, but apparently Gentoo
users are hit particularly hard. Please send it up to 3.4. I hope DaveM
doesn't get too upset.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1853,14 +1853,6 @@ int __devinit rtl_pci_probe(struct pci_d
 	/*like read eeprom and so on */
 	rtlpriv->cfg->ops->read_eeprom_info(hw);
 
-	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
-		err = -ENODEV;
-		goto fail3;
-	}
-
-	rtlpriv->cfg->ops->init_sw_leds(hw);
-
 	/*aspm */
 	rtl_pci_init_aspm(hw);
 
@@ -1879,6 +1871,14 @@ int __devinit rtl_pci_probe(struct pci_d
 		goto fail3;
 	}
 
+	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
+		err = -ENODEV;
+		goto fail3;
+	}
+
+	rtlpriv->cfg->ops->init_sw_leds(hw);
+
 	err = sysfs_create_group(&pdev->dev.kobj, &rtl_attribute_group);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -971,11 +971,6 @@ int __devinit rtl_usb_probe(struct usb_i
 	rtlpriv->cfg->ops->read_chip_version(hw);
 	/*like read eeprom and so on */
 	rtlpriv->cfg->ops->read_eeprom_info(hw);
-	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
-		goto error_out;
-	}
-	rtlpriv->cfg->ops->init_sw_leds(hw);
 	err = _rtl_usb_init(hw);
 	if (err)
 		goto error_out;
@@ -987,6 +982,11 @@ int __devinit rtl_usb_probe(struct usb_i
 			 "Can't allocate sw for mac80211\n");
 		goto error_out;
 	}
+	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "Can't init_sw_vars\n");
+		goto error_out;
+	}
+	rtlpriv->cfg->ops->init_sw_leds(hw);
 
 	return 0;
 error_out:
