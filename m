Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41872 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbeFHKn0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jun 2018 06:43:26 -0400
Date: Fri, 8 Jun 2018 12:43:23 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Jakub Kicinski <kubakici@wp.pl>, linux-wireless@vger.kernel.org
Subject: WARNING: drivers/net/wireless/mediatek/mt7601u/phy.c:989
Message-ID: <20180608104323.vaw6vtbmxdut6yld@angband.pl> (sfid-20180608_124330_733976_F56990B7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!
In mid-merge-window kernel I'm getting this warning in mt7601.  My tree,
skipping certainly irrelevant extra patches, has merge-base with master at
289cf155d95df07ac1e692dfaa7036f10235c77c.

static void mt7601u_agc_tune(struct mt7601u_dev *dev)
{
        u8 val = mt7601u_agc_default(dev);
        long avg_rssi;

        if (test_bit(MT7601U_STATE_SCANNING, &dev->state))
                return;

        /* Note: only in STA mode and not dozing; perhaps do this only if
         *       there is enough rssi updates since last run?
         *       Rssi updates are only on beacons and U2M so should work...
         */
        spin_lock_bh(&dev->con_mon_lock);
        avg_rssi = ewma_rssi_read(&dev->avg_rssi);
====>   WARN_ON_ONCE(avg_rssi == 0);
        avg_rssi = -avg_rssi;


WARNING: CPU: 4 PID: 109 at drivers/net/wireless/mediatek/mt7601u/phy.c:989 mt7601u_phy_calibrate+0x58b/0xaa0 [mt7601u]
Modules linked in: arc4 mt7601u mac80211 sha256_generic snd_usb_audio snd_usbmidi_lib cfg80211 rfkill nouveau video ttm
CPU: 4 PID: 109 Comm: kworker/u12:7 Not tainted 4.17.0-debug-07836-ga3643eb8ca3a #1
Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
Workqueue: phy0 mt7601u_phy_calibrate [mt7601u]
RIP: 0010:mt7601u_phy_calibrate+0x58b/0xaa0 [mt7601u]
Code: be b2 00 00 00 48 89 ef 0f 84 da 00 00 00 e8 1c f2 ff
  ff 83 f8 01 19 c0 25 00 e0 ff ff 45 8d bc 07 66 46 00 00 e9 93 fc ff ff <0f>
  0b e9 ba fe ff ff 8b 83 f0 07 00 00 e9 5d fc ff ff c0 e8 04 4d
RSP: 0018:ffffc90001febe10 EFLAGS: 00010256
RAX: 0000000000000000 RBX: ffff8802200f95d0 RCX: ffff88022700c020
RDX: 0000000000000001 RSI: ffff88021ffac0b0 RDI: ffff8802200f9d20
RBP: ffff8802200f9500 R08: 8080808080808080 R09: fefefefefefefeff
R10: ffffffff8287baf0 R11: 000000000000001f R12: 0000000000000034
R13: ffff8802200f9d20 R14: ffff88021f80de00 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000563bf575c168 CR3: 00000002259ed000 CR4: 00000000000006e0
Call Trace:
 ? process_one_work+0x239/0x680
 ? pwq_activate_delayed_work+0x5c/0x100
 ? worker_thread+0x4a/0x4b0
 ? process_one_work+0x680/0x680
 ? kthread+0x16b/0x220
 ? kthread_create_worker_on_cpu+0x40/0x40
 ? ret_from_fork+0x22/0x40
---[ end trace e40c73f71a371719 ]---

As bisecting on real metal is more involved than a VM, I'm reporting first
-- in case you already have a fix pending.  If not, how may I help?  Bisect? 
Some extra debug data?  Or, would you prefer to wait until the merge window
is over?


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ I've read an article about how lively happy music boosts
⣾⠁⢰⠒⠀⣿⡁ productivity.  You can read it, too, you just need the
⢿⡄⠘⠷⠚⠋⠀ right music while doing so.  I recommend Skepticism
⠈⠳⣄⠀⠀⠀⠀ (funeral doom metal).
