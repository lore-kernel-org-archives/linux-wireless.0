Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35146 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab0LFTr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 14:47:59 -0500
Message-ID: <4CFD3DE3.4000207@candelatech.com>
Date: Mon, 06 Dec 2010 11:47:47 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: Felix Fietkau <nbd@openwrt.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Script to crash ath9k with DMA errors.
References: <4CF44543.9070605@candelatech.com> <20101130004424.GC1901@tux> <4CF6D8C8.2000308@candelatech.com> <4CF8A6DE.4020804@candelatech.com> <4CFAFBE1.3080505@openwrt.org> <4CFB20BA.5090300@candelatech.com> <20101206193600.GC21442@tux>
In-Reply-To: <20101206193600.GC21442@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2010 11:36 AM, Luis R. Rodriguez wrote:

> Can you clarify the status of this issue. It remains unclear to me from
> your above description how things are going. As I read it some things
> look OK now but you still get a warning.

Ok, since you asked :)

I worked on this over the weekend and this morning.  I had all sorts of
issues until I realized that I had one STA with non-configured SSID.
It sometimes connected to one /a AP and the other STAs attempted to connect
to another /n (on entirely different band) AP.  I basically got zero stations associated for any length
of time due to constant channel switching.  No crashes, but lots of
warnings about DMA failing to stop.

Now..I've fixed this configuration issue (and adding steps to help prevent this mis-configuration
again).

With 16 properly configured non-encrypted stations, running with wpa-supplicant
with netlink driver & sharing scan results,  the interfaces quickly associate.

However, I do continue to see DMA warnings such as these (I had picked up my
portable phone, and it knocked all the interfaces offline ..here
they are coming back up after I hung up the phone).

Please note that I ported Felix's 2.6.37 patch he posted this morning
to wireless-testing and have applied it.

I'm highly tempted to just make that a WARN_ON_ONCE so at least my logs
aren't spammed so heavily with the recv.c:531 DMA warning.

Dec  6 11:32:15 atom kernel: sta2: direct probe to 00:18:e7:cb:ad:6e timed out
Dec  6 11:32:15 atom kernel: sta14: direct probe to 00:18:e7:cb:ad:6e timed out
Dec  6 11:32:15 atom kernel: ieee80211 wiphy0: device now idle
Dec  6 11:32:15 atom kernel: ieee80211 wiphy0: device no longer idle - scanning
Dec  6 11:32:15 atom kernel: start_sw_scan: running-other-vifs: 0  running-station-vifs: 16, associated-stations: 0 scanning all channels.
Dec  6 11:32:17 atom kernel: ieee80211 wiphy0: device now idle
Dec  6 11:32:22 atom kernel: ieee80211 wiphy0: device no longer idle - scanning
Dec  6 11:32:22 atom kernel: start_sw_scan: running-other-vifs: 0  running-station-vifs: 16, associated-stations: 0 scanning all channels.
Dec  6 11:32:24 atom kernel: ieee80211 wiphy0: device now idle
Dec  6 11:32:29 atom kernel: ieee80211 wiphy0: device no longer idle - scanning
Dec  6 11:32:29 atom kernel: start_sw_scan: running-other-vifs: 0  running-station-vifs: 16, associated-stations: 0 scanning all channels.
Dec  6 11:32:29 atom kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Dec  6 11:32:29 atom kernel: ------------[ cut here ]------------
Dec  6 11:32:29 atom kernel: WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/recv.c:531 ath_stoprecv+0x90/0x9a [ath9)
Dec  6 11:32:29 atom kernel: Hardware name: 945GM
Dec  6 11:32:29 atom kernel: Could not stop RX, we could be confusing the DMA engine when we start RX up
Dec  6 11:32:29 atom kernel: Modules linked in: michael_mic ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 arc4 8021q garp stp llc macvlan pktgen isc]
Dec  6 11:32:29 atom kernel: Pid: 2732, comm: kworker/u:2 Tainted: G        W   2.6.37-rc4-wl+ #17
Dec  6 11:32:29 atom kernel: Call Trace:
Dec  6 11:32:29 atom kernel: [<78436fbd>] warn_slowpath_common+0x77/0x8c
Dec  6 11:32:29 atom kernel: [<fb7a125e>] ? ath_stoprecv+0x90/0x9a [ath9k]
Dec  6 11:32:29 atom kernel: [<fb7a125e>] ? ath_stoprecv+0x90/0x9a [ath9k]
Dec  6 11:32:29 atom kernel: [<7843704e>] warn_slowpath_fmt+0x2e/0x30
Dec  6 11:32:29 atom kernel: [<fb7a125e>] ath_stoprecv+0x90/0x9a [ath9k]
Dec  6 11:32:29 atom kernel: [<fb7a0182>] ath_set_channel+0x94/0x1f2 [ath9k]
Dec  6 11:32:29 atom kernel: [<7845a405>] ? mark_held_locks+0x47/0x5f
Dec  6 11:32:29 atom kernel: [<7878e7cb>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Dec  6 11:32:29 atom kernel: [<fb7a067a>] ath9k_config+0x39a/0x479 [ath9k]
Dec  6 11:32:29 atom kernel: [<fb6caaaa>] ieee80211_hw_config+0x11b/0x125 [mac80211]
Dec  6 11:32:29 atom kernel: [<fb6cef1b>] ieee80211_scan_work+0x29e/0x3f7 [mac80211]
Dec  6 11:32:29 atom kernel: [<78446f63>] ? process_one_work+0x13e/0x2bf
Dec  6 11:32:29 atom kernel: [<78446fd4>] process_one_work+0x1af/0x2bf
Dec  6 11:32:29 atom kernel: [<78446f63>] ? process_one_work+0x13e/0x2bf
Dec  6 11:32:29 atom kernel: [<fb6cec7d>] ? ieee80211_scan_work+0x0/0x3f7 [mac80211]
Dec  6 11:32:29 atom kernel: [<78448722>] worker_thread+0xf9/0x1bf
Dec  6 11:32:29 atom kernel: [<78448629>] ? worker_thread+0x0/0x1bf
Dec  6 11:32:29 atom kernel: [<7844b252>] kthread+0x62/0x67
Dec  6 11:32:29 atom kernel: [<7844b1f0>] ? kthread+0x0/0x67
Dec  6 11:32:29 atom kernel: [<784036c6>] kernel_thread_helper+0x6/0x1a
Dec  6 11:32:29 atom kernel: ---[ end trace 617a0f44fc30537b ]---
Dec  6 11:32:29 atom kernel: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020


On module unload, I sometimes see lots of more scary looking DMA warnings,
..but again, system seems stable aside from the noise
in the logs.  I will capture these and post them next time I get a clean
set of them (previous ones were on the mis-configured STA scenario..maybe
they only happen when you unload while driver is scanning or something like that).


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
