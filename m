Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:38853 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759622AbZKYTy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 14:54:58 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: RTL8187 warnings on suspend
Date: Wed, 25 Nov 2009 17:55:00 -0200
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200911251626.15959.mb@bu3sch.de> <200911251625.39536.herton@mandriva.com.br> <200911252029.22084.mb@bu3sch.de>
In-Reply-To: <200911252029.22084.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911251755.00596.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Qua 25 Nov 2009, às 17:29:21, Michael Buesch escreveu:
> On Wednesday 25 November 2009 19:25:39 Herton Ronaldo Krzesinski wrote:
> > of the led inside rtl8187_leds_exit, like the patch below, could you try it?
> 
> Does not completely fix it

Indeed, ieee80211_queue_delayed_work run also in rtl8187_led_brightness_set...
my patch didn't fix anything... I think the only way is starting and stopping
leds in start and stop, the following patch should do it:

diff --git a/drivers/net/wireless/rtl818x/rtl8187.h b/drivers/net/wireless/rtl818x/rtl8187.h
index bf9175a..4b85a77 100644
--- a/drivers/net/wireless/rtl818x/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187.h
@@ -133,6 +133,9 @@ struct rtl8187_priv {
 		__le16 bits16;
 		__le32 bits32;
 	} *io_dmabuf;
+#ifdef CONFIG_RTL8187_LEDS
+	u16 custid;
+#endif
 	bool rfkill_off;
 };
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 2017ccc..ad95bdd 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -990,6 +990,7 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 
 rtl8187_start_exit:
 	mutex_unlock(&priv->conf_mutex);
+	rtl8187_leds_start(dev);
 	return ret;
 }
 
@@ -1022,6 +1023,10 @@ static void rtl8187_stop(struct ieee80211_hw *dev)
 
 	if (!priv->is_rtl8187b)
 		cancel_delayed_work_sync(&priv->work);
+
+#ifdef CONFIG_RTL8187_LEDS
+	rtl8187_leds_stop(dev);
+#endif
 }
 
 static int rtl8187_add_interface(struct ieee80211_hw *dev,
@@ -1522,8 +1527,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 
 #ifdef CONFIG_RTL8187_LEDS
 	eeprom_93cx6_read(&eeprom, 0x3F, &reg);
-	reg &= 0xFF;
-	rtl8187_leds_init(dev, reg);
+	priv->custid = reg & 0xFF;
 #endif
 	rtl8187_rfkill_init(dev);
 
@@ -1546,9 +1550,6 @@ static void __devexit rtl8187_disconnect(struct usb_interface *intf)
 	if (!dev)
 		return;
 
-#ifdef CONFIG_RTL8187_LEDS
-	rtl8187_leds_exit(dev);
-#endif
 	rtl8187_rfkill_exit(dev);
 	ieee80211_unregister_hw(dev);
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c b/drivers/net/wireless/rtl818x/rtl8187_leds.c
index cf8a4a4..a48407f 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -149,7 +149,7 @@ static void rtl8187_unregister_led(struct rtl8187_led *led)
 	led->dev = NULL;
 }
 
-void rtl8187_leds_init(struct ieee80211_hw *dev, u16 custid)
+void rtl8187_leds_start(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	char name[RTL8187_LED_MAX_NAME_LEN + 1];
@@ -159,8 +159,8 @@ void rtl8187_leds_init(struct ieee80211_hw *dev, u16 custid)
 	/* According to the vendor driver, the LED operation depends on the
 	 * customer ID encoded in the EEPROM
 	 */
-	printk(KERN_INFO "rtl8187: Customer ID is 0x%02X\n", custid);
-	switch (custid) {
+	printk(KERN_INFO "rtl8187: Customer ID is 0x%02X\n", priv->custid);
+	switch (priv->custid) {
 	case EEPROM_CID_RSVD0:
 	case EEPROM_CID_RSVD1:
 	case EEPROM_CID_SERCOMM_PS:
@@ -204,7 +204,7 @@ error:
 	cancel_delayed_work_sync(&priv->led_on);
 }
 
-void rtl8187_leds_exit(struct ieee80211_hw *dev)
+void rtl8187_leds_stop(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.h b/drivers/net/wireless/rtl818x/rtl8187_leds.h
index a033202..2751430 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.h
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.h
@@ -49,8 +49,8 @@ struct rtl8187_led {
 	char name[RTL8187_LED_MAX_NAME_LEN + 1];
 };
 
-void rtl8187_leds_init(struct ieee80211_hw *dev, u16 code);
-void rtl8187_leds_exit(struct ieee80211_hw *dev);
+void rtl8187_leds_start(struct ieee80211_hw *dev);
+void rtl8187_leds_stop(struct ieee80211_hw *dev);
 
 #endif /* def CONFIG_RTL8187_LED */
 


> 
> [14727.733053] Freezing user space processes ... (elapsed 0.00 seconds) done.
> [14727.735205] Freezing remaining freezable tasks ... (elapsed 1.15 seconds) done.
> [14728.918070] queueing ieee80211 work while going to suspend
> [14728.919327] ------------[ cut here ]------------
> [14728.920372] Badness at net/mac80211/util.c:524
> [14728.921401] NIP: f244c71c LR: f244c71c CTR: 00000000
> [14728.922441] REGS: ee95bb50 TRAP: 0700   Tainted: G        W   (2.6.32-rc8-wl-wltest)
> [14728.923562] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 22082444  XER: 00000000
> [14728.924787] TASK = efb46000[2479] 'pbbuttonsd' THREAD: ee95a000
> [14728.924980] GPR00: f244c71c ee95bc00 efb46000 00000041 00000001 c0041078 00000000 00000002 
> [14728.926257] GPR08: 00000000 00000000 efb46000 00009032 22082444 100351d0 bff9c428 bff9c42c 
> [14728.927536] GPR16: 0fc6fb2c 0fc6fa88 c0811598 c0983594 c0aa0000 00000002 00000004 00000001 
> [14728.928836] GPR24: ee95bdd8 00000005 c0aa2b74 00000000 00000000 ed7db04c ed7dac20 ed7da300 
> [14728.931137] NIP [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
> [14728.932305] LR [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
> [14728.933462] Call Trace:
> [14728.934487] [ee95bc00] [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211] (unreliable)
> [14728.935735] [ee95bc10] [f2d480e0] rtl8187_led_brightness_set+0x34/0x88 [rtl8187]
> [14728.936930] [ee95bc30] [c05306f8] led_trigger_set+0xf4/0xf8
> [14728.938071] [ee95bc50] [c05301fc] led_classdev_unregister+0x64/0xa8
> [14728.939236] [ee95bc70] [f2d48078] rtl8187_leds_exit+0x20/0x54 [rtl8187]
> [14728.940411] [ee95bc90] [f2d48b84] rtl8187_disconnect+0x28/0x74 [rtl8187]
> [14728.941588] [ee95bcb0] [c04aa084] usb_unbind_interface+0x170/0x1bc
> [14728.942752] [ee95bcd0] [c0417a14] __device_release_driver+0x84/0xe4
> [14728.943910] [ee95bcf0] [c0417b68] device_release_driver+0x28/0x44
> [14728.945065] [ee95bd10] [c04aa308] usb_driver_release_interface+0x90/0x94
> [14728.946231] [ee95bd30] [c04aa3c4] usb_forced_unbind_intf+0x24/0x48
> [14728.947387] [ee95bd50] [c04aa4c0] do_unbind_rebind+0xd8/0xe0
> [14728.948526] [ee95bd70] [c04aa5f0] usb_external_suspend_device+0x24/0x74
> [14728.949691] [ee95bda0] [c04aa6b0] usb_suspend+0x70/0x9c
> [14728.950822] [ee95bdb0] [c049ced8] usb_dev_suspend+0x1c/0x2c
> [14728.951963] [ee95bdc0] [c041c8ec] pm_op+0x19c/0x1f8
> [14728.953085] [ee95bdd0] [c041d1ec] dpm_suspend_start+0x384/0x4e8
> [14728.954230] [ee95be30] [c00870b0] suspend_devices_and_enter+0x5c/0x1cc
> [14728.955372] [ee95be50] [c0087304] enter_state+0xe4/0xf4
> [14728.956475] [ee95be70] [c0424e54] pmu_ioctl+0x84/0x1e0
> [14728.957565] [ee95be80] [c00fc8dc] vfs_ioctl+0xb8/0xc4
> [14728.958637] [ee95bea0] [c00fcab8] do_vfs_ioctl+0x84/0x7ec
> [14728.959712] [ee95bf10] [c00fd260] sys_ioctl+0x40/0x88
> [14728.960771] [ee95bf40] [c0017334] ret_from_syscall+0x0/0x38
> [14728.961832] --- Exception: c01 at 0xfaab878
> [14728.961834]     LR = 0xfaab7dc
> [14728.963792] Instruction dump:
> [14728.964761] 880300de 2f800000 419e001c 80630048 4800914d 80010014 38210010 7c0803a6 
> [14728.966006] 4e800020 3c60f246 38638bb0 48008bb1 <0fe00000> 80010014 38210010 7c0803a6 
> [14728.967624] queueing ieee80211 work while going to suspend
> [14728.968740] ------------[ cut here ]------------
> [14728.969762] Badness at net/mac80211/util.c:524
> [14728.970769] NIP: f244c71c LR: f244c71c CTR: 00000000
> [14728.971797] REGS: ee95bb50 TRAP: 0700   Tainted: G        W   (2.6.32-rc8-wl-wltest)
> [14728.972919] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 42082444  XER: 00000000
> [14728.974155] TASK = efb46000[2479] 'pbbuttonsd' THREAD: ee95a000
> [14728.974347] GPR00: f244c71c ee95bc00 efb46000 00000041 00000001 c0041078 00000000 00000002 
> [14728.975641] GPR08: 00000000 ee95a000 efb46000 00009032 22082444 100351d0 bff9c428 bff9c42c 
> [14728.976929] GPR16: 0fc6fb2c 0fc6fa88 c0811598 c0983594 c0aa0000 00000002 00000004 00000001 
> [14728.978240] GPR24: ee95bdd8 00000005 c0aa2b74 00000000 00000000 ed7dafc0 ed7dac20 ed7da300 
> [14728.980501] NIP [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
> [14728.981667] LR [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
> [14728.982831] Call Trace:
> [14728.983858] [ee95bc00] [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211] (unreliable)
> [14728.985116] [ee95bc10] [f2d480e0] rtl8187_led_brightness_set+0x34/0x88 [rtl8187]
> [14728.986322] [ee95bc30] [c05306f8] led_trigger_set+0xf4/0xf8
> [14728.987464] [ee95bc50] [c05301fc] led_classdev_unregister+0x64/0xa8
> [14728.988610] [ee95bc70] [f2d48084] rtl8187_leds_exit+0x2c/0x54 [rtl8187]
> [14728.989749] [ee95bc90] [f2d48b84] rtl8187_disconnect+0x28/0x74 [rtl8187]
> [14728.990866] [ee95bcb0] [c04aa084] usb_unbind_interface+0x170/0x1bc
> [14728.991962] [ee95bcd0] [c0417a14] __device_release_driver+0x84/0xe4
> [14728.993057] [ee95bcf0] [c0417b68] device_release_driver+0x28/0x44
> [14728.994146] [ee95bd10] [c04aa308] usb_driver_release_interface+0x90/0x94
> [14728.995249] [ee95bd30] [c04aa3c4] usb_forced_unbind_intf+0x24/0x48
> [14728.996338] [ee95bd50] [c04aa4c0] do_unbind_rebind+0xd8/0xe0
> [14728.997402] [ee95bd70] [c04aa5f0] usb_external_suspend_device+0x24/0x74
> [14728.998497] [ee95bda0] [c04aa6b0] usb_suspend+0x70/0x9c
> [14728.999550] [ee95bdb0] [c049ced8] usb_dev_suspend+0x1c/0x2c
> [14729.000612] [ee95bdc0] [c041c8ec] pm_op+0x19c/0x1f8
> [14729.001659] [ee95bdd0] [c041d1ec] dpm_suspend_start+0x384/0x4e8
> [14729.002743] [ee95be30] [c00870b0] suspend_devices_and_enter+0x5c/0x1cc
> [14729.003840] [ee95be50] [c0087304] enter_state+0xe4/0xf4
> [14729.004899] [ee95be70] [c0424e54] pmu_ioctl+0x84/0x1e0
> [14729.005952] [ee95be80] [c00fc8dc] vfs_ioctl+0xb8/0xc4
> [14729.007008] [ee95bea0] [c00fcab8] do_vfs_ioctl+0x84/0x7ec
> [14729.008071] [ee95bf10] [c00fd260] sys_ioctl+0x40/0x88
> [14729.009126] [ee95bf40] [c0017334] ret_from_syscall+0x0/0x38
> [14729.010200] --- Exception: c01 at 0xfaab878
> [14729.010202]     LR = 0xfaab7dc
> [14729.012189] Instruction dump:
> [14729.013175] 880300de 2f800000 419e001c 80630048 4800914d 80010014 38210010 7c0803a6 
> [14729.014444] 4e800020 3c60f246 38638bb0 48008bb1 <0fe00000> 80010014 38210010 7c0803a6 
> 
> 

-- 
[]'s
Herton
