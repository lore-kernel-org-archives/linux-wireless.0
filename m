Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:57025 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab1ECRyM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 13:54:12 -0400
Received: from [195.4.92.22] (helo=12.mx.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QHJnW-0005OS-I9
	for linux-wireless@vger.kernel.org; Tue, 03 May 2011 19:54:10 +0200
Received: from p54a19618.dip0.t-ipconnect.de ([84.161.150.24]:60952 helo=mail.maya.org)
	by 12.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QHJnW-0002v7-8D
	for linux-wireless@vger.kernel.org; Tue, 03 May 2011 19:54:10 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p43HuAdt002268
	for <linux-wireless@vger.kernel.org>; Tue, 3 May 2011 19:56:11 +0200
Message-ID: <4DC041BC.3040007@01019freenet.de> (sfid-20110503_195421_300049_CFC1C0BB)
Date: Tue, 03 May 2011 19:56:12 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: trace: compat-wireless crashes modprobe and hangs fuse on linux 2.6.34.9
 vanilla
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

while loading compat with vanilla 2.6.34.9, modprobe crashes (-> it's
killed) and the following traces can be seen in messages:


May  3 19:29:53 dualc kernel: [  130.153439] Compat-wireless backport
release: compat-wireless-2011-04-26-3-g6542f4c
May  3 19:29:53 dualc kernel: [  130.153446] Backport based on
linux-next.git next-20110502
May  3 19:29:53 dualc kernel: [  130.153464] BUG: unable to handle
kernel paging request at ffff87ffa20a1d3c
May  3 19:29:53 dualc kernel: [  130.153478] IP: [<ffffffff8108709a>]
module_put+0x2a/0xa0
May  3 19:29:53 dualc kernel: [  130.153497] PGD 0
May  3 19:29:53 dualc kernel: [  130.153504] Oops: 0002 [#1] SMP
May  3 19:29:53 dualc kernel: [  130.153510] last sysfs file:
/sys/module/usbcore/initstate
May  3 19:29:53 dualc kernel: [  130.153519] CPU 1
May  3 19:29:53 dualc kernel: [  130.153523] Modules linked in: compat
eeprom_93cx6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device bridge stp
llc tun cpuf
req_conservative cpufreq_userspace cpufreq_powersave powernow_k8 fuse
sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt reiserfs loop
dm_mod snd_hda
_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm firewire_ohci firewire_core crc_itu_t snd_timer
kvm_amd snd ohci1394 soun
dcore edac_core e100 kvm usb_storage snd_page_alloc r8169 pcspkr
i2c_piix4 sr_mod ieee1394 k8temp edac_mce_amd wmi cdrom shpchp
pci_hotplug button sg usbhid
 sd_mod ohci_hcd ssb ehci_hcd mmc_core usbcore pcmcia ahci pcmcia_core
edd fan processor ata_generic pata_atiixp libata scsi_mod thermal
thermal_sys raid1
May  3 19:29:53 dualc kernel: [  130.153659]
May  3 19:29:53 dualc kernel: [  130.153669] Pid: 8157, comm: modprobe
Not tainted 2.6.34.9-4-vanilla #1 GA-MA78G-DS3H/GA-MA78G-DS3H
May  3 19:29:53 dualc kernel: [  130.153679] RIP:
0010:[<ffffffff8108709a>]  [<ffffffff8108709a>] module_put+0x2a/0xa0
May  3 19:29:53 dualc kernel: [  130.153694] RSP: 0018:ffff88021cf1ff28
 EFLAGS: 00010286
May  3 19:29:53 dualc kernel: [  130.153702] RAX: ffffffffa0421d38 RBX:
ffffffffa04227a0 RCX: ffffffff81819290
May  3 19:29:53 dualc kernel: [  130.153711] RDX: ffffffff81819290 RSI:
0000000000000296 RDI: ffffffffa04227a0
May  3 19:29:53 dualc kernel: [  130.153719] RBP: ffff88021cf1ff48 R08:
0000000000000000 R09: 000000000000f61f
May  3 19:29:53 dualc kernel: [  130.153728] R10: 0000000000000006 R11:
0000000000000096 R12: 0000000000000000
May  3 19:29:53 dualc kernel: [  130.153737] R13: 0000000000612480 R14:
0000000000000000 R15: 0000000000611780
May  3 19:29:53 dualc kernel: [  130.153747] FS:  00007f6aa42346f0(0000)
GS:ffff880001c80000(0000) knlGS:0000000000000000
May  3 19:29:53 dualc kernel: [  130.153757] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
May  3 19:29:53 dualc kernel: [  130.153765] CR2: ffff87ffa20a1d3c CR3:
000000021cf58000 CR4: 00000000000006e0
May  3 19:29:53 dualc kernel: [  130.153774] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May  3 19:29:53 dualc kernel: [  130.153783] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May  3 19:29:53 dualc kernel: [  130.153793] Process modprobe (pid:
8157, threadinfo ffff88021cf1e000, task ffff88021a60c580)
May  3 19:29:53 dualc kernel: [  130.153801] Stack:
May  3 19:29:53 dualc kernel: [  130.153806]  ffffffffa04227a0
0000000000000000 0000000000612480 0000000000000000
May  3 19:29:53 dualc kernel: [  130.153818] <0> ffff88021cf1ff78
ffffffff8108b0d3 0000000000611780 0000000000612320
May  3 19:29:53 dualc kernel: [  130.153831] <0> 00000000006163f0
0000000000612480 0000000000000000 ffffffff81002eeb
May  3 19:29:53 dualc kernel: [  130.153845] Call Trace:
May  3 19:29:53 dualc kernel: [  130.153858]  [<ffffffff8108b0d3>]
sys_init_module+0x133/0x250
May  3 19:29:53 dualc kernel: [  130.153872]  [<ffffffff81002eeb>]
system_call_fastpath+0x16/0x1b
May  3 19:29:53 dualc kernel: [  130.153879] Code: 00 55 48 89 e5 48 83
ec 20 48 85 ff 48 89 1c 24 4c 89 64 24 08 48 89 fb 4c 89 6c 24 10 4c 89
74 24 18 74
2c 48 8b 87 30 02 00 00 <65> ff 40 04 44 8b 1d 03 fe 87 00 48 8b 87 30
02 00 00 65 44 8b
May  3 19:29:53 dualc kernel: [  130.153965] RIP  [<ffffffff8108709a>]
module_put+0x2a/0xa0
May  3 19:29:53 dualc kernel: [  130.153976]  RSP <ffff88021cf1ff28>
May  3 19:29:53 dualc kernel: [  130.153982] CR2: ffff87ffa20a1d3c
May  3 19:29:53 dualc kernel: [  130.153990] ---[ end trace
e6ac555646ff87d2 ]---




May  3 19:44:45 dualc kernel: [  102.634714] Compat-wireless backport
release: compat-wireless-2011-04-14-3-g77081fd
May  3 19:44:45 dualc kernel: [  102.634722] Backport based on
linux-next.git next-20110421
May  3 19:44:45 dualc kernel: [  102.634741] BUG: unable to handle
kernel paging request at ffff87ffa1fafcfc
May  3 19:44:45 dualc kernel: [  102.634755] IP: [<ffffffff8108709a>]
module_put+0x2a/0xa0
May  3 19:44:45 dualc kernel: [  102.634774] PGD 0
May  3 19:44:45 dualc kernel: [  102.634781] Oops: 0002 [#1] SMP
May  3 19:44:45 dualc kernel: [  102.634789] last sysfs file:
/sys/module/usbcore/initstate
May  3 19:44:45 dualc kernel: [  102.634798] CPU 0
May  3 19:44:45 dualc kernel: [  102.634802] Modules linked in: compat
eeprom_93cx6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device bridge stp
llc tun cpuf
req_conservative cpufreq_userspace cpufreq_powersave powernow_k8 fuse
sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt reiserfs loop
dm_mod snd_hda
_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
firewire_ohci firewire_core snd_hwdep crc_itu_t snd_pcm snd_timer
ohci1394 kvm_amd snd edac
_core sr_mod usb_storage soundcore edac_mce_amd i2c_piix4 k8temp
ieee1394 cdrom kvm button r8169 pcspkr e100 snd_page_alloc wmi sg shpchp
pci_hotplug usbhid
 sd_mod ohci_hcd ssb ehci_hcd mmc_core usbcore pcmcia ahci pcmcia_core
edd fan processor ata_generic pata_atiixp libata scsi_mod thermal
thermal_sys raid1
May  3 19:44:45 dualc kernel: [  102.634938]
May  3 19:44:45 dualc kernel: [  102.634947] Pid: 7011, comm: modprobe
Not tainted 2.6.34.9-4-vanilla #1 GA-MA78G-DS3H/GA-MA78G-DS3H
May  3 19:44:45 dualc kernel: [  102.634957] RIP:
0010:[<ffffffff8108709a>]  [<ffffffff8108709a>] module_put+0x2a/0xa0
May  3 19:44:45 dualc kernel: [  102.634973] RSP: 0018:ffff88021ef17f28
 EFLAGS: 00010282
May  3 19:44:45 dualc kernel: [  102.634980] RAX: ffffffffa03afcf8 RBX:
ffffffffa03b0740 RCX: ffffffff81819290
May  3 19:44:45 dualc kernel: [  102.634989] RDX: ffffffff81819290 RSI:
0000000000000296 RDI: ffffffffa03b0740
May  3 19:44:45 dualc kernel: [  102.634998] RBP: ffff88021ef17f48 R08:
0000000000000000 R09: 000000000000f6a4
May  3 19:44:45 dualc kernel: [  102.635007] R10: 0000000000000006 R11:
0000000000000096 R12: 0000000000000000
May  3 19:44:45 dualc kernel: [  102.635016] R13: 0000000000612480 R14:
0000000000000000 R15: 0000000000611780
May  3 19:44:45 dualc kernel: [  102.635026] FS:  00007f65b00d46f0(0000)
GS:ffff880001c00000(0000) knlGS:0000000000000000
May  3 19:44:45 dualc kernel: [  102.635035] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
May  3 19:44:45 dualc kernel: [  102.635043] CR2: ffff87ffa1fafcfc CR3:
000000021ca94000 CR4: 00000000000006f0
May  3 19:44:45 dualc kernel: [  102.635052] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May  3 19:44:45 dualc kernel: [  102.635061] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May  3 19:44:45 dualc kernel: [  102.635071] Process modprobe (pid:
7011, threadinfo ffff88021ef16000, task ffff88021c9d2040)
May  3 19:44:45 dualc kernel: [  102.635080] Stack:
May  3 19:44:45 dualc kernel: [  102.635084]  ffffffffa03b0740
0000000000000000 0000000000612480 0000000000000000
May  3 19:44:45 dualc kernel: [  102.635097] <0> ffff88021ef17f78
ffffffff8108b0d3 0000000000611780 0000000000612320
May  3 19:44:45 dualc kernel: [  102.635110] <0> 00000000006163f0
0000000000612480 0000000000000000 ffffffff81002eeb
May  3 19:44:45 dualc kernel: [  102.635125] Call Trace:
May  3 19:44:45 dualc kernel: [  102.635137]  [<ffffffff8108b0d3>]
sys_init_module+0x133/0x250
May  3 19:44:45 dualc kernel: [  102.635152]  [<ffffffff81002eeb>]
system_call_fastpath+0x16/0x1b
May  3 19:44:45 dualc kernel: [  102.635159] Code: 00 55 48 89 e5 48 83
ec 20 48 85 ff 48 89 1c 24 4c 89 64 24 08 48 89 fb 4c 89 6c 24 10 4c 89
74 24 18 74
2c 48 8b 87 30 02 00 00 <65> ff 40 04 44 8b 1d 03 fe 87 00 48 8b 87 30
02 00 00 65 44 8b
May  3 19:44:45 dualc kernel: [  102.635234] RIP  [<ffffffff8108709a>]
module_put+0x2a/0xa0
May  3 19:44:45 dualc kernel: [  102.635245]  RSP <ffff88021ef17f28>
May  3 19:44:45 dualc kernel: [  102.635251] CR2: ffff87ffa1fafcfc
May  3 19:44:45 dualc kernel: [  102.635259] ---[ end trace
bfc5903509e64344 ]---



Please try to fix those problems!


Thank you,
Andreas
