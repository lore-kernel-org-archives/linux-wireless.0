Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50612 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958AbYDKOvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 10:51:43 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Kismet shows no clients (drivers iwl3945.ko or p54pci.ko)
Date: Fri, 11 Apr 2008 07:50:33 -0700
Message-ID: <D936D925018D154694D8A362EEB089200428A22D@orsmsx416.amr.corp.intel.com> (sfid-20080411_155148_213582_60409B0B)
In-Reply-To: <20080410181612.GB23971@drd1813.lan>
References: <47FDF732.7000304@interia.pl> <20080410181612.GB23971@drd1813.lan>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Mike Kershaw" <dragorn@kismetwireless.net>,
	"Maciek Kaliszewski" <mkalkal@interia.pl>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, April 10, 2008 11:16 AM, Mike Kershaw  wrote:

> I can currently say that iwl4965, 2.6.24.3, rfmon returns no packets
> at all.  In wireless-testing head as of 2 days ago, rfmon threw the
> card into sw-rfkill, then got into a thrash where it couldn't find the
> firmware anymore, and then kernel paniced the system.  Maybe tonight
> I'll try again and post more logs, I'll include the errors at
> the time but
> readily admit that since they're not from the wireless-test
> head they're
> probably not incredibly useful.
> 
> iwl4965: Microcode SW error detected.  Restarting 0x2000000.
> ACPI: PCI interrupt for device 0000:03:00.0 disabled
> wlan0: deauthenticate(reason=3)
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PM: Writing back config space on device 0000:03:00.0 at offset 1 (was
> 100102, writing 100106) Registered led device: iwl-phy0:radio
> Registered led device: iwl-phy0:assoc
> Registered led device: iwl-phy0:RX
> Registered led device: iwl-phy0:TX
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> device wlan0 entered promiscuous mode
> iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
> iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
> iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
> ACPI: PCI interrupt for device 0000:03:00.0 disabled
> device wlan0 left promiscuous mode
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PM: Writing back config space on device 0000:03:00.0 at offset 1 (was
> 100102, writing 100106) iwl4965: Radio disabled by SW RF kill (module
> parameter) 
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PM: Writing back config space on device 0000:03:00.0 at offset 1 (was
> 100102, writing 100106) iwl4965: Radio disabled by SW RF kill (module
> parameter) 
> iwl4965: Detected Intel Wireless WiFi Link 4965AGN
> iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
> phy2: Selected rate control algorithm 'iwl-4965-rs'
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> iwl4965: ucode not available for device bringup
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> iwl4965: Could not read microcode: -22
> general protection fault: ff04 [#1] PREEMPT SMP
> Modules linked in: iwl4965(+) iwlcore mac80211 nvidia(P)
> ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT nf_conntrack_ipv4
> xt_state nf_conntrack iptable_filter ip_tables x_tables rfcomm
> l2cap bluetooth snd_seq snd_seq_device snd_pcm_oss
> snd_mixer_oss bridge ppp_generic slhc video snd_hda_intel
> snd_pcm snd_timer snd_page_alloc snd_hwdep uhci_hcd
> thinkpad_acpi ehci_hcd snd backlight usbcore i2c_i801
> soundcore i2c_core [last unloaded: mac80211]
> 
> Pid: 20349, comm: modprobe Tainted: P         (2.6.25-rc7-wl-git #2)
> EIP: 0060:[<f898ad28>] EFLAGS: 00010246 CPU: 0
> EIP is at iwl4965_pci_probe+0xe1/0x99e [iwl4965]
> EAX: 00000000 EBX: f656ff04 ECX: f7526454 EDX: c02d4035
> ESI: f7526454 EDI: c02780b8 EBP: 00000000 ESP: f656fefc
> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process modprobe (pid: 20349, ti=f656e000 task=f39c60a0
> task.ti=f656e000) Stack: f656ff04 c0565210 f656ff10 c02d4196 f656ff1c
> f656ff34 
> c02d3611 f89a88c0
>       f747d1fc f747d200 f75264a8 00000000 f89a88c0 f89a88c0
> f656ff40 c02d3eda
>       c02d414d f656ff5c c02d3d00 c0565210 f6de1e40 f89a8890
> f89a88c0 f89a88c0
> Call Trace:
> [<c02d4196>] ? __driver_attach+0x49/0x7d
> [<c02d3611>] ? bus_for_each_dev+0x3b/0x5d
> [<c02d3eda>] ? driver_attach+0x14/0x16
> [<c02d414d>] ? __driver_attach+0x0/0x7d
> [<c02d3d00>] ? bus_add_driver+0x97/0x1a7
> [<c02d4350>] ? driver_register+0x47/0xa3
> [<c0278275>] ? __pci_register_driver+0x35/0x64
> [<f88ec02c>] ? iwl4965_init+0x2c/0x71 [iwl4965]
> [<c015252c>] ? sys_init_module+0x80/0x162
> [<c01142ea>] ? sysenter_past_esp+0x5f/0x85
> [<c0400000>] ? init_centaur+0x177/0x281
> =======================
> Code: e3 3e 6c 34 39 36 35 3a 20 25 63 20 25 73 20 52 75 6e 6e
> 69 6e 67 20 46 c1 21 b0 6c 65 6d 70 65 72 61 74 75 72 65 20 63
> 61 6c 53 <1f> 01 29 74 69 6f 6e 0a 00 3c 33 3e 69 77 6c 34 39 36 35
> 3a 20 EIP: [<f898ad28>] iwl4965_pci_probe+0xe1/0x99e [iwl4965]
> SS:ESP 0068:f656fefc

Looks like something brought the interface up and down a few times -
were you running wpa_supplicant at the time? 

Could you please load the driver with debugging (modprobe iwl4965
debug=0x43fff) to help us get a better idea what is going on.

Also, if you can, can you determine on which line that GFP occurred? The
error offset from above is 0xe1.
$ nm iwl4965.ko | grep iwl4965_pci_probe

Above will return start offset. Add the two numbers (start offset and
error offset) and decode to file:line
$addr2line -e iwl4965.ko <start offset + error offset>

It is not clear which version of the code you are running, so when you
send the line number please send it with some context so that we can
find it if we are looking at another version of the driver.

Thanks!

Reinette

