Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55474 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbZCPSaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 14:30:12 -0400
Date: Mon, 16 Mar 2009 20:29:53 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alina Friedrichsen <x-alina@gmx.net>, feldmann_markus@gmx.de,
	linux-wireless@vger.kernel.org, xose.vazquez@gmail.com
Subject: Re: zd1211rw panuc (was: well working usb wlan stick)
Message-ID: <20090316182953.GA19470@jm.kir.nu> (sfid-20090316_193016_816823_5F2D12E7)
References: <ee588a540903160324s59c83547jc7d2148642e00af4@mail.gmail.com> <20090316155152.276920@gmx.net> <ee588a540903160948u6b5c758ay5addec857b3cf913@mail.gmail.com> <20090316173301.92330@gmx.net> <1237225374.18086.1.camel@johannes.local> <20090316180310.206110@gmx.net> <1237227126.18086.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1237227126.18086.3.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2009 at 07:12:06PM +0100, Johannes Berg wrote:
> On Mon, 2009-03-16 at 19:03 +0100, Alina Friedrichsen wrote:

> > > Me too, were you ever able to capture it? It scrolls off my screen :(
> > 
> > Try "vga=9" as kernel command line option. On i386 and amd64 you
> > should get a bigger text resolution with it.
> 
> I already use vga=0x361 :)

Which is nothing compared to the buffer provided with netconsole.. ;-)

I would assume this skb_under_panic is the crash you are seeing. Though,
for some reason, I managed to get two interfaces (wlan2 and
wlan1_rename) when I first tried to reproduce the problem be ejecting
the device and then re-inserting it, so this could be something else,
too, or USB on that laptop does not always behave nicely.. ;-)

[  253.620359] usb 4-3: new high speed USB device using ehci_hcd and address 4
[  253.757698] usb 4-3: configuration #1 chosen from 1 choice
[  253.873681] usb 4-3: reset high speed USB device using ehci_hcd and address 4
[  254.036528] phy3: Selected rate control algorithm 'pid'
[  254.037063] zd1211rw 4-3:1.0: phy3
[  260.302033] usb 4-3: firmware: requesting zd1211/zd1211b_ub
[  260.317397] usb 4-3: firmware: requesting zd1211/zd1211b_uphr
[  260.371225] zd1211rw 4-3:1.0: firmware version 4725
[  260.411261] zd1211rw 4-3:1.0: zd1211b chip 0586:340f v4810 high 00-13-49 AL2230_RF pa0 g---S
[  260.438306] ADDRCONF(NETDEV_UP): wlan1_rename: link is not ready
[  278.345028] wlan1_rename: authenticate with AP 00:1a:9f:c9:60:96
[  278.349033] wlan1_rename: authenticated
[  278.349056] wlan1_rename: associate with AP 00:1a:9f:c9:60:96
[  278.357029] wlan1_rename: RX AssocResp from 00:1a:9f:c9:60:96 (capab=0x471 status=0 aid=1)
[  278.357029] wlan1_rename: associated
[  278.357029] phy3: Allocated STA 00:1a:9f:c9:60:96
[  278.357029] phy3: Inserted STA 00:1a:9f:c9:60:96
[  278.357029] wlan1_rename: switched to short barker preamble (BSSID=00:1a:9f:c9:60:96)
[  278.357029] wlan1_rename: switched to short slot time (BSSID=00:1a:9f:c9:60:96)
[  278.392780] ADDRCONF(NETDEV_CHANGE): wlan1_rename: link becomes ready
[  286.660675] usb 4-3: USB disconnect, address 4
[  286.682479] wlan1_rename: deauthenticating by local choice (reason=3)
[  286.683540] skb_under_panic: text:ffffffffa03936da len:59 put:11 head:ffff88012cf59400 data:ffff88012cf593fa tail:0x35 end:0x80 dev:wmaster2
[  286.683672] ------------[ cut here ]------------
[  286.683709] kernel BUG at net/core/skbuff.c:143!
[  286.683744] invalid opcode: 0000 [#1] SMP 
[  286.683829] last sysfs file: /sys/class/power_supply/BAT0/charge_full
[  286.683867] CPU 1 
[  286.683915] Modules linked in: aes_x86_64 aes_generic zd1211rw netconsole configfs af_packet ipv6 powernow_k8 cpufreq_powersave cpufreq_conservative cpufreq_ondemand freq_table cpufreq_userspace sbs sbshc fan container iptable_filter ip_tables x_tables sbp2 fuse dvb_usb_af9015 tda18271 af9013 dvb_pll snd_hda_codec_atihdmi mt2060 mxl5005s dvb_usb dvb_core qt1010 snd_hda_codec_idt arc4 snd_hda_intel ecb snd_hda_codec snd_pcm_oss snd_mixer_oss snd_seq_midi ath9k snd_pcm snd_rawmidi snd_seq_midi_event mac80211 snd_seq snd_timer snd_seq_device rfkill ohci1394 snd cfg80211 i2c_piix4 ehci_hcd sr_mod ohci_hcd ieee1394 r8169 mii soundcore led_class thermal pcspkr psmouse atiixp i2c_core cdrom sg usbcore snd_page_alloc video output rtc_cmos battery button ac processor thermal_sys shpchp pci_hotplug evdev
[  286.685066] Pid: 2133, comm: khubd Not tainted 2.6.29-rc7-wl #1 HP Pavilion dv5 Notebook PC
[  286.685066] RIP: 0010:[<ffffffff8043a3fa>]  [<ffffffff8043a3fa>] skb_push+0x7a/0x80
[  286.685066] RSP: 0018:ffff88013b1f9800  EFLAGS: 00010286
[  286.685066] RAX: 0000000000000093 RBX: ffff880123407600 RCX: 0000000000000001
[  286.685066] RDX: ffff8800a79a7000 RSI: 0000000000000001 RDI: ffffffff804cf808
[  286.685066] RBP: ffff88013b1f9820 R08: 0000000000000002 R09: 0000000000000001
[  286.685066] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000034
[  286.685066] R13: ffff880123407600 R14: ffff880123407638 R15: ffff880135ed1760
[  286.685066] FS:  00007fc515e73770(0000) GS:ffff88013f802a00(0000) knlGS:0000000000000000
[  286.685066] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  286.685066] CR2: 00007fc514ea8098 CR3: 000000013e834000 CR4: 00000000000006e0
[  286.685066] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  286.685066] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  286.685066] Process khubd (pid: 2133, threadinfo ffff88013b1f8000, task ffff88013b1ebb00)
[  286.685066] Stack:
[  286.685066]  0000000000000035 0000000000000080 ffff880123520000 ffff880135ed1760
[  286.685066]  ffff88013b1f9870 ffffffffa03936da ffff88013b1f9860 ffff880135ed0460
[  286.685066]  ffff88012cf59405 ffff880123407600 ffff880135ed0460 ffff88013b1f98d0
[  286.685066] Call Trace:
[  286.685066]  [<ffffffffa03936da>] zd_op_tx+0x4a/0x1f0 [zd1211rw]
[  286.685066]  [<ffffffffa01c4abd>] __ieee80211_tx+0x4d/0x140 [mac80211]
[  286.685066]  [<ffffffffa01c5c0f>] ieee80211_master_start_xmit+0x2ff/0x6d0 [mac80211]
[  286.685066]  [<ffffffffa01c5b97>] ?  ieee80211_master_start_xmit+0x287/0x6d0 [mac80211]
[  286.685392]  [<ffffffff80443a65>] dev_hard_start_xmit+0x285/0x300
[  286.685392]  [<ffffffff804577f6>] __qdisc_run+0x236/0x280
[  286.685392]  [<ffffffff80443f18>] dev_queue_xmit+0x308/0x620
[  286.685392]  [<ffffffff80443c62>] ? dev_queue_xmit+0x52/0x620
[  286.685392]  [<ffffffffa01c7a11>] ieee80211_tx_skb+0x61/0x70 [mac80211]
[  286.685392]  [<ffffffffa01b662f>] ieee80211_send_deauth_disassoc+0x12f/0x170 [mac80211]
[  286.685392]  [<ffffffffa01b6b7f>] ieee80211_set_disassoc+0x21f/0x2f0 [mac80211]
[  286.685392]  [<ffffffffa01b6960>] ? ieee80211_set_disassoc+0x0/0x2f0 [mac80211]
[  286.685392]  [<ffffffffa01b351d>] ?  __ieee80211_stop_tx_ba_session+0x4d/0xa0 [mac80211]
[  286.685392]  [<ffffffffa01b6d1d>] ieee80211_sta_deauthenticate+0x5d/0x70 [mac80211]
[  286.685392]  [<ffffffffa01ba57c>] ieee80211_stop+0x37c/0x630 [mac80211]
[  286.685392]  [<ffffffffa01ba279>] ? ieee80211_stop+0x79/0x630 [mac80211]
[  286.685392]  [<ffffffff804cf75f>] ? _spin_unlock_bh+0x2f/0x40
[  286.685392]  [<ffffffff8045711f>] ? dev_deactivate+0x18f/0x1d0
[  286.685392]  [<ffffffff8045713a>] ? dev_deactivate+0x1aa/0x1d0
[  286.685392]  [<ffffffff80444ae4>] dev_close+0x74/0xc0
[  286.685392]  [<ffffffff80444b75>] rollback_registered+0x45/0x250
[  286.685392]  [<ffffffff80444d9d>] unregister_netdevice+0x1d/0x70
[  286.685392]  [<ffffffffa01b9c9e>] ieee80211_remove_interfaces+0x7e/0xc0 [mac80211]
[  286.685392]  [<ffffffffa01ac0c1>] ieee80211_unregister_hw+0x31/0xf0 [mac80211]
[  286.685392]  [<ffffffffa0396e50>] disconnect+0x30/0x80 [zd1211rw]
[  286.685392]  [<ffffffffa0084155>] usb_unbind_interface+0x65/0x170 [usbcore]
[  286.685392]  [<ffffffff803d96c8>] __device_release_driver+0x78/0xc0
[  286.685392]  [<ffffffff803d980b>] device_release_driver+0x2b/0x40
[  286.685392]  [<ffffffff803d8b3d>] bus_remove_device+0xbd/0x100
[  286.685392]  [<ffffffff803d6ec0>] device_del+0x130/0x190
[  286.685392]  [<ffffffffa0080e18>] usb_disable_device+0xa8/0x130 [usbcore]
[  286.685392]  [<ffffffffa007b9b3>] usb_disconnect+0xb3/0x130 [usbcore]
[  286.685392]  [<ffffffffa007c92f>] hub_thread+0x4cf/0x13d0 [usbcore]
[  286.685392]  [<ffffffff80264bed>] ? trace_hardirqs_on+0xd/0x10
[  286.685392]  [<ffffffff80254dd0>] ? autoremove_wake_function+0x0/0x40
[  286.685392]  [<ffffffffa007c460>] ? hub_thread+0x0/0x13d0 [usbcore]
[  286.685392]  [<ffffffff80254a29>] kthread+0x49/0x80
[  286.685392]  [<ffffffff8020cafa>] child_rip+0xa/0x20
[  286.685392]  [<ffffffff8020c4fc>] ? restore_args+0x0/0x30
[  286.685392]  [<ffffffff802549e0>] ? kthread+0x0/0x80
[  286.685392]  [<ffffffff8020caf0>] ? child_rip+0x0/0x20
[  286.685392] Code: 8b 57 68 48 89 44 24 10 8b 87 c8 00 00 00 48 89 44 24 08 8b bf c4 00 00 00 31 c0 48 89 3c 24 48 c7 c7 c8 e4 5d 80 e8 7a 1c 09 00 <0f> 0b eb fe 66 90 55 89 f1 48 89 e5 48 83 ec 20 44 8b 4f 6c 4c 
[  286.685392] RIP  [<ffffffff8043a3fa>] skb_push+0x7a/0x80
[  286.685392]  RSP <ffff88013b1f9800>
[  286.688534] ---[ end trace c004fb5735d74053 ]---
[  286.688569] Kernel panic - not syncing: Fatal exception in interrupt

-- 
Jouni Malinen                                            PGP id EFC895FA
