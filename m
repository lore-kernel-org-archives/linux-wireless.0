Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:42116 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbbBDJ3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 04:29:49 -0500
Received: by mail-we0-f177.google.com with SMTP id l61so554105wev.8
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2015 01:29:48 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Feb 2015 10:29:47 +0100
Message-ID: <CALhHN=p8PxiQ2BPjeEtVUTj2XJEbHbsSsuoH=38sbgAO_e6cQQ@mail.gmail.com> (sfid-20150204_102958_213154_54DD8FE8)
Subject: oops in pwq_activate_delayed_work+0x1f/0x3f
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: tj@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

3.19rc3 and 3.19rc5 - I am not 100% sure, but didn't see this on 3.17?
In 2 cases last log I see is: "cancelling AP probe due to a received beacon"
Any idea what could be a problem here?

[ 1654.833647] wlan1: cancelling AP probe due to a received beacon
[ 1654.840062] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[ 1654.844009] IP: [<ffffffff81054908>] pwq_activate_delayed_work+0x1f/0x3f
[ 1654.844009] PGD 36b8f067 PUD d7d2b067 PMD 0
[ 1654.844009] Oops: 0000 [#1] SMP
[ 1654.844009] Modules linked in: ath10k_pci(O) ath10k_core(O) ath
mac80211(O) cfg80211(O) snd_hda_codec_hdmi snd_hda_codec_idt
snd_hda_codec_generic dell_wmi sparse_keymap coretemp snd_hda_intel
snd_hda_controller kvm_intel snd_hda_codec kvm snd_hwdep dell_laptop
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_seq_midi_event
snd_rawmidi snd_seq dcdbas snd_timer i8k microcode ecb evdev
snd_seq_device i915 ath3k btusb bnep joydev serio_raw snd lpc_ich
soundcore mfd_core ehci_pci rfcomm drm_kms_helper bluetooth drm wmi
ehci_hcd i2c_algo_bit i2c_core battery button tpm_tis tpm video ac
acpi_cpufreq processor fuse parport_pc ppdev binfmt_misc lp parport
ext4 crc16 jbd2 mbcache sr_mod sd_mod cdrom psmouse sdhci_pci
ata_generic firewire_ohci sdhci mmc_core ata_piix firewire_core
crc_itu_t thermal uhci_hcd thermal_sys e1000e usbcore ptp libata
usb_common pps_core scsi_mod
[ 1654.844009] CPU: 0 PID: 24383 Comm: kworker/u4:3 Tainted: G
W  O   3.19.0-rc3-rome-2015-01-25-wl-ath-00320-g86b465c-dirty #240
[ 1654.844009] Hardware name: Dell Inc. Latitude E4300
 /0D201R, BIOS A14 12/22/2009
[ 1654.844009] task: ffff8800a0fb52b0 ti: ffff8800a0fcc000 task.ti:
ffff8800a0fcc000
[ 1654.844009] RIP: 0010:[<ffffffff81054908>]  [<ffffffff81054908>]
pwq_activate_delayed_work+0x1f/0x3f
[ 1654.844009] RSP: 0018:ffff8800a0fcfdc8  EFLAGS: 00010046
[ 1654.844009] RAX: 0000000000000000 RBX: ffff8800a0fd6ca8 RCX: 0000000000000d58
[ 1654.844009] RDX: ffff8801165dca60 RSI: 0000000000000001 RDI: ffff8800a0fd6ca8
[ 1654.844009] RBP: ffff8800a0fcfdd8 R08: 0000000000000018 R09: 0000000043429f0e
[ 1654.844009] R10: ffffffff81a0d1c0 R11: ffffffff81a0d5c0 R12: 0000000000000000
[ 1654.844009] R13: 0000000000000001 R14: ffff8801165dca00 R15: 0000000000000000
[ 1654.844009] FS:  0000000000000000(0000) GS:ffff88011bc00000(0000)
knlGS:0000000000000000
[ 1654.844009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1654.844009] CR2: 00000000000000b8 CR3: 0000000036d95000 CR4: 00000000000407f0
[ 1654.844009] Stack:
[ 1654.844009]  ffff8801165dca00 0000000000000001 ffff8800a0fcfe08
ffffffff81054c1b
[ 1654.844009]  ffff88011b098158 ffff8800a0fbaa00 ffff880116468ca8
ffff88011b098000
[ 1654.844009]  ffff8800a0fcfe58 ffffffff81055056 0000000000000004
00000001a0fbaa00
[ 1654.844009] Call Trace:
[ 1654.844009]  [<ffffffff81054c1b>] pwq_dec_nr_in_flight+0x45/0x8c
[ 1654.844009]  [<ffffffff81055056>] process_one_work+0x221/0x288
[ 1654.844009]  [<ffffffff8105558e>] worker_thread+0x1ed/0x2c4
[ 1654.844009]  [<ffffffff810553a1>] ? cancel_delayed_work_sync+0x15/0x15
[ 1654.844009]  [<ffffffff8105943c>] kthread+0xae/0xb6
[ 1654.844009]  [<ffffffff8105938e>] ? __kthread_parkme+0x61/0x61
[ 1654.844009]  [<ffffffff813fb22c>] ret_from_fork+0x7c/0xb0
[ 1654.844009]  [<ffffffff8105938e>] ? __kthread_parkme+0x61/0x61
[ 1654.844009] Code: 08 48 89 c7 48 8d 41 f8 eb b9 5d c3 66 66 66 66
90 55 48 89 e5 41 54 53 48 89 fb e8 98 dd ff ff 48 89 df 49 89 c4 e8
09 ed ff ff <49> 8b 04 24 31 d2 48 89 df 48 8d 70 18 e8 75 ff ff ff 0f
ba 33
[ 1654.844009] RIP  [<ffffffff81054908>] pwq_activate_delayed_work+0x1f/0x3f
[ 1654.844009]  RSP <ffff8800a0fcfdc8>
[ 1654.844009] CR2: 0000000000000000
[ 1654.844009] ---[ end trace cb4601ec9d59eb96 ]---
[ 1654.844009] Kernel panic - not syncing: Fatal exception
[ 1654.844009] Shutting down cpus with NMI
[ 1654.844009] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffff9fffffff)
[ 1654.844009] drm_kms_helper: panic occurred, switching back to text console


[ 3786.332442] cfg80211: Found new beacon on frequency: 5180 MHz (Ch 36) on phy1
[ 3787.590329] cfg80211: Found new beacon on frequency: 5745 MHz (Ch
149) on phy1
[ 3788.082302] p2p-wlan1-0: cancelling AP probe due to a received beacon
[ 3788.099515] wlan1: authenticate with a4:17:31:0d:1e:63
[ 3788.104659] wlan1: Allocated STA a4:17:31:0d:1e:63
[ 3788.164798] wlan1: Inserted STA a4:17:31:0d:1e:63
[ 3788.169513] wlan1: send auth to a4:17:31:0d:1e:63 (try 1/3)
[ 3788.176692] wlan1: authenticated
[ 3788.179915] wlan1: moving STA a4:17:31:0d:1e:63 to state 2
[ 3788.188061] wlan1: associate with a4:17:31:0d:1e:63 (try 1/3)
[ 3788.195888] wlan1: RX AssocResp from a4:17:31:0d:1e:63 (capab=0x1
status=0 aid=1)
[ 3788.203388] wlan1: moving STA a4:17:31:0d:1e:63 to state 3
[ 3788.208881] wlan1: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15
cWmax=1023 txop=0 uapsd=0, downgraded=0
[ 3788.218362] wlan1: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15
cWmax=1023 txop=0 uapsd=0, downgraded=0
[ 3788.227713] wlan1: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15
txop=94 uapsd=0, downgraded=0
[ 3788.236937] wlan1: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7
txop=47 uapsd=0, downgraded=0
[ 3788.246963] wlan1: associated
[ 3788.250644] wlan1: moving STA a4:17:31:0d:1e:63 to state 4
[ 3791.702507] p2p-wlan1-0: deauthenticating from f6:b7:e2:38:83:f3 by
local choice (Reason: 3=DEAUTH_LEAVING)
[ 3791.724905] p2p-wlan1-0: moving STA f6:b7:e2:38:83:f3 to state 3
[ 3791.730999] p2p-wlan1-0: moving STA f6:b7:e2:38:83:f3 to state 2
[ 3791.737026] p2p-wlan1-0: moving STA f6:b7:e2:38:83:f3 to state 1
[ 3791.743519] p2p-wlan1-0: Removed STA f6:b7:e2:38:83:f3
[ 3791.748778] p2p-wlan1-0: Destroyed STA f6:b7:e2:38:83:f3
[ 3795.803098] wlan1: cancelling AP probe due to a received beacon
[ 3795.818926] p2p-wlan1-0: authenticate with f6:b7:e2:38:83:f3
[ 3795.824630] p2p-wlan1-0: Allocated STA f6:b7:e2:38:83:f3
[ 3795.888988] p2p-wlan1-0: Inserted STA f6:b7:e2:38:83:f3
[ 3795.894223] p2p-wlan1-0: send auth to f6:b7:e2:38:83:f3 (try 1/3)
[ 3796.808330] p2p-wlan1-0: send auth to f6:b7:e2:38:83:f3 (try 2/3)
[ 3797.808324] p2p-wlan1-0: send auth to f6:b7:e2:38:83:f3 (try 3/3)
[ 3798.808326] p2p-wlan1-0: authentication with f6:b7:e2:38:83:f3 timed out
[ 3798.828662] p2p-wlan1-0: Removed STA f6:b7:e2:38:83:f3
[ 3798.834168] p2p-wlan1-0: Destroyed STA f6:b7:e2:38:83:f3
[ 3801.825822] wlan1: cancelling AP probe due to a received beacon
[ 3801.832149] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[ 3801.836010] IP: [<ffffffff81054a8c>] pwq_activate_delayed_work+0x1f/0x3f
[ 3801.836010] PGD 3680f067 PUD 3656a067 PMD 0
[ 3801.836010] Oops: 0000 [#1] SMP
[ 3801.836010] Modules linked in: ath10k_pci ath10k_core ath mac80211
cfg80211 snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep ecb
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi bnep dell_wmi
sparse_keymap snd_seq_midi_event snd_rawmidi i915 ath3k snd_seq btusb
snd_timer rfcomm coretemp dell_laptop dcdbas bluetooth snd_seq_device
snd kvm_intel i8k soundcore evdev joydev serio_raw kvm microcode
drm_kms_helper lpc_ich ehci_pci drm mfd_core ehci_hcd i2c_algo_bit
i2c_core battery wmi button tpm_tis tpm video ac acpi_cpufreq
processor fuse parport_pc ppdev lp binfmt_misc parport ext4 crc16 jbd2
mbcache e1000e ptp sr_mod sd_mod cdrom ata_generic sdhci_pci sdhci
psmouse ata_piix libata mmc_core thermal thermal_sys firewire_ohci
firewire_core uhci_hcd usbcore crc_itu_t usb_common pps_core scsi_mod
[last unloaded: cfg80211]
[ 3801.836010] CPU: 1 PID: 28318 Comm: kworker/u4:1 Tainted: G
W      3.19.0-rc5-2015-02-03-wl-ath-00109-g8e17d00-dirty #245
[ 3801.836010] Hardware name: Dell Inc. Latitude E4300
 /0D201R, BIOS A14 12/22/2009
[ 3801.836010] task: ffff88007219c0d0 ti: ffff8800aba88000 task.ti:
ffff8800aba88000
[ 3801.836010] RIP: 0010:[<ffffffff81054a8c>]  [<ffffffff81054a8c>]
pwq_activate_delayed_work+0x1f/0x3f
[ 3801.836010] RSP: 0000:ffff8800aba8bdc8  EFLAGS: 00010046
[ 3801.836010] RAX: 0000000000000000 RBX: ffff8800a7ca2ca8 RCX: 000000000000f4b0
[ 3801.836010] RDX: ffff8800a981be60 RSI: 0000000000000001 RDI: ffff8800a7ca2ca8
[ 3801.836010] RBP: ffff8800aba8bdd8 R08: ffff8800d710a000 R09: ffff8800d84fb000
[ 3801.836010] R10: ffff8800d65ca000 R11: ffff8800a7d31000 R12: 0000000000000000
[ 3801.836010] R13: 0000000000000001 R14: ffff8800a981be00 R15: 0000000000000000
[ 3801.836010] FS:  0000000000000000(0000) GS:ffff88011bd00000(0000)
knlGS:0000000000000000
[ 3801.836010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3801.836010] CR2: 00000000000000b8 CR3: 00000000d70a5000 CR4: 00000000000407e0
[ 3801.836010] Stack:
[ 3801.836010]  ffff8800a981be00 0000000000000001 ffff8800aba8be08
ffffffff81054d9f
[ 3801.836010]  ffff88011b098158 ffff8800d7092d00 ffff8800a990cca8
ffff88011b098000
[ 3801.836010]  ffff8800aba8be58 ffffffff810551da 0000000000000003
00000001d7092d00
[ 3801.836010] Call Trace:
[ 3801.836010]  [<ffffffff81054d9f>] pwq_dec_nr_in_flight+0x45/0x8c
[ 3801.836010]  [<ffffffff810551da>] process_one_work+0x221/0x288
[ 3801.836010]  [<ffffffff81055712>] worker_thread+0x1ed/0x2c4
[ 3801.836010]  [<ffffffff81055525>] ? cancel_delayed_work_sync+0x15/0x15
[ 3801.836010]  [<ffffffff810595c0>] kthread+0xae/0xb6
[ 3801.836010]  [<ffffffff81059512>] ? __kthread_parkme+0x61/0x61
[ 3801.836010]  [<ffffffff813fb7ac>] ret_from_fork+0x7c/0xb0
[ 3801.836010]  [<ffffffff81059512>] ? __kthread_parkme+0x61/0x61
[ 3801.836010] Code: 08 48 89 c7 48 8d 41 f8 eb b9 5d c3 66 66 66 66
90 55 48 89 e5 41 54 53 48 89 fb e8 98 dd ff ff 48 89 df 49 89 c4 e8
09 ed ff ff <49> 8b 04 24 31 d2 48 89 df 48 8d 70 18 e8 75 ff ff ff 0f
ba 33
[ 3801.836010] RIP  [<ffffffff81054a8c>] pwq_activate_delayed_work+0x1f/0x3f
[ 3801.836010]  RSP <ffff8800aba8bdc8>
[ 3801.836010] CR2: 0000000000000000
[ 3801.836010] ---[ end trace 7453be02adc76e27 ]---
[ 3801.836010] Kernel panic - not syncing: Fatal exception
[ 3801.836010] Shutting down cpus with NMI
[ 3801.836010] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffff9fffffff)
[ 3801.836010] drm_kms_helper: panic occurred, switching back to text console

[ 8246.010992] p2p-wlan1-0: moving STA f6:b7:e2:38:83:f3 to state 4
[ 8250.896506] p2p-wlan1-0: deauthenticating from f6:b7:e2:38:83:f3 by
local choice (Reason: 3=DEAUTH_LEAVING)
[ 8250.906769] p2p-wlan1-0: moving STA f6:b7:e2:38:83:f3 to state 3
[ 8250.912793] p2p-wlan1-0: moving STA f6:b7:e2:38:83:f3 to state 2
[ 8250.918841] p2p-wlan1-0: moving STA f6:b7:e2:38:83:f3 to state 1
[ 8250.925242] p2p-wlan1-0: Removed STA f6:b7:e2:38:83:f3
[ 8250.930490] p2p-wlan1-0: Destroyed STA f6:b7:e2:38:83:f3
[ 8254.950040] wlan1: cancelling AP probe due to a received beacon
[ 8254.956426] p2p-wlan1-0: authenticate with f6:b7:e2:38:83:f3
[ 8254.962096] p2p-wlan1-0: Allocated STA f6:b7:e2:38:83:f3
[ 8255.024100] p2p-wlan1-0: Inserted STA f6:b7:e2:38:83:f3
[ 8255.029325] p2p-wlan1-0: send auth to f6:b7:e2:38:83:f3 (try 1/3)
[ 8255.820334] p2p-wlan1-0: send auth to f6:b7:e2:38:83:f3 (try 2/3)
[ 8256.820294] p2p-wlan1-0: send auth to f6:b7:e2:38:83:f3 (try 3/3)
[ 8257.808348] p2p-wlan1-0: authentication with f6:b7:e2:38:83:f3 timed out
[ 8257.832301] p2p-wlan1-0: Removed STA f6:b7:e2:38:83:f3
[ 8257.837569] p2p-wlan1-0: Destroyed STA f6:b7:e2:38:83:f3
[ 8260.992360] wlan1: cancelling AP probe due to a received beacon
[ 8260.998689] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[ 8261.002556] IP: [<ffffffff81054a8c>] pwq_activate_delayed_work+0x1f/0x3f
[ 8261.002556] PGD 0
[ 8261.002556] Oops: 0000 [#1] SMP
[ 8261.002556] Modules linked in: ath10k_pci(O) ath10k_core(O) ath
mac80211(O) cfg80211 dell_wmi sparse_keymap snd_hda_codec_hdmi
snd_hda_codec_idt snd_hda_codec_generic snd_hda_intel
snd_hda_controller snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
snd_pcm coretemp kvm_intel snd_seq_midi ecb snd_seq_midi_event
dell_laptop snd_rawmidi kvm microcode dcdbas i8k snd_seq joydev
snd_timer evdev serio_raw bnep snd_seq_device snd soundcore i915 ath3k
btusb lpc_ich mfd_core rfcomm drm_kms_helper ehci_pci bluetooth drm
ehci_hcd button i2c_algo_bit i2c_core wmi battery tpm_tis tpm video ac
acpi_cpufreq processor fuse parport_pc ppdev lp parport binfmt_misc
ext4 crc16 jbd2 mbcache e1000e sr_mod ptp sd_mod cdrom ata_generic
sdhci_pci sdhci firewire_ohci psmouse ata_piix libata mmc_core thermal
firewire_core crc_itu_t thermal_sys uhci_hcd usbcore usb_common
pps_core scsi_mod
[ 8261.002556] CPU: 0 PID: 5817 Comm: kworker/u4:2 Tainted: G        W
 O   3.19.0-rc5-2015-02-03-wl-ath-00109-g8e17d00-dirty #245
[ 8261.002556] Hardware name: Dell Inc. Latitude E4300
 /0D201R, BIOS A14 12/22/2009
[ 8261.002556] task: ffff8800d774b5b0 ti: ffff8801129f4000 task.ti:
ffff8801129f4000
[ 8261.002556] RIP: 0010:[<ffffffff81054a8c>]  [<ffffffff81054a8c>]
pwq_activate_delayed_work+0x1f/0x3f
[ 8261.002556] RSP: 0018:ffff8801129f7dc8  EFLAGS: 00010046
[ 8261.002556] RAX: 0000000000000000 RBX: ffff88010a4ceca8 RCX: 000000000000984f
[ 8261.002556] RDX: ffff8800d8afa260 RSI: 0000000000000001 RDI: ffff88010a4ceca8
[ 8261.002556] RBP: ffff8801129f7dd8 R08: 0000000000000018 R09: 0000000017f8ee3f
[ 8261.002556] R10: ffffffff81a0d1c0 R11: ffffffff81a0d5c0 R12: 0000000000000000
[ 8261.002556] R13: 0000000000000001 R14: ffff8800d8afa200 R15: 0000000000000000
[ 8261.002556] FS:  0000000000000000(0000) GS:ffff88011bc00000(0000)
knlGS:0000000000000000
[ 8261.002556] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8261.002556] CR2: 00000000000000b8 CR3: 0000000001a11000 CR4: 00000000000407f0
[ 8261.002556] Stack:
[ 8261.002556]  ffff8800d8afa200 0000000000000001 ffff8801129f7e08
ffffffff81054d9f
[ 8261.002556]  ffff88011b098158 ffff8800d6f5d1c0 ffff880066c58ca8
ffff88011b098000
[ 8261.002556]  ffff8801129f7e58 ffffffff810551da 0000000000000003
00000001d6f5d1c0
[ 8261.002556] Call Trace:
[ 8261.002556]  [<ffffffff81054d9f>] pwq_dec_nr_in_flight+0x45/0x8c
[ 8261.002556]  [<ffffffff810551da>] process_one_work+0x221/0x288
[ 8261.002556]  [<ffffffff81055712>] worker_thread+0x1ed/0x2c4
[ 8261.002556]  [<ffffffff81055525>] ? cancel_delayed_work_sync+0x15/0x15
[ 8261.002556]  [<ffffffff810595c0>] kthread+0xae/0xb6
[ 8261.002556]  [<ffffffff81059512>] ? __kthread_parkme+0x61/0x61
[ 8261.002556]  [<ffffffff813fb7ac>] ret_from_fork+0x7c/0xb0
[ 8261.002556]  [<ffffffff81059512>] ? __kthread_parkme+0x61/0x61
[ 8261.002556] Code: 08 48 89 c7 48 8d 41 f8 eb b9 5d c3 66 66 66 66
90 55 48 89 e5 41 54 53 48 89 fb e8 98 dd ff ff 48 89 df 49 89 c4 e8
09 ed ff ff <49> 8b 04 24 31 d2 48 89 df 48 8d 70 18 e8 75 ff ff ff 0f
ba 33
[ 8261.002556] RIP  [<ffffffff81054a8c>] pwq_activate_delayed_work+0x1f/0x3f
[ 8261.002556]  RSP <ffff8801129f7dc8>
[ 8261.002556] CR2: 0000000000000000
[ 8261.002556] ---[ end trace adb85aed42a63d55 ]---
[ 8261.002556] Kernel panic - not syncing: Fatal exception
[ 8261.002556] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffff9fffffff)
[ 8261.002556] drm_kms_helper: panic occurred, switching back to text console
