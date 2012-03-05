Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rosa.fh-joanneum.at ([91.229.57.22]:56548 "EHLO
	rosa.fh-joanneum.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2CEV6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 16:58:03 -0500
Received: from CANTON.technikum.fh-joanneum.local (unknown [10.25.1.27])
	by rosa.fh-joanneum.at (Postfix) with ESMTPS id 27BAF40EB
	for <linux-wireless@vger.kernel.org>; Mon,  5 Mar 2012 22:50:14 +0100 (CET)
From: Gmeiner Maximilian <Maximilian.Gmeiner.sam04@fh-joanneum.at>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Compat-Wireless Kernel Bug Report
Date: Mon, 5 Mar 2012 21:50:13 +0000
Message-ID: <CDCF1538AB98AA4FBCA89C8D5750845F1A473A21@MALMO.technikum.fh-joanneum.local> (sfid-20120305_225807_880979_BDF90F2D)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After compiling from the bleeding-edge without any errors this is what I get in kern.log when doing modprobe ath9k:

Hardware:
02:00.0 Network controller: Atheros Communications Inc. AR9485 Wireless Network Adapter (rev 01)
	Subsystem: AzureWave Device 2086
	Kernel driver in use: ath9k
	Kernel modules: ath9

Kernel: 
3.3.0-030300rc6-generic (the same happens on 3.2 kernel

Distribution:
Ubuntu 12.04 Testing



Mar  5 21:21:31 karl kernel: [25063.046563] ath9k: Driver unloaded
Mar  5 21:21:32 karl kernel: [25063.557834] NET: Unregistered protocol family 31
Mar  5 21:22:14 karl kernel: [25105.553769] Compat-wireless backport release: compat-wireless-2012-02-28
Mar  5 21:22:14 karl kernel: [25105.553781] Backport based on linux-next.git next-20120302
Mar  5 21:22:14 karl kernel: [25105.553793] sys_init_module: 'compat'->init suspiciously returned 68, it should follow 0/-E convention
Mar  5 21:22:14 karl kernel: [25105.553799] sys_init_module: loading module anyway...
Mar  5 21:22:14 karl kernel: [25105.553811] Pid: 6188, comm: modprobe Tainted: G        WC O 3.3.0-030300rc6-generic #201203032235
Mar  5 21:22:14 karl kernel: [25105.553817] Call Trace:
Mar  5 21:22:14 karl kernel: [25105.553833]  [<ffffffff810b557b>] sys_init_module+0x21b/0x220
Mar  5 21:22:14 karl kernel: [25105.553844]  [<ffffffff816683e9>] system_call_fastpath+0x16/0x1b
Mar  5 21:22:14 karl kernel: [25105.553862] BUG: unable to handle kernel paging request at ffff8800df439014
Mar  5 21:22:14 karl kernel: [25105.560967] IP: [<ffffffff810b3138>] module_put+0x28/0x90
Mar  5 21:22:14 karl kernel: [25105.564465] PGD 1c06063 PUD 0 
Mar  5 21:22:14 karl kernel: [25105.567077] Oops: 0002 [#1] SMP 
Mar  5 21:22:14 karl kernel: [25105.569750] CPU 1 
Mar  5 21:22:14 karl kernel: [25105.569776] Modules linked in: compat(O) msr parport_pc ppdev snd_hda_codec_hdmi snd_hda_codec_realtek joydev rts5139(C) snd_hda_intel asus_nb_wmi snd_hda_codec asus_wmi sparse_keymap snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device arc4 psmouse serio_raw i915 snd drm_kms_helper mac_hid drm soundcore snd_page_alloc i2c_algo_bit video mei(C) wmi lp parport [last unloaded: bluetooth]
Mar  5 21:22:14 karl kernel: [25105.582988] 
Mar  5 21:22:14 karl kernel: [25105.586294] Pid: 6188, comm: modprobe Tainted: G        WC O 3.3.0-030300rc6-generic #201203032235 ASUSTeK Computer Inc. UX31E/UX31E
Mar  5 21:22:14 karl kernel: [25105.588207] RIP: 0010:[<ffffffff810b3138>]  [<ffffffff810b3138>] module_put+0x28/0x90
Mar  5 21:22:14 karl kernel: [25105.591281] RSP: 0018:ffff88000e6aff28  EFLAGS: 00010282
Mar  5 21:22:14 karl kernel: [25105.594775] RAX: ffffffffa001900c RBX: ffffffffa001b020 RCX: 0000000000000000
Mar  5 21:22:14 karl kernel: [25105.598230] RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffffffffa001b020
Mar  5 21:22:14 karl kernel: [25105.601637] RBP: ffff88000e6aff48 R08: 0000000000000000 R09: 0000000000000000
Mar  5 21:22:14 karl kernel: [25105.604235] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffffa001b020
Mar  5 21:22:14 karl kernel: [25105.607506] R13: 0000000000ad7530 R14: 0000000000000000 R15: 0000000000405d30
Mar  5 21:22:14 karl kernel: [25105.610716] FS:  00007f61c762a700(0000) GS:ffff88013f420000(0000) knlGS:0000000000000000
Mar  5 21:22:14 karl kernel: [25105.613961] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar  5 21:22:14 karl kernel: [25105.617146] CR2: ffff8800df439014 CR3: 00000001364f6000 CR4: 00000000000406e0
Mar  5 21:22:14 karl kernel: [25105.620365] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar  5 21:22:14 karl kernel: [25105.623530] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  5 21:22:14 karl kernel: [25105.626720] Process modprobe (pid: 6188, threadinfo ffff88000e6ae000, task ffff88000260c4d0)
Mar  5 21:22:14 karl kernel: [25105.629988] Stack:
Mar  5 21:22:14 karl kernel: [25105.629992]  ffff88000e6aff48 ffffffffa001b020 0000000000000044 0000000000ad7530
Mar  5 21:22:14 karl kernel: [25105.630000]  ffff88000e6aff78 ffffffff810b5486 0000000000405d30 0000000000ada220
Mar  5 21:22:14 karl kernel: [25105.630006]  0000000000000000 0000000000ad6080 0000000000ad7530 ffffffff816683e9
Mar  5 21:22:14 karl kernel: [25105.630013] Call Trace:
Mar  5 21:22:14 karl kernel: [25105.630025]  [<ffffffff810b5486>] sys_init_module+0x126/0x220
Mar  5 21:22:14 karl kernel: [25105.630034]  [<ffffffff816683e9>] system_call_fastpath+0x16/0x1b
Mar  5 21:22:14 karl kernel: [25105.630038] Code: 44 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 4c 89 6d f8 66 66 66 66 90 48 85 ff 49 89 fc 74 21 48 8b 87 48 02 00 00 <65> 48 ff 40 08 8b 05 a5 29 c1 00 4c 8b 6d 08 85 c0 75 15 41 83 
Mar  5 21:22:14 karl kernel: [25105.630089] RIP  [<ffffffff810b3138>] module_put+0x28/0x90
Mar  5 21:22:14 karl kernel: [25105.630096]  RSP <ffff88000e6aff28>
Mar  5 21:22:14 karl kernel: [25105.630099] CR2: ffff8800df439014
Mar  5 21:22:14 karl kernel: [25105.725381] ---[ end trace 5190b7aaf2d6bf84 ]---


FH JOANNEUM Gesellschaft mbH
Rechtsform/Legal form: GmbH
Firmenbuchgericht/Court of registry: Landesgericht für ZRS Graz
Firmenbuchnummer/Company registration: FN 125888 f
DVR: 0813559
UID-Nr.: ATU 42361001
