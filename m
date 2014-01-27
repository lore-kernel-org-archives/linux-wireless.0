Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.mlh-server.de ([5.9.104.232]:54096 "EHLO
	mail.mlh-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaA0TpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 14:45:09 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.mlh-server.de (Postfix) with ESMTP id C9900307506
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jan 2014 20:28:01 +0100 (CET)
Received: from mail.mlh-server.de ([127.0.0.1])
	by localhost (mail.mlh-server.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ydiBF_05SKpj for <linux-wireless@vger.kernel.org>;
	Mon, 27 Jan 2014 20:28:01 +0100 (CET)
Received: from purefruit (arbi-dyn-27-6.Informatik.Uni-Oldenburg.DE [134.106.27.171])
	(Authenticated sender: mail@matthias-larisch.de)
	by mail.mlh-server.de (Postfix) with ESMTPSA id 928DB300E21
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jan 2014 20:28:01 +0100 (CET)
Date: Mon, 27 Jan 2014 20:28:00 +0100
From: Matthias Larisch <mail@matthias-larisch.de>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi in monitor mode: wrong command Queue and kernel tried to
 execute NX-protected page - exploit attempt? (uid: 0)
Message-ID: <20140127202800.4343dcdd@purefruit> (sfid-20140127_204516_927343_B6A81B75)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/GLCKNfz_Z9k2rhYsvPRH_2U"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--MP_/GLCKNfz_Z9k2rhYsvPRH_2U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello all,

I currently use my Intel Wireless 6200 AGN in monitor mode with aircrack 1.1-10
(current Archlinux community version) on Linux 3.12.7-2.

I recently got the error message I mentioned in the subject of this report, see
attached journalctl-dmesg output line 66.

Situation was the laptop running for multiple days, suspended multiple times
(I heard that sometimes triggers the Queue stuck bug).

Above bug happened while capturing traffic with airodump-ng on a fixed g
channel, iwlwifi was loaded with 11n_disabled=1, after about one hour. Could
not reproduce it but it sounds really serious.

Can I do anything to help debug this problem?

Regards,

Matthias
--MP_/GLCKNfz_Z9k2rhYsvPRH_2U
Content-Type: text/x-log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=20140127_buglog_iwlwifi_nx.log

-- Logs begin at Fr 2013-05-24 09:46:51 CEST, end at Mo 2014-01-27 15:26:12=
 CET. --
Jan 27 14:22:23 purefruit kernel: ------------[ cut here ]------------
Jan 27 14:22:23 purefruit kernel: WARNING: CPU: 2 PID: 314 at drivers/net/w=
ireless/iwlwifi/pcie/tx.c:1426 iwl_pcie_hcmd_complete+0x3d0/0x450 [iwlwifi]=
()
Jan 27 14:22:23 purefruit kernel: wrong command queue 31 (should be 4), seq=
uence 0x1F4F readp=3D180 writep=3D180
Jan 27 14:22:23 purefruit kernel: Modules linked in: fuse nls_cp437 vfat fa=
t usb_storage nfnetlink_queue nfnetlink_log nfnetlink ipt_REJECT iptable_fi=
lter ip_tables x_tables 8021q mrp psmouse serio_raw ppp_deflate bsd_comp pp=
p_async crc_ccitt joydev hdaps(O) ppp_generic slhc bnep intel_powerclamp co=
retemp arc4 kvm_intel kvm iwldvm mac80211 mxm_wmi iTCO_wdt iTCO_vendor_supp=
ort snd_hda_codec_hdmi snd_hda_codec_conexant btusb bluetooth uvcvideo vide=
obuf2_vmalloc videobuf2_memops qmi_wwan videobuf2_core qcserial cdc_wdm vid=
eodev usb_wwan usbnet usbserial mii media microcode iwlwifi cfg80211 intel_=
ips i2c_i801 thermal thinkpad_acpi nvram snd_hda_intel rfkill ac snd_hda_co=
dec battery snd_hwdep e1000e snd_pcm snd_page_alloc snd_timer wmi evdev mei=
_me ptp snd soundcore mei pps_core shpchp lpc_ich usbip_host(C) usbip_core(=
C) tp_smapi(O)
Jan 27 14:22:23 purefruit kernel:  thinkpad_ec(O) nfs lockd sunrpc fscache =
speakup_soft(C) speakup(C) acpi_cpufreq processor sg ext4 crc16 mbcache jbd=
2 dm_crypt dm_mod sr_mod cdrom sd_mod crct10dif_pclmul crct10dif_common crc=
32_pclmul crc32c_intel ghash_clmulni_intel ahci aesni_intel aes_x86_64 lrw =
gf128mul glue_helper sdhci_pci libahci ablk_helper cryptd libata ehci_pci s=
dhci ehci_hcd scsi_mod mmc_core usbcore usb_common i915 video button i2c_al=
go_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
Jan 27 14:22:23 purefruit kernel: CPU: 2 PID: 314 Comm: irq/44-iwlwifi Tain=
ted: G        WC O 3.12.7-2-ARCH #1
Jan 27 14:22:23 purefruit kernel: Hardware name: LENOVO 2522W29/2522W29, BI=
OS 6IET85WW (1.45 ) 02/14/2013
Jan 27 14:22:23 purefruit kernel:  0000000000000009 ffff8800b6b31c50 ffffff=
ff814ec113 ffff8800b6b31c98
Jan 27 14:22:23 purefruit kernel:  ffff8800b6b31c88 ffffffff81061b8d 000000=
000000001f ffff8800b6584000
Jan 27 14:22:23 purefruit kernel:  0000000000000014 ffff8800b67cf2c0 000000=
000000001f ffff8800b6b31ce8
Jan 27 14:22:23 purefruit kernel: Call Trace:
Jan 27 14:22:23 purefruit kernel:  [<ffffffff814ec113>] dump_stack+0x54/0x8d
Jan 27 14:22:23 purefruit kernel:  [<ffffffff81061b8d>] warn_slowpath_commo=
n+0x7d/0xa0
Jan 27 14:22:23 purefruit kernel:  [<ffffffff81061bfc>] warn_slowpath_fmt+0=
x4c/0x50
Jan 27 14:22:23 purefruit kernel:  [<ffffffffa07bbdc0>] iwl_pcie_hcmd_compl=
ete+0x3d0/0x450 [iwlwifi]
Jan 27 14:22:23 purefruit kernel:  [<ffffffffa0b215a9>] ? iwl_rx_dispatch+0=
xd9/0xf0 [iwldvm]
Jan 27 14:22:23 purefruit kernel:  [<ffffffffa07b716f>] iwl_pcie_irq_handle=
r+0x75f/0x12e0 [iwlwifi]
Jan 27 14:22:23 purefruit kernel:  [<ffffffff810b69d0>] ? irq_finalize_ones=
hot.part.29+0xd0/0xd0
Jan 27 14:22:23 purefruit kernel:  [<ffffffff810b69f0>] irq_thread_fn+0x20/=
0x50
Jan 27 14:22:23 purefruit kernel:  [<ffffffff810b69d0>] ? irq_finalize_ones=
hot.part.29+0xd0/0xd0
Jan 27 14:22:23 purefruit kernel:  [<ffffffff810b6d2f>] irq_thread+0x11f/0x=
150
Jan 27 14:22:23 purefruit kernel:  [<ffffffff810b6b50>] ? wake_threads_wait=
q+0x50/0x50
Jan 27 14:22:23 purefruit kernel:  [<ffffffff810b6c10>] ? irq_thread_dtor+0=
xc0/0xc0
Jan 27 14:22:23 purefruit kernel:  [<ffffffff81083f60>] kthread+0xc0/0xd0
Jan 27 14:22:23 purefruit kernel:  [<ffffffff81083ea0>] ? kthread_create_on=
_node+0x120/0x120
Jan 27 14:22:23 purefruit kernel:  [<ffffffff814fab7c>] ret_from_fork+0x7c/=
0xb0
Jan 27 14:22:23 purefruit kernel:  [<ffffffff81083ea0>] ? kthread_create_on=
_node+0x120/0x120
Jan 27 14:22:23 purefruit kernel: ---[ end trace d77076e42af19a4f ]---
Jan 27 14:22:23 purefruit kernel: iwl data: 00000000: 50 08 80 0a 56 02 4f =
1f bf bc 4f 29 45 48 83 dd  P...V.O...O)EH..
Jan 27 14:22:23 purefruit kernel: iwl data: 00000010: d9 8d 96 24 8c fd 1f =
fa 9b c3 73 6c 92 9a 0a 1e  ...$......sl....
Jan 27 14:22:24 purefruit kernel: ------------[ cut here ]------------
Jan 27 14:22:24 purefruit kernel: WARNING: CPU: 2 PID: 314 at drivers/net/w=
ireless/iwlwifi/pcie/tx.c:1426 iwl_pcie_hcmd_complete+0x3d0/0x450 [iwlwifi]=
()
Jan 27 14:22:24 purefruit kernel: wrong command queue 31 (should be 4), seq=
uence 0x3FCA readp=3D180 writep=3D180
Jan 27 14:22:24 purefruit kernel: Modules linked in: fuse nls_cp437 vfat fa=
t usb_storage nfnetlink_queue nfnetlink_log nfnetlink ipt_REJECT iptable_fi=
lter ip_tables x_tables 8021q mrp psmouse serio_raw ppp_deflate bsd_comp pp=
p_async crc_ccitt joydev hdaps(O) ppp_generic slhc bnep intel_powerclamp co=
retemp arc4 kvm_intel kvm iwldvm mac80211 mxm_wmi iTCO_wdt iTCO_vendor_supp=
ort snd_hda_codec_hdmi snd_hda_codec_conexant btusb bluetooth uvcvideo vide=
obuf2_vmalloc videobuf2_memops qmi_wwan videobuf2_core qcserial cdc_wdm vid=
eodev usb_wwan usbnet usbserial mii media microcode iwlwifi cfg80211 intel_=
ips i2c_i801 thermal thinkpad_acpi nvram snd_hda_intel rfkill ac snd_hda_co=
dec battery snd_hwdep e1000e snd_pcm snd_page_alloc snd_timer wmi evdev mei=
_me ptp snd soundcore mei pps_core shpchp lpc_ich usbip_host(C) usbip_core(=
C) tp_smapi(O)
Jan 27 14:22:24 purefruit kernel:  thinkpad_ec(O) nfs lockd sunrpc fscache =
speakup_soft(C) speakup(C) acpi_cpufreq processor sg ext4 crc16 mbcache jbd=
2 dm_crypt dm_mod sr_mod cdrom sd_mod crct10dif_pclmul crct10dif_common crc=
32_pclmul crc32c_intel ghash_clmulni_intel ahci aesni_intel aes_x86_64 lrw =
gf128mul glue_helper sdhci_pci libahci ablk_helper cryptd libata ehci_pci s=
dhci ehci_hcd scsi_mod mmc_core usbcore usb_common i915 video button i2c_al=
go_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
Jan 27 14:22:24 purefruit kernel: CPU: 2 PID: 314 Comm: irq/44-iwlwifi Tain=
ted: G        WC O 3.12.7-2-ARCH #1
Jan 27 14:22:24 purefruit kernel: Hardware name: LENOVO 2522W29/2522W29, BI=
OS 6IET85WW (1.45 ) 02/14/2013
Jan 27 14:22:24 purefruit kernel:  0000000000000009 ffff8800b6b31c50 ffffff=
ff814ec113 ffff8800b6b31c98
Jan 27 14:22:24 purefruit kernel:  ffff8800b6b31c88 ffffffff81061b8d 000000=
000000001f ffff8800b6584000
Jan 27 14:22:24 purefruit kernel:  0000000000000014 ffff8800b67cf2c0 000000=
000000001f ffff8800b6b31ce8
Jan 27 14:22:24 purefruit kernel: Call Trace:
Jan 27 14:22:24 purefruit kernel:  [<ffffffff814ec113>] dump_stack+0x54/0x8d
Jan 27 14:22:24 purefruit kernel:  [<ffffffff81061b8d>] warn_slowpath_commo=
n+0x7d/0xa0
Jan 27 14:22:24 purefruit kernel:  [<ffffffff81061bfc>] warn_slowpath_fmt+0=
x4c/0x50
Jan 27 14:22:24 purefruit kernel:  [<ffffffffa07bbdc0>] iwl_pcie_hcmd_compl=
ete+0x3d0/0x450 [iwlwifi]
Jan 27 14:22:24 purefruit kernel:  [<ffffffffa0b215a9>] ? iwl_rx_dispatch+0=
xd9/0xf0 [iwldvm]
Jan 27 14:22:24 purefruit kernel:  [<ffffffffa07b716f>] iwl_pcie_irq_handle=
r+0x75f/0x12e0 [iwlwifi]
Jan 27 14:22:24 purefruit kernel:  [<ffffffff810b69d0>] ? irq_finalize_ones=
hot.part.29+0xd0/0xd0
Jan 27 14:22:24 purefruit kernel:  [<ffffffff810b69f0>] irq_thread_fn+0x20/=
0x50
Jan 27 14:22:24 purefruit kernel:  [<ffffffff810b69d0>] ? irq_finalize_ones=
hot.part.29+0xd0/0xd0
Jan 27 14:22:24 purefruit kernel:  [<ffffffff810b6d2f>] irq_thread+0x11f/0x=
150
Jan 27 14:22:24 purefruit kernel:  [<ffffffff810b6b50>] ? wake_threads_wait=
q+0x50/0x50
Jan 27 14:22:24 purefruit kernel:  [<ffffffff810b6c10>] ? irq_thread_dtor+0=
xc0/0xc0
Jan 27 14:22:24 purefruit kernel:  [<ffffffff81083f60>] kthread+0xc0/0xd0
Jan 27 14:22:24 purefruit kernel:  [<ffffffff81083ea0>] ? kthread_create_on=
_node+0x120/0x120
Jan 27 14:22:24 purefruit kernel:  [<ffffffff814fab7c>] ret_from_fork+0x7c/=
0xb0
Jan 27 14:22:24 purefruit kernel:  [<ffffffff81083ea0>] ? kthread_create_on=
_node+0x120/0x120
Jan 27 14:22:24 purefruit kernel: ---[ end trace d77076e42af19a50 ]---
Jan 27 14:22:24 purefruit kernel: iwl data: 00000000: 50 08 80 0a 8b 42 ca =
3f 55 6e 42 cd 0c 98 99 7b  P....B.?UnB....{
Jan 27 14:22:24 purefruit kernel: iwl data: 00000010: 09 2a 92 c1 2d 06 99 =
66 48 13 de 6d ab d8 be 2e  .*..-..fH..m....
Jan 27 14:22:24 purefruit kernel: iwlwifi 0000:03:00.0: Not sending command=
 - CT KILL
Jan 27 14:22:24 purefruit kernel: iwlwifi 0000:03:00.0: Not sending command=
 - CT KILL
Jan 27 14:22:24 purefruit kernel: iwlwifi 0000:03:00.0: Not sending command=
 - CT KILL
Jan 27 14:22:24 purefruit kernel: iwlwifi 0000:03:00.0: Not sending command=
 - CT KILL
Jan 27 14:22:24 purefruit kernel: kernel tried to execute NX-protected page=
 - exploit attempt? (uid: 0)
Jan 27 14:22:24 purefruit kernel: BUG: unable to handle kernel paging reque=
st at ffff8800b66d2128
Jan 27 14:22:24 purefruit kernel: IP: [<ffff8800b66d2128>] 0xffff8800b66d21=
27
Jan 27 14:22:24 purefruit kernel: PGD 1b32067 PUD 1bbffe067 PMD 80000000b66=
001e3=20
Jan 27 14:22:25 purefruit kernel: Oops: 0011 [#1] PREEMPT SMP=20
Jan 27 14:22:25 purefruit kernel: Modules linked in: fuse nls_cp437 vfat fa=
t usb_storage nfnetlink_queue nfnetlink_log nfnetlink ipt_REJECT iptable_fi=
lter ip_tables x_tables 8021q mrp psmouse serio_raw ppp_deflate bsd_comp pp=
p_async crc_ccitt joydev hdaps(O) ppp_generic slhc bnep intel_powerclamp co=
retemp arc4 kvm_intel kvm iwldvm mac80211 mxm_wmi iTCO_wdt iTCO_vendor_supp=
ort snd_hda_codec_hdmi snd_hda_codec_conexant btusb bluetooth uvcvideo vide=
obuf2_vmalloc videobuf2_memops qmi_wwan videobuf2_core qcserial cdc_wdm vid=
eodev usb_wwan usbnet usbserial mii media microcode iwlwifi cfg80211 intel_=
ips i2c_i801 thermal thinkpad_acpi nvram snd_hda_intel rfkill ac snd_hda_co=
dec battery snd_hwdep e1000e snd_pcm snd_page_alloc snd_timer wmi evdev mei=
_me ptp snd soundcore mei pps_core shpchp lpc_ich usbip_host(C) usbip_core(=
C) tp_smapi(O)
Jan 27 14:22:25 purefruit kernel:  thinkpad_ec(O) nfs lockd sunrpc fscache =
speakup_soft(C) speakup(C) acpi_cpufreq processor sg ext4 crc16 mbcache jbd=
2 dm_crypt dm_mod sr_mod cdrom sd_mod crct10dif_pclmul crct10dif_common crc=
32_pclmul crc32c_intel ghash_clmulni_intel ahci aesni_intel aes_x86_64 lrw =
gf128mul glue_helper sdhci_pci libahci ablk_helper cryptd libata ehci_pci s=
dhci ehci_hcd scsi_mod mmc_core usbcore usb_common i915 video button i2c_al=
go_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
Jan 27 14:22:25 purefruit kernel: CPU: 2 PID: 314 Comm: irq/44-iwlwifi Tain=
ted: G        WC O 3.12.7-2-ARCH #1
Jan 27 14:22:25 purefruit kernel: Hardware name: LENOVO 2522W29/2522W29, BI=
OS 6IET85WW (1.45 ) 02/14/2013
Jan 27 14:22:25 purefruit kernel: task: ffff8801b1a53420 ti: ffff8800b6b300=
00 task.ti: ffff8800b6b30000
Jan 27 14:22:25 purefruit kernel: RIP: 0010:[<ffff8800b66d2128>]  [<ffff880=
0b66d2128>] 0xffff8800b66d2127
Jan 27 14:22:25 purefruit kernel: RSP: 0018:ffff8800b6b31d38  EFLAGS: 00010=
202
Jan 27 14:22:25 purefruit kernel: RAX: 00000000000000ff RBX: ffff8800b66d17=
c0 RCX: 00000000000000ff
Jan 27 14:22:25 purefruit kernel: RDX: ffff8801b124e000 RSI: ffff8800b6b31e=
00 RDI: ffff8800b66d17d0
Jan 27 14:22:25 purefruit kernel: RBP: ffff8800b6b31d70 R08: ffffffffa07cb0=
30 R09: 0000000000000000
Jan 27 14:22:25 purefruit kernel: R10: ffff8801bbbf4e20 R11: 00000000000000=
01 R12: ffff8800b6b31e00
Jan 27 14:22:25 purefruit kernel: R13: ffff88007ee29000 R14: ffff8800b66d17=
d0 R15: ffff8801b124e000
Jan 27 14:22:25 purefruit kernel: FS:  0000000000000000(0000) GS:ffff8801bb=
d00000(0000) knlGS:0000000000000000
Jan 27 14:22:25 purefruit kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
8005003b
Jan 27 14:22:25 purefruit kernel: CR2: ffff8800b66d2128 CR3: 000000000180d0=
00 CR4: 00000000000007e0
Jan 27 14:22:25 purefruit kernel: Stack:
Jan 27 14:22:25 purefruit kernel:  ffffffffa0b2155e ffff8801b245e098 000000=
0000000028 ffff8801b245e098
Jan 27 14:22:25 purefruit kernel:  0000000000000e48 ffff8800b67cf2c0 ffff88=
00b6584000 ffff8800b6b31e40
Jan 27 14:22:25 purefruit kernel:  ffffffffa07b7138 ffffffffa07c955a ffff88=
00000000ff 80000000b6b31db8
Jan 27 14:22:25 purefruit kernel: Call Trace:
Jan 27 14:22:25 purefruit kernel:  [<ffffffffa0b2155e>] ? iwl_rx_dispatch+0=
x8e/0xf0 [iwldvm]
Jan 27 14:22:25 purefruit kernel:  [<ffffffffa07b7138>] iwl_pcie_irq_handle=
r+0x728/0x12e0 [iwlwifi]
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b69d0>] ? irq_finalize_ones=
hot.part.29+0xd0/0xd0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b69f0>] irq_thread_fn+0x20/=
0x50
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b69d0>] ? irq_finalize_ones=
hot.part.29+0xd0/0xd0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b6d2f>] irq_thread+0x11f/0x=
150
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b6b50>] ? wake_threads_wait=
q+0x50/0x50
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b6c10>] ? irq_thread_dtor+0=
xc0/0xc0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff81083f60>] kthread+0xc0/0xd0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff81083ea0>] ? kthread_create_on=
_node+0x120/0x120
Jan 27 14:22:25 purefruit kernel:  [<ffffffff814fab7c>] ret_from_fork+0x7c/=
0xb0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff81083ea0>] ? kthread_create_on=
_node+0x120/0x120
Jan 27 14:22:25 purefruit kernel: Code: 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 <28> 21 6d b6 00 88 ff ff 28 21 6d b6 00 88 ff ff 2c 2c =
00 00 00=20
Jan 27 14:22:25 purefruit kernel: RIP  [<ffff8800b66d2128>] 0xffff8800b66d2=
127
Jan 27 14:22:25 purefruit kernel:  RSP <ffff8800b6b31d38>
Jan 27 14:22:25 purefruit kernel: CR2: ffff8800b66d2128
Jan 27 14:22:25 purefruit kernel: ---[ end trace d77076e42af19a51 ]---
Jan 27 14:22:25 purefruit kernel: BUG: unable to handle kernel paging reque=
st at ffffffffffffffd8
Jan 27 14:22:25 purefruit kernel: IP: [<ffffffff810845c0>] kthread_data+0x1=
0/0x20
Jan 27 14:22:25 purefruit kernel: PGD 1810067 PUD 1812067 PMD 0=20
Jan 27 14:22:25 purefruit kernel: Oops: 0000 [#2] PREEMPT SMP=20
Jan 27 14:22:25 purefruit kernel: Modules linked in: fuse nls_cp437 vfat fa=
t usb_storage nfnetlink_queue nfnetlink_log nfnetlink ipt_REJECT iptable_fi=
lter ip_tables x_tables 8021q mrp psmouse serio_raw ppp_deflate bsd_comp pp=
p_async crc_ccitt joydev hdaps(O) ppp_generic slhc bnep intel_powerclamp co=
retemp arc4 kvm_intel kvm iwldvm mac80211 mxm_wmi iTCO_wdt iTCO_vendor_supp=
ort snd_hda_codec_hdmi snd_hda_codec_conexant btusb bluetooth uvcvideo vide=
obuf2_vmalloc videobuf2_memops qmi_wwan videobuf2_core qcserial cdc_wdm vid=
eodev usb_wwan usbnet usbserial mii media microcode iwlwifi cfg80211 intel_=
ips i2c_i801 thermal thinkpad_acpi nvram snd_hda_intel rfkill ac snd_hda_co=
dec battery snd_hwdep e1000e snd_pcm snd_page_alloc snd_timer wmi evdev mei=
_me ptp snd soundcore mei pps_core shpchp lpc_ich usbip_host(C) usbip_core(=
C) tp_smapi(O)
Jan 27 14:22:25 purefruit kernel:  thinkpad_ec(O) nfs lockd sunrpc fscache =
speakup_soft(C) speakup(C) acpi_cpufreq processor sg ext4 crc16 mbcache jbd=
2 dm_crypt dm_mod sr_mod cdrom sd_mod crct10dif_pclmul crct10dif_common crc=
32_pclmul crc32c_intel ghash_clmulni_intel ahci aesni_intel aes_x86_64 lrw =
gf128mul glue_helper sdhci_pci libahci ablk_helper cryptd libata ehci_pci s=
dhci ehci_hcd scsi_mod mmc_core usbcore usb_common i915 video button i2c_al=
go_bit intel_agp intel_gtt drm_kms_helper drm i2c_core
Jan 27 14:22:25 purefruit kernel: CPU: 2 PID: 314 Comm: irq/44-iwlwifi Tain=
ted: G      D WC O 3.12.7-2-ARCH #1
Jan 27 14:22:25 purefruit kernel: Hardware name: LENOVO 2522W29/2522W29, BI=
OS 6IET85WW (1.45 ) 02/14/2013
Jan 27 14:22:25 purefruit kernel: task: ffff8801b1a53420 ti: ffff8800b6b300=
00 task.ti: ffff8800b6b30000
Jan 27 14:22:25 purefruit kernel: RIP: 0010:[<ffffffff810845c0>]  [<fffffff=
f810845c0>] kthread_data+0x10/0x20
Jan 27 14:22:25 purefruit kernel: RSP: 0018:ffff8800b6b319c8  EFLAGS: 00010=
202
Jan 27 14:22:25 purefruit kernel: RAX: 0000000000000000 RBX: 00000000000000=
00 RCX: 0000000000000000
Jan 27 14:22:25 purefruit kernel: RDX: ffff8800b6b31e90 RSI: 00000000000000=
00 RDI: ffff8801b1a53420
Jan 27 14:22:25 purefruit kernel: RBP: ffff8800b6b319c8 R08: 00000000000000=
00 R09: 00000000000022f8
Jan 27 14:22:25 purefruit kernel: R10: 0000000000000001 R11: 00000000000001=
3a R12: ffff8801b1a53420
Jan 27 14:22:25 purefruit kernel: R13: ffff8801b1a53a38 R14: ffff8801b1a534=
20 R15: ffff8801b1a53420
Jan 27 14:22:25 purefruit kernel: FS:  0000000000000000(0000) GS:ffff8801bb=
d00000(0000) knlGS:0000000000000000
Jan 27 14:22:25 purefruit kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000=
8005003b
Jan 27 14:22:25 purefruit kernel: CR2: ffffffffffffffd8 CR3: 000000000180d0=
00 CR4: 00000000000007e0
Jan 27 14:22:25 purefruit kernel: Stack:
Jan 27 14:22:25 purefruit kernel:  ffff8800b6b319f0 ffffffff810b6b79 ffffff=
ff81867b80 0000000000000000
Jan 27 14:22:25 purefruit kernel:  ffffffff81a2fbc0 ffff8800b6b31a20 ffffff=
ff81080c9f 0000000000000000
Jan 27 14:22:25 purefruit kernel:  ffff8800b6b31c88 0000000000000046 ffff88=
01b1a53420 ffff8800b6b31a98
Jan 27 14:22:25 purefruit kernel: Call Trace:
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b6b79>] irq_thread_dtor+0x2=
9/0xc0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff81080c9f>] task_work_run+0x9f/=
0xe0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff8106402e>] do_exit+0x2be/0xab0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b4d61>] ? kmsg_dump+0xc1/0x=
d0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff814f44d1>] oops_end+0xa1/0xe0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff814e8e16>] no_context+0x281/0x=
28e
Jan 27 14:22:25 purefruit kernel:  [<ffffffff814e8ea9>] __bad_area_nosemaph=
ore+0x86/0x1dc
Jan 27 14:22:25 purefruit kernel:  [<ffffffff814e9012>] bad_area_nosemaphor=
e+0x13/0x15
Jan 27 14:22:25 purefruit kernel:  [<ffffffff814f6b6e>] __do_page_fault+0x3=
fe/0x5e0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff811890ba>] ? kmem_cache_free+0=
x22a/0x270
Jan 27 14:22:25 purefruit kernel:  [<ffffffff813ef327>] ? kfree_skbmem+0x37=
/0x90
Jan 27 14:22:25 purefruit kernel:  [<ffffffff813f29f8>] ? consume_skb+0x38/=
0xc0
Jan 27 14:22:25 purefruit kernel:  [<ffffffffa0a954b5>] ? ieee80211_rx+0x20=
5/0x860 [mac80211]
Jan 27 14:22:25 purefruit kernel:  [<ffffffff814f6d5e>] do_page_fault+0xe/0=
x10
Jan 27 14:22:25 purefruit kernel:  [<ffffffff814f3988>] page_fault+0x28/0x30
Jan 27 14:22:25 purefruit kernel:  [<ffffffffa0b2155e>] ? iwl_rx_dispatch+0=
x8e/0xf0 [iwldvm]
Jan 27 14:22:25 purefruit kernel:  [<ffffffffa07b7138>] iwl_pcie_irq_handle=
r+0x728/0x12e0 [iwlwifi]
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b69d0>] ? irq_finalize_ones=
hot.part.29+0xd0/0xd0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b69f0>] irq_thread_fn+0x20/=
0x50
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b69d0>] ? irq_finalize_ones=
hot.part.29+0xd0/0xd0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b6d2f>] irq_thread+0x11f/0x=
150
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b6b50>] ? wake_threads_wait=
q+0x50/0x50
Jan 27 14:22:25 purefruit kernel:  [<ffffffff810b6c10>] ? irq_thread_dtor+0=
xc0/0xc0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff81083f60>] kthread+0xc0/0xd0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff81083ea0>] ? kthread_create_on=
_node+0x120/0x120
Jan 27 14:22:25 purefruit kernel:  [<ffffffff814fab7c>] ret_from_fork+0x7c/=
0xb0
Jan 27 14:22:25 purefruit kernel:  [<ffffffff81083ea0>] ? kthread_create_on=
_node+0x120/0x120
Jan 27 14:22:25 purefruit kernel: Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8=
 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 d0 03=
 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 =
66 66 90=20
Jan 27 14:22:25 purefruit kernel: RIP  [<ffffffff810845c0>] kthread_data+0x=
10/0x20
Jan 27 14:22:25 purefruit kernel:  RSP <ffff8800b6b319c8>
Jan 27 14:22:25 purefruit kernel: CR2: ffffffffffffffd8
Jan 27 14:22:25 purefruit kernel: ---[ end trace d77076e42af19a52 ]---
Jan 27 14:22:25 purefruit kernel: Fixing recursive fault but reboot is need=
ed!
Jan 27 14:22:26 purefruit kernel: iwlwifi 0000:03:00.0: Not sending command=
 - CT KILL
Jan 27 14:22:26 purefruit kernel: iwlwifi 0000:03:00.0: Not sending command=
 - CT KILL
Jan 27 14:22:27 purefruit kernel: iwlwifi 0000:03:00.0: Not sending command=
 - CT KILL

--MP_/GLCKNfz_Z9k2rhYsvPRH_2U--
