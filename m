Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.177]:14091 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYIOVuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 17:50:18 -0400
Received: by ik-out-1112.google.com with SMTP id c30so2101140ika.5
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 14:50:16 -0700 (PDT)
Message-ID: <f488382f0809151450u2f5501cbt14ef9f4ce19a9eb3@mail.gmail.com> (sfid-20080915_235022_203106_F18976FF)
Date: Mon, 15 Sep 2008 14:50:16 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: ath9k-devel@lists.ath9k.org,
	wireless <linux-wireless@vger.kernel.org>, jmalinen@atheros.com,
	lrodriguez@atheros.com
Subject: Fwd: frustrating ath9k issues
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I sent this message to the linux-kernel list 3 days ago and then
realized I'd probably get more replies if I'd actually sent it to the
right people. I've updated this message with anything that's changed
since I sent it, and -hopefully- I'm sending to all the right people.

And before I go on, I want to say that I -much- appreciate the
development of this driver. Being forced to use ndiswrapper on a
32-bit Linux install was getting on my nerves!



I'm having some problems with ath9k in the 2.6.27-rc6 kernel, -tip
kernel, etc (all the latest code). First of all, it incorrectly
reports the connection bitrate as 1 megabit per second, which is more
of a cosmetic issue:

wlan0     IEEE 802.11abgn  ESSID:"Introversion"
         Mode:Managed  Frequency:2.437 GHz  Access Point: 00:1E:52:79:4D:01
         Bit Rate=1 Mb/s   Tx-Power=23 dBm
         Retry min limit:7   RTS thr:off   Fragment thr=2352 B
         Encryption key: [snip]   Security mode:open
         Power Management:off
         Link Quality=67/100  Signal level:-52 dBm  Noise level=-95 dBm
         Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
         Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Second, it frequently drops the connection (could it possibly be
related to the message 'wlan0 (WE) : Wireless Event too big (320)'?).
One time, the connection dropped and I couldn't get it to reassociate,
and the dmesg showed the following:

[53963.201797] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[53964.809889] wlan0: authenticate with AP 00:1e:52:79:4d:01
[53964.811598] wlan0: authenticated
[53964.811742] wlan0: associate with AP 00:1e:52:79:4d:01
[53965.011340] wlan0: associate with AP 00:1e:52:79:4d:01
[53965.211343] wlan0: associate with AP 00:1e:52:79:4d:01
[53965.411345] wlan0: association with AP 00:1e:52:79:4d:01 timed out
[53976.532464] wlan0: authenticate with AP 00:1e:52:79:4d:01
[53976.542516] wlan0: authenticate with AP 00:1e:52:79:4d:01
[53976.751331] wlan0: authenticate with AP 00:1e:52:79:4d:01
[53976.752757] wlan0: authenticated
[53976.752762] wlan0: associate with AP 00:1e:52:79:4d:01
[53976.760374] wlan0: RX AssocResp from 00:1e:52:79:4d:01 (capab=0x431
status=0 aid=1)
[53976.760380] wlan0: associated
[53976.760721] wlan0 (WE) : Wireless Event too big (320)
[53976.772243] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

Despite -saying- it associated, I couldn't get 'route' to print a
table (it just decided to hang), and I couldn't get an IP address.

So I figured I'd try unloading and reloading the ath9k module. This
was the result:

[53997.493777] ath9k: driver unloaded
[54001.098532] ath9k: 0.1
[54001.098833] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[54001.099013] ath9k 0000:03:00.0: setting latency timer to 64
[54001.233825] phy1: Selected rate control algorithm 'ath9k_rate_control'
[54001.236980] phy1: Atheros 5416: mem=0xffffc20000060000, irq=17
[54002.136218] irq 17: nobody cared (try booting with the "irqpoll" option)
[54002.136229] Pid: 0, comm: swapper Tainted: P
2.6.27-rc6-00036-ga551b98 #2
[54002.136234]
[54002.136235] Call Trace:
[54002.136241]  <IRQ>  [<ffffffff80265231>] __report_bad_irq+0x3d/0x81
[54002.136258]  [<ffffffff80265477>] note_interrupt+0x202/0x267
[54002.136265]  [<ffffffff80265bfc>] handle_fasteoi_irq+0xba/0xe4
[54002.136273]  [<ffffffff8020e7ff>] do_IRQ+0x115/0x191
[54002.136279]  [<ffffffff8020bc01>] ret_from_intr+0x0/0xa
[54002.136283]  <EOI>  [<ffffffff802541bb>] ?
tick_nohz_stop_sched_tick+0x2c5/0x2d4
[54002.136296]  [<ffffffff8020a69f>] ? cpu_idle+0x2d/0xed
[54002.136304]  [<ffffffff8060d741>] ? rest_init+0x75/0x77
[54002.136309]
[54002.136312] handlers:
[54002.136315] [<ffffffffa0209016>] (ath_isr+0x0/0x160 [ath9k])
[54002.136340] Disabling IRQ #17

I could unload and reload the driver multiple times but got the same
IRQ issue at that point. As a result of the 'nobody cared', I'm now
using irqpoll at boot. Not sure what sort of impact this has had on
anything, except I haven't seen a single 'nobody cared' in my dmesg
since.

More recently, I had another incident where it disassociated and
refused to reassociate. I got about 100 of these in my dmesg (fixed by
unloading and reloading ath9k):

[...]
[ 1279.031033] ath_set_channel: unable to reset channel 149 (5745Mhz)
flags 0x30142 hal status 4294967277
[ 1279.031203] ath9k_config: Unable to set channel
[ 1279.323427] ath_set_channel: unable to reset channel 153 (5765Mhz)
flags 0x50142 hal status 4294967277
[ 1279.323577] ath9k_config: Unable to set channel
[ 1279.624562] ath_set_channel: unable to reset channel 157 (5785Mhz)
flags 0x30142 hal status 4294967277
[ 1279.624687] ath9k_config: Unable to set channel
[ 1279.916441] ath_set_channel: unable to reset channel 161 (5805Mhz)
flags 0x50142 hal status 4294967277
[ 1279.916586] ath9k_config: Unable to set channel
[ 1280.207274] ath_set_channel: unable to reset channel 165 (5825Mhz)
flags 0x10142 hal status 4294967277
[ 1280.207387] ath9k_config: Unable to set channel
[...]

And finally, I'm most certainly not getting 802.11n connection speeds
with this driver. The connection speed seems to be about equivalent to
802.11g (54mb/s), but I can't tell for certain with the messed up
bitrate reporting from iwconfig.
