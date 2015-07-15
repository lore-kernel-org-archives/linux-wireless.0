Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57793 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbGON0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2015 09:26:52 -0400
Subject: Re: iwlwifi: Microcode SW error detected. Restarting 0x2000000.
To: Emmanuel Grumbach <egrumbach@gmail.com>
References: <55A43355.2070302@gmx.de>
 <CANUX_P3hndEGmrkUrW2=UjDXU2m=V7o01kabnS_7R-t0nQ0mTA@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Message-ID: <55A65F98.2030304@gmx.de> (sfid-20150715_152733_291864_A5681859)
Date: Wed, 15 Jul 2015 15:26:48 +0200
MIME-Version: 1.0
In-Reply-To: <CANUX_P3hndEGmrkUrW2=UjDXU2m=V7o01kabnS_7R-t0nQ0mTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/14/2015 08:43 AM, Emmanuel Grumbach wrote:
> Hi,
> 
> On Tue, Jul 14, 2015 at 12:53 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>> At a Gentoo (hardened) I experienced - starting with hardened kernel 4.0.6-r1 - the (attached) hickup of the "03:00.0 Network controller: Intel Corporation Wireless 7260 (rev 83)" at a ThinkPad T440s. The network stucks till I do restart the network device using /etc/init.d/net.wlp3s0.
> 
> You are not using the latest firmware. Please upgrade to 25.17.12.0.
> You'll be able to find the firmware here:
> https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git/plain/iwlwifi-7260-12.ucode
> 

With the mentioned firmware and 4.0.8 I get now repaetingly (restart of the servcie helped):



Jul 15 15:21:32 t44 kernel: ieee80211 phy0: Hardware restart was requested
Jul 15 15:21:34 t44 kernel: ------------[ cut here ]------------
Jul 15 15:21:34 t44 kernel: WARNING: CPU: 0 PID: 0 at drivers/net/wireless/iwlwifi/pcie/trans.c:1385 iwl_trans_pcie_grab_nic_access+0x14b/0x160 [iwlwifi]()
Jul 15 15:21:34 t44 kernel: Timeout waiting for hardware access (CSR_GP_CNTRL 0x080003d8)
Jul 15 15:21:34 t44 kernel: Modules linked in: nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_log_ipv4 nf_log_common xt_LOG xt_limit ipt_REJECT nf_reject_ipv4 xt_recent xt_tcpudp xt_conntrack iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables nfsd auth_rpcgss oid_registry lockd grace ctr ccm sunrpc af_packet bridge stp llc tun rc_dib0700_rc5 hid_cherry dib7000p hid_generic usbhid hid dvb_usb_dib0700 dib3000mc dvb_usb dvb_core dib0070 dib7000m dibx000_common dib0090 rc_core usblp snd_hda_codec_generic arc4 rtsx_pci_sdmmc mmc_core evdev x86_pkg_temp_thermal coretemp kvm_intel kvm iwlmvm aesni_intel aes_x86_64 glue_helper mac80211 lrw gf128mul ablk_helper cryptd psmouse iwlwifi pcspkr atkbd
Jul 15 15:21:34 t44 kernel:  i2c_i801 i915 cfg80211 cfbfillrect rtsx_pci cfbimgblt fbcon bitblit thermal i2c_algo_bit softcursor font cfbcopyarea wmi drm_kms_helper snd_hda_intel snd_hda_controller snd_hda_codec drm snd_pcm i2c_core thinkpad_acpi intel_gtt snd_timer nvram battery agpgart rfkill ac tpm_tis tpm xhci_pci ehci_pci xhci_hcd ehci_hcd video lpc_ich mfd_core fb button fbdev usbcore snd processor e1000e thermal_sys usb_common soundcore hwmon [last unloaded: microcode]
Jul 15 15:21:34 t44 kernel: CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.0.8-hardened #1
Jul 15 15:21:34 t44 kernel: Hardware name: LENOVO 20AQCTO1WW/20AQCTO1WW, BIOS GJET83WW (2.33 ) 03/09/2015
Jul 15 15:21:34 t44 kernel:  ffffffff810dc4c6 0000000000000000 ffffffffc05ca3a8 ffff88033e203c58
Jul 15 15:21:34 t44 kernel:  ffffffff8159675c 0000000000000000 ffff88033e203ca8 ffff88033e203c98
Jul 15 15:21:34 t44 kernel:  ffffffff81059fea ffffffffc05c8c18 ffffffffc05ca3a8 0000000000000569
Jul 15 15:21:34 t44 kernel: Call Trace:
Jul 15 15:21:34 t44 kernel:  <IRQ>  [<ffffffff810dc4c6>] ? print_modules+0x76/0xe0
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05ca3a8>] ? iwl8000_base_params+0x1c68/0x299b [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffff8159675c>] dump_stack+0x45/0x5d
Jul 15 15:21:34 t44 kernel:  [<ffffffff81059fea>] warn_slowpath_common+0x8a/0xd0
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05c8c18>] ? iwl8000_base_params+0x4d8/0x299b [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05ca3a8>] ? iwl8000_base_params+0x1c68/0x299b [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05ca5f8>] ? iwl8000_base_params+0x1eb8/0x299b [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05bed30>] ? iwl_trans_pcie_write32+0x40/0x40 [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffff8105a08a>] warn_slowpath_fmt+0x5a/0x70
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05ca5f8>] ? iwl8000_base_params+0x1eb8/0x299b [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05b4045>] ? iwl_poll_bit+0x45/0x90 [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05c0aeb>] iwl_trans_pcie_grab_nic_access+0x14b/0x160 [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05b40c7>] iwl_read_direct32+0x37/0x80 [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05bb5f8>] iwl_pcie_txq_stuck_timer+0x138/0x3e0 [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05bb4c0>] ? iwl_pcie_alloc_dma_ptr.isra.23+0x110/0x110 [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffff810bc0b7>] call_timer_fn+0x47/0x140
Jul 15 15:21:34 t44 kernel:  [<ffffffff810bc551>] run_timer_softirq+0x291/0x450
Jul 15 15:21:34 t44 kernel:  [<ffffffffc05bb4c0>] ? iwl_pcie_alloc_dma_ptr.isra.23+0x110/0x110 [iwlwifi]
Jul 15 15:21:34 t44 kernel:  [<ffffffff8105e6a8>] __do_softirq+0xf8/0x290
Jul 15 15:21:34 t44 kernel:  [<ffffffff8105ea85>] irq_exit+0xa5/0xb0
Jul 15 15:21:34 t44 kernel:  [<ffffffff815a0975>] smp_apic_timer_interrupt+0x55/0x70
Jul 15 15:21:34 t44 kernel:  [<ffffffff8159eb13>] apic_timer_interrupt+0x83/0x90
Jul 15 15:21:34 t44 kernel:  <EOI>  [<ffffffff810bee15>] ? __hrtimer_start_range_ns+0x1a5/0x3d0
Jul 15 15:21:34 t44 kernel:  [<ffffffff8147c7b7>] ? cpuidle_enter_state+0x87/0x1a0
Jul 15 15:21:34 t44 kernel:  [<ffffffff8147c939>] cpuidle_enter+0x29/0x40
Jul 15 15:21:34 t44 kernel:  [<ffffffff8109b6d8>] cpu_startup_entry+0x358/0x3e0
Jul 15 15:21:34 t44 kernel:  [<ffffffff81c12120>] ? early_idt_handler_array+0x120/0x120
Jul 15 15:21:34 t44 kernel:  [<ffffffff8158cc42>] rest_init+0x72/0x80
Jul 15 15:21:34 t44 kernel:  [<ffffffff81c13ad2>] start_kernel+0x610/0x621
Jul 15 15:21:34 t44 kernel:  [<ffffffff81c13050>] ? set_init_arg+0xc7/0xc7
Jul 15 15:21:34 t44 kernel:  [<ffffffff81c7ac38>] ? memblock_reserve+0x81/0x8f
Jul 15 15:21:34 t44 kernel:  [<ffffffff81c126f8>] x86_64_start_reservations+0x5e/0x68
Jul 15 15:21:34 t44 kernel:  [<ffffffff81c12881>] x86_64_start_kernel+0x17f/0x194
Jul 15 15:21:34 t44 kernel: ---[ end trace 06dfec9f8d69e13b ]---


few time within of that I saw :
Jul 15 15:21:39 t44 dhcpcd[2582]: wlp3s0: carrier lost
Jul 15 15:21:39 t44 wpa_cli: interface wlp3s0 DISCONNECTED
Jul 15 15:21:39 t44 wpa_cli: executing 'false /etc/init.d/net.wlp3s0 --quiet stop' failed
Jul 15 15:21:39 t44 dhcpcd[2582]: wlp3s0: deleting address fd00::674f:8c20:a0a:2cef/64
Jul 15 15:21:39 t44 dhcpcd[2582]: wlp3s0: deleting route to fd00::/64
Jul 15 15:21:39 t44 kernel:  [<ffffffff8107c986>] kthread+0xf6/0x110
Jul 15 15:21:39 t44 kernel:  [<ffffffff8107c890>] ? kthread_create_on_node+0x1b0/0x1b0
Jul 15 15:21:39 t44 kernel:  [<ffffffff8159dc19>] ret_from_fork+0x49/0x80
Jul 15 15:21:39 t44 kernel:  [<ffffffff8107c890>] ? kthread_create_on_node+0x1b0/0x1b0
Jul 15 15:21:39 t44 kernel: ---[ end trace 06dfec9f8d69e13e ]---
Jul 15 15:21:39 t44 kernel: wlp3s0: deauthenticating from 08:96:d7:05:f9:2a by local choice (Reason: 3=DEAUTH_LEAVING)
Jul 15 15:21:39 t44 kernel: ------------[ cut here ]------------
Jul 15 15:21:39 t44 kernel: WARNING: CPU: 2 PID: 3950 at net/mac80211/driver-ops.h:12 ieee80211_bss_info_change_notify+0x19c/0x1f0 [mac80211]()
Jul 15 15:21:39 t44 kernel: wlp3s0:  Failed check-sdata-in-driver check, flags: 0x4




-- 
Toralf, pgp key: 872AE508 0076E94E
