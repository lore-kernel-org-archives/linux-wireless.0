Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3992 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab2GJLCH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 07:02:07 -0400
Received: from mail-sj1-12.sj.broadcom.com (mail-sj1-12.sj.broadcom.com
 [10.17.16.106]) by mail-irva-13.broadcom.com (Postfix) with ESMTP id
 BB9399F9F5 for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012
 04:01:55 -0700 (PDT)
Received: from [10.0.2.15] (unknown [10.176.68.147]) by
 mail-sj1-12.sj.broadcom.com (Postfix) with ESMTP id 2E894207C0 for
 <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 04:01:55 -0700 (PDT)
Message-ID: <4FFC0BA2.3060107@broadcom.com> (sfid-20120710_130212_744547_93D9E56B)
Date: Tue, 10 Jul 2012 13:01:54 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: kernel oops on wireless-testing
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently I get a kernel oops in nightly test on the wireless-testing
tree (see below). This is on 3.5-rc4 kernel based on following commit:

commit a5b846deb890fbea72267e4e7d98f8f022959d14
Merge: 1532e30 bf52592
Author: John W. Linville <linville@tuxdriver.com>
Date:   Wed Jun 27 16:15:29 2012 -0400

    Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/linvi

Can this be expected (eg. recent change in struct wiphy) ? I will built
a new kernel from wireless-testing and see if that helps.

Gr. AvS

Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699393] BUG: unable to handle
kernel NULL pointer dereference at 00000006
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699436] IP: [<c14a3325>]
wext_handle_ioctl+0x105/0x190
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699453] *pde = 00000000
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699466] Oops: 0000 [#1] SMP
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699534] Modules linked in: arc4
brcmsmac(O) brcmutil(O) crc_ccitt bcma(O) mac80211(O) cfg80211(O)
binfmt_misc snd_hda_codec_hdmi snd_hda_codec_idt nouveau snd_hda_intel
ttm drm_kms_helper drm snd_hda_codec dell_laptop i2c_algo_bit snd_hwdep
mxm_wmi snd_seq_midi snd_rawmidi snd_pcm snd_seq_midi_event dell_wmi
coretemp lpc_ich mfd_core snd_seq video snd_timer snd_seq_device snd
intel_ips dcdbas soundcore intel_agp intel_gtt agpgart snd_page_alloc
crc32c_intel microcode psmouse serio_raw sparse_keymap ahci libahci
firewire_ohci sdhci_pci sdhci mmc_core firewire_core crc_itu_t e1000e
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699620]
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699636] Pid: 946, comm:
NetworkManager Tainted: G           O
3.5.0-rc4-wl-testing-00002-gd1ae704 #1 Dell Inc. Latitude E6410/07XJP9
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699664] EIP: 0060:[<c14a3325>]
EFLAGS: 00010297 CPU: 0
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699682] EIP is at
wext_handle_ioctl+0x105/0x190
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699700] EAX: f3bb4000 EBX:
00000001 ECX: 000000d4 EDX: 00000002
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699717] ESI: 00008b01 EDI:
f385fec0 EBP: f385fe78 ESP: f385fe58
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699735]  DS: 007b ES: 007b FS:
00d8 GS: 00e0 SS: 0068
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699751] CR0: 80050033 CR2:
00000006 CR3: 33a81000 CR4: 000007d0
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699769] DR0: 00000000 DR1:
00000000 DR2: 00000000 DR3: 00000000
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699785] DR6: ffff0ff0 DR7: 00000400
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699799] Process NetworkManager
(pid: 946, ti=f385e000 task=f34bd860 task.ti=f385e000)
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699818] Stack:
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699835]  000280d0 f385fe70
00000001 00008b01 00008b01 00008b01 c1878820 f3ffad80
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699862]  f385fef0 c13f0c29
bfe9ff4c c17064a0 f391df68 00000000 bfe9ff4c c1120944
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699887]  00000002 f4676e40
c17a27e8 00000002 c125a743 000080d0 f391d3b0 f4676e40
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699907] Call Trace:
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699927]  [<c13f0c29>]
dev_ioctl+0x579/0x6d0
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699949]  [<c1120944>] ?
kmem_cache_alloc_trace+0xa4/0x100
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699972]  [<c125a743>] ?
apparmor_file_alloc_security+0x23/0x50
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.699995]  [<c13da000>] ?
move_addr_to_kernel+0x70/0x70
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.700014]  [<c13da1d3>]
sock_ioctl+0x1d3/0x270
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.700032]  [<c13da000>] ?
move_addr_to_kernel+0x70/0x70
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.700053]  [<c11398f6>]
do_vfs_ioctl+0x86/0x5a0
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.700074]  [<c14c40dd>] ?
_raw_spin_lock+0xd/0x10
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.700094]  [<c1127d0c>] ?
fd_install+0x4c/0x60
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.700111]  [<c13da4f4>] ?
sock_map_fd+0x24/0x30
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.700129]  [<c13daa7c>] ?
sys_socket+0x5c/0x70
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.700148]  [<c13dcb26>] ?
sys_socketcall+0xa6/0x2e0
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.700167]  [<c1139e87>]
sys_ioctl+0x77/0x80
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.700184]  [<c1127e73>] ?
sys_close+0x73/0xc0
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.701100]  [<c14cadbf>]
sysenter_do_call+0x12/0x28
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.702094] Code: 5d 8b 90 bc 01 00
00 85 d2 74 2f 8b 12 85 d2 74 29 8b 92 20 02 00 00 85 d2 74 1f 0f b7 4a
04 8d 9e 00 75 ff ff 39 cb 73 11 8b 12 <8b> 14 9a 85 d2 74 08 81 fe df
8b 00 00 76 5e 8b 90 2c 01 00 00
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.703537] EIP: [<c14a3325>]
wext_handle_ioctl+0x105/0x190 SS:ESP 0068:f385fe58
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.704183] CR2: 0000000000000006
Jul 10 12:29:07 lb-bun-10 kernel: [ 1718.708501] ---[ end trace
3df9e57d53a37de6 ]---

