Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:54623 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931AbZKYSZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 13:25:37 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: RTL8187 warnings on suspend
Date: Wed, 25 Nov 2009 16:25:39 -0200
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200911251626.15959.mb@bu3sch.de>
In-Reply-To: <200911251626.15959.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911251625.39536.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Qua 25 Nov 2009, às 13:26:15, Michael Buesch escreveu:
> 
> [   76.758422] queueing ieee80211 work while going to suspend
> [   76.758768] ------------[ cut here ]------------
> [   76.758927] Badness at net/mac80211/util.c:524
> [   76.759080] NIP: f244c71c LR: f244c71c CTR: 00000000
> [   76.759249] REGS: ee95bbb0 TRAP: 0700   Not tainted  (2.6.32-rc8-wl-wltest)
> [   76.759476] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 22082444  XER: 00000000
> [   76.759856] TASK = efb46000[2479] 'pbbuttonsd' THREAD: ee95a000
> [   76.760052] GPR00: f244c71c ee95bc60 efb46000 00000041 00000001 c0041078 00000000 00000002 
> [   76.760490] GPR08: 00000000 00000000 efb46000 00009032 22082444 100351d0 bff9c428 bff9c42c 
> [   76.760927] GPR16: 0fc6fb2c 0fc6fa88 c0811598 c0983594 c0aa0000 00000002 00000004 00000001 
> [   76.761364] GPR24: ee95bdd8 00000005 c0aa2b74 eebcd114 00000000 eebccc20 ed520800 eebcc300 
> [   76.761858] NIP [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
> [   76.762093] LR [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
> [   76.762318] Call Trace:
> [   76.762415] [ee95bc60] [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211] (unreliable)
> [   76.762738] [ee95bc70] [f26370f8] rtl8187_leds_exit+0x28/0x64 [rtl8187]
> [   76.762972] [ee95bc90] [f2637b84] rtl8187_disconnect+0x28/0x74 [rtl8187]
> [   76.763211] [ee95bcb0] [c04aa084] usb_unbind_interface+0x170/0x1bc
> [   76.763436] [ee95bcd0] [c0417a14] __device_release_driver+0x84/0xe4
> [   76.763658] [ee95bcf0] [c0417b68] device_release_driver+0x28/0x44
> [   76.763875] [ee95bd10] [c04aa308] usb_driver_release_interface+0x90/0x94
> [   76.764110] [ee95bd30] [c04aa3c4] usb_forced_unbind_intf+0x24/0x48
> [   76.764329] [ee95bd50] [c04aa4c0] do_unbind_rebind+0xd8/0xe0
> [   76.764532] [ee95bd70] [c04aa5f0] usb_external_suspend_device+0x24/0x74
> [   76.764764] [ee95bda0] [c04aa6b0] usb_suspend+0x70/0x9c
> [   76.764957] [ee95bdb0] [c049ced8] usb_dev_suspend+0x1c/0x2c
> [   76.765160] [ee95bdc0] [c041c8ec] pm_op+0x19c/0x1f8
> [   76.765339] [ee95bdd0] [c041d1ec] dpm_suspend_start+0x384/0x4e8
> [   76.765555] [ee95be30] [c00870b0] suspend_devices_and_enter+0x5c/0x1cc
> [   76.765784] [ee95be50] [c0087304] enter_state+0xe4/0xf4
> [   76.765978] [ee95be70] [c0424e54] pmu_ioctl+0x84/0x1e0
> [   76.766167] [ee95be80] [c00fc8dc] vfs_ioctl+0xb8/0xc4
> [   76.766352] [ee95bea0] [c00fcab8] do_vfs_ioctl+0x84/0x7ec
> [   76.766547] [ee95bf10] [c00fd260] sys_ioctl+0x40/0x88
> [   76.766734] [ee95bf40] [c0017334] ret_from_syscall+0x0/0x38
> [   76.766935] --- Exception: c01 at 0xfaab878
> [   76.766937]     LR = 0xfaab7dc
> [   76.767183] Instruction dump:
> [   76.767305] 880300de 2f800000 419e001c 80630048 4800914d 80010014 38210010 7c0803a6 
> [   76.767707] 4e800020 3c60f246 38638bb0 48008bb1 <0fe00000> 80010014 38210010 7c0803a6 
> [   76.768225] queueing ieee80211 work while going to suspend
<snip>

I think the problem is the call to rtl8187_leds_exit after rtl8187_stop,
because rtl8187_leds_exit calls ieee80211_queue_delayed_work. We can avoid
calling ieee80211_queue_delayed_work, replacing it with simple
queue_delayed_work as was before just to avoid the warning, or may be just
relying on current leds code and check if trigger is NULL, avoid having to turn
of the led inside rtl8187_leds_exit, like the patch below, could you try it?
(patch untested, hope it works)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c b/drivers/net/wireless/rtl818x/rtl8187_leds.c
index cf8a4a4..7591e3d 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -109,8 +109,12 @@ static void rtl8187_led_brightness_set(struct led_classdev *led_dev,
 
 	if (brightness == LED_OFF) {
 		ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
-		/* The LED is off for 1/20 sec so that it just blinks. */
-		ieee80211_queue_delayed_work(hw, &priv->led_on, HZ / 20);
+		/* The LED is off for 1/20 sec so that it just blinks.
+		 * If trigger is null it means we are unregistering leds,
+		 * so avoid turning it on. */
+		if (led_dev->trigger)
+			ieee80211_queue_delayed_work(hw, &priv->led_on,
+						     HZ / 20);
 	} else
 		ieee80211_queue_delayed_work(hw, &priv->led_on, 0);
 }
@@ -209,7 +213,6 @@ void rtl8187_leds_exit(struct ieee80211_hw *dev)
 	struct rtl8187_priv *priv = dev->priv;
 
 	/* turn the LED off before exiting */
-	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
 	rtl8187_unregister_led(&priv->led_rx);
 	rtl8187_unregister_led(&priv->led_tx);
 	cancel_delayed_work_sync(&priv->led_off);


-- 
[]'s
Herton
