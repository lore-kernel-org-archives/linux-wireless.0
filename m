Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:37632 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbYJQMSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 08:18:17 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KqoHR-0005zL-0X
	for linux-wireless@vger.kernel.org; Fri, 17 Oct 2008 12:18:09 +0000
Received: from artipc9.vub.ac.be ([134.184.26.59])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 12:18:09 +0000
Received: from fhimpe by artipc9.vub.ac.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 12:18:09 +0000
To: linux-wireless@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: iwlagn: associating with AP causes kernel hiccup
Date: Fri, 17 Oct 2008 12:18:00 +0000 (UTC)
Message-ID: <gd9vpo$5ql$1@ger.gmane.org> (sfid-20081017_141822_447551_DBBD7D44)
References: <gd5gs4$abi$1@ger.gmane.org> <1224104363.19219.30.camel@rc-desk>
	<gd9v3f$3ft$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 17 Oct 2008 12:06:08 +0000, Frederik Himpe wrote:

> On Wed, 15 Oct 2008 13:59:23 -0700, reinette chatre wrote:
> 
>> On Wed, 2008-10-15 at 19:38 +0000, Frederik Himpe wrote:
>>> When I associate with an AP, Linux 2.6.27 seems to "hang" for a few
>>> seconds. During that time, all sound stops playing and keyboard and
>>> mouse input is impossible. In the log I see this:
>>> 
>>> wlan0: authenticate with AP 00:15:f2:0a:ab:43 wlan0: authenticate with
>>> AP 00:15:f2:0a:ab:43 wlan0: authenticate with AP 00:15:f2:0a:ab:43
>>> wlan0: authenticated
>>> wlan0: associate with AP 00:15:f2:0a:ab:43 wlan0: RX AssocResp from
>>> 00:15:f2:0a:ab:43 (capab=0x431 status=0 aid=2) wlan0: associated
>>> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready iwlagn
>>> 0000:0c:00.0: PCI INT A disabled iwlagn 0000:0c:00.0: PCI INT A -> GSI
>>> 17 (level, low) -> IRQ 17 iwlagn 0000:0c:00.0: restoring config space
>>> at offset 0x1 (was 0x100102, writing 0x100106)
>> 
>> Are you running wpa_supplicant and/or network manager?
> 
> I'm using Mandriva 2009.0 x86_64 with wpa_supplicant and Mandriva's
> wireless network configuration tool (drakroam).
> 
>> Can you try testing without them?
> 
> Actually I just found out that running # ifconfig wlan0 down
> is enough to trigger the sound and mouse hanging for a few seconds.

And shortly after I wrote that, while associating while getting an IP 
with dhclient when associating with a WPA encrypted AP, I got this 
backtrace in my logs:

ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
ADDRCONF(NETDEV_UP): eth0: link is not ready
0000:00:19.0: eth0: Link is Up 10 Mbps Full Duplex, Flow Control: None
0000:00:19.0: eth0: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
martian source 255.255.255.255 from 134.184.26.55, on dev eth0
ll header: ff:ff:ff:ff:ff:ff:00:16:cb:06:4b:54:08:00
wlan0: disassociating by local choice (reason=3)
wlan0: no IPv6 routers present
wlan0: authenticate with AP 00:0d:54:a0:07:e3
wlan0: authenticate with AP 00:0d:54:a0:07:e3
wlan0: authenticated
wlan0: associate with AP 00:0d:54:a0:07:e3
wlan0: RX ReassocResp from 00:0d:54:a0:07:e3 (capab=0x431 status=0 aid=7)
wlan0: associated
eth0: no IPv6 routers present
iwlagn: index 255 not used in uCode key table.
iwlagn 0000:0c:00.0: PCI INT A disabled
iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:0c:00.0: restoring config space at offset 0x1 (was 0x100102, 
writing 0x100106)
general protection fault: 0000 [1] SMP 
CPU 1 
Modules linked in: sit tunnel4 i915 drm af_packet ipt_MASQUERADE 
iptable_nat nf_nat hidp nf_conntrack_ipv4 xt_state nf_conntrack 
ipt_REJECT bnep xt_tcpudp btusb iptable_filter ip_tables rfcomm x_tables 
bridge l2cap bluetooth stp ipv6 kvm_intel kvm vboxdrv binfmt_misc fuse 
nls_utf8 nls_cp437 vfat fat ext3 jbd loop cpufreq_ondemand 
cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table nvram i8k 
snd_hda_intel arc4 firewire_ohci ecb firewire_core snd_hwdep crc_itu_t 
snd_seq_dummy crypto_blkcipher snd_seq_oss thermal snd_seq_midi_event 
i2c_i801 pcmcia video wmi snd_seq i2c_core ac button battery processor sg 
snd_seq_device iwlagn snd_pcm_oss sr_mod snd_pcm iwlcore usbhid sdhci_pci 
ohci1394 ricoh_mmc sdhci ieee1394 rfkill led_class snd_timer output 
e1000e snd_page_alloc mmc_core yenta_socket rsrc_nonstatic pcmcia_core 
snd_mixer_oss rtc_cmos joydev dcdbas snd mac80211 soundcore ff_memless 
cfg80211 evdev dm_snapshot dm_zero dm_mirror dm_log dm_mod ata_piix ahci 
libata dock sd_mod scsi_mod crc_t10dif xfs uhci_hcd ohci_hcd ehci_hcd 
usbcore [last unloaded: scsi_wait_scan]
Pid: 29422, comm: ifconfig Not tainted 2.6.27-tmb-desktop-2mdv #1
RIP: 0010:[<ffffffffa027b25b>]  [<ffffffffa027b25b>] iwl_eeprom_query16
+0xb/0x20 [iwlcore]
RSP: 0018:ffff8800b193fb48  EFLAGS: 00010002
RAX: 7fff88011a87b800 RBX: 0000000000000286 RCX: 00000000800c00f0
RDX: ffffc200050b403c RSI: 0000000000000090 RDI: ffff88011a0c1900
RBP: ffff8800b193fb48 R08: 0000000000000001 R09: ffff8800b193fb1c
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88011a0c1900
R13: ffff88011a0c1900 R14: ffff88011a0c2348 R15: 0000000000000282
FS:  00007f75811606f0(0000) GS:ffff88011fc02980(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000016df108 CR3: 000000007c005000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ifconfig (pid: 29422, threadinfo ffff8800b193e000, task 
ffff8800bbccd700)
Stack:  ffff8800b193fb98 ffffffffa02c81fb 0000000000000282 
ffffffffffffff04
 42ffffff804dd893 0000000000000286 ffff88011a0c1900 ffff88011a0c2348
 ffff88011a0c2a50 ffff88011a0c2350 ffff8800b193fbc8 ffffffffa0279a66
 Call Trace:
 [<ffffffffa02c81fb>] iwl5000_nic_config+0x6b/0x200 [iwlagn]
 [<ffffffffa0279a66>] iwl_hw_nic_init+0x96/0x160 [iwlcore]
 [<ffffffffa02be795>] __iwl4965_up+0xb5/0x2d0 [iwlagn]
 [<ffffffffa02bf1c8>] iwl4965_mac_start+0x408/0x710 [iwlagn]
 [<ffffffff8046efe3>] ? rt_cache_flush+0x23/0x130
 [<ffffffff804a5e02>] ? fib_inetaddr_event+0x62/0x2b0
 [<ffffffff804dd731>] ? _spin_lock_irq+0x11/0x20
 [<ffffffffa0185632>] ieee80211_open+0x152/0x690 [mac80211]
 [<ffffffff80261889>] ? up_read+0x9/0x10
 [<ffffffff802625f3>] ? __blocking_notifier_call_chain+0x63/0x80
 [<ffffffff8044b7da>] dev_open+0xaa/0xf0
 [<ffffffff8044ad06>] dev_change_flags+0x96/0x1e0
 [<ffffffff8049e3ae>] devinet_ioctl+0x6fe/0x760
 [<ffffffff8049f284>] inet_ioctl+0x94/0xc0
 [<ffffffff8043a646>] sock_ioctl+0x66/0x270
 [<ffffffff802d59c1>] vfs_ioctl+0x31/0xa0
 [<ffffffff802d5aa4>] do_vfs_ioctl+0x74/0x480
 [<ffffffff804dd829>] ? _spin_lock+0x9/0x10
 [<ffffffff8024f531>] ? cap_set_effective+0x61/0x90
 [<ffffffff802d5f49>] sys_ioctl+0x99/0xa0
 [<ffffffff8020c6ba>] system_call_fastpath+0x16/0x1b


Code: 48 8b 47 18 55 48 89 e5 48 8b 40 18 48 8b 00 ff 90 00 01 00 00 c9 
c3 66 0f 1f 84 00 00 00 00 00 48 8b 87 30 23 01 00 55 48 89 e5 <0f> b6 54 
30 01 0f b6 04 30 c9 c1 e2 08 09 d0 c3 0f 1f 44 00 00 
RIP  [<ffffffffa027b25b>] iwl_eeprom_query16+0xb/0x20 [iwlcore]
 RSP <ffff8800b193fb48>
---[ end trace 186c7f9fa5d4b374 ]---

While rebooting the machine after that, it completely hung and I had to 
do a hard reset.

-- 
Frederik Himpe

