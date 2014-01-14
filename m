Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55645 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaANIxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 03:53:07 -0500
Message-ID: <52D4FAED.1040603@lukas-wirz.de> (sfid-20140114_095312_348967_D9FF0DE7)
Date: Tue, 14 Jan 2014 21:53:01 +1300
From: Wirz <spam@lukas-wirz.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: kernel panic, probably due to wifi (mac80211/b43)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I'm experiencing frequent kernel panics which can be triggered by
sending the laptop to sleep and waking it up.

The wifi chip is a bcm4331, the driver should be b43, kernel version is
3.12.6, OS is Debian 7.3.

The extract from /var/log/messages is in the end of this email.

Is that something I'm doing wrong?  Can I provide any further
information to help fix this?

cheers, lukas




Jan 14 09:43:26 debianPro kernel: [10740.497028] PM: Syncing filesystems
... done.
Jan 14 09:43:26 debianPro kernel: [10740.499963] Freezing user space
processes ... (elapsed 0.000 seconds) done.
Jan 14 09:43:26 debianPro kernel: [10740.500869] Freezing remaining
freezable tasks ... (elapsed 0.000 seconds) done.
Jan 14 09:43:26 debianPro kernel: [10740.501887] Suspending console(s)
(use no_console_suspend to debug)
Jan 14 09:43:26 debianPro kernel: [10740.524120] wlan0: deauthenticating
from a4:b1:e9:00:14:5f by local choice (reason=3)
Jan 14 09:43:26 debianPro kernel: [10740.542248] sd 0:0:0:0: [sda]
Synchronizing SCSI cache
Jan 14 09:43:26 debianPro kernel: [10740.542299] sd 0:0:0:0: [sda]
Stopping disk
Jan 14 09:43:26 debianPro kernel: [10740.542404] cfg80211: Calling CRDA
to update world regulatory domain
Jan 14 09:43:26 debianPro kernel: [10740.576888] ------------[ cut here
]------------
Jan 14 09:43:26 debianPro kernel: [10740.576907] WARNING: CPU: 2 PID: 0
at net/mac80211/util.c:661 ieee80211_can_queue_work+0x37/0x3b [mac80211]()
Jan 14 09:43:26 debianPro kernel: [10740.576907] queueing ieee80211 work
while going to suspend
Jan 14 09:43:26 debianPro kernel: [10740.576932] Modules linked in: b43
hidp ppdev lp parport rfcomm bnep binfmt_misc nfsd auth_rpcgss
oid_registry exportfs nfs_acl nfs lockd sunrpc nls_utf8 hfsplus
nls_iso8859_1 nls_cp437 vfat fat sha256_generic dm_crypt firewire_sbp2
btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_cirrus hid_apple
bcm5974 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_dummy snd_page_alloc snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq arc4 snd_seq_device snd_timer snd
soundcore ssb mac80211 cfg80211 iTCO_wdt iTCO_vendor_support uvcvideo
fbcon bitblit softcursor videobuf2_vmalloc font applesmc
videobuf2_memops tileblit videobuf2_core input_polldev i915 videodev
intel_agp intel_gtt lpc_ich i2c_i801 bcma apple_gmux drm_kms_helper drm
i2c_algo_bit video apple_bl hid_generic usbhid hid firewire_ohci tg3 ptp
firewire_core sdhci_pci pps_core crc_itu_t sdhci led_class ahci libahci
xhci_hcd [last unloaded: b43]
Jan 14 09:43:26 debianPro kernel: [10740.576939] CPU: 2 PID: 0 Comm:
swapper/2 Tainted: G        W    3.12.6 #1
Jan 14 09:43:26 debianPro kernel: [10740.576940] Hardware name: Apple
Inc. MacBookPro9,2/Mac-6F01561E16C75D06, BIOS
MBP91.88Z.00D3.B08.1208081132 08/08/2012
Jan 14 09:43:26 debianPro kernel: [10740.576942]  0000000000000009
ffff88046f303d20 ffffffff814d2888 0000000000000000
Jan 14 09:43:26 debianPro kernel: [10740.576943]  ffff88046f303d70
ffff88046f303d60 ffffffff8103b288 ffff88046f312a40
Jan 14 09:43:26 debianPro kernel: [10740.576944]  ffffffffa02fd4cc
ffff88045c6305c0 ffff88045c631e58 0000000000000032
Jan 14 09:43:26 debianPro kernel: [10740.576945] Call Trace:
Jan 14 09:43:26 debianPro kernel: [10740.576950]  <IRQ>
[<ffffffff814d2888>] dump_stack+0x46/0x58
Jan 14 09:43:26 debianPro kernel: [10740.576953]  [<ffffffff8103b288>]
warn_slowpath_common+0x81/0x9b
Jan 14 09:43:26 debianPro kernel: [10740.576959]  [<ffffffffa02fd4cc>] ?
ieee80211_can_queue_work+0x37/0x3b [mac80211]
Jan 14 09:43:26 debianPro kernel: [10740.576961]  [<ffffffff8103b345>]
warn_slowpath_fmt+0x46/0x48
Jan 14 09:43:26 debianPro kernel: [10740.576966]  [<ffffffffa02fd4cc>]
ieee80211_can_queue_work+0x37/0x3b [mac80211]
Jan 14 09:43:26 debianPro kernel: [10740.576971]  [<ffffffffa02fd863>]
ieee80211_queue_work+0x17/0x34 [mac80211]
Jan 14 09:43:26 debianPro kernel: [10740.576974]  [<ffffffffa06f15e8>]
b43_led_brightness_set+0x2c/0x2e [b43]
Jan 14 09:43:26 debianPro kernel: [10740.576978]  [<ffffffffa00342cf>]
led_timer_function+0x8a/0xd4 [led_class]
Jan 14 09:43:26 debianPro kernel: [10740.576981]  [<ffffffffa0034245>] ?
led_classdev_unregister+0xa9/0xa9 [led_class]
Jan 14 09:43:26 debianPro kernel: [10740.576984]  [<ffffffff81045591>]
call_timer_fn+0x58/0x10b
Jan 14 09:43:26 debianPro kernel: [10740.576986]  [<ffffffffa0034245>] ?
led_classdev_unregister+0xa9/0xa9 [led_class]
Jan 14 09:43:26 debianPro kernel: [10740.576988]  [<ffffffff81045d1e>]
run_timer_softirq+0x1a2/0x1fd
Jan 14 09:43:26 debianPro kernel: [10740.576990]  [<ffffffff8107cf25>] ?
ktime_get+0x56/0xb7
Jan 14 09:43:26 debianPro kernel: [10740.576992]  [<ffffffff8103f255>]
__do_softirq+0xf1/0x206
Jan 14 09:43:26 debianPro kernel: [10740.576995]  [<ffffffff81083e90>] ?
tick_program_event+0x24/0x26
Jan 14 09:43:26 debianPro kernel: [10740.576998]  [<ffffffff814d971c>]
call_softirq+0x1c/0x30
Jan 14 09:43:26 debianPro kernel: [10740.576999]  [<ffffffff810042c8>]
do_softirq+0x37/0x6f
Jan 14 09:43:26 debianPro kernel: [10740.577001]  [<ffffffff8103f44a>]
irq_exit+0x43/0x88
Jan 14 09:43:26 debianPro kernel: [10740.577003]  [<ffffffff814d9e39>]
smp_apic_timer_interrupt+0x45/0x52
Jan 14 09:43:26 debianPro kernel: [10740.577005]  [<ffffffff814d8c4a>]
apic_timer_interrupt+0x6a/0x70
Jan 14 09:43:26 debianPro kernel: [10740.577008]  <EOI>
[<ffffffff813dbbd5>] ? cpuidle_enter_state+0x4e/0xb1
Jan 14 09:43:26 debianPro kernel: [10740.577009]  [<ffffffff813dbbce>] ?
cpuidle_enter_state+0x47/0xb1
Jan 14 09:43:26 debianPro kernel: [10740.577010]  [<ffffffff813dbd3b>]
cpuidle_idle_call+0x103/0x1b0
Jan 14 09:43:26 debianPro kernel: [10740.577012]  [<ffffffff8100a6fe>]
arch_cpu_idle+0xe/0x1d
Jan 14 09:43:26 debianPro kernel: [10740.577015]  [<ffffffff8107749c>]
cpu_startup_entry+0x16e/0x1fe
Jan 14 09:43:26 debianPro kernel: [10740.577018]  [<ffffffff81024e6b>]
start_secondary+0x1fa/0x201
Jan 14 09:43:26 debianPro kernel: [10740.577019] ---[ end trace
c5d82393efe44d27 ]---
Jan 14 09:43:26 debianPro kernel: [10741.975103] PM: suspend of devices
complete after 1449.335 msecs
Jan 14 09:43:26 debianPro kernel: [10741.975104] PM: suspend devices
took 1.471 seconds
Jan 14 09:43:26 debianPro kernel: [10741.975223] PM: late suspend of
devices complete after 0.116 msecs


- -- 
Do not believe the naysayers who say it cannot be done.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLU+usACgkQ1m2kmG8CIy2HkwCdEfIeh8LY8UlfY6ST8t22+5FM
R6EAoMJZofX+Q1AgAJqvALAnhKSOhiXs
=KSWU
-----END PGP SIGNATURE-----
