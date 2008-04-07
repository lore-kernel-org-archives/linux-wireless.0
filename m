Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:19560 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYDGU2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 16:28:12 -0400
Received: by mu-out-0910.google.com with SMTP id i10so2327338mue.5
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2008 13:28:09 -0700 (PDT)
Message-ID: <47FA83D3.4030203@gmail.com> (sfid-20080407_212817_701569_F8816B15)
Date: Mon, 07 Apr 2008 22:28:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: ath5k-devel@lists.ath5k.org
Subject: WARNING: at ieee80211_rate.h:155
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I got this. Maybe it's an ath5k bug, just in case you saw it already, don't you 
know what could be wrong here?

rate_control_pid_rate_init: 0 2462
PUJ: 0 12 00000000
------------[ cut here ]------------
WARNING: at /home/l/latest/xxx/net/mac80211/ieee80211_rate.h:155 
rate_control_pid_rate_init+0x90/0xc0 [mac80211]()
Modules linked in: ath5k mac80211 nls_cp437 vfat fat usb_storage tun bitrev ipv6 
test arc4 ecb crypto_blkcipher cryptomgr crypto_algapi usbhid crc32 sr_mod hid 
rtc_cmos cfg80211 ohci1394 rtc_core floppy ieee1394 ehci_hcd ff_memless cdrom 
rtc_lib [last unloaded: mac80211]
Pid: 0, comm: swapper Not tainted 2.6.25-rc8-mm1_64lock #6

Call Trace:
  <IRQ>  [<ffffffff8022fdef>] warn_on_slowpath+0x5f/0x80
  [<ffffffff80230ff7>] ? printk+0x67/0x70
  [<ffffffff80328108>] ? __spin_lock_init+0x38/0x70
  [<ffffffffa0090c9b>] ? :mac80211:sta_info_alloc+0x1ab/0x210
  [<ffffffffa00a2c50>] :mac80211:rate_control_pid_rate_init+0x90/0xc0
  [<ffffffffa0093023>] :mac80211:ieee80211_ibss_add_sta+0xe3/0x140
  [<ffffffff80228698>] ? try_to_wake_up+0x88/0x130
  [<ffffffffa009ceb0>] :mac80211:__ieee80211_rx_handle_packet+0x420/0x800
  [<ffffffffa009f106>] ? :mac80211:__ieee80211_rx+0x76/0x5c0
  [<ffffffffa009f106>] ? :mac80211:__ieee80211_rx+0x76/0x5c0
  [<ffffffffa009f372>] :mac80211:__ieee80211_rx+0x2e2/0x5c0
  [<ffffffffa0146a15>] :ath5k:ath5k_tasklet_rx+0x105/0x5f0
  [<ffffffff80236077>] tasklet_action+0x67/0xf0
  [<ffffffff80235f04>] __do_softirq+0x84/0x110
  [<ffffffff8020c8cc>] call_softirq+0x1c/0x30
  [<ffffffff8020e5f5>] do_softirq+0x65/0xa0
  [<ffffffff80235e75>] irq_exit+0x95/0xa0
  [<ffffffff8020e6e9>] do_IRQ+0x89/0x100
  [<ffffffff8020a420>] ? default_idle+0x0/0x80
  [<ffffffff8020bbc6>] ret_from_intr+0x0/0xf
  <EOI>  [<ffffffff8020a463>] ? default_idle+0x43/0x80
  [<ffffffff8020a461>] ? default_idle+0x41/0x80
  [<ffffffff8020a420>] ? default_idle+0x0/0x80
  [<ffffffff8020a4e7>] ? cpu_idle+0x47/0xd0
  [<ffffffff804da4ce>] ? start_secondary+0x2fe/0x430

---[ end trace 9dbdd8f4f112ff0b ]---
wlan0: Trigger new scan to find an IBSS to join
wlan0: Trigger new scan to find an IBSS to join
wlan0: no IPv6 routers present
wlan0: Trigger new scan to find an IBSS to join
wlan0: Creating new IBSS network, BSSID f6:ae:b9:e2:70:1f
phy1: Removed STA
...
wlan0: Configured IBSS beacon template
ieee80211_sta_join_ibss: 00000fff rates

It's
printk(KERN_DEBUG "PUJ: %u %u %.8llx\n", sband->band, sband->n_bitrates,
                      sta->supp_rates[sband->band]);
right before the WARN_ON. And this
printk(KERN_DEBUG "%s: %u %u\n", __func__, local->hw.conf.channel->band,
                      local->hw.conf.channel->center_freq);
in rate_control_pid_rate_init.

00000fff means which rates were set to
ifsta->supp_rates_bits[local->hw.conf.channel->band]
The problem here is that it is after receiving a frame which caused the warning.

Thanks.
