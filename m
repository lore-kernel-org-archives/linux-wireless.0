Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:58206 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449AbYJCBn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 21:43:26 -0400
Message-ID: <48E586B4.5010808@lwfinger.net> (sfid-20081003_034341_009333_E953FA1B)
Date: Thu, 02 Oct 2008 20:43:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@nokia.com>
Subject: Re: [RFC][PATCH] p54: fix memory management
References: <200810020359.40610.chunkeey@web.de>
In-Reply-To: <200810020359.40610.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> Well, since a lot of people have worked with the memory management of p54 driver
> (or similar projects ;-) ), it's probably the best to give this _urgent_ thing a RFC round.
> 
> The problem is that if multiple "control frames" are passed in a very short intervals to
> the device's firmware (e.g: QoS and frequency are the best candidates)
> the data might get corrupted. As p54_assign_address always put them into same 
> memory location and the device's firmware is too slow to pick the frames up,
> before they're overwritten again.
> 
> P.S: the code inside the #if 0 - #endif will go away in the final version,
> but for now its very useful for debugging. So don't complain about it ;-).

When the patch works, it seems to be OK; however, I got two oops and
one system lockup (caps lock blinking at a 1 Hz rate). The first one
is as follows:

Oct  2 17:22:52 larrylap kernel: BUG: unable to handle kernel NULL
pointer dereference at 0000000000000000
Oct  2 17:22:52 larrylap kernel: IP: [<ffffffffa024916e>]
p54_assign_address+0xff/0x162 [p54common]
Oct  2 17:22:52 larrylap kernel: PGD 0
Oct  2 17:22:52 larrylap kernel: Oops: 0000 [1] SMP
Oct  2 17:22:52 larrylap kernel: CPU 0
Oct  2 17:22:52 larrylap kernel: Modules linked in: snd_pcm_oss
snd_mixer_oss snd_seq snd_seq_device af_packet sunrpc rfkill_input
cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8
fuse loop dm_mod ide_cd_mod cdrom arc4 ecb crypto_blkcipher p54usb b43
snd_hda_intel rfkill amd74xx p54common snd_pcm led_class
ide_pci_generic mac80211 snd_timer k8temp input_polldev snd battery ac
button hwmon joydev ide_core forcedeth soundcore cfg80211 ssb
snd_page_alloc serio_raw sg sd_mod ehci_hcd ohci_hcd usbcore edd fan
thermal processor ext3 mbcache jbd ahci libata scsi_mod dock
Oct  2 17:22:52 larrylap kernel: Pid: 2021, comm: p54usb Tainted: G
M      2.6.27-rc8-wl #51
Oct  2 17:22:52 larrylap kernel: RIP: 0010:[<ffffffffa024916e>]
[<ffffffffa024916e>] p54_assign_address+0xff/0x162 [p54common]
Oct  2 17:22:52 larrylap kernel: RSP: 0018:ffff8800ba0ebd20  EFLAGS:
00010006
Oct  2 17:22:52 larrylap kernel: RAX: ffff8800ba0b04a0 RBX:
ffff8800ba0b1d00 RCX: 000000000000009c
Oct  2 17:22:52 larrylap kernel: RDX: ffff8800b9260f40 RSI:
0000000000000000 RDI: ffff8800b9260840
Oct  2 17:22:52 larrylap kernel: RBP: ffff8800ba0ebd70 R08:
0000000000000002 R09: ffffffffa02490d0
Oct  2 17:22:52 larrylap kernel: R10: ffff8800b9260f00 R11:
ffff8800a7de2480 R12: 00000000000000c0
Oct  2 17:22:52 larrylap kernel: R13: ffff8800b9260f00 R14:
0000000000024178 R15: ffff8800ba0b1d08
Oct  2 17:22:52 larrylap kernel: FS:  00007f9a5f2fe6f0(0000)
GS:ffffffff8069d680(0000) knlGS:00000000f7caf6c0
Oct  2 17:22:52 larrylap kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Oct  2 17:22:52 larrylap kernel: CR2: 0000000000000000 CR3:
00000000b9cdc000 CR4: 00000000000006e0
Oct  2 17:22:52 larrylap kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Oct  2 17:22:52 larrylap kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Oct  2 17:22:52 larrylap kernel: Process p54usb (pid: 2021, threadinfo
ffff8800ba0ea000, task ffff8800b8a4c790)
Oct  2 17:22:52 larrylap kernel: Stack:  ffff8800a7e69e10
ffff8800ba0b04a0 ffff8800ba0b1d20 0002020000000000
Oct  2 17:22:52 larrylap kernel:  0000000000000286 ffff8800b9260f00
ffff8800a7e69e10 ffff8800ba0b1d00
Oct  2 17:22:52 larrylap kernel:  ffff8800ba0b04a0 ffff8800ba0b04a0
ffff8800ba0ebdb0 ffffffffa02499fb
Oct  2 17:22:52 larrylap kernel: Call Trace:
Oct  2 17:22:52 larrylap kernel:  [<ffffffffa02499fb>]
p54_set_vdcf+0xe1/0x104 [p54common]
Oct  2 17:22:52 larrylap kernel:  [<ffffffffa024a0fb>]
p54_config+0x2b0/0x2ca [p54common]
Oct  2 17:22:52 larrylap kernel:  [<ffffffff802339a2>] ?
finish_task_switch+0x0/0xb9
Oct  2 17:22:52 larrylap kernel:  [<ffffffffa01f1055>]
ieee80211_hw_config+0x55/0x57 [mac80211]
Oct  2 17:22:52 larrylap kernel:  [<ffffffffa01f6de7>]
ieee80211_scan_work+0xd1/0x196 [mac80211]
Oct  2 17:22:52 larrylap kernel:  [<ffffffff802478ef>]
run_workqueue+0x103/0x20a
Oct  2 17:22:52 larrylap kernel:  [<ffffffff8024789d>] ?
run_workqueue+0xb1/0x20a
Oct  2 17:22:52 larrylap kernel:  [<ffffffffa01f6d16>] ?
ieee80211_scan_work+0x0/0x196 [mac80211]
Oct  2 17:22:52 larrylap kernel:  [<ffffffff80247ad6>]
worker_thread+0xe0/0xf1
Oct  2 17:22:52 larrylap kernel:  [<ffffffff8024b5e0>] ?
autoremove_wake_function+0x0/0x38
Oct  2 17:22:53 larrylap kernel:  [<ffffffff802479f6>] ?
worker_thread+0x0/0xf1
Oct  2 17:22:53 larrylap kernel:  [<ffffffff8024b284>] kthread+0x49/0x76
Oct  2 17:22:53 larrylap kernel:  [<ffffffff8020d099>] child_rip+0xa/0x11
Oct  2 17:22:53 larrylap kernel:  [<ffffffff80427834>] ?
_spin_unlock_irq+0x2b/0x30
Oct  2 17:22:53 larrylap kernel:  [<ffffffff8020c6cf>] ?
restore_args+0x0/0x30
Oct  2 17:22:53 larrylap kernel:  [<ffffffff8024b23b>] ? kthread+0x0/0x76
Oct  2 17:22:53 larrylap kernel:  [<ffffffff8020d08f>] ?
child_rip+0x0/0x11
Oct  2 17:22:53 larrylap kernel:
Oct  2 17:22:53 larrylap kernel:
Oct  2 17:22:53 larrylap kernel: Code: 8b 4b 04 44 29 f1 39 d1 0f 42
ca 4d 85 ed 74 54 8b 45 cc 49 8d 55 40 89 c9 41 89 45 40 44 01 e0 89
42 04 48 8b 45 b8 48 89 42 08 <48> 8b 06 49 89 75 08 49 89 45 00 4c 89
68 08 4c 89 2e 0f b7 53
Oct  2 17:22:53 larrylap kernel: RIP  [<ffffffffa024916e>]
p54_assign_address+0xff/0x162 [p54common]
Oct  2 17:22:53 larrylap kernel:  RSP <ffff8800ba0ebd20>
Oct  2 17:22:53 larrylap kernel: CR2: 0000000000000000
Oct  2 17:22:53 larrylap kernel: ---[ end trace 4bd18aa5f2aeb5d8 ]---

Note, the "tainted" flag is false. No closed-source drivers have been
loaded.

The oops occurs in the following inline routine:

static inline void __skb_queue_after(struct sk_buff_head *list,
                                     struct sk_buff *prev,
                                     struct sk_buff *newsk)
{
        __skb_insert(newsk, prev, prev->next, list);
}

and is called from p54_assign_addresses() in the following region:

       if (skb) {
                struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
                struct memrecord *range = (void *)info->driver_data;
                range->start_addr = target_addr;
                range->end_addr = target_addr + len;
                range->dev = dev;
                __skb_queue_after(&priv->tx_queue, target_skb, skb);
                if (largest_hole < priv->rx_mtu + priv->headroom +
                                   priv->tailroom +
                                   sizeof(struct p54_control_hdr))
                        ieee80211_stop_queues(dev);
        }

Larry

