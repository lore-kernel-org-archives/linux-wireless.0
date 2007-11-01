Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:63909 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXKATR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 15:17:26 -0400
Received: by an-out-0708.google.com with SMTP id b36so88177ana
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 12:17:25 -0700 (PDT)
Date: Thu, 1 Nov 2007 15:17:16 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: RFC: Reproducible oops with lockdep on count_matching_names()
Message-ID: <20071101191716.GA3201@pogo> (sfid-20071101_191732_265577_AC85638C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mcgrof@pogo:~/devel/wireless-2.6$ git-describe 
v2.6.24-rc1-146-g2280253

So I hit segfault with lockdep on count_matching_names() on the
strcmp() multiple times now. This is reproducible and with different
wireless drivers.

Essentially I have an ipw2200 built-in to my laptop so the driver
always loads on bootup. Then I have a few cardbus cards. I've tested
this with ath5k and with b43. If I do the following after bootup I
always get a segfault:

(ipw2200 loaded as I have the card built-in)

--> Insert my ath5k card ---- OR ---- Insert b43 card
mcgrof@pogo:~$ sudo rmmod ipw2200 
mcgrof@pogo:~$ sudo rmmod ath5k  ---- OR ----  sudo rmmod b43
mcgrof@pogo:~$ sudo modprobe ipw2200 
Segmentation fault

Below you'll find a few captured oops:

ath5k + ipw2200 combo:

****************************************************************
Nov  1 13:15:17 pogo kernel: pccard: CardBus card inserted into slot 0
Nov  1 13:15:17 pogo kernel: PCI: Enabling device 0000:15:00.0 (0000 -> 0002)
Nov  1 13:15:17 pogo kernel: ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Nov  1 13:15:17 pogo kernel: phy0: Selected rate control algorithm 'simple'
Nov  1 13:15:17 pogo kernel: ath5k_pci 0000:15:00.0: Atheros AR5213A chip found: MAC 0x59, PHY: 0x43
Nov  1 13:15:17 pogo kernel: ath5k_pci 0000:15:00.0: RF5112A radio found (0x36)
Nov  1 13:15:34 pogo kernel: ACPI: PCI interrupt for device 0000:14:02.0 disabled
Nov  1 13:15:39 pogo kernel: ACPI: PCI interrupt for device 0000:15:00.0 disabled
Nov  1 13:15:43 pogo kernel: ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmpr
Nov  1 13:15:43 pogo kernel: ipw2200: Copyright(c) 2003-2006 Intel Corporation
Nov  1 13:15:43 pogo kernel: ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 18
Nov  1 13:15:43 pogo kernel: ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
Nov  1 13:15:43 pogo kernel: BUG: unable to handle kernel paging request at virtual address f89ba359
Nov  1 13:15:43 pogo kernel: printing eip: c01be6e4 *pde = 02000067 *pte = 00000000 
Nov  1 13:15:43 pogo kernel: Oops: 0000 [#1] 
Nov  1 13:15:43 pogo kernel: Modules linked in: ipw2200 arc4 ecb blkcipher cryptomgr crypto_algapi rc80211_simple mac80211 cfg80211 uinput thinkpad_acpi hwmon backlight nvram ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative dock snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_oss snd_seq_midi_event pcmcia crc32 snd_seq ieee80211 ieee80211_crypt snd_timer snd_seq_device firmware_class sg ehci_hcd uhci_hcd yenta_socket rsrc_nonstatic pcmcia_core sr_mod cdrom tg3 snd evdev usbcore rng_core rtc soundcore
Nov  1 13:15:43 pogo kernel: 
Nov  1 13:15:43 pogo kernel: Pid: 2950, comm: modprobe Not tainted (2.6.24-rc1 #6)
Nov  1 13:15:43 pogo kernel: EIP: 0060:[strcmp+9/29] EFLAGS: 00010086 CPU: 0
Nov  1 13:15:43 pogo kernel: EIP is at strcmp+0x9/0x1d
Nov  1 13:15:43 pogo kernel: EAX: f89ba359 EBX: c044ce00 ECX: 00000000 EDX: f8941e70
Nov  1 13:15:43 pogo kernel: ESI: f89ba359 EDI: f8941e70 EBP: c2b3bce4 ESP: c2b3bcdc
Nov  1 13:15:43 pogo kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Nov  1 13:15:43 pogo kernel: Process modprobe (pid: 2950, ti=c2b3a000 task=c3403010 task.ti=c2b3a000)
Nov  1 13:15:43 pogo kernel: Stack: c044cfb8 00000000 c2b3bcf8 c013034d 000303b8 c044cfb8 00000002 c2b3bd58 
Nov  1 13:15:43 pogo kernel:        c01329b7 00000000 00000000 00000000 00000000 00000000 00000000 00000002 
Nov  1 13:15:43 pogo kernel:        00000000 00000000 c352acdc 00000000 c3403010 00000000 c04d4580 00000000 
Nov  1 13:15:43 pogo kernel: Call Trace:
Nov  1 13:15:43 pogo kernel:  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
Nov  1 13:15:43 pogo kernel:  [show_stack_log_lvl+157/165] show_stack_log_lvl+0x9d/0xa5
Nov  1 13:15:43 pogo kernel:  [show_registers+173/380] show_registers+0xad/0x17c
Nov  1 13:15:43 pogo kernel:  [die+245/454] die+0xf5/0x1c6
Nov  1 13:15:43 pogo kernel:  [do_page_fault+1104/1335] do_page_fault+0x450/0x537
Nov  1 13:15:43 pogo kernel:  [error_code+106/112] error_code+0x6a/0x70
Nov  1 13:15:43 pogo kernel:  [count_matching_names+74/118] count_matching_names+0x4a/0x76
Nov  1 13:15:43 pogo kernel:  [__lock_acquire+609/3102] __lock_acquire+0x261/0xc1e
Nov  1 13:15:43 pogo kernel:  [lock_acquire+120/145] lock_acquire+0x78/0x91
Nov  1 13:15:43 pogo kernel:  [mutex_lock_nested+244/628] mutex_lock_nested+0xf4/0x274
Nov  1 13:15:43 pogo kernel:  [<f8938e9d>] ipw_pci_probe+0x8aa/0xac6 [ipw2200]
Nov  1 13:15:43 pogo kernel:  [pci_device_probe+57/91] pci_device_probe+0x39/0x5b
Nov  1 13:15:43 pogo kernel:  [driver_probe_device+232/360] driver_probe_device+0xe8/0x168
Nov  1 13:15:43 pogo kernel:  [__driver_attach+106/161] __driver_attach+0x6a/0xa1
Nov  1 13:15:43 pogo kernel:  [bus_for_each_dev+54/91] bus_for_each_dev+0x36/0x5b
Nov  1 13:15:43 pogo kernel:  [driver_attach+25/27] driver_attach+0x19/0x1b
Nov  1 13:15:43 pogo kernel:  [bus_add_driver+115/426] bus_add_driver+0x73/0x1aa
Nov  1 13:15:43 pogo kernel:  [driver_register+103/108] driver_register+0x67/0x6c
Nov  1 13:15:43 pogo kernel:  [__pci_register_driver+86/131] __pci_register_driver+0x56/0x83
Nov  1 13:15:43 pogo kernel:  [<f885a033>] ipw_init+0x33/0x78 [ipw2200]
Nov  1 13:15:43 pogo kernel:  [sys_init_module+4418/4706] sys_init_module+0x1142/0x1262
Nov  1 13:15:43 pogo kernel:  [sysenter_past_esp+95/165] sysenter_past_esp+0x5f/0xa5
Nov  1 13:15:43 pogo kernel:  =======================
Nov  1 13:15:43 pogo kernel: Code: ec 89 d0 83 c9 ff f2 ae 4f 8b 4d ec 49 78 06 ac aa 84 c0 75 f7 31 c0 aa 83 c4 0c 89 d8 5b 5e 5f 5d c3 55 89 e5 57 89 d7 56 89 c6 <ac> ae 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 5e 5f 5d c3 55 
Nov  1 13:15:43 pogo kernel: EIP: [strcmp+9/29] strcmp+0x9/0x1d SS:ESP 0068:c2b3bcdc


****************************************************************

b43 + ipw2200 combo:

****************************************************************
Nov  1 13:52:34 pogo kernel: pccard: CardBus card inserted into slot 0
Nov  1 13:52:34 pogo kernel: PCI: Enabling device 0000:15:00.0 (0000 -> 0002)
Nov  1 13:52:34 pogo kernel: ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Nov  1 13:52:34 pogo kernel: PCI: Setting latency timer of device 0000:15:00.0 to 64
Nov  1 13:52:34 pogo kernel: ssb: Sonics Silicon Backplane found on PCI device 0000:15:00.0
Nov  1 13:52:35 pogo kernel: bcm43xx driver
Nov  1 13:52:35 pogo kernel: b43-phy0: Broadcom 4318 WLAN found
Nov  1 13:52:35 pogo kernel: phy0: Selected rate control algorithm 'simple'
Nov  1 13:52:52 pogo kernel: ACPI: PCI interrupt for device 0000:14:02.0 disabled
Nov  1 13:53:12 pogo kernel: ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmpr
Nov  1 13:53:12 pogo kernel: ipw2200: Copyright(c) 2003-2006 Intel Corporation
Nov  1 13:53:12 pogo kernel: ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 18
Nov  1 13:53:12 pogo kernel: ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
Nov  1 13:53:12 pogo kernel: BUG: unable to handle kernel paging request at virtual address f8bbda82
Nov  1 13:53:12 pogo kernel: printing eip: c01be6e4 *pde = 02000067 *pte = 00000000 
Nov  1 13:53:12 pogo kernel: Oops: 0000 [#1] 
Nov  1 13:53:12 pogo kernel: Modules linked in: ipw2200 arc4 ecb blkcipher cryptomgr crypto_algapi rc80211_simple mac80211 cfg80211 bcm43xx ieee80211softmac ssb uinput thinkpad_acpi hwmon backlight nvram ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative dock snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_oss snd_seq_midi_event pcmcia crc32 snd_seq snd_timer snd_seq_device ehci_hcd uhci_hcd ieee80211 ieee80211_crypt sg firmware_class yenta_socket rsrc_nonstatic pcmcia_core sr_mod cdrom tg3 snd usbcore rng_core evdev rtc soundcore
Nov  1 13:53:12 pogo kernel: 
Nov  1 13:53:12 pogo kernel: Pid: 2970, comm: modprobe Not tainted (2.6.24-rc1 #7)
Nov  1 13:53:12 pogo kernel: EIP: 0060:[strcmp+9/29] EFLAGS: 00010086 CPU: 0
Nov  1 13:53:12 pogo kernel: EIP is at strcmp+0x9/0x1d
Nov  1 13:53:12 pogo kernel: EAX: f8bbda82 EBX: c044d094 ECX: 00000000 EDX: f88e5e70
Nov  1 13:53:12 pogo kernel: ESI: f8bbda82 EDI: f88e5e70 EBP: c3483ce4 ESP: c3483cdc
Nov  1 13:53:12 pogo kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Nov  1 13:53:12 pogo kernel: Process modprobe (pid: 2970, ti=c3482000 task=c341e5f0 task.ti=c3482000)
Nov  1 13:53:12 pogo kernel: Stack: c044d328 00000000 c3483cf8 c013034d 00030728 c044d328 00000002 c3483d58 
Nov  1 13:53:12 pogo kernel:        c01329b7 00000000 00000000 00000000 00000000 00000000 00000000 00000002 
Nov  1 13:53:12 pogo kernel:        00000000 00000000 c2a92cdc 00000000 c341e5f0 00000000 c04d3d80 00000000 
Nov  1 13:53:12 pogo kernel: Call Trace:
Nov  1 13:53:12 pogo kernel:  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
Nov  1 13:53:12 pogo kernel:  [show_stack_log_lvl+157/165] show_stack_log_lvl+0x9d/0xa5
Nov  1 13:53:12 pogo kernel:  [show_registers+173/380] show_registers+0xad/0x17c
Nov  1 13:53:12 pogo kernel:  [die+245/454] die+0xf5/0x1c6
Nov  1 13:53:12 pogo kernel:  [do_page_fault+1104/1335] do_page_fault+0x450/0x537
Nov  1 13:53:12 pogo kernel:  [error_code+106/112] error_code+0x6a/0x70
Nov  1 13:53:12 pogo kernel:  [count_matching_names+74/118] count_matching_names+0x4a/0x76
Nov  1 13:53:12 pogo kernel:  [__lock_acquire+609/3102] __lock_acquire+0x261/0xc1e
Nov  1 13:53:12 pogo kernel:  [lock_acquire+120/145] lock_acquire+0x78/0x91
Nov  1 13:53:12 pogo kernel:  [mutex_lock_nested+244/628] mutex_lock_nested+0xf4/0x274
Nov  1 13:53:12 pogo kernel:  [<f88dce9d>] ipw_pci_probe+0x8aa/0xac6 [ipw2200]
Nov  1 13:53:12 pogo kernel:  [pci_device_probe+57/91] pci_device_probe+0x39/0x5b
Nov  1 13:53:12 pogo kernel:  [driver_probe_device+232/360] driver_probe_device+0xe8/0x168
Nov  1 13:53:12 pogo kernel:  [__driver_attach+106/161] __driver_attach+0x6a/0xa1
Nov  1 13:53:12 pogo kernel:  [bus_for_each_dev+54/91] bus_for_each_dev+0x36/0x5b
Nov  1 13:53:12 pogo kernel:  [driver_attach+25/27] driver_attach+0x19/0x1b
Nov  1 13:53:12 pogo kernel:  [bus_add_driver+115/426] bus_add_driver+0x73/0x1aa
Nov  1 13:53:12 pogo kernel:  [driver_register+103/108] driver_register+0x67/0x6c
Nov  1 13:53:12 pogo kernel:  [__pci_register_driver+86/131] __pci_register_driver+0x56/0x83
Nov  1 13:53:12 pogo kernel:  [<f8834033>] ipw_init+0x33/0x78 [ipw2200]
Nov  1 13:53:12 pogo kernel:  [sys_init_module+4418/4706] sys_init_module+0x1142/0x1262
Nov  1 13:53:12 pogo kernel:  [sysenter_past_esp+95/165] sysenter_past_esp+0x5f/0xa5
Nov  1 13:53:12 pogo kernel:  =======================
Nov  1 13:53:12 pogo kernel: Code: ec 89 d0 83 c9 ff f2 ae 4f 8b 4d ec 49 78 06 ac aa 84 c0 75 f7 31 c0 aa 83 c4 0c 89 d8 5b 5e 5f 5d c3 55 89 e5 57 89 d7 56 89 c6 <ac> ae 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 5e 5f 5d c3 55 
Nov  1 13:53:12 pogo kernel: EIP: [strcmp+9/29] strcmp+0x9/0x1d SS:ESP 0068:c3483cdc
****************************************************************

So I started reviewing the probes on each driver and came up with this
patch because Documenation/pci.txt has:

"The device driver needs to call pci_request_region() to verify
no other device is already using the same address resource.
Conversely, drivers should call pci_release_region() AFTER
calling pci_disable_device(). The idea is to prevent two devices 
colliding on the same address range"

Most wireless drivers do this backwards, we tend to call
pci_release_region() BEFORE pci_disable_device() as when you
probe you first pci_enable_device() and then pci_request_region().
Anyway so I tried the following patch, but no I still get the same
oops. I'll have to review more the probe/remove paths. Any ideas?

Changes to base.c
Changes-licensed-under: 3-clause-BSD

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 15ae868..d4fff45 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -602,10 +602,10 @@ err_free:
 	ieee80211_free_hw(hw);
 err_map:
 	pci_iounmap(pdev, mem);
-err_reg:
-	pci_release_region(pdev, 0);
 err_dis:
 	pci_disable_device(pdev);
+err_reg:
+	pci_release_region(pdev, 0);
 err:
 	return ret;
 }
@@ -621,8 +621,8 @@ ath5k_pci_remove(struct pci_dev *pdev)
 	free_irq(pdev->irq, sc);
 	pci_disable_msi(pdev);
 	pci_iounmap(pdev, sc->iobase);
-	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
+	pci_release_region(pdev, 0);
 	ieee80211_free_hw(hw);
 }
 
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 54f44e5..47af1f2 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -11756,10 +11756,10 @@ static int ipw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->workqueue = NULL;
       out_iounmap:
 	iounmap(priv->hw_base);
-      out_pci_release_regions:
-	pci_release_regions(pdev);
       out_pci_disable_device:
 	pci_disable_device(pdev);
+      out_pci_release_regions:
+	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
       out_free_ieee80211:
 	free_ieee80211(priv->net_dev);
@@ -11824,8 +11824,8 @@ static void ipw_pci_remove(struct pci_dev *pdev)
 
 	free_irq(pdev->irq, priv);
 	iounmap(priv->hw_base);
-	pci_release_regions(pdev);
 	pci_disable_device(pdev);
+	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
 	free_ieee80211(priv->net_dev);
 	free_firmware();
