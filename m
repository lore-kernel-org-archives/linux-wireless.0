Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65019 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab0HEWba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 18:31:30 -0400
Received: by iwn33 with SMTP id 33so549628iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 15:31:26 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 5 Aug 2010 15:31:06 -0700
Message-ID: <AANLkTinwbLXVHmC9eUczoe-ntT=adyFFx6C6Q=GcBc79@mail.gmail.com>
Subject: Odd BUG on wireless-testing master-2010-08-05
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just ran into this. My first load of master-2010-08-05 was fine but
I started getting a lot of disconnects on AR9003 hardware after a
period of RX'ing data over an encrypted legacy network. Instead of
checking dmesg I just rebooted though. After that I connected to the
same AP again, started Rx'ing for a while and then shortly got this:


[  818.749585] BUG: unable to handle kernel paging request at 00003f3f00000000
[  818.749594] IP: [<ffffffff814ee0d8>] unix_stream_recvmsg+0x3f8/0x790
[  818.749604] PGD 0
[  818.749607] Oops: 0002 [#1] SMP
[  818.749611] last sysfs file:
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/voltage_now
[  818.749615] CPU 1
[  818.749617] Modules linked in: aes_generic snd_hda_codec_analog
rfcomm sco binfmt_misc bridge ppdev stp bnep l2cap joydev arc4 ath9k
mac80211 snd_hda_intel snd_hda_codec snd_hwdep thinkpad_acpi snd_pcm
i915 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq btusb
bluetooth pcmcia snd_timer ath9k_common snd_seq_device ath9k_hw ath
drm_kms_helper cfg80211 tpm_tis drm snd tpm tpm_bios nvram
yenta_socket psmouse pcmcia_rsrc serio_raw pcmcia_core led_class
soundcore snd_page_alloc i2c_algo_bit video intel_agp output lp
parport ohci1394 ieee1394 e1000e ahci libahci
[  818.749668]
[  818.749671] Pid: 785, comm: NetworkManager Not tainted 2.6.35-wl+
#229 7660A14/7660A14
[  818.749674] RIP: 0010:[<ffffffff814ee0d8>]  [<ffffffff814ee0d8>]
unix_stream_recvmsg+0x3f8/0x790
[  818.749679] RSP: 0018:ffff880079f01bc8  EFLAGS: 00010206
[  818.749682] RAX: ffff880079f01c98 RBX: ffff88007aed98a0 RCX: 0000000000000000
[  818.749685] RDX: ffff880079f01d28 RSI: 0000000000000080 RDI: 00003f3f00000000
[  818.749688] RBP: ffff880079f01d08 R08: 0000000000000000 R09: 0000000000000000
[  818.749691] R10: 0000000000000001 R11: 0000000000000293 R12: ffff88007aed9878
[  818.749693] R13: ffff880079f01d60 R14: 0000000000000000 R15: 0000000000000000
[  818.749697] FS:  00007f048c3777e0(0000) GS:ffff880001f00000(0000)
knlGS:0000000000000000
[  818.749700] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  818.749703] CR2: 00003f3f00000000 CR3: 000000007ae29000 CR4: 00000000000006e0
[  818.749706] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  818.749708] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  818.749712] Process NetworkManager (pid: 785, threadinfo
ffff880079f00000, task ffff880079b85b40)
[  818.749714] Stack:
[  818.749716]  000000c900000000 ffff880079f01b88 ffffffff00000040
ffff88007ad9043c
[  818.749721] <0> ffff880079b85b40 ffff880079b85b40 ffff880079f01c80
ffff88007ad90300
[  818.749725] <0> ffff880079b85b40 ffff88007ad90560 0000000100000000
dead0000ffffffa1
[  818.749731] Call Trace:

[  818.749738]  [<ffffffff8115c010>] ? pollwake+0x0/0x60
[  818.749744]  [<ffffffff8146193e>] sock_aio_read+0x17e/0x190
[  818.749748]  [<ffffffff8114a3fa>] do_sync_read+0xda/0x120
[  818.749754]  [<ffffffff8104e711>] ? finish_task_switch+0x51/0xc0
[  818.749760]  [<ffffffff812551a6>] ? security_file_permission+0x16/0x20
[  818.749764]  [<ffffffff8114ad41>] vfs_read+0x181/0x1a0
[  818.749767]  [<ffffffff8114adb1>] sys_read+0x51/0x80
[  818.749771]  [<ffffffff8115c96c>] ? sys_poll+0x7c/0x110
[  818.749776]  [<ffffffff8100a032>] system_call_fastpath+0x16/0x1b
[  818.749778] Code: ff ff 89 bd 54 ff ff ff e9 76 fc ff ff 49 8b 7c
24 28 48 8b 95 40 ff ff ff 49 8d 5c 24 28 48 8b 73 08 48 85 ff 48 8b
42 28 74 03 <f0> ff 07 48 89 38 f0 ff 06 48 8d 50 18 48 89 70 08 e8 32
72 f7
[  818.749819] RIP  [<ffffffff814ee0d8>] unix_stream_recvmsg+0x3f8/0x790
[  818.749824]  RSP <ffff880079f01bc8>
[  818.749825] CR2: 00003f3f00000000
[  818.749866] ---[ end trace 3adfb3cee65b74df ]---

After a reboot I got a hard hang which I could not capture any logs
for. I rebooted and am up now but not seeing these issues yet. John,
does this smell like what you were seeing or is this different?

  Luis
