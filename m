Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54137 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1B1Wka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 17:40:30 -0500
Date: Mon, 28 Feb 2011 16:40:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix error registering rate-control
Message-ID: <4d6c245c.QdaRNI2fJAp8tw9+%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

When a second module such as rtl8192ce or rtl8192cu links to rtlwifi, the attempt
to register a rate-control mechanism fails with the warning shown below. The fix is to
select the RC mechanism when rtlwifi is initialized.


WARNING: at net/mac80211/rate.c:42 ieee80211_rate_control_register+0xc9/0x100 [mac80211]()
Hardware name: HP Pavilion dv2700 Notebook PC
Modules linked in: arc4 ecb rtl8192ce rtl8192cu(+) rtl8192c_common rtlwifi snd_hda_codec_conexant amd74xx(+) ide_core sg mac80211 snd_hda_intel snd_hda_codec i2c_nforce2 snd_pcm snd_timer cfg80211 snd k8temp hwmon serio_raw joydev i2c_core soundcore snd_page_alloc rfkill forcedeth video ac battery button ext3 jbd mbcache sd_mod ohci_hcd ahci libahci libata scsi_mod ehci_hcd usbcore fan processor thermal
Pid: 2227, comm: modprobe Not tainted 2.6.38-rc6-wl+ #468
Call Trace:
 [<ffffffff8104a3da>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff8104a425>] ? warn_slowpath_null+0x15/0x20
 [<ffffffffa02de409>] ? ieee80211_rate_control_register+0xc9/0x100 [mac80211]
 [<ffffffffa03b3790>] ? rtl_rate_control_register+0x10/0x20 [rtlwifi]
 [<ffffffffa03ab9c9>] ? rtl_init_core+0x189/0x620 [rtlwifi]
 [<ffffffff811cfff8>] ? __raw_spin_lock_init+0x38/0x70
 [<ffffffffa03b9dea>] ? rtl_usb_probe+0x709/0x82e [rtlwifi]
 [<ffffffffa002a7fd>] ? usb_match_one_id+0x3d/0xc0 [usbcore]
 [<ffffffffa002aae9>] ? usb_probe_interface+0xb9/0x160 [usbcore]
 [<ffffffff8126ed19>] ? driver_probe_device+0x89/0x1a0
 [<ffffffff8126eed3>] ? __driver_attach+0xa3/0xb0
 [<ffffffff8126ee30>] ? __driver_attach+0x0/0xb0
 [<ffffffff8126dd4e>] ? bus_for_each_dev+0x5e/0x90
 [<ffffffff8126e9d9>] ? driver_attach+0x19/0x20
 [<ffffffff8126e5e8>] ? bus_add_driver+0x158/0x290
 [<ffffffff8126f151>] ? driver_register+0x71/0x140
 [<ffffffff811cfff8>] ? __raw_spin_lock_init+0x38/0x70
 [<ffffffffa002a2cc>] ? usb_register_driver+0xdc/0x190 [usbcore]
 [<ffffffffa0013000>] ? rtl8192cu_init+0x0/0x20 [rtl8192cu]
 [<ffffffffa001301e>] ? rtl8192cu_init+0x1e/0x20 [rtl8192cu]
 [<ffffffff810002cf>] ? do_one_initcall+0x3f/0x180
 [<ffffffff8108fd4b>] ? sys_init_module+0xbb/0x200
 [<ffffffff81002c7b>] ? system_call_fastpath+0x16/0x1b
 ---[ end trace 726271c07a47439e ]---
rtlwifi:rtl_init_core():<0-0> rtl: Unable to register rtl_rc,use default RC !!
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'

Signed-off-by: Chaoming Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -283,13 +283,7 @@ int rtl_init_core(struct ieee80211_hw *h
 	rtlmac->hw = hw;
 
 	/* <2> rate control register */
-	if (rtl_rate_control_register()) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("rtl: Unable to register rtl_rc,"
-			  "use default RC !!\n"));
-	} else {
-		hw->rate_control_algorithm = "rtl_rc";
-	}
+	hw->rate_control_algorithm = "rtl_rc";
 
 	/*
 	 * <3> init CRDA must come after init
@@ -325,8 +319,6 @@ int rtl_init_core(struct ieee80211_hw *h
 
 void rtl_deinit_core(struct ieee80211_hw *hw)
 {
-	 /*RC*/
-	rtl_rate_control_unregister();
 }
 
 void rtl_init_rx_config(struct ieee80211_hw *hw)
@@ -945,11 +937,16 @@ MODULE_DESCRIPTION("Realtek 802.11n PCI
 
 static int __init rtl_core_module_init(void)
 {
+	if (rtl_rate_control_register())
+		printk(KERN_ERR "rtlwifi: Unable to register rtl_rc,"
+		       "use default RC !!\n");
 	return 0;
 }
 
 static void __exit rtl_core_module_exit(void)
 {
+	 /*RC*/
+	rtl_rate_control_unregister();
 }
 
 module_init(rtl_core_module_init);
