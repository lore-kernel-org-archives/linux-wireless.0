Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56039 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753668AbZJUTsS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 15:48:18 -0400
From: "Dominik D. Geyer" <dominik.geyer@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: WARNING: at net/mac80211/rx.c:2488 ath_rx_tasklet+0x4a5/0x5ee [ath9k]()
Date: Wed, 21 Oct 2009 21:48:07 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200910212148.07374.dominik.geyer@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just found this one in my logs. The system uses the bit older kernel 
2.6.30-gentoo-r3 (with gentoo patches - I don't think it has an effect on this).
The wireless card uses the ath9k driver.

Maybe this issue is already fixed in newer kernel versions. I'm going to fetch
2.6.32.

------------[ cut here ]------------
WARNING: at net/mac80211/rx.c:2488 ath_rx_tasklet+0x4a5/0x5ee [ath9k]()
Hardware name: CN400-8237
Modules linked in: snd_pcm_oss snd_mixer_oss dm_crypt dm_mod padlock_aes via_rng vfat fat pppoe pppox ppp_generic slhc bridge stp llc w83627hf hwmon_vid w83697hf_wdt snd_via82xx snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart ath9k snd_rawmidi snd led_class soundcore i2c_viapro via_rhine
Pid: 0, comm: swapper Not tainted 2.6.30-gentoo-r3-homeserver #8
Call Trace:
 [<c01191fb>] ? warn_slowpath_common+0x41/0x71
 [<c0119218>] ? warn_slowpath_common+0x5e/0x71
 [<c0119235>] ? warn_slowpath_null+0xa/0xc
 [<cf8ca4ba>] ? ath_rx_tasklet+0x4a5/0x5ee [ath9k]
 [<cf8c7b6f>] ? ath9k_tasklet+0x31/0x55 [ath9k]
 [<c011c833>] ? tasklet_action+0x3d/0x63
 [<c011c659>] ? __do_softirq+0x4c/0xb5
 [<c011c6e4>] ? do_softirq+0x22/0x26
 [<c011c8e1>] ? irq_exit+0x25/0x4e
 [<c0103fbf>] ? do_IRQ+0x53/0x64
 [<c0102d69>] ? common_interrupt+0x29/0x30
 [<c0107037>] ? default_idle+0x25/0x38
 [<c0101aa8>] ? cpu_idle+0x23/0x3c
 [<c04ba917>] ? start_kernel+0x23f/0x242
---[ end trace 52a130d663d9bfc8 ]---
