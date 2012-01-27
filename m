Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59492 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2A0T00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 14:26:26 -0500
Date: Fri, 27 Jan 2012 13:26:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: kay.sievers@vrfy.org, torvalds@linux-foundation.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Convert to asynchronous firmware load
Message-ID: <4f22fa73.yIELvVcCsxf3uiyt%Larry.Finger@lwfinger.net> (sfid-20120127_202631_423637_B91800AA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch addresses a kernel bugzilla report and two recent mail threads.

The kernel bugzilla report is https://bugzilla.kernel.org/show_bug.cgi?id=42632,
which reports a udev timeout on boot.

The first mail thread, which was on LKML (http://lkml.indiana.edu/hypermail/
linux/kernel/1112.3/00965.html) was for a WARNING that occurs after a
suspend/resume cycle for rtl8192cu.

The scond mail thread (http://marc.info/?l=linux-wireless&m=132655490826766&w=2)
concerned changes in udev that break drivers that delay while firmware is loaded
on modprobe.

This patch converts all rtlwifi-based drivers to use the asynchronous firmware
loading mechanism. Drivers rtl8192ce, rtl8192cu and rtl8192de share a common
callback routine. Driver rtl8192se needs different handling of the firmware,
thus it has its own code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

John,

This patch will apply to the wireless-testing git tree.

I have mixed feelings about the timing of the inclusion of this patch.
It is quite invasive, which would normally indicate that it go through
the normal process and ultimately be included in V3.4 to get further
testing. On the other hand, the number of bug reports is growing rapidly,
which argues for it to be included quickly and backported to stable.

I'll leave that decision to you. If you decide to push this to mainline
now, there is one additional complication due to conflicts with the series
of patches by Joe Perches that modified the debug printouts (commits
804dd24 through 07839b1). I have a version of the patch for Linus's tree,
but that pushes the conflicts in a later merge in linux-next.

To improve the testing coverage, I will post the mainline patch at b.k.o,
bug #42632.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1565,6 +1565,9 @@ static void rtl_pci_stop(struct ieee8021
 
 	rtlpci->driver_is_goingto_unload = true;
 	rtlpriv->cfg->ops->hw_disable(hw);
+	/* some things are not needed if firmware not available */
+	if (!rtlpriv->max_fw_size)
+		return;
 	rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_OFF);
 
 	spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flags);
@@ -1862,15 +1865,6 @@ int __devinit rtl_pci_probe(struct pci_d
 		goto fail3;
 	}
 
-	err = ieee80211_register_hw(hw);
-	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Can't register mac80211 hw\n");
-		goto fail3;
-	} else {
-		rtlpriv->mac80211.mac80211_registered = 1;
-	}
-
 	err = sysfs_create_group(&pdev->dev.kobj, &rtl_attribute_group);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
@@ -1878,9 +1872,6 @@ int __devinit rtl_pci_probe(struct pci_d
 		goto fail3;
 	}
 
-	/*init rfkill */
-	rtl_init_rfkill(hw);
-
 	rtlpci = rtl_pcidev(pcipriv);
 	err = request_irq(rtlpci->pdev->irq, &_rtl_pci_interrupt,
 			  IRQF_SHARED, KBUILD_MODNAME, hw);
@@ -1889,18 +1880,15 @@ int __devinit rtl_pci_probe(struct pci_d
 			 "%s: failed to register IRQ handler\n",
 			 wiphy_name(hw->wiphy));
 		goto fail3;
-	} else {
-		rtlpci->irq_alloc = 1;
 	}
+	rtlpci->irq_alloc = 1;
 
-	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 	return 0;
 
 fail3:
 	pci_set_drvdata(pdev, NULL);
 	rtl_deinit_core(hw);
 	_rtl_pci_io_handler_release(hw);
-	ieee80211_free_hw(hw);
 
 	if (rtlpriv->io.pci_mem_start != 0)
 		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -257,10 +257,9 @@ int rtl92c_download_fw(struct ieee80211_
 	u32 fwsize;
 	enum version_8192c version = rtlhal->version;
 
-	if (!rtlhal->pfirmware)
+	if (rtlpriv->max_fw_size == 0 || !rtlhal->pfirmware)
 		return 1;
 
-	pr_info("Loading firmware file %s\n", rtlpriv->cfg->fw_name);
 	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
 	pfwdata = (u8 *) rtlhal->pfirmware;
 	fwsize = rtlhal->fwsize;
@@ -512,15 +511,8 @@ static void _rtl92c_fill_h2c_command(str
 void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
 			 u8 element_id, u32 cmd_len, u8 *p_cmdbuffer)
 {
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u32 tmp_cmdbuf[2];
 
-	if (rtlhal->fw_ready == false) {
-		RT_ASSERT(false,
-			  "return H2C cmd because of Fw download fail!!!\n");
-		return;
-	}
-
 	memset(tmp_cmdbuf, 0, 8);
 	memcpy(tmp_cmdbuf, p_cmdbuffer, cmd_len);
 	_rtl92c_fill_h2c_command(hw, element_id, cmd_len, (u8 *)&tmp_cmdbuf);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -91,9 +91,7 @@ int rtl92c_init_sw_vars(struct ieee80211
 	int err;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	const struct firmware *firmware;
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	char *fw_name = NULL;
 
 	rtl8192ce_bt_reg_init(hw);
 
@@ -165,26 +163,20 @@ int rtl92c_init_sw_vars(struct ieee80211
 	/* request fw */
 	if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
 	    !IS_92C_SERIAL(rtlhal->version))
-		fw_name = "rtlwifi/rtl8192cfwU.bin";
+		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cfwU.bin";
 	else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version))
-		fw_name = "rtlwifi/rtl8192cfwU_B.bin";
-	else
-		fw_name = rtlpriv->cfg->fw_name;
-	err = request_firmware(&firmware, fw_name, rtlpriv->io.dev);
+		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cfwU_B.bin";
+
+	rtlpriv->max_fw_size = 0x4000;
+	pr_info("Using firmware %s\n", rtlpriv->cfg->fw_name);
+	err = request_firmware_nowait(THIS_MODULE, 1, rtlpriv->cfg->fw_name,
+				      rtlpriv->io.dev, GFP_KERNEL, hw,
+				      rtl_fw_cb);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Failed to request firmware!\n");
 		return 1;
 	}
-	if (firmware->size > 0x4000) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is too big!\n");
-		release_firmware(firmware);
-		return 1;
-	}
-	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
-	rtlpriv->rtlhal.fwsize = firmware->size;
-	release_firmware(firmware);
 
 	return 0;
 }
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -1047,7 +1047,6 @@ struct rtl_hal {
 	u16 fw_subversion;
 	bool h2c_setinprogress;
 	u8 last_hmeboxnum;
-	bool fw_ready;
 	/*Reserve page start offset except beacon in TxQ. */
 	u8 fw_rsvdpage_startoffset;
 	u8 h2c_txcmd_seq;
@@ -1614,6 +1613,7 @@ struct rtl_priv {
 	struct rtl_rate_priv *rate_priv;
 
 	struct rtl_debug dbg;
+	int max_fw_size;
 
 	/*
 	 *hal_cfg : for diff cards
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/core.c
@@ -31,8 +31,49 @@
 #include "core.h"
 #include "cam.h"
 #include "base.h"
+#include "pci.h"
 #include "ps.h"
 
+#include <linux/export.h>
+
+void rtl_fw_cb(const struct firmware *firmware, void *context)
+{
+	struct ieee80211_hw *hw = context;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int err;
+
+	RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
+			 "Firmware callback routine entered!\n");
+	if (!firmware) {
+		pr_err("Firmware %s not available\n", rtlpriv->cfg->fw_name);
+		rtlpriv->max_fw_size = 0;
+		return;
+	}
+	if (firmware->size > rtlpriv->max_fw_size) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Firmware is too big!\n");
+		release_firmware(firmware);
+		return;
+	}
+	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
+	rtlpriv->rtlhal.fwsize = firmware->size;
+	release_firmware(firmware);
+
+	err = ieee80211_register_hw(hw);
+	if (err) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Can't register mac80211 hw\n");
+		return;
+	} else {
+		rtlpriv->mac80211.mac80211_registered = 1;
+	}
+	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
+
+	/*init rfkill */
+	rtl_init_rfkill(hw);
+}
+EXPORT_SYMBOL(rtl_fw_cb);
+
 /*mutex for start & stop is must here. */
 static int rtl_op_start(struct ieee80211_hw *hw)
 {
@@ -252,10 +293,12 @@ static int rtl_op_config(struct ieee8021
 			 * because that will cause nullfunc send by mac80211
 			 * fail, and cause pkt loss, we have tested that 5mA
 			 * is worked very well */
-			if (!rtlpriv->psc.multi_buffered)
+			if (!rtlpriv->psc.multi_buffered) {
 				queue_delayed_work(rtlpriv->works.rtl_wq,
 						&rtlpriv->works.ps_work,
 						MSECS(5));
+				pr_info("In section\n");
+			}
 		} else {
 			rtl_swlps_rf_awake(hw);
 			rtlpriv->psc.sw_ps_enabled = false;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/core.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/core.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/core.h
@@ -40,4 +40,6 @@
 #define RTL_SUPPORTED_CTRL_FILTER	0xFF
 
 extern const struct ieee80211_ops rtl_ops;
+void rtl_fw_cb(const struct firmware *firmware, void *context);
+
 #endif
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -53,7 +53,6 @@ MODULE_FIRMWARE("rtlwifi/rtl8192cufw.bin
 static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	const struct firmware *firmware;
 	int err;
 
 	rtlpriv->dm.dm_initialgain_enable = true;
@@ -61,29 +60,21 @@ static int rtl92cu_init_sw_vars(struct i
 	rtlpriv->dm.disable_framebursting = false;
 	rtlpriv->dm.thermalvalue = 0;
 	rtlpriv->dbg.global_debuglevel = rtlpriv->cfg->mod_params->debug;
-	rtlpriv->rtlhal.pfirmware = vmalloc(0x4000);
+
+	/* for firmware buf */
+	rtlpriv->rtlhal.pfirmware = vzalloc(0x4000);
 	if (!rtlpriv->rtlhal.pfirmware) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Can't alloc buffer for fw\n");
 		return 1;
 	}
-	/* request fw */
-	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			rtlpriv->io.dev);
-	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Failed to request firmware!\n");
-		return 1;
-	}
-	if (firmware->size > 0x4000) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is too big!\n");
-		release_firmware(firmware);
-		return 1;
-	}
-	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
-	rtlpriv->rtlhal.fwsize = firmware->size;
-	release_firmware(firmware);
+
+	pr_info("Loading firmware %s\n", rtlpriv->cfg->fw_name);
+	rtlpriv->max_fw_size = 0x4000;
+	err = request_firmware_nowait(THIS_MODULE, 1,
+				      rtlpriv->cfg->fw_name, rtlpriv->io.dev,
+				      GFP_KERNEL, hw, rtl_fw_cb);
+
 
 	return 0;
 }
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -30,6 +30,8 @@
 #include "../wifi.h"
 #include "../core.h"
 #include "../pci.h"
+#include "../base.h"
+#include "../pci.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
@@ -86,12 +88,52 @@ static void rtl92s_init_aspm_vars(struct
 	rtlpci->const_support_pciaspm = 2;
 }
 
+static void rtl92se_fw_cb(const struct firmware *firmware, void *context)
+{
+	struct ieee80211_hw *hw = context;
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci *rtlpci = rtl_pcidev(pcipriv);
+	struct rt_firmware *pfirmware = NULL;
+	int err;
+
+	RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
+			 "Firmware callback routine entered!\n");
+	if (!firmware) {
+		pr_err("Firmware %s not available\n", rtlpriv->cfg->fw_name);
+		rtlpriv->max_fw_size = 0;
+		return;
+	}
+	if (firmware->size > rtlpriv->max_fw_size) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Firmware is too big!\n");
+		release_firmware(firmware);
+		return;
+	}
+	pfirmware = (struct rt_firmware *)rtlpriv->rtlhal.pfirmware;
+	memcpy(pfirmware->sz_fw_tmpbuffer, firmware->data, firmware->size);
+	pfirmware->sz_fw_tmpbufferlen = firmware->size;
+	release_firmware(firmware);
+
+	err = ieee80211_register_hw(hw);
+	if (err) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Can't register mac80211 hw\n");
+		return;
+	} else {
+		rtlpriv->mac80211.mac80211_registered = 1;
+	}
+	rtlpci->irq_alloc = 1;
+	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
+
+	/*init rfkill */
+	rtl_init_rfkill(hw);
+}
+
 static int rtl92s_init_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	const struct firmware *firmware;
-	struct rt_firmware *pfirmware = NULL;
 	int err = 0;
 	u16 earlyrxthreshold = 7;
 
@@ -189,27 +231,19 @@ static int rtl92s_init_sw_vars(struct ie
 		return 1;
 	}
 
+	rtlpriv->max_fw_size = sizeof(struct rt_firmware);
+
 	pr_info("Driver for Realtek RTL8192SE/RTL8191SE\n"
 		"Loading firmware %s\n", rtlpriv->cfg->fw_name);
 	/* request fw */
-	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			rtlpriv->io.dev);
+	err = request_firmware_nowait(THIS_MODULE, 1, rtlpriv->cfg->fw_name,
+				      rtlpriv->io.dev, GFP_KERNEL, hw,
+				      rtl92se_fw_cb);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Failed to request firmware!\n");
 		return 1;
 	}
-	if (firmware->size > sizeof(struct rt_firmware)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is too big!\n");
-		release_firmware(firmware);
-		return 1;
-	}
-
-	pfirmware = (struct rt_firmware *)rtlpriv->rtlhal.pfirmware;
-	memcpy(pfirmware->sz_fw_tmpbuffer, firmware->data, firmware->size);
-	pfirmware->sz_fw_tmpbufferlen = firmware->size;
-	release_firmware(firmware);
 
 	return err;
 }
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -664,15 +664,17 @@ static int rtl_usb_start(struct ieee8021
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 
 	err = rtlpriv->cfg->ops->hw_init(hw);
-	rtl_init_rx_config(hw);
+	if (!err) {
+		rtl_init_rx_config(hw);
 
-	/* Enable software */
-	SET_USB_START(rtlusb);
-	/* should after adapter start and interrupt enable. */
-	set_hal_start(rtlhal);
+		/* Enable software */
+		SET_USB_START(rtlusb);
+		/* should after adapter start and interrupt enable. */
+		set_hal_start(rtlhal);
 
-	/* Start bulk IN */
-	_rtl_usb_receive(hw);
+		/* Start bulk IN */
+		_rtl_usb_receive(hw);
+	}
 
 	return err;
 }
@@ -982,23 +984,10 @@ int __devinit rtl_usb_probe(struct usb_i
 		goto error_out;
 	}
 
-	/*init rfkill */
-	/* rtl_init_rfkill(hw); */
-
-	err = ieee80211_register_hw(hw);
-	if (err) {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
-			 "Can't register mac80211 hw\n");
-		goto error_out;
-	} else {
-		rtlpriv->mac80211.mac80211_registered = 1;
-	}
-	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 	return 0;
 error_out:
 	rtl_deinit_core(hw);
 	_rtl_usb_io_handler_release(hw);
-	ieee80211_free_hw(hw);
 	usb_put_dev(udev);
 	return -ENODEV;
 }
@@ -1013,6 +1002,7 @@ void rtl_usb_disconnect(struct usb_inter
 
 	if (unlikely(!rtlpriv))
 		return;
+
 	/*ieee80211_unregister_hw will call ops_stop */
 	if (rtlmac->mac80211_registered == 1) {
 		ieee80211_unregister_hw(hw);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/sw.c
@@ -91,7 +91,6 @@ static int rtl92d_init_sw_vars(struct ie
 	u8 tid;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	const struct firmware *firmware;
 	static int header_print;
 
 	rtlpriv->dm.dm_initialgain_enable = true;
@@ -167,6 +166,15 @@ static int rtl92d_init_sw_vars(struct ie
 	else if (rtlpriv->psc.reg_fwctrl_lps == 3)
 		rtlpriv->psc.fwctrl_psmode = FW_PS_DTIM_MODE;
 
+	/* for early mode */
+	rtlpriv->rtlhal.earlymode_enable = true;
+	for (tid = 0; tid < 8; tid++)
+		skb_queue_head_init(&rtlpriv->mac80211.skb_waitq[tid]);
+
+	/* Only load firmware for first MAC */
+	if (header_print)
+		return 0;
+
 	/* for firmware buf */
 	rtlpriv->rtlhal.pfirmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.pfirmware) {
@@ -175,33 +183,21 @@ static int rtl92d_init_sw_vars(struct ie
 		return 1;
 	}
 
-	if (!header_print) {
-		pr_info("Driver for Realtek RTL8192DE WLAN interface\n");
-		pr_info("Loading firmware file %s\n", rtlpriv->cfg->fw_name);
-		header_print++;
-	}
+	rtlpriv->max_fw_size = 0x8000;
+	pr_info("Driver for Realtek RTL8192DE WLAN interface\n");
+	pr_info("Loading firmware file %s\n", rtlpriv->cfg->fw_name);
+	header_print++;
+
 	/* request fw */
-	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			       rtlpriv->io.dev);
+	err = request_firmware_nowait(THIS_MODULE, 1, rtlpriv->cfg->fw_name,
+				      rtlpriv->io.dev, GFP_KERNEL, hw,
+				      rtl_fw_cb);
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Failed to request firmware!\n");
 		return 1;
 	}
-	if (firmware->size > 0x8000) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 "Firmware is too big!\n");
-		release_firmware(firmware);
-		return 1;
-	}
-	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
-	rtlpriv->rtlhal.fwsize = firmware->size;
-	release_firmware(firmware);
 
-	/* for early mode */
-	rtlpriv->rtlhal.earlymode_enable = true;
-	for (tid = 0; tid < 8; tid++)
-		skb_queue_head_init(&rtlpriv->mac80211.skb_waitq[tid]);
 	return 0;
 }
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
@@ -253,7 +253,7 @@ int rtl92d_download_fw(struct ieee80211_
 	bool fw_downloaded = false, fwdl_in_process = false;
 	unsigned long flags;
 
-	if (!rtlhal->pfirmware)
+	if (rtlpriv->max_fw_size == 0 || !rtlhal->pfirmware)
 		return 1;
 	fwsize = rtlhal->fwsize;
 	pfwheader = (u8 *) rtlhal->pfirmware;
@@ -532,14 +532,8 @@ static void _rtl92d_fill_h2c_command(str
 void rtl92d_fill_h2c_cmd(struct ieee80211_hw *hw,
 			 u8 element_id, u32 cmd_len, u8 *cmdbuffer)
 {
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u32 tmp_cmdbuf[2];
 
-	if (rtlhal->fw_ready == false) {
-		RT_ASSERT(false,
-			  "return H2C cmd because of Fw download fail!!!\n");
-		return;
-	}
 	memset(tmp_cmdbuf, 0, 8);
 	memcpy(tmp_cmdbuf, cmdbuffer, cmd_len);
 	_rtl92d_fill_h2c_command(hw, element_id, cmd_len, (u8 *)&tmp_cmdbuf);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
@@ -364,7 +364,7 @@ int rtl92s_download_fw(struct ieee80211_
 	u8 fwstatus = FW_STATUS_INIT;
 	bool rtstatus = true;
 
-	if (!rtlhal->pfirmware)
+	if (rtlpriv->max_fw_size == 0 || !rtlhal->pfirmware)
 		return 1;
 
 	firmware = (struct rt_firmware *)rtlhal->pfirmware;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
@@ -47,7 +47,8 @@ bool rtl_ps_enable_nic(struct ieee80211_
 			 "Driver is already down!\n");
 
 	/*<2> Enable Adapter */
-	rtlpriv->cfg->ops->hw_init(hw);
+	if (rtlpriv->cfg->ops->hw_init(hw))
+		return 1;
 	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 
 	/*<3> Enable Interrupt */
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -949,10 +949,9 @@ int rtl92se_hw_init(struct ieee80211_hw
 	rtstatus = rtl92s_download_fw(hw);
 	if (!rtstatus) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 "Failed to download FW. Init HW without FW now... Please copy FW into /lib/firmware/rtlwifi\n");
-		rtlhal->fw_ready = false;
-	} else {
-		rtlhal->fw_ready = true;
+			 "Failed to download FW. Init HW without FW now... "
+			 "Please copy FW into /lib/firmware/rtlwifi\n");
+		return 1;
 	}
 
 	/* After FW download, we have to reset MAC register */
@@ -1215,9 +1214,14 @@ void rtl92se_enable_interrupt(struct iee
 
 void rtl92se_disable_interrupt(struct ieee80211_hw *hw)
 {
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl_priv *rtlpriv;
+	struct rtl_pci *rtlpci;
 
+	rtlpriv = rtl_priv(hw);
+	/* if firmware not available, no interrupts */
+	if (!rtlpriv || !rtlpriv->max_fw_size)
+		return;
+	rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	rtl_write_dword(rtlpriv, INTA_MASK, 0);
 	rtl_write_dword(rtlpriv, INTA_MASK + 4, 0);
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -917,10 +917,7 @@ int rtl92ce_hw_init(struct ieee80211_hw
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Failed to download FW. Init HW without FW now..\n");
 		err = 1;
-		rtlhal->fw_ready = false;
 		return err;
-	} else {
-		rtlhal->fw_ready = true;
 	}
 
 	rtlhal->last_hmeboxnum = 0;
@@ -1193,7 +1190,6 @@ static void _rtl92ce_poweroff_adapter(st
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u8 u1b_tmp;
 	u32 u4b_tmp;
 
@@ -1204,7 +1200,7 @@ static void _rtl92ce_poweroff_adapter(st
 	rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x40);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE2);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE0);
-	if ((rtl_read_byte(rtlpriv, REG_MCUFWDL) & BIT(7)) && rtlhal->fw_ready)
+	if (rtl_read_byte(rtlpriv, REG_MCUFWDL) & BIT(7))
 		rtl92c_firmware_selfreset(hw);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, 0x51);
 	rtl_write_byte(rtlpriv, REG_MCUFWDL, 0x00);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -997,10 +997,7 @@ int rtl92cu_hw_init(struct ieee80211_hw
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Failed to download FW. Init HW without FW now..\n");
 		err = 1;
-		rtlhal->fw_ready = false;
 		return err;
-	} else {
-		rtlhal->fw_ready = true;
 	}
 	rtlhal->last_hmeboxnum = 0; /* h2c */
 	_rtl92cu_phy_param_tab_init(hw);
@@ -1094,23 +1091,21 @@ static void  _ResetDigitalProcedure1(str
 		if (rtl_read_byte(rtlpriv, REG_MCUFWDL) & BIT(1)) {
 			/* reset MCU ready status */
 			rtl_write_byte(rtlpriv, REG_MCUFWDL, 0);
-			if (rtlhal->fw_ready) {
-				/* 8051 reset by self */
-				rtl_write_byte(rtlpriv, REG_HMETFR+3, 0x20);
-				while ((retry_cnts++ < 100) &&
-				       (FEN_CPUEN & rtl_read_word(rtlpriv,
-				       REG_SYS_FUNC_EN))) {
-					udelay(50);
-				}
-				if (retry_cnts >= 100) {
-					RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-						 "#####=> 8051 reset failed!.........................\n");
-					/* if 8051 reset fail, reset MAC. */
-					rtl_write_byte(rtlpriv,
-						       REG_SYS_FUNC_EN + 1,
-						       0x50);
-					udelay(100);
-				}
+			/* 8051 reset by self */
+			rtl_write_byte(rtlpriv, REG_HMETFR+3, 0x20);
+			while ((retry_cnts++ < 100) &&
+			       (FEN_CPUEN & rtl_read_word(rtlpriv,
+			       REG_SYS_FUNC_EN))) {
+				udelay(50);
+			}
+			if (retry_cnts >= 100) {
+				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+					 "#####=> 8051 reset failed!.........................\n");
+				/* if 8051 reset fail, reset MAC. */
+				rtl_write_byte(rtlpriv,
+					       REG_SYS_FUNC_EN + 1,
+					       0x50);
+				udelay(100);
 			}
 		}
 		/* Reset MAC and Enable 8051 */
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -931,10 +931,7 @@ int rtl92de_hw_init(struct ieee80211_hw
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Failed to download FW. Init HW without FW..\n");
-		rtlhal->fw_ready = false;
 		return 1;
-	} else {
-		rtlhal->fw_ready = true;
 	}
 	rtlhal->last_hmeboxnum = 0;
 	rtlpriv->psc.fw_current_inpsmode = false;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/base.c
@@ -411,6 +411,7 @@ void rtl_init_rfkill(struct ieee80211_hw
 
 	wiphy_rfkill_start_polling(hw->wiphy);
 }
+EXPORT_SYMBOL(rtl_init_rfkill);
 
 void rtl_deinit_rfkill(struct ieee80211_hw *hw)
 {
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.h
@@ -239,7 +239,6 @@ int __devinit rtl_pci_probe(struct pci_d
 void rtl_pci_disconnect(struct pci_dev *pdev);
 int rtl_pci_suspend(struct device *dev);
 int rtl_pci_resume(struct device *dev);
-
 static inline u8 pci_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
 	return readb((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/led.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/led.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/led.c
@@ -76,10 +76,13 @@ void rtl92se_sw_led_on(struct ieee80211_
 
 void rtl92se_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_priv *rtlpriv;
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 ledcfg;
 
+	rtlpriv = rtl_priv(hw);
+	if (!rtlpriv || rtlpriv->max_fw_size)
+		return;
 	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, "LedAddr:%X ledpin=%d\n",
 		 LEDCFG, pled->ledpin);
 
