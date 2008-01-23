Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:55645 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbYAWLAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 06:00:06 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: b43 bug on card removal
Date: Wed, 23 Jan 2008 11:58:38 +0100
Cc: linux-wireless@vger.kernel.org
References: <4796AD76.7020304@candelatech.com>
In-Reply-To: <4796AD76.7020304@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801231158.38980.mb@bu3sch.de> (sfid-20080123_110011_398353_AA3CF117)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 January 2008, Ben Greear wrote:
> Jan 22 17:50:20 nx5000 kernel: b43-phy1 ERROR: Firmware file "b43/ucode5.fw" not found or load failed.
> Jan 22 17:50:20 nx5000 kernel: b43-phy1 ERROR: You must go to http://linuxwireless.org/en/users/Drivers/b43#devicefir mware and download the latest firmware (version 4).

I don't have to explain that, right?

> Jan 22 17:50:20 nx5000 firmware.sh[2934]: Cannot find  firmware file 'b43/ucode5.fw'
> Jan 22 17:50:28 nx5000 kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
> Jan 22 17:50:29 nx5000 kernel: nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
> Jan 22 17:52:23 nx5000 kernel: pccard: card ejected from slot 1
> Jan 22 17:52:23 nx5000 kernel: ACPI: PCI interrupt for device 0000:03:00.0 disabled
> Jan 22 17:52:31 nx5000 kernel: list_add corruption. prev->next should be next (df3c0e94), but was 00000001. (prev=de4 f9600).
> Jan 22 17:52:31 nx5000 kernel: ------------[ cut here ]------------
> Jan 22 17:52:31 nx5000 kernel: kernel BUG at /mnt/ghome/greearb/git/wireless-2.6/lib/list_debug.c:33!
> Jan 22 17:52:31 nx5000 kernel: invalid opcode: 0000 [#1] PREEMPT SMP
> Jan 22 17:52:31 nx5000 kernel: Modules linked in: rfkill_input 8021q redirdev macvlan pktgen rfcomm l2cap bluetooth a utofs4 sunrpc xirc2ps_cs ipv6 cpufreq_ondemand acpi_cpufreq loop snd_intel8x0 snd_intel8x0m snd_seq_dummy snd_ac97_co dec ac97_bus snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_timer b 43 ecb rfkill input_polldev blkcipher tifm_7xx1 firewire_ohci firewire_core snd smsc_ircc2 tifm_core ath5k mac80211 c fg80211 video irda iTCO_wdt crc_itu_t iTCO_vendor_support output battery b44 mii ac parport_pc soundcore parport snd_ page_alloc sr_mod crc_ccitt joydev button pcspkr serio_raw sg floppy cdrom dm_snapshot dm_zero dm_mirror dm_mod ata_g eneric 
> ata_piix pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ssb ehci_hcd
> Jan 22 17:52:31 nx5000 kernel:
> Jan 22 17:52:31 nx5000 kernel: Pid: 2928, comm: ipolldevd Not tainted (2.6.24-rc8 #1)
> Jan 22 17:52:31 nx5000 kernel: EIP: 0060:[<c04f7721>] EFLAGS: 00010292 CPU: 0
> Jan 22 17:52:31 nx5000 kernel: EIP is at __list_add+0x48/0x5c
> Jan 22 17:52:31 nx5000 kernel: EAX: 00000061 EBX: de524f40 ECX: de524000 EDX: 00000001
> Jan 22 17:52:31 nx5000 kernel: ESI: 00000001 EDI: de0f06a0 EBP: df3f3f60 ESP: de524f24
> Jan 22 17:52:31 nx5000 kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Jan 22 17:52:31 nx5000 kernel: Process ipolldevd (pid: 2928, ti=de524000 task=de0f06a0 task.ti=de524000)
> Jan 22 17:52:31 nx5000 kernel: Stack: c06ce997 df3c0e94 00000001 de4f9600 df3c0e88 df3c0e88 c0622b89 00000246
> Jan 22 17:52:31 nx5000 kernel:        c0623cd2 c0429305 df3c0e88 df3f3f74 df3c0e88 c0622a8d c0622573 dea86800
> Jan 22 17:52:31 nx5000 kernel:        e02bb7c9 ffffffff c043cea4 00000000 df3c0e80 df3f3f60 df3f3f74 df3f3f74
> Jan 22 17:52:31 nx5000 kernel: Call Trace:
> Jan 22 17:52:31 nx5000 kernel:  [<c0622b89>] __mutex_lock_slowpath+0x24/0x7f
> Jan 22 17:52:31 nx5000 kernel:  [<c0623cd2>] _spin_unlock_irq+0x18/0x2c
> Jan 22 17:52:31 nx5000 kernel:  [<c0429305>] finish_task_switch+0x1d/0x82
> Jan 22 17:52:31 nx5000 kernel:  [<c0622a8d>] mutex_lock+0x21/0x24
> Jan 22 17:52:31 nx5000 kernel:  [<c0622573>] schedule+0x657/0x671
> Jan 22 17:52:31 nx5000 kernel:  [<e02bb7c9>] b43_rfkill_poll+0x1e/0xe5 [b43]
> Jan 22 17:52:31 nx5000 kernel:  [<c043cea4>] queue_delayed_work_on+0x8e/0x9a
> Jan 22 17:52:31 nx5000 kernel:  [<e029909d>] input_polled_device_work+0x0/0x24 [input_polldev]
> Jan 22 17:52:31 nx5000 kernel:  [<e02990a9>] input_polled_device_work+0xc/0x24 [input_polldev]
> Jan 22 17:52:31 nx5000 kernel:  [<c043c7fb>] run_workqueue+0x77/0xfc
> Jan 22 17:52:31 nx5000 kernel:  [<c043fd16>] prepare_to_wait+0x24/0x3f
> Jan 22 17:52:31 nx5000 kernel:  [<c043d0a9>] worker_thread+0x0/0xc7
> Jan 22 17:52:31 nx5000 kernel:  [<c043d163>] worker_thread+0xba/0xc7
> Jan 22 17:52:31 nx5000 kernel:  [<c043fbcc>] autoremove_wake_function+0x0/0x35
> Jan 22 17:52:31 nx5000 kernel:  [<c043fafc>] kthread+0x38/0x60
> Jan 22 17:52:31 nx5000 kernel:  [<c043fac4>] kthread+0x0/0x60
> Jan 22 17:52:31 nx5000 kernel:  [<c0405da3>] kernel_thread_helper+0x7/0x10
> Jan 22 17:52:31 nx5000 kernel:  =======================
> Jan 22 17:52:31 nx5000 kernel: Code: 47 e9 6c c0 e8 33 7a f3 ff 0f 0b eb fe 8b 32 39 ce 74 1c 89 54 24 0c 89 74 24 08  89 4c 24 04 c7 04 24 97 e9 6c c0 e8 11 7a f3 ff <0f> 0b eb fe 89 59 04 89 0b 89 43 04 89 18 83 c4 10 5b 5e c3 8b
> Jan 22 17:52:31 nx5000 kernel: EIP: [<c04f7721>] __list_add+0x48/0x5c SS:ESP 0068:de524f24
> Jan 22 17:52:31 nx5000 kernel: ---[ end trace 67c9aa1fe405439a ]---

Should be fixed by the following patch.

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-01-23 11:52:50.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-01-23 11:55:17.000000000 +0100
@@ -3626,38 +3626,45 @@ static void b43_op_remove_interface(stru
 static int b43_op_start(struct ieee80211_hw *hw)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 	int did_init = 0;
 	int err = 0;
+	bool do_rfkill_exit = 0;
 
 	/* First register RFkill.
 	 * LEDs that are registered later depend on it. */
 	b43_rfkill_init(dev);
 
 	mutex_lock(&wl->mutex);
 
 	if (b43_status(dev) < B43_STAT_INITIALIZED) {
 		err = b43_wireless_core_init(dev);
-		if (err)
+		if (err) {
+			do_rfkill_exit = 1;
 			goto out_mutex_unlock;
+		}
 		did_init = 1;
 	}
 
 	if (b43_status(dev) < B43_STAT_STARTED) {
 		err = b43_wireless_core_start(dev);
 		if (err) {
 			if (did_init)
 				b43_wireless_core_exit(dev);
+			do_rfkill_exit = 1;
 			goto out_mutex_unlock;
 		}
 	}
 
  out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
 
+	if (do_rfkill_exit)
+		b43_rfkill_exit(dev);
+
 	return err;
 }
 
 static void b43_op_stop(struct ieee80211_hw *hw)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);

