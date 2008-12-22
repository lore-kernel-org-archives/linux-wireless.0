Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:43603 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbYLVOID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 09:08:03 -0500
Received: by bwz14 with SMTP id 14so8060845bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 06:08:00 -0800 (PST)
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler\, Tomas" <tomas.winkler@intel.com>
Subject: Re: [PATCH 10/10] iwl3945: use rx queue management infrastructure from iwlcore
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-2-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-3-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-4-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-5-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-6-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-7-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-8-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-9-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-10-git-send-email-yi.zhu@intel.com>
	<1229916683-9772-11-git-send-email-yi.zhu@intel.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 22 Dec 2008 16:07:54 +0200
In-Reply-To: <1229916683-9772-11-git-send-email-yi.zhu@intel.com> (Zhu Yi's message of "Mon\, 22 Dec 2008 11\:31\:23 +0800")
Message-ID: <87r640s3ph.fsf@litku.valot.fi> (sfid-20081222_150836_083397_B4B6B0D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi <yi.zhu@intel.com> writes:

> From: Winkler, Tomas <tomas.winkler@intel.com>
>
> This patch uses rx queue alloc free and reset function from iwlcore.
> This should fix the regression reported by Kalle Valo.

Yes, ifconfig up works but now iwlist wlan0 scan crashes. I just
tested this once due to lack of time.

I hope I get my wifi working before Christmas ;)

[18031.912914] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kd
[18031.912929] iwl3945: Copyright(c) 2003-2008 Intel Corporation
[18031.913084] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[18031.972027] iwl3945 0000:03:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[18031.972043] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
[18068.633607] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[18068.634164] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
[18068.758728] iwl3945 0000:03:00.0: iwlwifi-3945-2.ucode firmware file req failed: -2
[18068.758746] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-1.ucode
[18068.803611] iwl3945 0000:03:00.0: Loaded firmware iwlwifi-3945-1.ucode, which is deprecated.  Please use API v2 instead.
[18068.803629] iwl3945 0000:03:00.0: Firmware has old API version. Expected 2, got 1. New firmware can be obtained from http://www.intellinuxwireless.org.
[18068.803638] iwl3945 0000:03:00.0: loaded firmware version 15.28.1.6
[18068.864814] Registered led device: iwl-phy1:radio
[18068.864869] Registered led device: iwl-phy1:assoc
[18068.864916] Registered led device: iwl-phy1:RX
[18068.864958] Registered led device: iwl-phy1:TX
[18068.895330] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[18074.727526] BUG: unable to handle kernel NULL pointer dereference at 00000980
[18074.727549] IP: [<f9a3ee5c>] iwl_enqueue_hcmd+0x155/0x3a2 [iwlcore]
[18074.727583] *pde = 00000000 
[18074.727593] Oops: 0002 [#1] SMP 
[18074.727605] last sysfs file: /sys/class/firmware/0000:03:00.0/loading
[18074.727611] Modules linked in: iwl3945 iwlcore netconsole configfs cdc_acm cdc_ether usbnet mii pl2303 usbserial i915 drm rfcomm l2cap cpufreq_ondemand binfmt_misc ipv6 fuse acpi_cpufreq freq_table loop snd_hda_intel snd_pcm arc4 ecb snd_seq snd_timer snd_seq_device snd mac80211 thinkpad_acpi hci_usb soundcore pcmcia rfkill lib80211 video backlight i2c_i801 psmouse pcspkr cfg80211 bluetooth yenta_socket rsrc_nonstatic pcmcia_core snd_page_alloc rng_core output led_class battery ac nvram ext3 aes_i586 dm_mirror dm_region_hash dm_mod sd_mod ide_pci_generic sdhci ehci_hcd e1000e processor [last unloaded: iwlcore][18074.727916] Pid: 0, comm: swapper Not tainted (2.6.28-rc9-wl #105) 1703Y1F
[18074.727924] EIP: 0060:[<f9a3ee5c>] EFLAGS: 00010002 CPU: 0
[18074.727949] EIP is at iwl_enqueue_hcmd+0x155/0x3a2 [iwlcore]
[18074.727963] ESI: 00000000 EDI: 00000980 EBP: c03b1d80 ESP: c03b1d40
[18074.727970]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[18074.727977] Process swapper (pid: 0, ti=c03b0000 task=c037732c task.ti=c03b0000)
 eebc148c c011a998 c03b1d60
 f2689c00 c03b1dac[18074.728049]  f9a3a8ef cea6b0fc d55555d5[18074.728084] Call Trace:
[18074.728089]  [<f9a3a8ef>] ? iwl_send_cmd_async+0x44/0x8a [iwlcore]
[18074.728136]  [<f9a3ae4c>] ? iwl_send_cmd+0xe/0x1a [iwlcore]
 [<f9a47656>] ? iwl4965_led_pattern+0x156/0x15e [iwlcore]
[18074.728192]  [<f9a3a982>] ? iwl_generic_cmd_callback+0x0/0x108 [iwlcore]
[18074.728220]  [<f9a47917>] ? iwl_leds_background+0x66/0x207 [iwlcore]
[18074.728249]  [<f9b65ae5>] ? iwl3945_hw_rx_statistics+0x92/0xa9 [iwl3945]
 [<f9b5a41d>] ? iwl3945_irq_tasklet+0x863/0x1058 [iwl3945]
[18074.728297]  [<c01373aa>] ? update_wall_time+0x5e1/0x712
[18074.728312]  [<c0125cf9>] ? irq_exit+0x38/0x6d
 [<c010502d>] ? do_IRQ+0x6f/0x86
 [<c01039f3>] ? common_interrupt+0x23/0x28
[18074.728390]  [<c01e7918>] ? acpi_os_release_lock+0x8/0xa
[18074.728435]  [<f806bf80>] ? acpi_idle_enter_bm+0xca/0x35a [processor]
[18074.728457]  [<c0240839>] ? cpuidle_idle_call+0x60/0x93
 [<c0101f60>] ? cpu_idle+0x6b/0x87
 [<c02935ca>] ? rest_init+0x4e/0x50
f0 2c 86 c0 4d 45 f0 8b 00 8b 38 00 00 01 b9 89 55 d4 ab c0 0c 01 38 00 8b 00 00 iwl_enqueue_hcmd+0x155/0x3a2 [iwlcore][18074.728457] Kernel panic - not syncing: Fatal exception in interrupt
[18074.728457] ------------[ cut here ]------------
[18074.728457] WARNING: at kernel/smp.c:333 smp_call_function_mask+0x28/0x17d()
[18074.728457] Modules linked in: iwl3945 configfs cdc_acm usbnet usbserial rfcomm l2cap fuse loop arc4 snd_seq mac80211 soundcore pcmcia rfkill i2c_i801 pcspkr yenta_socket snd_page_alloc rng_core led_class ac jbd mbcache sha256_generic dm_crypt dm_log dm_mod sd_mod ata_generic ide_pci_generic ide_core uhci_hcd usbcore fan
[18074.728457] Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc9-wl #105
[18074.728457]  [<c029f7fb>] ? printk+0xf/0x14
[18074.728457]  [<c01219a3>] warn_on_slowpath+0x41/0x63
[18074.728457]  [<c025a4f2>] ? netpoll_send_udp+0x1e8/0x1f2
[18074.728457]  [<f96f8178>] ? write_msg+0xb1/0xb9 [netconsole]
[18074.728457]  [<c013dd9c>] smp_call_function_mask+0x28/0x17d
[18074.728457]  [<c01100c7>] ? stop_this_cpu+0x0/0x36
[18074.728457]  [<c01100ba>] native_smp_send_stop+0x1b/0x28
[18074.728457]  [<c029f759>] panic+0x41/0xd4
[18074.728457]  [<c0105703>] die+0x5b/0x63
[18074.728457]  [<c0115e45>] do_page_fault+0x549/0x63c
[18074.728457]  [<c011d49f>] ? default_wake_function+0xb/0xd
[18074.728457]  [<c01317fe>] ? autoremove_wake_function+0xf/0x33
[18074.728457]  [<c0131858>] ? wake_bit_function+0x36/0x43
[18074.728457]  [<c01196e4>] ? __wake_up_common+0x35/0x5b
[18074.728457]  [<c0131788>] ? __wake_up_bit+0x2c/0x32
[18074.728457]  [<c014ebe9>] ? mempool_free+0x64/0x6b
[18074.728457]  [<c014ea00>] ? mempool_free_slab+0xe/0x10
[18074.728457]  [<c014ebe9>] ? mempool_free+0x64/0x6b
[18074.728457]  [<c01158fc>] ? do_page_fault+0x0/0x63c
[18074.728457]  [<c01400d8>] ? load_module+0x6dd/0x1908
[18074.728457]  [<f9a3ee5c>] ? iwl_enqueue_hcmd+0x155/0x3a2 [iwlcore]
[18074.728457]  [<c011a998>] ? enqueue_task_fair+0x131/0x17a
[18074.728457]  [<f9a3ae4c>] iwl_send_cmd+0xe/0x1a [iwlcore]
[18074.728457]  [<f9a47656>] iwl4965_led_pattern+0x156/0x15e [iwlcore]
[18074.728457]  [<f9a3a982>] ? iwl_generic_cmd_callback+0x0/0x108 [iwlcore]
[18074.728457]  [<f9a47917>] iwl_leds_background+0x66/0x207 [iwlcore]
[18074.728457]  [<f9b65ae5>] iwl3945_hw_rx_statistics+0x92/0xa9 [iwl3945]
[18074.728457]  [<c01373aa>] ? update_wall_time+0x5e1/0x712
[18074.728457]  [<c012555d>] tasklet_action+0x61/0xac
[18074.728457]  [<c0125bf4>] do_softirq+0x35/0x3a
[18074.728457]  [<c010502d>] do_IRQ+0x6f/0x86
[18074.728457]  [<f806c3a8>] ? acpi_idle_enter_simple+0x198/0x205 [processor]
[18074.728457]  [<c01e7918>] ? acpi_os_release_lock+0x8/0xa
[18074.728457]  [<f806bf80>] acpi_idle_enter_bm+0xca/0x35a [processor]
[18074.728457]  [<c024125e>] ? menu_select+0x38/0x86
[18074.728457]  [<c0240839>] cpuidle_idle_call+0x60/0x93
[18074.728457]  [<c02935ca>] rest_init+0x4e/0x50
[18074.728457] ------------[ cut here ]------------
[18074.728457] WARNING: at kernel/smp.c:220 smp_call_function_single+0x2d/0x9c()
[18074.728457] Modules linked in: iwl3945 cdc_acm mii i915 drm binfmt_misc fuse freq_table snd_pcm arc4 ecb snd thinkpad_acpi soundcore pcmcia backlight psmouse bluetooth rsrc_nonstatic pcmcia_core battery button ext3 jbd mbcache cbc dm_region_hash dm_snapshot dm_mod libata ide_pci_generic sdhci_pci sdhci ehci_hcd ide_core usbcore processor fan
[18074.728457] Pid: 0, comm: swapper Tainted: G      D W  2.6.28-rc9-wl #105
[18074.728457] Call Trace:
[18074.728457]  [<c029f7fb>] ? printk+0xf/0x14
[18074.728457]  [<c01219a3>] warn_on_slowpath+0x41/0x63
[18074.728457]  [<c02a1abf>] ? _spin_unlock+0x8/0xa
[18074.728457]  [<c025a4f2>] ? netpoll_send_udp+0x1e8/0x1f2
[18074.728457]  [<f96f8178>] ? write_msg+0xb1/0xb9 [netconsole]
[18074.728457]  [<c013dd05>] smp_call_function_single+0x2d/0x9c
[18074.728457]  [<c013ddeb>] smp_call_function_mask+0x77/0x17d
[18074.728457]  [<c01100c7>] ? stop_this_cpu+0x0/0x36
[18074.728457]  [<c01100ba>] native_smp_send_stop+0x1b/0x28
[18074.728457]  [<c0105158>] oops_end+0x5d/0x71
[18074.728457]  [<c0115e45>] do_page_fault+0x549/0x63c
[18074.728457]  [<c011d49f>] ? default_wake_function+0xb/0xd
[18074.728457]  [<c0131858>] ? wake_bit_function+0x36/0x43
[18074.728457]  [<c01196e4>] ? __wake_up_common+0x35/0x5b
[18074.728457]  [<c0119db3>] ? __wake_up+0x31/0x3b
[18074.728457]  [<c014ea00>] ? mempool_free_slab+0xe/0x10
[18074.728457]  [<c01895b2>] ? bio_free+0x31/0x35
[18074.728457]  [<c014ea00>] ? mempool_free_slab+0xe/0x10
[18074.728457]  [<c01158fc>] ? do_page_fault+0x0/0x63c
[18074.728457]  [<c01400d8>] ? load_module+0x6dd/0x1908
[18074.728457]  [<f9a3ee5c>] ? iwl_enqueue_hcmd+0x155/0x3a2 [iwlcore]
[18074.728457]  [<c011a998>] ? enqueue_task_fair+0x131/0x17a
[18074.728457]  [<f9a3a8ef>] iwl_send_cmd_async+0x44/0x8a [iwlcore]
[18074.728457]  [<f9a47656>] iwl4965_led_pattern+0x156/0x15e [iwlcore]
[18074.728457]  [<f9a3a982>] ? iwl_generic_cmd_callback+0x0/0x108 [iwlcore]
[18074.728457]  [<f9a47917>] iwl_leds_background+0x66/0x207 [iwlcore]
[18074.728457]  [<f9b65ae5>] iwl3945_hw_rx_statistics+0x92/0xa9 [iwl3945]
[18074.728457]  [<f9b5a41d>] iwl3945_irq_tasklet+0x863/0x1058 [iwl3945]
[18074.728457]  [<c01373aa>] ? update_wall_time+0x5e1/0x712
[18074.728457]  [<c012555d>] tasklet_action+0x61/0xac
[18074.728457]  [<c0125bf4>] do_softirq+0x35/0x3a
[18074.728457]  [<c010502d>] do_IRQ+0x6f/0x86
[18074.728457]  [<f806c3a8>] ? acpi_idle_enter_simple+0x198/0x205 [processor]
[18074.728457]  [<c01e7918>] ? acpi_os_release_lock+0x8/0xa
[18074.728457]  [<f806bf80>] acpi_idle_enter_bm+0xca/0x35a [processor]
[18074.728457]  [<c0240839>] cpuidle_idle_call+0x60/0x93
[18074.728457]  [<c0101f60>] cpu_idle+0x6b/0x87
[18074.728457] ---[ end trace 7a31e9607358195d ]---

-- 
Kalle Valo
