Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crane.lixil.net ([71.19.157.101]:55908 "EHLO crane.lixil.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab3JNCr4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Oct 2013 22:47:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sun, 13 Oct 2013 20:36:28 -0600
From: Joel Johnson <mrjoel@lixil.net>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: ath9k oops report on RNWD-N9003PCe device
Message-ID: <dc9d9182b3e0f696615ee7ce898cd875@lixil.net> (sfid-20131014_044811_384495_4C6C9EB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've received the oops captured below on an ath9k card (Rosewill 
RNWD-N9003PCe), whose $(lspci -n -v) output is:

03:00.0 0280: 168c:0030 (rev 01)
         Subsystem: 168c:3112
         Flags: bus master, fast devsel, latency 0, IRQ 18
         Memory at f7c00000 (64-bit, non-prefetchable) [size=128K]
         Expansion ROM at f7c20000 [disabled] [size=64K]
         Capabilities: [40] Power Management version 3
         Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
         Capabilities: [70] Express Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Virtual Channel
         Capabilities: [300] Device Serial Number 00-00-00-00-00-00-00-00
         Kernel driver in use: ath9k

I'm assuming from the stacktrace that this is related to framing in the 
ath9k driver, if not then please let me know and I'll forward it along.

Joel

[319628.023086] ------------[ cut here ]------------
[319628.023097] WARNING: at 
/build/linux-BPzSEt/linux-3.10.11/net/ipv4/tcp_input.c:2776 
tcp_fastretrans_alert+0x13b/0x923()
[319628.023099] Modules linked in: cpuid fuse ufs qnx4 hfsplus hfs minix 
ntfs msdos jfs xfs reiserfs ext4 jbd2 ext3 jbd ext2 mbcach
e nfsv4 ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat 
ebtables x_tables parport_pc ppdev lp parport autofs4 uinpu
t rpcsec_gss_krb5 nfsd auth_rpcgss oid_registry nfs_acl nfs lockd 
dns_resolver fscache sunrpc nls_utf8 nls_cp437 vfat fat loop dm_c
rypt joydev usb_storage btusb bluetooth crc16 snd_hda_codec_realtek 
snd_hda_codec_hdmi iTCO_wdt iTCO_vendor_support arc4 mxm_wmi ev
dev ath9k ath9k_common ath9k_hw ath mac80211 coretemp snd_hda_intel 
snd_hda_codec kvm_intel snd_hwdep snd_seq cfg80211 snd_pcm kvm
snd_page_alloc snd_seq_device snd_timer rfkill efi_pstore psmouse 
serio_raw microcode pcspkr i2c_i801 lpc_ich mfd_core efivars mei_
me mei i915 snd wmi acpi_cpufreq mperf drm_kms_helper video drm 
i2c_algo_bit button i2c_core soundcore processor btrfs xor zlib_deflate 
hid_generic usbhid hid raid6_pq libcrc32c dm_mod sg sr_mod sd_mod cdrom 
crc_t10dif crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 
ablk_helper cryptd lrw gf128mul glue_helper ahci libahci libata scsi_mod 
thermal fan thermal_sys xhci_hcd r8169 mii ehci_pci ehci_hcd usbcore 
usb_common
[319628.023168] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10-3-amd64 
#1 Debian 3.10.11-1
[319628.023169] Hardware name: MSI MS-7823/H87M-G43 (MS-7823), BIOS V1.2 
06/07/2013
[319628.023171]  0000000000000000 ffffffff8103bb70 0000000000000000 
0000000000004320
[319628.023174]  0000000000000001 ffff8801ef365801 0000000000000000 
ffffffff812fe930
[319628.023176]  0000000000000000 0000000000004320 ffff88041ea03a60 
ffff8801ef3658c0
[319628.023178] Call Trace:
[319628.023180]  <IRQ>  [<ffffffff8103bb70>] ? 
warn_slowpath_common+0x5b/0x70
[319628.023187]  [<ffffffff812fe930>] ? 
tcp_fastretrans_alert+0x13b/0x923
[319628.023189]  [<ffffffff812ffac6>] ? tcp_ack+0x94e/0xb26
[319628.023192]  [<ffffffff81041f31>] ? 
_local_bh_enable_ip.isra.17+0x1a/0x84
[319628.023195]  [<ffffffff8130048e>] ? tcp_rcv_established+0x53c/0x5de
[319628.023200]  [<ffffffff812b5f6f>] ? sock_def_readable+0x41/0x44
[319628.023203]  [<ffffffff81308c0e>] ? tcp_v4_do_rcv+0x1d3/0x3d8
[319628.023205]  [<ffffffff812b973a>] ? skb_checksum+0x47/0x1af
[319628.023208]  [<ffffffff813096a8>] ? tcp_v4_rcv+0x2b2/0x559
[319628.023211]  [<ffffffff812e7e99>] ? nf_hook_slow+0x69/0xfd
[319628.023215]  [<ffffffff812ecb9d>] ? 
__xfrm_policy_check2.constprop.9+0x4c/0x4c
[319628.023217]  [<ffffffff812ecc9d>] ? 
ip_local_deliver_finish+0x100/0x176
[319628.023221]  [<ffffffff812c4fef>] ? 
__netif_receive_skb_core+0x42f/0x4a5
[319628.023223]  [<ffffffff812c523e>] ? netif_receive_skb+0x4c/0x7d
[319628.023235]  [<ffffffffa04ccd2a>] ? ieee80211_deliver_skb+0xbd/0xfa 
[mac80211]
[319628.023244]  [<ffffffffa04ce069>] ? 
ieee80211_rx_handlers+0x10a3/0x1b63 [mac80211]
[319628.023248]  [<ffffffff81079900>] ? 
tick_do_update_jiffies64+0x37/0x9e
[319628.023252]  [<ffffffff811c6bc4>] ? timerqueue_add+0x79/0x97
[319628.023260]  [<ffffffffa04cf31d>] ? 
ieee80211_prepare_and_rx_handle+0x7c6/0x827 [mac80211]
[319628.023266]  [<ffffffffa04a2f53>] ? ath_tx_complete+0xad/0x13b 
[ath9k]
[319628.023273]  [<ffffffffa04cf88b>] ? ieee80211_rx+0x50d/0x61d 
[mac80211]
[319628.023278]  [<ffffffffa04a264f>] ? ath_rx_tasklet+0xb9b/0xcbd 
[ath9k]
[319628.023284]  [<ffffffffa04a0936>] ? ath9k_tasklet+0xc1/0x10b [ath9k]
[319628.023286]  [<ffffffff8104256d>] ? tasklet_action+0x73/0xc2
[319628.023288]  [<ffffffff810421cb>] ? __do_softirq+0xea/0x205
[319628.023290]  [<ffffffff810423b0>] ? irq_exit+0x3e/0x81
[319628.023293]  [<ffffffff8100e697>] ? do_IRQ+0x80/0x95
[319628.023296]  [<ffffffff8138646d>] ? common_interrupt+0x6d/0x6d
[319628.023297]  <EOI>  [<ffffffff81073670>] ? ktime_get+0x5f/0x6b
[319628.023304]  [<ffffffff8129ecfd>] ? arch_local_irq_enable+0x7/0x8
[319628.023306]  [<ffffffff8129f0d1>] ? cpuidle_enter_state+0x52/0xc1
[319628.023309]  [<ffffffff8129f214>] ? cpuidle_idle_call+0xd4/0x143
[319628.023312]  [<ffffffff8101394c>] ? arch_cpu_idle+0x5/0x17
[319628.023314]  [<ffffffff810725eb>] ? cpu_startup_entry+0x10d/0x187
[319628.023318]  [<ffffffff816b3d3d>] ? start_kernel+0x3e8/0x3f3
[319628.023320]  [<ffffffff816b3777>] ? repair_env_string+0x54/0x54
[319628.023323]  [<ffffffff816b3598>] ? x86_64_start_kernel+0xf2/0xfd
[319628.023325] ---[ end trace 19a7e47c4b12d290 ]---



